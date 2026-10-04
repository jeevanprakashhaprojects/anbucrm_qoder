import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ─── Lead Owner Data ──────────────────────────────────────────────────────────

class LeadOwner {
  final String name;
  final String initials;
  final String role;
  final String id;

  const LeadOwner({
    required this.name,
    required this.initials,
    required this.role,
    required this.id,
  });
}

const List<LeadOwner> kLeadOwners = [
  LeadOwner(
    name: 'Priya Sharma',
    initials: 'PS',
    role: 'Admin',
    id: 'ADM-1042',
  ),
  LeadOwner(
    name: 'Rahul Singh',
    initials: 'RS',
    role: 'Senior Rep',
    id: 'EMP-2391',
  ),
  LeadOwner(
    name: 'Ananya Patel',
    initials: 'AP',
    role: 'Manager',
    id: 'EMP-1874',
  ),
  LeadOwner(
    name: 'Kavya Menon',
    initials: 'KM',
    role: 'Sales Rep',
    id: 'EMP-3012',
  ),
  LeadOwner(
    name: 'Arjun Das',
    initials: 'AD',
    role: 'Sales Rep',
    id: 'EMP-2756',
  ),
  LeadOwner(
    name: 'Vikram Nair',
    initials: 'VN',
    role: 'Contractor',
    id: 'CONT-8391',
  ),
  LeadOwner(
    name: 'Meera Iyer',
    initials: 'MI',
    role: 'Contractor',
    id: 'CONT-5204',
  ),
];

// ─── Section Lead Details Widget ─────────────────────────────────────────────

class SectionLeadDetailsWidget extends StatefulWidget {
  final void Function(int filledCount)? onCompulsoryChanged;
  final void Function(Map<String, dynamic>)? onDataChanged;
  final Map<String, dynamic>? prefillData;
  const SectionLeadDetailsWidget({
    super.key,
    this.onCompulsoryChanged,
    this.onDataChanged,
    this.prefillData,
  });

  @override
  State<SectionLeadDetailsWidget> createState() =>
      _SectionLeadDetailsWidgetState();
}

