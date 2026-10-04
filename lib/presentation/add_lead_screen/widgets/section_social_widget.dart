import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionSocialWidget extends StatefulWidget {
  final Map<String, dynamic>? prefillData;
  final void Function(Map<String, dynamic>)? onDataChanged;

  const SectionSocialWidget({super.key, this.prefillData, this.onDataChanged});

  @override
  State<SectionSocialWidget> createState() => _SectionSocialWidgetState();
}

class _SectionSocialWidgetState extends State<SectionSocialWidget> {
  // Social platforms
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _facebookCtrl;
  late final TextEditingController _twitterCtrl;
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _youtubeCtrl;
  late final TextEditingController _githubCtrl;
  late final TextEditingController _telegramCtrl;
  late final TextEditingController _skypeCtrl;
  late final TextEditingController _calendlyCtrl;
  late final TextEditingController _threadsCtrl;
  late final TextEditingController _tiktokCtrl;

  // ATO / Insurance fields
  late final TextEditingController _existingLifeCoverCtrl;
  late final TextEditingController _existingTpdCoverCtrl;
  late final TextEditingController _existingTraumaCoverCtrl;
  late final TextEditingController _existingIpCoverCtrl;
  late final TextEditingController _superFundNameCtrl;
  late final TextEditingController _superMemberNoCtrl;
  late final TextEditingController _centrelinkCtrl;

  String _selectedMeetingTool = '';
  final String _selectedPrivateHealthStatus = '';
  final String _selectedPolicyOwnership = '';
  final bool _isSmsf = false;
  final bool _dutyOfDisclosureAck = false;
  DateTime? _dutyOfDisclosureDate;

  bool _showMoreSocial = false;
  final bool _showAtoFields = false;

  static const _meetingTools = [
    'Zoom',
    'Google Meet',
    'Microsoft Teams',
    'Webex',
    'Skype',
    'Others',
  ];
  static const _privateHealthStatuses = [
    'Yes - Basic',
    'Yes - Comprehensive',
    'No',
    'Pending Application',
  ];
  static const _policyOwnerships = [
    'Self',
    'Super Fund',
    'Trust',
    'Company',
    'Joint',
    'Others',
  ];

  static const _mainPlatforms = [
    {
      'label': 'LinkedIn',
      'key': 'linkedin',
      'icon': Icons.work_outline_rounded,
      'color': 0xFF0077B5,
      'hint': 'linkedin.com/in/username',
    },
    {
      'label': 'Facebook',
      'key': 'facebook',
      'icon': Icons.facebook_rounded,
      'color': 0xFF1877F2,
      'hint': 'facebook.com/username',
    },
    {
      'label': 'Twitter / X',
      'key': 'twitter',
      'icon': Icons.alternate_email_rounded,
      'color': 0xFF1DA1F2,
      'hint': 'twitter.com/username',
    },
    {
      'label': 'Instagram',
      'key': 'instagram',
      'icon': Icons.camera_alt_outlined,
      'color': 0xFFE1306C,
      'hint': 'instagram.com/username',
    },
    {
      'label': 'Website',
      'key': 'website',
      'icon': Icons.language_rounded,
      'color': 0xFF10B981,
      'hint': 'https://yourwebsite.com',
    },
  ];

  static const _morePlatforms = [
    {
      'label': 'YouTube',
      'key': 'youtube',
      'icon': Icons.play_circle_outline_rounded,
      'color': 0xFFFF0000,
      'hint': 'youtube.com/@channel',
    },
    {
      'label': 'GitHub',
      'key': 'github',
      'icon': Icons.code_rounded,
      'color': 0xFF333333,
      'hint': 'github.com/username',
    },
    {
      'label': 'Telegram',
      'key': 'telegram',
      'icon': Icons.send_rounded,
      'color': 0xFF0088CC,
      'hint': '@username or t.me/username',
    },
    {
      'label': 'Skype',
      'key': 'skype',
      'icon': Icons.video_call_outlined,
      'color': 0xFF00AFF0,
      'hint': 'Skype ID',
    },
    {
      'label': 'Calendly / Cal.com',
      'key': 'calendly',
      'icon': Icons.calendar_month_outlined,
      'color': 0xFF006BFF,
      'hint': 'calendly.com/username',
    },
    {
      'label': 'Threads',
      'key': 'threads',
      'icon': Icons.hub_outlined,
      'color': 0xFF000000,
      'hint': 'threads.net/@username',
    },
    {
      'label': 'TikTok',
      'key': 'tiktok',
      'icon': Icons.music_note_rounded,
      'color': 0xFF010101,
      'hint': 'tiktok.com/@username',
    },
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.prefillData;
    _linkedinCtrl = TextEditingController(
      text: p?['linkedin'] as String? ?? '',
    );
    _facebookCtrl = TextEditingController(
      text: p?['facebook'] as String? ?? '',
    );
    _twitterCtrl = TextEditingController(text: p?['twitter'] as String? ?? '');
    _instagramCtrl = TextEditingController(
      text: p?['instagram'] as String? ?? '',
    );
    _websiteCtrl = TextEditingController(text: p?['website'] as String? ?? '');
    _youtubeCtrl = TextEditingController(text: p?['youtube'] as String? ?? '');
    _githubCtrl = TextEditingController(text: p?['github'] as String? ?? '');
    _telegramCtrl = TextEditingController(
      text: p?['telegram'] as String? ?? '',
    );
    _skypeCtrl = TextEditingController(text: p?['skype'] as String? ?? '');
    _calendlyCtrl = TextEditingController(
      text: p?['calendly'] as String? ?? '',
    );
    _threadsCtrl = TextEditingController(text: p?['threads'] as String? ?? '');
    _tiktokCtrl = TextEditingController(text: p?['tiktok'] as String? ?? '');
    _existingLifeCoverCtrl = TextEditingController(
      text: p?['existingLifeCover'] as String? ?? '',
    );
    _existingTpdCoverCtrl = TextEditingController(
      text: p?['existingTpdCover'] as String? ?? '',
    );
    _existingTraumaCoverCtrl = TextEditingController(
      text: p?['existingTraumaCover'] as String? ?? '',
    );
    _existingIpCoverCtrl = TextEditingController(
      text: p?['existingIpCover'] as String? ?? '',
    );
    _superFundNameCtrl = TextEditingController(
      text: p?['superFundName'] as String? ?? '',
    );
    _superMemberNoCtrl = TextEditingController(
      text: p?['superMemberNo'] as String? ?? '',
    );
    _centrelinkCtrl = TextEditingController(
      text: p?['centrelink'] as String? ?? '',
    );

    for (final ctrl in [
      _linkedinCtrl,
      _facebookCtrl,
      _twitterCtrl,
      _instagramCtrl,
      _websiteCtrl,
      _youtubeCtrl,
      _githubCtrl,
      _telegramCtrl,
      _skypeCtrl,
      _calendlyCtrl,
    ]) {
      ctrl.addListener(_notifyParent);
    }
  }

