import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class VideoSessionScreen extends StatefulWidget {
  final String? customerName;
  final String? customerPhone;
  final String? sessionTitle;

  const VideoSessionScreen({
    super.key,
    this.customerName,
    this.customerPhone,
    this.sessionTitle,
  });

  @override
  State<VideoSessionScreen> createState() => _VideoSessionScreenState();
}

class _VideoSessionScreenState extends State<VideoSessionScreen>
    with TickerProviderStateMixin {
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = true;
  bool _isLinkCopied = false;
  bool _sessionStarted = false;
  bool _showParticipantJoined = false;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _joinCtrl;
  late Animation<double> _joinAnim;

  Timer? _durationTimer;
  int _durationSeconds = 0;

  final String _sessionId =
      'ses-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  String get _sessionLink =>
      'https://anbucrm176098.builtwithrocket.new/join/$_sessionId';

  String get _formattedDuration {
    final h = _durationSeconds ~/ 3600;
    final m = (_durationSeconds % 3600) ~/ 60;
    final s = _durationSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _joinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _joinAnim = CurvedAnimation(parent: _joinCtrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _joinCtrl.dispose();
    _durationTimer?.cancel();
    super.dispose();
  }

  void _startSession() {
    setState(() => _sessionStarted = true);
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _durationSeconds++);
    });
    // Simulate participant joining after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showParticipantJoined = true);
        _joinCtrl.forward();
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            _joinCtrl.reverse().then((_) {
              if (mounted) setState(() => _showParticipantJoined = false);
            });
          }
        });
      }
    });
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: _sessionLink));
    setState(() => _isLinkCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLinkCopied = false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Session link copied! Share with customer.',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _shareLink() {
    // Show share options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _ShareSheet(
          link: _sessionLink,
          customerName: widget.customerName ?? 'Customer',
        ),
      ),
    );
  }

  void _endCall() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'End Session?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This will end the video session for all participants.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(
              'End Session',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerName = widget.customerName ?? 'Customer';
    final sessionTitle = widget.sessionTitle ?? 'Video Session';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                _buildTopBar(sessionTitle),
                Expanded(
                  child: _sessionStarted
                      ? _buildActiveSession(customerName)
                      : _buildWaitingRoom(customerName),
                ),
                _buildControlBar(),
              ],
            ),
            // Participant joined notification
            if (_showParticipantJoined)
              Positioned(
                top: 80,
                left: 16,
                right: 16,
                child: ScaleTransition(
                  scale: _joinAnim,
                  child: _buildJoinNotification(customerName),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () =>
                _sessionStarted ? _endCall() : Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (_sessionStarted)
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ADE80),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Live · $_formattedDuration',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF4ADE80),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Waiting for participant',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
              ],
            ),
          ),
          // Session ID badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withAlpha(40)),
            ),
            child: Text(
              _sessionId,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingRoom(String customerName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Camera preview placeholder
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(20)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primary.withAlpha(40),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _pulseAnim,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withAlpha(40),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primary.withAlpha(80),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your Camera Preview',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isCameraOff ? 'Camera is off' : 'Camera ready',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: _isCameraOff
                            ? Colors.red.shade300
                            : const Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
                // Camera off overlay
                if (_isCameraOff)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(160),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.videocam_off_rounded,
                            color: Colors.white54,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Camera Off',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Share link section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.link_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Session Link',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Share with $customerName to join',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Link display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _sessionLink,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _copyLink,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isLinkCopied
                                ? AppTheme.success.withAlpha(40)
                                : Colors.white.withAlpha(15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _isLinkCopied
                                  ? AppTheme.success.withAlpha(80)
                                  : Colors.white.withAlpha(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isLinkCopied
                                    ? Icons.check_rounded
                                    : Icons.copy_rounded,
                                size: 14,
                                color: _isLinkCopied
                                    ? AppTheme.success
                                    : Colors.white70,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isLinkCopied ? 'Copied!' : 'Copy Link',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _isLinkCopied
                                      ? AppTheme.success
                                      : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: _shareLink,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withAlpha(40),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.primary.withAlpha(80),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.share_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Share',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Customer info
          if (widget.customerName != null)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withAlpha(15)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        customerName.isNotEmpty
                            ? customerName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        if (widget.customerPhone != null)
                          Text(
                            widget.customerPhone!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Waiting',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          // Start session button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _startSession,
              icon: const Icon(Icons.videocam_rounded, size: 20),
              label: Text(
                'Start Session',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Copy and share the link above before starting',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSession(String customerName) {
    return Stack(
      children: [
        // Remote video (customer) — full screen placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnim,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(40),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary.withAlpha(80),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      customerName.isNotEmpty
                          ? customerName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                customerName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ADE80),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Connected · $_formattedDuration',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: const Color(0xFF4ADE80),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Local video (self) — small pip in corner
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            width: 90,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(40), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(80),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isCameraOff
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.videocam_off_rounded,
                        color: Colors.white38,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primary.withAlpha(60),
                              const Color(0xFF1A1A2E),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white54,
                            size: 36,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          'You',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        // Share link button (during session)
        Positioned(
          bottom: 16,
          left: 16,
          child: GestureDetector(
            onTap: _copyLink,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isLinkCopied
                    ? AppTheme.success.withAlpha(60)
                    : Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isLinkCopied
                      ? AppTheme.success.withAlpha(100)
                      : Colors.white.withAlpha(40),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLinkCopied ? Icons.check_rounded : Icons.link_rounded,
                    size: 14,
                    color: _isLinkCopied ? AppTheme.success : Colors.white70,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isLinkCopied ? 'Copied!' : 'Copy Link',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _isLinkCopied ? AppTheme.success : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(top: BorderSide(color: Colors.white.withAlpha(15))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlBtn(
            icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: _isMuted ? 'Unmute' : 'Mute',
            isActive: !_isMuted,
            activeColor: AppTheme.primary,
            inactiveColor: const Color(0xFF374151),
            onTap: () => setState(() => _isMuted = !_isMuted),
          ),
          _ControlBtn(
            icon: _isCameraOff
                ? Icons.videocam_off_rounded
                : Icons.videocam_rounded,
            label: _isCameraOff ? 'Cam On' : 'Cam Off',
            isActive: !_isCameraOff,
            activeColor: AppTheme.primary,
            inactiveColor: const Color(0xFF374151),
            onTap: () => setState(() => _isCameraOff = !_isCameraOff),
          ),
          _ControlBtn(
            icon: _isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            label: _isSpeakerOn ? 'Speaker' : 'Earpiece',
            isActive: _isSpeakerOn,
            activeColor: AppTheme.primary,
            inactiveColor: const Color(0xFF374151),
            onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
          ),
          _ControlBtn(
            icon: Icons.share_rounded,
            label: 'Share',
            isActive: true,
            activeColor: const Color(0xFF0891B2),
            inactiveColor: const Color(0xFF374151),
            onTap: _shareLink,
          ),
          // End call button
          GestureDetector(
            onTap: _endCall,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.error.withAlpha(80),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.call_end_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'End',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppTheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinNotification(String customerName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.success,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.success.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                customerName.isNotEmpty ? customerName[0].toUpperCase() : '?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$customerName joined!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Session is now active',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}

// ─── Control Button ───────────────────────────────────────────────────────────

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _ControlBtn({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive ? activeColor.withAlpha(40) : inactiveColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? activeColor.withAlpha(80)
                    : Colors.white.withAlpha(20),
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? activeColor : Colors.white54,
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: isActive ? Colors.white70 : Colors.white38,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Share Sheet ──────────────────────────────────────────────────────────────

class _ShareSheet extends StatelessWidget {
  final String link;
  final String customerName;

  const _ShareSheet({required this.link, required this.customerName});

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'icon': Icons.chat_rounded,
        'label': 'WhatsApp',
        'color': const Color(0xFF25D366),
      },
      {
        'icon': Icons.sms_rounded,
        'label': 'SMS',
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': Icons.email_rounded,
        'label': 'Email',
        'color': const Color(0xFFF59E0B),
      },
      {
        'icon': Icons.copy_rounded,
        'label': 'Copy Link',
        'color': AppTheme.primary,
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  'Share Session Link',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white54,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Link preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(20)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.link_rounded,
                    color: Colors.white54,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      link,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options.map((opt) {
                final color = opt['color'] as Color;
                return GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: link));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Link copied — open ${opt['label']} and paste',
                        ),
                        backgroundColor: color,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          shape: BoxShape.circle,
                          border: Border.all(color: color.withAlpha(60)),
                        ),
                        child: Icon(
                          opt['icon'] as IconData,
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        opt['label'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
