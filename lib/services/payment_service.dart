import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Thrown when the payment cannot be completed. [message] is safe to show.
class PaymentException implements Exception {
  final String message;
  const PaymentException(this.message);

  @override
  String toString() => message;
}

class PaymentResult {
  final bool paid;
  final String? orderId;
  final String? paymentId;
  final String message;
  final bool cancelled;

  const PaymentResult({
    required this.paid,
    this.orderId,
    this.paymentId,
    required this.message,
    this.cancelled = false,
  });
}

/// Drives the Razorpay checkout and defers every trust decision to the backend.
///
/// The app is never allowed to conclude that a payment succeeded: success is
/// only reported when the backend answers `paid: true` after re-fetching the
/// payment from Razorpay.
class PaymentService {
  PaymentService._();

  static final PaymentService instance = PaymentService._();

  /// Deployed Hostinger URL, no trailing slash.
  /// Point this at your server once the backend is live.
  static const String backendUrl = 'https://your-backend-domain.example';

  static const String _placeholder = 'your-backend-domain.example';

  static const int _confirmAttempts = 6;
  static const Duration _confirmInterval = Duration(seconds: 2);

  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: backendUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 25),
      headers: {'Accept': 'application/json'},
    ),
  );

  bool get isBackendConfigured => !backendUrl.contains(_placeholder);

  Future<String> _requireIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const PaymentException('You are signed out. Please sign up again.');
    }
    // forceRefresh so a token created before the backend was ready is never
    // rejected as expired mid-checkout.
    final token = await user.getIdToken(true);
    if (token == null) {
      throw const PaymentException('Could not verify your session. Try again.');
    }
    return token;
  }

  Future<Map<String, dynamic>> _createOrder(String token) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/create-order',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: const <String, dynamic>{},
      );
      final data = response.data;
      if (data == null) {
        throw const PaymentException('Payment server sent an empty reply.');
      }
      return data;
    } on DioException catch (e) {
      throw PaymentException(_describeDio(e, 'Could not create your order.'));
    }
  }

  Future<Map<String, dynamic>?> _paymentStatus(String token) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/payment-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException {
      return null;
    }
  }

  String _describeDio(DioException e, String fallback) {
    final code = e.response?.statusCode;
    if (code == 401) return 'Your session expired. Please sign in again.';
    if (code == 429) return 'Too many attempts. Wait a minute and retry.';
    final serverMessage = e.response?.data;
    if (serverMessage is Map && serverMessage['error'] is String) {
      final error = serverMessage['error'] as String;
      if (error == 'signature_invalid') {
        return 'Payment could not be verified. Contact support if money was deducted.';
      }
      if (error == 'payment_not_captured') {
        return 'Payment not completed. No amount was captured.';
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Cannot reach the payment server. Check your internet.';
    }
    if (code != null && code >= 500) return 'Payment server error. Try again.';
    return fallback;
  }

  /// Runs the whole flow: order -> checkout -> backend verification.
  ///
  /// [onStage] receives short progress labels for the overlay UI.
  Future<PaymentResult> startPayment({
    required String name,
    required String email,
    required String phone,
    void Function(String stage)? onStage,
  }) async {
    if (!isBackendConfigured) {
      throw const PaymentException(
        'Payment server is not configured yet. Set backendUrl in '
        'lib/services/payment_service.dart.',
      );
    }

    onStage?.call('Signing you in...');
    final token = await _requireIdToken();

    onStage?.call('Creating your order...');
    final order = await _createOrder(token);
    final orderId = order['order_id'] as String?;

    if (order['already_paid'] == true) {
      return PaymentResult(
        paid: true,
        orderId: orderId,
        paymentId: order['payment_id'] as String?,
        message: 'Payment already confirmed for this account.',
      );
    }

    if (orderId == null) {
      throw const PaymentException('Payment server did not return an order id.');
    }

    onStage?.call('Opening secure checkout...');
    final checkout = await _openCheckout(
      orderId: orderId,
      keyId: order['key_id'] as String? ?? '',
      amount: (order['amount'] as num?)?.toInt() ?? 0,
      currency: order['currency'] as String? ?? 'INR',
      businessName: order['name'] as String? ?? 'AnbuCRM',
      description: order['description'] as String? ?? 'AnbuCRM subscription',
      name: name,
      email: email,
      phone: phone,
    );

    if (!checkout.success) {
      return PaymentResult(
        paid: false,
        orderId: orderId,
        message: checkout.message,
        cancelled: checkout.cancelled,
      );
    }

    onStage?.call('Verifying transaction...');
    final verified = await _verifyWithBackend(
      token,
      orderId: orderId,
      paymentId: checkout.paymentId!,
      signature: checkout.signature!,
    );
    if (verified.paid) return verified;

    // The webhook confirms payments independently and can land slightly later
    // than the app's own verify call, so keep asking before declaring failure.
    onStage?.call('Confirming with your bank...');
    final confirmed = await _awaitBackendConfirmation(token, orderId);
    if (confirmed != null) return confirmed;

    return PaymentResult(
      paid: false,
      orderId: orderId,
      paymentId: checkout.paymentId,
      message:
          verified.message.isEmpty
              ? 'Payment is still being confirmed. If money was deducted, '
                  'it will reflect shortly.'
              : verified.message,
    );
  }

  Future<_CheckoutOutcome> _openCheckout({
    required String orderId,
    required String keyId,
    required int amount,
    required String currency,
    required String businessName,
    required String description,
    required String name,
    required String email,
    required String phone,
  }) {
    final razorpay = Razorpay();
    final completer = Completer<_CheckoutOutcome>();

    void complete(_CheckoutOutcome outcome) {
      if (!completer.isCompleted) completer.complete(outcome);
    }

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
      final paymentId = r.paymentId;
      final signature = r.signature;
      if (paymentId == null || signature == null) {
        complete(
          const _CheckoutOutcome(
            success: false,
            message: 'Checkout returned an incomplete response.',
          ),
        );
        return;
      }
      complete(
        _CheckoutOutcome(
          success: true,
          paymentId: paymentId,
          signature: signature,
        ),
      );
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
      final cancelled = r.code == 0;
      complete(
        _CheckoutOutcome(
          success: false,
          cancelled: cancelled,
          message: cancelled
              ? 'Payment cancelled.'
              : (r.message?.isNotEmpty == true
                    ? r.message!
                    : 'Payment failed. Please try again.'),
        ),
      );
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {
      // Informational only; the user still completes payment inside checkout.
    });

    razorpay.open(<String, dynamic>{
      'key': keyId,
      'amount': amount,
      'currency': currency,
      'order_id': orderId,
      'name': businessName,
      'description': description,
      'prefill': {
        'name': name.trim(),
        'email': email.trim(),
        'contact': phone.replaceAll(RegExp(r'[^0-9]'), ''),
      },
      'theme': {'color': '#4F46E5'},
    });

    return completer.future.whenComplete(razorpay.clear);
  }

  Future<PaymentResult> _verifyWithBackend(
    String token, {
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/verify-payment',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: <String, dynamic>{
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        },
      );
      final data = response.data ?? <String, dynamic>{};
      if (data['paid'] == true) {
        return PaymentResult(
          paid: true,
          orderId: data['razorpay_order_id'] as String? ?? orderId,
          paymentId: data['razorpay_payment_id'] as String? ?? paymentId,
          message: 'Payment verified.',
        );
      }
      return PaymentResult(
        paid: false,
        orderId: orderId,
        paymentId: paymentId,
        message: data['error'] is String ? data['error'] as String : '',
      );
    } on DioException catch (e) {
      // A network failure here does NOT mean unpaid — the webhook may still
      // confirm it, so let the caller poll before showing anything.
      return PaymentResult(
        paid: false,
        orderId: orderId,
        paymentId: paymentId,
        message: _describeDio(e, ''),
      );
    }
  }

  Future<PaymentResult?> _awaitBackendConfirmation(
    String token,
    String orderId,
  ) async {
    for (var attempt = 0; attempt < _confirmAttempts; attempt++) {
      await Future<void>.delayed(_confirmInterval);
      final status = await _paymentStatus(token);
      if (status != null && status['paid'] == true) {
        return PaymentResult(
          paid: true,
          orderId: status['razorpay_order_id'] as String? ?? orderId,
          paymentId: status['razorpay_payment_id'] as String?,
          message: 'Payment confirmed.',
        );
      }
    }
    return null;
  }
}

class _CheckoutOutcome {
  final bool success;
  final bool cancelled;
  final String message;
  final String? paymentId;
  final String? signature;

  const _CheckoutOutcome({
    required this.success,
    this.cancelled = false,
    this.message = '',
    this.paymentId,
    this.signature,
  });
}