  void _notifyParent() {
    widget.onDataChanged?.call({
      'linkedin': _linkedinCtrl.text,
      'facebook': _facebookCtrl.text,
      'twitter': _twitterCtrl.text,
      'instagram': _instagramCtrl.text,
      'website': _websiteCtrl.text,
      'youtube': _youtubeCtrl.text,
      'github': _githubCtrl.text,
      'telegram': _telegramCtrl.text,
      'skype': _skypeCtrl.text,
      'calendly': _calendlyCtrl.text,
      'threads': _threadsCtrl.text,
      'tiktok': _tiktokCtrl.text,
      'preferredMeetingTool': _selectedMeetingTool,
    });
  }

  TextEditingController _ctrlFor(String key) {
    switch (key) {
      case 'linkedin':
        return _linkedinCtrl;
      case 'facebook':
        return _facebookCtrl;
      case 'twitter':
        return _twitterCtrl;
      case 'instagram':
        return _instagramCtrl;
      case 'website':
        return _websiteCtrl;
      case 'youtube':
        return _youtubeCtrl;
      case 'github':
        return _githubCtrl;
      case 'telegram':
        return _telegramCtrl;
      case 'skype':
        return _skypeCtrl;
      case 'calendly':
        return _calendlyCtrl;
      case 'threads':
        return _threadsCtrl;
      case 'tiktok':
        return _tiktokCtrl;
      default:
        return _linkedinCtrl;
    }
  }

  @override
  void dispose() {
    for (final ctrl in [
      _linkedinCtrl,
      _facebookCtrl,
      _twitterCtrl,
      _instagramCtrl,
      _websiteCtrl,
      _youtubeCtrl,
      _githubCtrl,
      _telegramCtrl,
      _skypeCtrl,
      _calendlyCtrl,
      _threadsCtrl,
      _tiktokCtrl,
      _existingLifeCoverCtrl,
      _existingTpdCoverCtrl,
      _existingTraumaCoverCtrl,
      _existingIpCoverCtrl,
      _superFundNameCtrl,
      _superMemberNoCtrl,
      _centrelinkCtrl,
    ]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Social Profiles ────────────────────────────────────────────────
        Text(
          'Social Profiles & Website',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        ..._mainPlatforms.map((p) {
          final color = Color(p['color'] as int);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: _ctrlFor(p['key'] as String),
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: p['label'] as String,
                hintText: p['hint'] as String,
                prefixIcon: Icon(p['icon'] as IconData, size: 18, color: color),
              ),
            ),
          );
        }),

        // More Social Platforms
        GestureDetector(
          onTap: () => setState(() => _showMoreSocial = !_showMoreSocial),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'More Platforms (YouTube, GitHub, Telegram...)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _showMoreSocial ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: _showMoreSocial
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: _morePlatforms.map((p) {
                      final color = Color(p['color'] as int);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextFormField(
                          controller: _ctrlFor(p['key'] as String),
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: p['label'] as String,
                            hintText: p['hint'] as String,
                            prefixIcon: Icon(
                              p['icon'] as IconData,
                              size: 18,
                              color: color,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),

        // Preferred Meeting Tool
        Text(
          'Preferred Meeting Tool',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: _meetingTools.map((t) {
            final isSelected = _selectedMeetingTool == t;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedMeetingTool = t;
                _notifyParent();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryContainer
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.surface200,
                  ),
                ),
                child: Text(
                  t,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ATO / Insurance section removed as requested
  Widget _buildAtoFields() {
    return const SizedBox.shrink();
  }

  Widget _buildCoverRow(
    String label,
    TextEditingController ctrl,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Amount (₹)',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textMuted,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.surface200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.surface200),
              ),
            ),
            style: GoogleFonts.plusJakartaSans(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
