enum AccountStatus { disconnected, pendingOtp, verified, connected }

class WhatsAppSessionState {
  static final WhatsAppSessionState _instance = WhatsAppSessionState._internal();
  factory WhatsAppSessionState() => _instance;
  WhatsAppSessionState._internal();

  AccountStatus status = AccountStatus.disconnected;
  String businessName = 'Anbu Enterprise Tech';
  String wabaId = '948102948102';
  String selectedPhone = '+91 98765 43210';
  String phoneDisplayName = 'AnbuCRM Official Support';
  String qualityRating = 'High (Green)';
  String messagingTier = 'Tier 2 (100k/day)';
  bool isWebhookActive = false;

  List<Map<String, dynamic>> automations = [
    {
      'id': '#WA-108',
      'name': 'New Lead Instant Welcome & PDF',
      'category': 'Lead Nurture',
      'trigger': 'CRM Lead Created',
      'filter': 'Source = Inbound Campaign',
      'action': 'Send WhatsApp Template w/ PDF brochure',
      'runs': 1420,
      'replyRate': '38% reply rate',
      'isActive': true,
    },
    {
      'id': '#WA-204',
      'name': 'Deal Stage Changed: Quote Sent',
      'category': 'Deal Alerts',
      'trigger': "Deal → 'Proposal Sent'",
      'filter': '24 Hours grace window',
      'action': 'Send Quote summary & Stripe paylink',
      'runs': 312,
      'replyRate': '\$48.2k generated',
      'isActive': true,
    },
    {
      'id': '#WA-042',
      'name': 'Inactivity Re-engagement (30 Days)',
      'category': 'Lead Nurture',
      'trigger': 'No customer contact for 30 days',
      'filter': 'VIP and Enterprise tags',
      'action': 'Send WhatsApp Win-back offer & VIP perks',
      'runs': 0,
      'replyRate': 'Sequence Paused',
      'isActive': false,
    },
  ];
}

class MetaCloudApiService {
  static Future<Map<String, dynamic>> exchangeMetaAuthCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 1400));
    WhatsAppSessionState().status = AccountStatus.pendingOtp;
    return {
      'success': true,
      'waba_id': '948102948102',
      'business_name': 'Anbu Enterprise Tech',
      'access_token': 'EAAXx...token_authorized',
    };
  }

  static Future<bool> requestPhoneOtp(String phone, {bool isVoice = false}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return true;
  }

  static Future<bool> verifyOtpAndActivateWebhook(String otpCode) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (otpCode.length == 6) {
      WhatsAppSessionState().status = AccountStatus.connected;
      WhatsAppSessionState().isWebhookActive = true;
      return true;
    }
    return false;
  }

  static Future<bool> sendTemplateMessage({
    required String recipientPhone,
    required String templateName,
    required Map<String, String> dynamicParams,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