class _SectionLeadDetailsWidgetState extends State<SectionLeadDetailsWidget>
    with SingleTickerProviderStateMixin {
  static const _statuses = [
    'New',
    'Contacted',
    'Engaged',
    'Qualified',
    'Proposed',
    'Follow Up',
    'Sessions',
    'Negotiations',
    'Result',
  ];
  static const _statusSubStates = {
    'Contacted': ['Voicemail', 'No Answer', 'Callback Requested', 'Connected'],
    'Engaged': ['Responded', 'Interested', 'Needs More Info'],
    'Proposed': ['Proposal Sent', 'Under Review', 'Revision Requested'],
    'Qualified': ['BANT Qualified', 'Partially Qualified', 'Needs Nurturing'],
    'Follow Up': ['Waiting for Decision', 'Follow-up Scheduled', 'No Response'],
    'Sessions': ['Appointment Scheduled', 'Video Call Booked', 'Call Back Set'],
    'Negotiations': ['Price Negotiation', 'Contract Review', 'Legal Review'],
  };
  static const _wonLostReasons = [
    'Price too high',
    'Chose competitor',
    'No budget',
    'No need',
    'Timeline mismatch',
    'Product fit',
    'Relationship',
    'Others',
  ];
  static const _competitors = [
    'Competitor A',
    'Competitor B',
    'Competitor C',
    'Others',
  ];
  static const _forecastCategories = [
    'Pipeline',
    'Best Case',
    'Commit',
    'Closed Won',
    'Closed Lost',
  ];
  static const _leadGrades = ['A', 'B', 'C', 'D'];
  static const _currencies = [
    '₹ INR',
    '\$ USD',
    '€ EUR',
    '£ GBP',
    'AUD \$',
    'SGD \$',
    'AED',
    'Others',
  ];
  static const _contractLengths = [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year',
    '2 Years',
    '3 Years',
    'Custom',
  ];
  static const _renewalFrequencies = [
    'One-time',
    'Monthly',
    'Quarterly',
    'Annual',
    'Others',
  ];
  static const _nextBestActions = [
    'Send Proposal',
    'Schedule Demo',
    'Follow-up Call',
    'Send Case Study',
    'Escalate to Manager',
    'Nurture via Email',
    'Others',
  ];

  String _selectedStatus = 'New';
  String _selectedSubState = '';
  String _selectedPriority = 'Medium';
  String _selectedTier = 'Standard';
  bool _isVip = false;
  bool _isExistingCustomer = false;
  String _selectedSource = '';
  String _selectedAction = '';
  String _selectedForecastCategory = '';
  String _selectedLeadGrade = '';
  String _selectedCurrency = '₹ INR';
  String _selectedContractLength = '';
  String _selectedRenewalFrequency = '';
  final String _selectedWonLostReason = '';
  String _selectedResultOutcome = ''; // 'Won', 'Lost', 'Not Interested'
  String _resultReason = '';
  final String _selectedCompetitor = '';
  String _selectedNextBestAction = '';
  double _dealValue = 0;
  double _leadScore = 0;
  double _conversionProbability = 0;
  double _discountPercent = 0;
  final _dealValueCtrl = TextEditingController();
  final _campaignCtrl = TextEditingController();
  final _utmCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();
  final _actionNotesCtrl = TextEditingController();
  final _appointmentLocationCtrl = TextEditingController();
  final _appointmentLinkCtrl = TextEditingController();
  final _resultReasonCtrl = TextEditingController();
  final _quotationIdCtrl = TextEditingController();
  final _discountReasonCtrl = TextEditingController();
  final _slaCtrl = TextEditingController();
  // BANT
  final _bantBudgetCtrl = TextEditingController();
  final _bantAuthorityCtrl = TextEditingController();
  final _bantNeedCtrl = TextEditingController();
  final _bantTimelineCtrl = TextEditingController();

  DateTime? _scheduledActionDate;
  TimeOfDay? _scheduledActionTime;
  DateTime? _expectedCloseDate;
  DateTime? _quotationSentDate;
  DateTime? _slaDeadline;

  LeadOwner _selectedOwner = kLeadOwners.first;

  static const _priorities = ['High', 'Medium', 'Low'];
  static const _tiers = ['Standard', 'Silver', 'Gold', 'Platinum', 'Others'];
  String _otherTier = '';
  static const _sources = [
    'Website',
    'Referral',
    'Cold Call',
    'LinkedIn',
    'Trade Show',
    'Email Campaign',
    'Walk-in',
    'Partner',
    'Social Media',
    'Others',
  ];
  static const _actions = [
    'Appointment',
    'Follow-up',
    'Video Call',
    'Call Back',
    'Not Interested',
  ];
  static const _followUpFrequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'Custom',
  ];
  static const _tags = [
    'VIP',
    'Urgent',
    'Follow-up',
    'Hot Lead',
    'Cold Lead',
    'Nurture',
  ];
  final List<String> _selectedTags = [];

  static const _quickAmounts = [
    {'label': '₹1L', 'value': 100000.0},
    {'label': '₹5L', 'value': 500000.0},
    {'label': '₹10L', 'value': 1000000.0},
    {'label': '₹50L', 'value': 5000000.0},
    {'label': '₹1Cr', 'value': 10000000.0},
  ];

  bool _showBANT = false;
  bool _showAdvancedDeal = false;
  bool _showAttribution = false;

  String _selectedFrequency = '';
  DateTime? _customFrequencyDate;
  final List<String> _selectedPreferredContact = [];

  String _formatAmount(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Crore';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(2)} Lakh';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)} Thousand';
    return '₹${v.toStringAsFixed(0)}';
  }

  Color _ownerIdColor(String id) {
    if (id.startsWith('ADM')) return AppTheme.primary;
    if (id.startsWith('EMP')) return AppTheme.success;
    return const Color(0xFFD97706);
  }

  final _otherSourceCtrl = TextEditingController();
  String _otherSourceText = '';
  final String _otherWonLostReason = '';
  String _otherCurrency = '';
  String _otherRenewalFrequency = '';
  String _otherNextBestAction = '';
  final String _otherCompetitor = '';

  void _notifyParent() {
    int filled = 0;
    int othersExtra = 0;
    int othersFilled = 0;

    if (_selectedAction.isNotEmpty) {
      if (_selectedAction == 'Not Interested') {
        filled++;
      } else if (_selectedFrequency.isNotEmpty) {
        // Frequency selected — check if date is set for custom/yearly
        if (_selectedFrequency == 'Custom') {
          if (_customFrequencyDate != null) filled++;
        } else if (_selectedFrequency == 'Yearly') {
          if (_scheduledActionDate != null) filled++;
        } else {
          // Daily/Weekly/Monthly auto-set date
          filled++;
        }
      }
    }

    if (_selectedTier == 'Others') {
      othersExtra++;
      if (_otherTier.trim().isNotEmpty) othersFilled++;
    }
    if (_selectedSource == 'Others') {
      othersExtra++;
      if (_otherSourceText.trim().isNotEmpty) othersFilled++;
    }
    if (_selectedWonLostReason == 'Others') {
      othersExtra++;
      if (_otherWonLostReason.trim().isNotEmpty) othersFilled++;
    }
    if (_selectedCurrency == 'Others') {
      othersExtra++;
      if (_otherCurrency.trim().isNotEmpty) othersFilled++;
    }
    if (_selectedRenewalFrequency == 'Others') {
      othersExtra++;
      if (_otherRenewalFrequency.trim().isNotEmpty) othersFilled++;
    }
    if (_selectedNextBestAction == 'Others') {
      othersExtra++;
      if (_otherNextBestAction.trim().isNotEmpty) othersFilled++;
    }
    if (_selectedCompetitor == 'Others') {
      othersExtra++;
      if (_otherCompetitor.trim().isNotEmpty) othersFilled++;
    }

    filled += othersFilled;
    final totalRequired = 1 + othersExtra;

    widget.onCompulsoryChanged?.call(filled);
    widget.onDataChanged?.call({
      'scheduledAction': _selectedAction,
      'scheduledActionDate': _scheduledActionDate != null
          ? '${_scheduledActionDate!.day}/${_scheduledActionDate!.month}/${_scheduledActionDate!.year}'
          : '',
      'scheduledActionTime': _scheduledActionTime != null
          ? '${_scheduledActionTime!.hour.toString().padLeft(2, '0')}:${_scheduledActionTime!.minute.toString().padLeft(2, '0')}'
          : '',
      'scheduledFrequency': _selectedFrequency,
      'appointmentLocation': _appointmentLocationCtrl.text,
      'appointmentLink': _appointmentLinkCtrl.text,
      'preferredContact': _selectedPreferredContact,
      'actionNotes': _actionNotesCtrl.text,
      'ownerName': _selectedOwner.name,
      'ownerInitials': _selectedOwner.initials,
      'priority': _selectedPriority,
      'status': _selectedStatus,
      'statusSubState': _selectedSubState,
      'isExistingCustomer': _isExistingCustomer,
      'resultOutcome': _selectedResultOutcome,
      'resultReason': _resultReasonCtrl.text,
      'tier': _selectedTier == 'Others' ? _otherTier : _selectedTier,
      'source': _selectedSource == 'Others'
          ? _otherSourceText
          : _selectedSource,
      'dealValue': _dealValue,
      'currency': _selectedCurrency,
      'leadScore': _leadScore,
      'conversionProbability': _conversionProbability,
      'forecastCategory': _selectedForecastCategory,
      'leadGrade': _selectedLeadGrade,
      'discountPercent': _discountPercent,
      'discountReason': _discountReasonCtrl.text,
      'quotationId': _quotationIdCtrl.text,
      'quotationSentDate': _quotationSentDate != null
          ? '${_quotationSentDate!.day}/${_quotationSentDate!.month}/${_quotationSentDate!.year}'
          : '',
      'contractLength': _selectedContractLength,
      'renewalFrequency': _selectedRenewalFrequency,
      'wonLostReason': _selectedWonLostReason == 'Others'
          ? _otherWonLostReason
          : _selectedWonLostReason,
      'competitor': _selectedCompetitor,
      'bantBudget': _bantBudgetCtrl.text,
      'bantAuthority': _bantAuthorityCtrl.text,
      'bantNeed': _bantNeedCtrl.text,
      'bantTimeline': _bantTimelineCtrl.text,
      'nextBestAction': _selectedNextBestAction,
      'slaDeadline': _slaDeadline != null
          ? '${_slaDeadline!.day}/${_slaDeadline!.month}/${_slaDeadline!.year}'
          : '',
      'expectedCloseDate': _expectedCloseDate != null
          ? '${_expectedCloseDate!.day}/${_expectedCloseDate!.month}/${_expectedCloseDate!.year}'
          : '',
      'tags': _selectedTags,
      '_leadDetailsRequiredTotal': totalRequired,
    });
  }

  @override
  void initState() {
    super.initState();
    _dealValueCtrl.addListener(_notifyParent);
    _scheduledActionDate = DateTime.now();
  }

  @override
  void dispose() {
    _dealValueCtrl.dispose();
    _campaignCtrl.dispose();
    _utmCtrl.dispose();
    _referralCtrl.dispose();
    _actionNotesCtrl.dispose();
    _appointmentLocationCtrl.dispose();
    _appointmentLinkCtrl.dispose();
    _resultReasonCtrl.dispose();
    _otherSourceCtrl.dispose();
    _quotationIdCtrl.dispose();
    _discountReasonCtrl.dispose();
    _slaCtrl.dispose();
    _bantBudgetCtrl.dispose();
    _bantAuthorityCtrl.dispose();
    _bantNeedCtrl.dispose();
    _bantTimelineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPipelineBar(),
        const SizedBox(height: 16),
        _buildExistingCustomerToggle(),
        const SizedBox(height: 16),
        _buildLeadScoreSection(),
        const SizedBox(height: 16),
        _buildPrioritySection(),
        const SizedBox(height: 16),
        _buildTierDropdown(),
        const SizedBox(height: 12),
        _buildVipToggle(),
        const SizedBox(height: 16),
        _buildDealValueSection(),
        const SizedBox(height: 16),
        _buildCloseDatePicker(),
        const SizedBox(height: 16),
        _buildSourceSection(),
        const SizedBox(height: 16),
        _buildActionSection(),
        const SizedBox(height: 16),
        _buildOwnerSection(),
        const SizedBox(height: 16),
        _buildBANTSection(),
        const SizedBox(height: 12),
        _buildAdvancedDealSection(),
        const SizedBox(height: 12),
        _buildAttributionSection(),
        const SizedBox(height: 16),
        _buildTagsSection(),
      ],
    );
  }

  Widget _buildExistingCustomerToggle() {
    return GestureDetector(
      onTap: () => setState(() {
        _isExistingCustomer = !_isExistingCustomer;
        _notifyParent();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isExistingCustomer
              ? AppTheme.success.withAlpha(20)
              : AppTheme.surface100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isExistingCustomer
                ? AppTheme.success.withAlpha(120)
                : AppTheme.surface200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _isExistingCustomer
                  ? Icons.verified_user_rounded
                  : Icons.person_outline_rounded,
              size: 18,
              color: _isExistingCustomer
                  ? AppTheme.success
                  : AppTheme.textMuted,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Existing Customer',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _isExistingCustomer
                        ? AppTheme.success
                        : AppTheme.textSecondary,
                  ),
                ),
                Text(
                  _isExistingCustomer
                      ? 'Yes — this is an existing customer'
                      : 'No — this is a new lead',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: _isExistingCustomer
                        ? AppTheme.success
                        : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Switch(
              value: _isExistingCustomer,
              onChanged: (v) => setState(() {
                _isExistingCustomer = v;
                _notifyParent();
              }),
              activeThumbColor: AppTheme.success,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPipelineBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_tree_outlined,
                size: 16,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Pipeline Stage',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bars row
              Row(
                children: List.generate(_statuses.length, (i) {
                  final status = _statuses[i];
                  final currentIndex = _statuses.indexOf(_selectedStatus);
                  final isPast = i < currentIndex;
                  final isCurrent = i == currentIndex;
                  final color = AppTheme.leadStatusColor(status);
                  return Container(
                    width: 52,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isPast || isCurrent ? color : AppTheme.surface200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              // Labels row — tappable
              Row(
                children: List.generate(_statuses.length, (i) {
                  final status = _statuses[i];
                  final isActive = _selectedStatus == status;
                  final currentIndex = _statuses.indexOf(_selectedStatus);
                  final isPast = i < currentIndex;
                  final color = AppTheme.leadStatusColor(status);
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedStatus = status;
                      _selectedSubState = '';
                      _notifyParent();
                    }),
                    child: Container(
                      width: 56,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: isActive
                          ? BoxDecoration(
                              color: color.withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: color.withAlpha(120),
                                width: 1.5,
                              ),
                            )
                          : null,
                      child: Text(
                        status,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive
                              ? color
                              : isPast
                              ? AppTheme.textSecondary
                              : AppTheme.textMuted,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        // Sub-state
        if (_statusSubStates.containsKey(_selectedStatus)) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (_statusSubStates[_selectedStatus] ?? []).map((sub) {
              final isSelected = _selectedSubState == sub;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedSubState = sub;
                  _notifyParent();
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryContainer
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    sub,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
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
        // Won/Lost Result section
        if (_selectedStatus == 'Result') ...[
          const SizedBox(height: 12),
          // Result dropdown: Won, Lost, Not Interested
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Result *',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedResultOutcome.isEmpty
                    ? null
                    : _selectedResultOutcome,
                hint: Text(
                  'Select result',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                isExpanded: true,
                isDense: true,
                items: ['Won', 'Lost', 'Not Interested']
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Row(
                          children: [
                            Icon(
                              r == 'Won'
                                  ? Icons.emoji_events_rounded
                                  : r == 'Lost'
                                  ? Icons.cancel_rounded
                                  : Icons.do_not_disturb_alt_rounded,
                              size: 16,
                              color: r == 'Won'
                                  ? AppTheme.success
                                  : r == 'Lost'
                                  ? AppTheme.error
                                  : AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              r,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: r == 'Won'
                                    ? AppTheme.success
                                    : r == 'Lost'
                                    ? AppTheme.error
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedResultOutcome = v ?? '';
                  _resultReasonCtrl.clear();
                  _notifyParent();
                }),
                icon: const Icon(Icons.expand_more_rounded, size: 16),
              ),
            ),
          ),
          if (_selectedResultOutcome.isNotEmpty) ...[
            const SizedBox(height: 10),
            TextFormField(
              controller: _resultReasonCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Reason for $_selectedResultOutcome *',
                hintText: _selectedResultOutcome == 'Won'
                    ? 'Why was this deal won?'
                    : _selectedResultOutcome == 'Lost'
                    ? 'Why was this deal lost?'
                    : 'Why is the customer not interested?',
                prefixIcon: Icon(
                  _selectedResultOutcome == 'Won'
                      ? Icons.emoji_events_rounded
                      : _selectedResultOutcome == 'Lost'
                      ? Icons.cancel_rounded
                      : Icons.do_not_disturb_alt_rounded,
                  size: 18,
                  color: _selectedResultOutcome == 'Won'
                      ? AppTheme.success
                      : _selectedResultOutcome == 'Lost'
                      ? AppTheme.error
                      : AppTheme.textSecondary,
                ),
              ),
              onChanged: (v) => setState(() {
                _resultReason = v;
                _notifyParent();
              }),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildLeadScoreSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Lead Intelligence',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lead Score: ${_leadScore.toInt()}/100',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Slider(
                      value: _leadScore,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: _leadScore >= 70
                          ? AppTheme.success
                          : _leadScore >= 40
                          ? AppTheme.warning
                          : AppTheme.error,
                      onChanged: (v) => setState(() {
                        _leadScore = v;
                        _notifyParent();
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Lead Grade
              Column(
                children: [
                  Text(
                    'Grade',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: _leadGrades.map((g) {
                      final isSelected = _selectedLeadGrade == g;
                      final color = g == 'A'
                          ? AppTheme.success
                          : g == 'B'
                          ? AppTheme.primary
                          : g == 'C'
                          ? AppTheme.warning
                          : AppTheme.error;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedLeadGrade = g;
                          _notifyParent();
                        }),
                        child: Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? color : AppTheme.surface100,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? color : AppTheme.surface200,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              g,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conversion Probability: ${_conversionProbability.toInt()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Slider(
                value: _conversionProbability,
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: AppTheme.primary,
                onChanged: (v) => setState(() {
                  _conversionProbability = v;
                  _notifyParent();
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Forecast Category
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Forecast Category',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedForecastCategory.isEmpty
                    ? null
                    : _selectedForecastCategory,
                hint: Text(
                  'Select',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                isExpanded: true,
                isDense: true,
                items: _forecastCategories
                    .map(
                      (f) => DropdownMenuItem(
                        value: f,
                        child: Text(
                          f,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedForecastCategory = v ?? '';
                  _notifyParent();
                }),
                icon: const Icon(Icons.expand_more_rounded, size: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Next Best Action
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Next Best Action',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedNextBestAction.isEmpty
                    ? null
                    : _selectedNextBestAction,
                hint: Text(
                  'Select',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                isExpanded: true,
                isDense: true,
                items: _nextBestActions
                    .map(
                      (a) => DropdownMenuItem(
                        value: a,
                        child: Text(
                          a,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedNextBestAction = v ?? '';
                  if (v != 'Others') _otherNextBestAction = '';
                  _notifyParent();
                }),
                icon: const Icon(Icons.expand_more_rounded, size: 16),
              ),
            ),
          ),
          Visibility(
            visible: _selectedNextBestAction == 'Others',
            maintainState: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Specify Next Best Action *',
                  hintText: 'Please specify...',
                ),
                validator: (v) =>
                    _selectedNextBestAction == 'Others' &&
                        (v == null || v.trim().isEmpty)
                    ? 'Required'
                    : null,
                onChanged: (v) => setState(() {
                  _otherNextBestAction = v;
                  _notifyParent();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _priorities.map((p) {
            final isSelected = _selectedPriority == p;
            final color = AppTheme.priorityColor(p);
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedPriority = p;
                  _notifyParent();
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    p,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTierDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Customer Tier',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTier,
              isExpanded: true,
              isDense: true,
              items: _tiers
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(
                        t,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedTier = v!;
                if (v != 'Others') _otherTier = '';
                _notifyParent();
              }),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        Visibility(
          visible: _selectedTier == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Tier *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _selectedTier == 'Others' && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() {
                _otherTier = v;
                _notifyParent();
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVipToggle() {
    return GestureDetector(
      onTap: () => setState(() {
        _isVip = !_isVip;
        _notifyParent();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isVip ? const Color(0xFFFEF3C7) : AppTheme.surface100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isVip ? const Color(0xFFB45309) : AppTheme.surface200,
          ),
        ),
        child: Row(
          children: [
            Text('⭐', style: TextStyle(fontSize: _isVip ? 18 : 16)),
            const SizedBox(width: 8),
            Text(
              'Mark as VIP',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _isVip
                    ? const Color(0xFFB45309)
                    : AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            Switch(
              value: _isVip,
              onChanged: (v) => setState(() {
                _isVip = v;
                _notifyParent();
              }),
              activeThumbColor: const Color(0xFFB45309),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealValueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deal Value (Optional)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Currency selector
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCurrency,
                  items: _currencies
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                            c,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _selectedCurrency = v!;
                    if (v != 'Others') _otherCurrency = '';
                    _notifyParent();
                  }),
                  icon: const Icon(Icons.expand_more_rounded, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _dealValueCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
                ),
                onChanged: (v) => setState(() {
                  _dealValue = double.tryParse(v) ?? 0;
                  _notifyParent();
                }),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _selectedCurrency == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Currency *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _selectedCurrency == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() {
                _otherCurrency = v;
                _notifyParent();
              }),
            ),
          ),
        ),
        if (_dealValue > 0) ...[
          const SizedBox(height: 6),
          Text(
            _formatAmount(_dealValue),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: _quickAmounts.map((qa) {
            return GestureDetector(
              onTap: () {
                final val = qa['value'] as double;
                setState(() {
                  _dealValue = val;
                  _dealValueCtrl.text = val.toStringAsFixed(0);
                  _notifyParent();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.surface200),
                ),
                child: Text(
                  qa['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCloseDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          setState(() {
            _expectedCloseDate = picked;
            _notifyParent();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surface200),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              _expectedCloseDate != null
                  ? 'Close Date: ${_expectedCloseDate!.day}/${_expectedCloseDate!.month}/${_expectedCloseDate!.year}'
                  : 'Expected Close Date',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: _expectedCloseDate != null
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            if (_expectedCloseDate != null)
              GestureDetector(
                onTap: () => setState(() {
                  _expectedCloseDate = null;
                  _notifyParent();
                }),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Source Attribution',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _sources.map((s) {
            final isSelected = _selectedSource == s;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedSource = s;
                if (s != 'Others') _otherSourceText = '';
                _notifyParent();
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryContainer
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.surface200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  s,
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
        Visibility(
          visible: _selectedSource == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              controller: _otherSourceCtrl,
              decoration: const InputDecoration(
                labelText: 'Specify Source *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _selectedSource == 'Others' && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() {
                _otherSourceText = v;
                _notifyParent();
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _campaignCtrl,
          decoration: const InputDecoration(
            labelText: 'Campaign Name',
            prefixIcon: Icon(Icons.campaign_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _utmCtrl,
          decoration: const InputDecoration(
            labelText: 'UTM Source / Medium',
            prefixIcon: Icon(Icons.link_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _referralCtrl,
          decoration: const InputDecoration(
            labelText: 'Referral Name',
            prefixIcon: Icon(Icons.person_add_outlined, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_note_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Scheduled Action *',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.error.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Required',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppTheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action type chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _actions.map((a) {
              final isSelected = _selectedAction == a;
              final color = a == 'Not Interested'
                  ? AppTheme.error
                  : AppTheme.primary;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedAction = a;
                  _selectedFrequency = '';
                  _customFrequencyDate = null;
                  _scheduledActionDate = null;
                  _scheduledActionTime = null;
                  _appointmentLocationCtrl.clear();
                  _appointmentLinkCtrl.clear();
                  _notifyParent();
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withAlpha(30)
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.surface200,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    a,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? color : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // ── APPOINTMENT: custom date/time + optional address fields ──
          if (_selectedAction == 'Appointment') ...[
            const SizedBox(height: 14),
            Text(
              'Appointment Date & Time *',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            _scheduledActionDate ??
                            DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 1825),
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          _scheduledActionDate = picked;
                          _notifyParent();
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _scheduledActionDate == null
                              ? AppTheme.error.withAlpha(80)
                              : AppTheme.primary.withAlpha(80),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: _scheduledActionDate == null
                                ? AppTheme.error
                                : AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _scheduledActionDate != null
                                ? '${_scheduledActionDate!.day}/${_scheduledActionDate!.month}/${_scheduledActionDate!.year}'
                                : 'Select Date *',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: _scheduledActionDate == null
                                  ? AppTheme.error
                                  : AppTheme.primary,
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
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _scheduledActionTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _scheduledActionTime = picked;
                          _notifyParent();
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _scheduledActionTime == null
                              ? AppTheme.error.withAlpha(80)
                              : AppTheme.primary.withAlpha(80),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: _scheduledActionTime == null
                                ? AppTheme.error
                                : AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _scheduledActionTime != null
                                ? _scheduledActionTime!.format(context)
                                : 'Select Time *',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: _scheduledActionTime == null
                                  ? AppTheme.error
                                  : AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _actionNotesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Action Notes',
                hintText: 'Add notes for this appointment...',
                prefixIcon: Icon(Icons.notes_rounded, size: 18),
              ),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _appointmentLocationCtrl,
              decoration: const InputDecoration(
                labelText: 'Address / Location (Optional)',
                hintText: 'e.g. Client Office, 42 MG Road, Bangalore',
                prefixIcon: Icon(Icons.location_on_outlined, size: 18),
              ),
              onChanged: (_) => _notifyParent(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _appointmentLinkCtrl,
              decoration: const InputDecoration(
                labelText: 'Address Link (Optional)',
                hintText: 'e.g. https://maps.google.com/...',
                prefixIcon: Icon(Icons.map_outlined, size: 18),
              ),
              onChanged: (_) => _notifyParent(),
            ),
          ],

          // ── OTHER ACTIONS (Follow-up, Video Call, Call Back): frequency + time ──
          if (_selectedAction.isNotEmpty &&
              _selectedAction != 'Not Interested' &&
              _selectedAction != 'Appointment') ...[
            const SizedBox(height: 14),
            Text(
              'Follow-up Frequency *',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InputDecorator(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFrequency.isEmpty ? null : _selectedFrequency,
                  hint: Text(
                    'Select frequency',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  isExpanded: true,
                  isDense: true,
                  items: _followUpFrequencies
                      .map(
                        (f) => DropdownMenuItem(
                          value: f,
                          child: Text(
                            f,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedFrequency = v ?? '';
                      _customFrequencyDate = null;
                      if (v == 'Daily') {
                        _scheduledActionDate = DateTime.now().add(
                          const Duration(days: 1),
                        );
                      } else if (v == 'Weekly') {
                        _scheduledActionDate = DateTime.now().add(
                          const Duration(days: 7),
                        );
                      } else if (v == 'Monthly') {
                        final now = DateTime.now();
                        _scheduledActionDate = DateTime(
                          now.year,
                          now.month + 1,
                          now.day,
                        );
                      } else if (v == 'Yearly') {
                        final now = DateTime.now();
                        _scheduledActionDate = DateTime(
                          now.year + 1,
                          now.month,
                          now.day,
                        );
                      }
                      _notifyParent();
                    });
                  },
                  icon: const Icon(Icons.expand_more_rounded, size: 16),
                ),
              ),
            ),
            if (_selectedFrequency.isNotEmpty) ...[
              const SizedBox(height: 10),
              if (_selectedFrequency == 'Daily' ||
                  _selectedFrequency == 'Weekly' ||
                  _selectedFrequency == 'Monthly') ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.surface200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _scheduledActionDate != null
                            ? '${_scheduledActionDate!.day}/${_scheduledActionDate!.month}/${_scheduledActionDate!.year} (Auto-set)'
                            : 'Auto-set',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Auto',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_selectedFrequency == 'Yearly' ||
                  _selectedFrequency == 'Custom') ...[
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          _scheduledActionDate ??
                          DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 1825)),
                    );
                    if (picked != null) {
                      setState(() {
                        _customFrequencyDate = picked;
                        _scheduledActionDate = picked;
                        _notifyParent();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _scheduledActionDate == null
                            ? AppTheme.error.withAlpha(80)
                            : AppTheme.primary.withAlpha(80),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: _scheduledActionDate == null
                              ? AppTheme.error
                              : AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _scheduledActionDate != null
                              ? '${_scheduledActionDate!.day}/${_scheduledActionDate!.month}/${_scheduledActionDate!.year}'
                              : 'Select date *',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: _scheduledActionDate == null
                                ? AppTheme.error
                                : AppTheme.primary,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _scheduledActionTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _scheduledActionTime = picked;
                      _notifyParent();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.surface200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _scheduledActionTime != null
                            ? _scheduledActionTime!.format(context)
                            : 'Select Time *',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: _scheduledActionTime != null
                              ? AppTheme.textPrimary
                              : AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],

          const SizedBox(height: 10),
          if (_selectedAction.isNotEmpty &&
              _selectedAction != 'Appointment') ...[
            TextFormField(
              controller: _actionNotesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Action Notes',
                hintText: 'Add notes for this action...',
              ),
              onChanged: (_) => _notifyParent(),
            ),
          ],

          // Preferred Mode of Contact — for Follow-up
          if (_selectedAction == 'Follow-up') ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  'Preferred Mode of Contact *',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Required',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                    'Calls',
                    'Messages',
                    'WhatsApp Messages',
                    'Email',
                    'Video Call',
                  ].map((m) {
                    final isSelected = _selectedPreferredContact.contains(m);
                    return GestureDetector(
                      onTap: () => setState(() {
                        isSelected
                            ? _selectedPreferredContact.remove(m)
                            : _selectedPreferredContact.add(m);
                        _notifyParent();
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryContainer
                              : AppTheme.surface100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.surface200,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(
                                Icons.check_rounded,
                                size: 12,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              m,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            if (_selectedPreferredContact.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Select at least one preferred contact mode',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.error,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildOwnerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Owner',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showOwnerPicker(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _ownerIdColor(_selectedOwner.id).withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _selectedOwner.initials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _ownerIdColor(_selectedOwner.id),
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
                        _selectedOwner.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _selectedOwner.role,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _ownerIdColor(_selectedOwner.id).withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedOwner.id,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _ownerIdColor(_selectedOwner.id),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showOwnerPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _OwnerPickerSheet(
          selected: _selectedOwner,
          owners: kLeadOwners,
          onSelect: (o) {
            setState(() {
              _selectedOwner = o;
              _notifyParent();
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildBANTSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _showBANT = !_showBANT),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.checklist_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'BANT Qualification',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _showBANT ? 0.5 : 0,
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
            child: _showBANT
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _bantBudgetCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Budget (Confirmed Amount)',
                            prefixIcon: Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _bantAuthorityCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Authority (Decision Maker)',
                            prefixIcon: Icon(
                              Icons.verified_user_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _bantNeedCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Need (Problem to Solve)',
                            prefixIcon: Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _bantTimelineCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Timeline (When to Buy)',
                            prefixIcon: Icon(Icons.schedule_rounded, size: 18),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedDealSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _showAdvancedDeal = !_showAdvancedDeal),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Deal & Contract Details',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _showAdvancedDeal ? 0.5 : 0,
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
            child: _showAdvancedDeal
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _quotationIdCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Quotation / Proposal ID',
                            prefixIcon: Icon(
                              Icons.description_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                _quotationSentDate = picked;
                                _notifyParent();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariantLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.surface200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.send_outlined,
                                  size: 18,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _quotationSentDate != null
                                      ? 'Proposal Sent: ${_quotationSentDate!.day}/${_quotationSentDate!.month}/${_quotationSentDate!.year}'
                                      : 'Proposal Sent Date',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: _quotationSentDate != null
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Discount %: ${_discountPercent.toInt()}%',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  Slider(
                                    value: _discountPercent,
                                    min: 0,
                                    max: 50,
                                    divisions: 50,
                                    activeColor: AppTheme.warning,
                                    onChanged: (v) => setState(() {
                                      _discountPercent = v;
                                      _notifyParent();
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _discountReasonCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Discount Reason',
                            prefixIcon: Icon(
                              Icons.local_offer_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Contract Length',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedContractLength.isEmpty
                                  ? null
                                  : _selectedContractLength,
                              hint: Text(
                                'Select',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              isExpanded: true,
                              isDense: true,
                              items: _contractLengths
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        c,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _selectedContractLength = v ?? '';
                                _notifyParent();
                              }),
                              icon: const Icon(
                                Icons.expand_more_rounded,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Renewal Frequency',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedRenewalFrequency.isEmpty
                                  ? null
                                  : _selectedRenewalFrequency,
                              hint: Text(
                                'Select',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              isExpanded: true,
                              isDense: true,
                              items: _renewalFrequencies
                                  .map(
                                    (r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(
                                        r,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _selectedRenewalFrequency = v ?? '';
                                if (v != 'Others') _otherRenewalFrequency = '';
                                _notifyParent();
                              }),
                              icon: const Icon(
                                Icons.expand_more_rounded,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _selectedRenewalFrequency == 'Others',
                          maintainState: true,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Specify Renewal Frequency *',
                                hintText: 'Please specify...',
                              ),
                              validator: (v) =>
                                  _selectedRenewalFrequency == 'Others' &&
                                      (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                              onChanged: (v) => setState(() {
                                _otherRenewalFrequency = v;
                                _notifyParent();
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                const Duration(days: 1),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                _slaDeadline = picked;
                                _notifyParent();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariantLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.surface200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 18,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _slaDeadline != null
                                      ? 'SLA Due: ${_slaDeadline!.day}/${_slaDeadline!.month}/${_slaDeadline!.year}'
                                      : 'SLA / Response Due Date',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: _slaDeadline != null
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributionSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _showAttribution = !_showAttribution),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.track_changes_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Attribution & Tracking',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _showAttribution ? 0.5 : 0,
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
            child: _showAttribution
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Ad Group / Ad Set',
                            prefixIcon: Icon(Icons.ads_click_rounded, size: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Keyword',
                            prefixIcon: Icon(Icons.search_rounded, size: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                            labelText: 'Landing Page URL',
                            prefixIcon: Icon(Icons.link_rounded, size: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'First Touch Attribution Source',
                            prefixIcon: Icon(
                              Icons.first_page_rounded,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Last Touch Attribution Source',
                            prefixIcon: Icon(Icons.last_page_rounded, size: 18),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    // Tags are based on interests — get from form data or use defaults
    final interestTags = _selectedTags.isNotEmpty ? _selectedTags : <String>[];
    // Show interest-based tags from the interests section if available
    // Also show a note that tags come from interests
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tags',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Based on Interests',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Tags are automatically generated from selected interests in Step 7.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        if (interestTags.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Add interests in Step 7 to generate tags automatically.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interestTags
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary.withAlpha(80)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.label_rounded,
                          size: 12,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

// ─── Owner Picker Sheet ───────────────────────────────────────────────────────

class _OwnerPickerSheet extends StatefulWidget {
  final LeadOwner selected;
  final List<LeadOwner> owners;
  final ValueChanged<LeadOwner> onSelect;

  const _OwnerPickerSheet({
    required this.selected,
    required this.owners,
    required this.onSelect,
  });

  @override
  State<_OwnerPickerSheet> createState() => _OwnerPickerSheetState();
}

class _OwnerPickerSheetState extends State<_OwnerPickerSheet> {
  String _query = '';

  List<LeadOwner> get _filtered {
    // Sort ascending by name
    final sorted = List<LeadOwner>.from(widget.owners)
      ..sort((a, b) => a.name.compareTo(b.name));

    List<LeadOwner> result;
    if (_query.isEmpty) {
      result = sorted;
    } else {
      final q = _query.toLowerCase();
      result = sorted
          .where(
            (o) =>
                o.name.toLowerCase().contains(q) ||
                o.role.toLowerCase().contains(q),
          )
          .toList();
    }

    // Move selected to top
    final selectedIdx = result.indexWhere((o) => o.id == widget.selected.id);
    if (selectedIdx > 0) {
      final selected = result.removeAt(selectedIdx);
      result.insert(0, selected);
    }
    return result;
  }

  Color _idColor(String id) {
    if (id.startsWith('ADM')) return AppTheme.primary;
    if (id.startsWith('EMP')) return AppTheme.success;
    return const Color(0xFFD97706);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      builder: (_, scrollCtrl) => Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Assign Lead Owner',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search to see all employees...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.surface200),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final o = _filtered[i];
                final isSelected = o.id == widget.selected.id;
                final color = _idColor(o.id);
                return ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        o.initials,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    o.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    o.role,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          o.id,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.success,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  selected: isSelected,
                  selectedTileColor: AppTheme.primaryContainer.withAlpha(40),
                  onTap: () => widget.onSelect(o),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
