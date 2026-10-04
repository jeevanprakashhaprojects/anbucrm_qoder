import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/empty_state_widget.dart';

// ─── Interest Card Model ──────────────────────────────────────────────────────

class _InterestCard {
  final String industry;
  int activeTab = 0;
  _InterestCard({required this.industry});
}

// ─── Reusable Field Builders ──────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const _FieldLabel(this.text, {this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          if (required)
            Text(
              ' *',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildDropdownField(
  String label,
  List<String> options, {
  String? value,
  bool required = false,
}) {
  return _StatefulDropdownField(
    label: label,
    options: options,
    initialValue: value,
    required: required,
  );
}

/// Stateful dropdown so each field manages its own value
class _StatefulDropdownField extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? initialValue;
  final bool required;

  const _StatefulDropdownField({
    required this.label,
    required this.options,
    this.initialValue,
    this.required = false,
  });

  @override
  State<_StatefulDropdownField> createState() => _StatefulDropdownFieldState();
}

class _StatefulDropdownFieldState extends State<_StatefulDropdownField> {
  String? _value;
  String _otherText = '';

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final hasOthers = widget.options.contains('Others');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(widget.label, required: widget.required),
        InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _value,
              isExpanded: true,
              isDense: true,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              items: widget.options
                  .map(
                    (o) => DropdownMenuItem(
                      value: o,
                      child: Text(
                        o,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _value = v;
                if (v != 'Others') _otherText = '';
              }),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        if (hasOthers)
          Visibility(
            visible: _value == 'Others',
            maintainState: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Specify ${widget.label} *',
                  hintText: 'Please specify...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.surface200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.surface200),
                  ),
                ),
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                validator: (v) =>
                    _value == 'Others' && (v == null || v.trim().isEmpty)
                    ? 'Required'
                    : null,
                onChanged: (v) => setState(() => _otherText = v),
              ),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}

Widget _buildTextField(
  String label, {
  int maxLines = 1,
  bool required = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FieldLabel(label, required: required),
      TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.surface200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.surface200),
          ),
        ),
        style: GoogleFonts.plusJakartaSans(fontSize: 13),
      ),
      const SizedBox(height: 12),
    ],
  );
}

// ─── Accordion Section ────────────────────────────────────────────────────────

class _AccordionSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget content;
  final bool initiallyExpanded;

  const _AccordionSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  State<_AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<_AccordionSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.color.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.icon, size: 16, color: widget.color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
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
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        widget.content,
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─── Nominees Sub-section ─────────────────────────────────────────────────────

class _NomineesSection extends StatefulWidget {
  const _NomineesSection();

  @override
  State<_NomineesSection> createState() => _NomineesSectionState();
}

class _NomineesSectionState extends State<_NomineesSection> {
  final List<_NomineeData> _nominees = [];

  static const _relationTypes = [
    'Spouse',
    'Son',
    'Daughter',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Guardian',
    'Other',
  ];

  void _addNominee() {
    if (_totalShare >= 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot add more nominees. Total share is already 100%.',
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    setState(() {
      _nominees.add(_NomineeData());
    });
  }

  void _removeNominee(int index) {
    setState(() => _nominees.removeAt(index));
  }

  double get _totalShare => _nominees.fold<double>(
    0,
    (sum, n) => sum + (double.tryParse(n.shareCtrl.text) ?? 0),
  );

  bool get _isShareValid => _nominees.isEmpty || _totalShare == 100;
  bool get _isShareExceeded => _totalShare > 100;

  void _trySaveNominee(int index) {
    final nominee = _nominees[index];
    if (nominee.nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter nominee name',
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    final share = double.tryParse(nominee.shareCtrl.text) ?? 0;
    if (share <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid share percentage',
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    // Check if adding/updating this nominee would exceed 100%
    final otherShares = _nominees
        .asMap()
        .entries
        .where((e) => e.key != index)
        .fold<double>(
          0,
          (sum, e) => sum + (double.tryParse(e.value.shareCtrl.text) ?? 0),
        );
    if (otherShares + share > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Total nominee share cannot exceed 100%. Remaining: ${(100 - otherShares).toStringAsFixed(0)}%',
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    setState(() => nominee.isSaved = true);
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
              '${nominee.nameCtrl.text.split(' ').first} saved (${share.toStringAsFixed(0)}%)',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalShare = _totalShare;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_nominees.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'No nominees added yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ..._nominees.asMap().entries.map((entry) {
          final i = entry.key;
          final nominee = entry.value;
          return _NomineeCard(
            key: ValueKey('nominee_$i'),
            nominee: nominee,
            relationTypes: _relationTypes,
            index: i,
            onRemove: () => _removeNominee(i),
            onChanged: () => setState(() {}),
            onSave: () => _trySaveNominee(i),
          );
        }),
        if (_nominees.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _isShareExceeded
                  ? AppTheme.error.withAlpha(20)
                  : totalShare == 100
                  ? AppTheme.success.withAlpha(20)
                  : AppTheme.warning.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isShareExceeded
                    ? AppTheme.error.withAlpha(80)
                    : totalShare == 100
                    ? AppTheme.success.withAlpha(80)
                    : AppTheme.warning.withAlpha(80),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isShareExceeded
                      ? Icons.error_outline_rounded
                      : totalShare == 100
                      ? Icons.check_circle_outline_rounded
                      : Icons.info_outline_rounded,
                  size: 16,
                  color: _isShareExceeded
                      ? AppTheme.error
                      : totalShare == 100
                      ? AppTheme.success
                      : AppTheme.warning,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isShareExceeded
                        ? 'Total share ${totalShare.toStringAsFixed(0)}% exceeds 100% — please adjust'
                        : totalShare == 100
                        ? 'Total share is 100% ✓'
                        : 'Total share: ${totalShare.toStringAsFixed(0)}% (must equal 100%)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _isShareExceeded
                          ? AppTheme.error
                          : totalShare == 100
                          ? AppTheme.success
                          : AppTheme.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        GestureDetector(
          onTap: _addNominee,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _totalShare >= 100
                  ? AppTheme.surface200
                  : AppTheme.surface100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _totalShare >= 100
                    ? AppTheme.surface200
                    : AppTheme.primary.withAlpha(102),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _totalShare >= 100 ? Icons.block_rounded : Icons.add_rounded,
                  size: 16,
                  color: _totalShare >= 100
                      ? AppTheme.textMuted
                      : AppTheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  _totalShare >= 100
                      ? 'Cannot add nominee (100% allocated)'
                      : 'Add Nominee',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _totalShare >= 100
                        ? AppTheme.textMuted
                        : AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NomineeData {
  final nameCtrl = TextEditingController();
  final shareCtrl = TextEditingController();
  String relation = 'Spouse';
  bool isSaved = false;
}

class _NomineeCard extends StatefulWidget {
  final _NomineeData nominee;
  final List<String> relationTypes;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final VoidCallback onSave;

  const _NomineeCard({
    super.key,
    required this.nominee,
    required this.relationTypes,
    required this.index,
    required this.onRemove,
    required this.onChanged,
    required this.onSave,
  });

  @override
  State<_NomineeCard> createState() => _NomineeCardState();
}

class _NomineeCardState extends State<_NomineeCard> {
  @override
  Widget build(BuildContext context) {
    final isSaved = widget.nominee.isSaved;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSaved ? AppTheme.success.withAlpha(10) : AppTheme.surface100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSaved ? AppTheme.success.withAlpha(80) : AppTheme.surface200,
          width: isSaved ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Nominee ${widget.index + 1}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSaved ? AppTheme.success : AppTheme.primary,
                ),
              ),
              if (isSaved) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: AppTheme.success,
                ),
              ],
              const Spacer(),
              if (isSaved)
                GestureDetector(
                  onTap: () {
                    setState(() => widget.nominee.isSaved = false);
                    widget.onChanged();
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: widget.onRemove,
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
          if (isSaved) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.nominee.nameCtrl.text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.nominee.relation,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.nominee.shareCtrl.text}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.success,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            TextFormField(
              controller: widget.nominee.nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nominee Name'),
              onChanged: (_) => widget.onChanged(),
            ),
            const SizedBox(height: 10),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Relation',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.nominee.relation,
                  isDense: true,
                  isExpanded: true,
                  items: widget.relationTypes
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(
                            r,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => widget.nominee.relation = v);
                      widget.onChanged();
                    }
                  },
                  icon: const Icon(Icons.expand_more_rounded, size: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: widget.nominee.shareCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Share %',
                hintText: 'e.g. 50',
                suffixText: '%',
              ),
              onChanged: (_) => widget.onChanged(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: widget.onRemove,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: AppTheme.error,
                  ),
                  label: Text(
                    'Remove',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.error,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: widget.onSave,
                  icon: const Icon(Icons.save_rounded, size: 16),
                  label: Text(
                    'Save Nominee',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Universal Fields ─────────────────────────────────────────────────────────

class _UniversalFieldsSection extends StatefulWidget {
  const _UniversalFieldsSection();

  @override
  State<_UniversalFieldsSection> createState() =>
      _UniversalFieldsSectionState();
}

class _UniversalFieldsSectionState extends State<_UniversalFieldsSection> {
  String? _priority;
  String? _readiness;
  String? _source;
  String? _timeline;
  String? _commPref;
  String? _crossSell;
  String? _upsell;
  String? _replacement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownFieldStateful(
          'Interest Priority',
          ['High', 'Medium', 'Low'],
          _priority,
          (v) => setState(() => _priority = v),
        ),
        _buildDropdownFieldStateful(
          'Customer Readiness',
          [
            'Just Exploring',
            'Researching',
            'Ready to Buy',
            'Comparing Options',
            'Decision Made',
          ],
          _readiness,
          (v) => setState(() => _readiness = v),
        ),
        _buildDropdownFieldStateful(
          'Interest Source',
          [
            'Customer mentioned',
            'Agent suggested',
            'Referral',
            'Campaign',
            'Cross-sell from existing policy',
            'Website enquiry',
          ],
          _source,
          (v) => setState(() => _source = v),
        ),
        _buildDropdownFieldStateful(
          'Estimated Closing Timeline',
          [
            'This Week',
            'This Month',
            '1-3 Months',
            '3-6 Months',
            '6-12 Months',
            'No timeline',
          ],
          _timeline,
          (v) => setState(() => _timeline = v),
        ),
        _buildTextField('Agent Commission Preference'),
        _buildDropdownFieldStateful(
          'Preferred Communication for This Interest',
          ['Phone Call', 'WhatsApp', 'Email', 'SMS', 'In-Person Visit'],
          _commPref,
          (v) => setState(() => _commPref = v),
        ),
        _buildDropdownFieldStateful(
          'Cross-sell Opportunity',
          ['Yes', 'No'],
          _crossSell,
          (v) => setState(() => _crossSell = v),
        ),
        if (_crossSell == 'Yes')
          _buildTextField('Link Existing Policy/Lead (Cross-sell)'),
        _buildDropdownFieldStateful(
          'Upsell Opportunity',
          ['Yes', 'No'],
          _upsell,
          (v) => setState(() => _upsell = v),
        ),
        if (_upsell == 'Yes')
          _buildTextField('Link Existing Policy/Lead (Upsell)'),
        _buildDropdownFieldStateful(
          'Replacement Flag',
          ['Yes', 'No', 'Exploring'],
          _replacement,
          (v) => setState(() => _replacement = v),
        ),
        if (_replacement == 'Yes') ...[
          _buildTextField('Existing Insurer'),
          _buildTextField('Existing Policy Number'),
          _buildTextField('Reason for Switching'),
        ],
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdownFieldStateful(
    String label,
    List<String> options,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              isDense: true,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              items: options
                  .map(
                    (o) => DropdownMenuItem(
                      value: o,
                      child: Text(
                        o,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ─── Agent Activity & Competitive Intelligence ────────────────────────────────

Widget _buildAgentActivitySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Date of First Discussion'),
      _buildTextField('Number of Discussions Had'),
      _buildTextField('Next Scheduled Follow-up Date'),
      _buildDropdownField('Next Follow-up Mode', [
        'Call',
        'Visit',
        'WhatsApp',
        'Email',
      ]),
      _buildDropdownField('Customer Responsiveness', [
        'Very responsive',
        'Moderately responsive',
        'Slow',
        'Not responding',
      ]),
      _buildDropdownField('Interest Temperature', [
        'Hot',
        'Warm',
        'Cold',
        'Ice cold',
      ]),
    ],
  );
}

Widget _buildCompetitiveSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Competitor Products Customer is Comparing'),
      _buildDropdownField('Competitor Pricing Known?', ['Yes', 'No']),
      _buildTextField('Our Competitive Advantage Discussed'),
      _buildTextField('Customer Concern About Our Product'),
      _buildDropdownField('Competitor Being Preferred?', [
        'Yes',
        'No',
        'Equal',
      ]),
    ],
  );
}

Widget _buildFinancialQualificationSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Annual Income'),
      _buildDropdownField('Income Stability', [
        'Stable',
        'Fluctuating',
        'Seasonal',
      ]),
      _buildDropdownField('Credit Awareness', ['High', 'Medium', 'Low']),
      _buildTextField('Existing EMI Burden (₹/month)'),
      _buildDropdownField('Budget Flexibility', [
        'Fixed',
        'Somewhat flexible',
        'Very flexible',
      ]),
      _buildTextField('Down Payment Available (₹)'),
    ],
  );
}

Widget _buildDecisionProcessSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Number of Decision Makers Involved'),
      _buildTextField('Decision Maker Names and Roles'),
      _buildDropdownField('Decision Timeline Confirmed?', [
        'Yes',
        'Approximate',
        'No idea',
      ]),
      _buildTextField('Approval Hierarchy'),
      _buildDropdownField('Budget Approved?', ['Yes', 'Partially', 'Not yet']),
      _buildDropdownField('Final Decision Maker Confirmed?', [
        'Yes',
        'Not sure',
      ]),
    ],
  );
}

Widget _buildAfterSalesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Service Expectation Level', [
        'High',
        'Medium',
        'Low',
      ]),
      _buildDropdownField('Claim Expectation Awareness', [
        'Well informed',
        'Somewhat aware',
        'Not aware',
      ]),
      _buildDropdownField('Renewal Reminder Preference', [
        '30 days before',
        '15 days before',
        'SMS',
        'Call',
      ]),
      _buildDropdownField('Loyalty Program Interest', [
        'Yes',
        'No',
        'Not Sure',
      ]),
    ],
  );
}

// ─── Industry-Specific Field Sections ────────────────────────────────────────

Widget _buildLifeInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product Name'),
      _buildTextField('Sum Assured (₹)'),
      _buildTextField('Premium Amount (₹/year)'),
      _buildTextField('Policy Term (years)'),
      _buildTextField('Existing Life Cover Amount (₹)'),
      _buildTextField('Number of Dependent Family Members'),
      _buildDropdownField('Any Existing Critical Illness Cover?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Any Existing Accidental Cover?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Preferred Insurer Interaction Mode', [
        'Online only',
        'Agent-assisted',
        'Branch visit',
      ]),
      _buildDropdownField('Medical Test Preference', [
        'At home',
        'At hospital',
        'Already done',
        'Not required',
      ]),
      _buildDropdownField('Policy Document Delivery Preference', [
        'Digital',
        'Physical',
        'Both',
      ]),
      _buildTextField('Annual Premium as % of Income'),
      _buildTextField('Previous Policy Surrender Value (₹)'),
      _buildTextField('Previous Policy Loan Outstanding (₹)'),
      _buildTextField('Trustee Name (if for child)'),
      _buildTextField('Trustee Age'),
      _buildTextField('Trustee Relation'),
    ],
  );
}

Widget _buildHealthInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product Name'),
      _buildTextField('Sum Insured (₹)'),
      _buildTextField('Premium Amount (₹/year)'),
      _buildTextField('Existing Health Cover Amount (₹)'),
      _buildTextField('Family Members to be Covered (count + names)'),
      _buildDropdownField('Any Pre-existing Diseases Declared?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Waiting Period Acceptable?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Maternity Cover Needed For?', [
        'Self',
        'Spouse',
        'Daughter',
        'Not needed',
      ]),
      _buildDropdownField('Day Care Treatments Covered Previously?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Ambulance Cover Required?', ['Yes', 'No']),
      _buildDropdownField('Ayush Treatment Required?', ['Yes', 'No']),
      _buildDropdownField('Organ Donor Expenses Covered?', ['Yes', 'No']),
      _buildDropdownField('Restore Benefit Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('No Claim Bonus Expected?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Preferred Network Hospitals'),
      _buildDropdownField('Co-pay Acceptable Percentage', [
        '0%',
        '10%',
        '20%',
        '30%',
        'Not acceptable',
      ]),
      _buildDropdownField('Top-up Plan Required?', ['Yes', 'No']),
      _buildDropdownField('Parental Health Cover Needed?', [
        'Yes',
        'No',
        'Only one',
        'Both',
      ]),
    ],
  );
}

Widget _buildMotorInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Vehicle Make & Model'),
      _buildTextField('Vehicle Year'),
      _buildTextField('Registration Number'),
      _buildDropdownField('Vehicle Type', [
        'Two Wheeler',
        'Four Wheeler',
        'Commercial',
      ]),
      _buildDropdownField('Insurance Type', [
        'Comprehensive',
        'Third Party',
        'Own Damage',
      ]),
      _buildTextField('IDV Value (₹)'),
      _buildTextField('Previous Claim Amount (₹)'),
      _buildTextField('Previous Claim Details'),
      _buildDropdownField('Vehicle Modification Done?', ['Yes', 'No']),
      _buildTextField('Modification Description (if any)'),
      _buildDropdownField('Hypothecation / Loan on Vehicle?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Financier Name'),
      _buildTextField('Previous Insurer Claim Settlement Rating'),
      _buildDropdownField('Roadside Assistance Required?', [
        'Yes',
        'No',
        'Already have',
      ]),
      _buildDropdownField('Garage Preference', [
        'Authorized',
        'Any networked',
        'Specific garage',
      ]),
      _buildTextField('Previous Policy Discount %'),
      _buildDropdownField('Transfer of NCB from Previous Vehicle?', [
        'Yes',
        'No',
        'Not Applicable',
      ]),
    ],
  );
}

Widget _buildHomeInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Property Address'),
      _buildDropdownField('Property Type', [
        'Apartment',
        'Independent House',
        'Villa',
        'Commercial',
      ]),
      _buildTextField('Property Value (₹)'),
      _buildTextField('Built-up Area (sq ft)'),
      _buildTextField('Previous Home Insurance Claim History'),
      _buildTextField('Claim Amount (₹)'),
      _buildDropdownField('Security System Installed?', ['Yes', 'No']),
      _buildDropdownField('Smoke Detectors Installed?', ['Yes', 'No']),
      _buildDropdownField('Fire Extinguishers Available?', ['Yes', 'No']),
      _buildDropdownField('CCTV Installed?', ['Yes', 'No']),
      _buildTextField('Nearby Fire Station Distance (km)'),
      _buildTextField('Nearby Hospital Distance (km)'),
      _buildDropdownField('Building Approval from Local Authority?', [
        'Yes',
        'No',
        'Pending',
      ]),
      _buildDropdownField('Property Tax Up to Date?', ['Yes', 'No']),
      _buildDropdownField('Flood Zone Area?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Earthquake Zone Area?', ['Yes', 'No', 'Not Sure']),
    ],
  );
}

Widget _buildTravelInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Destination Country/Countries'),
      _buildTextField('Travel Start Date'),
      _buildTextField('Travel End Date'),
      _buildTextField('Number of Travellers'),
      _buildDropdownField('Travel Purpose', [
        'Leisure',
        'Business',
        'Education',
        'Medical',
        'Other',
      ]),
      _buildTextField('Pre-existing Medical Conditions'),
      _buildTextField('Medical Condition Stability Period'),
      _buildTextField('Luggage Value Estimate (₹)'),
      _buildDropdownField('Flight Booking Status', [
        'Booked',
        'Planning',
        'Not booked',
      ]),
      _buildDropdownField('Hotel Booking Status', [
        'Booked',
        'Planning',
        'Not booked',
      ]),
      _buildDropdownField('Traveller Occupation', [
        'Student',
        'Professional',
        'Business',
        'Retired',
        'Others',
      ]),
      _buildDropdownField('Travel Agent Used?', ['Yes', 'No']),
      _buildTextField('Travel Agent Name (if any)'),
      _buildTextField('Trip Cost Estimate (₹)'),
    ],
  );
}

Widget _buildRealEstateFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Property Type', [
        'Residential',
        'Commercial',
        'Plot',
        'Agricultural',
      ]),
      _buildDropdownField('Transaction Type', ['Buy', 'Sell', 'Rent', 'Lease']),
      _buildTextField('Budget Range (₹)'),
      _buildTextField('Preferred Location'),
      _buildTextField('Required Area (sq ft)'),
      _buildDropdownField('BHK Requirement', [
        '1 BHK',
        '2 BHK',
        '3 BHK',
        '4 BHK',
        '4+ BHK',
        'Studio',
        'Villa',
      ]),
      _buildDropdownField('Property Visit Done?', ['Yes', 'No']),
      _buildTextField('Property Visited Locations'),
      _buildTextField('Builder Reputation Rating'),
      _buildTextField('Construction Quality Feedback'),
      _buildDropdownField('Legal Verification Status', [
        'Verified',
        'Pending',
        'Not checked',
      ]),
      _buildDropdownField('Encumbrance Certificate Checked?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Approved Plan Number'),
      _buildDropdownField('Occupancy Certificate Status', [
        'Received',
        'Pending',
        'Not applicable',
      ]),
      _buildTextField('Brokerage Expectation'),
      _buildTextField('Agent Commission Preference'),
      _buildDropdownField('Price Negotiation Flexibility', [
        'Firm',
        '5% negotiable',
        '10% negotiable',
        'More than 10%',
      ]),
      _buildTextField('Registration Cost Expectation'),
      _buildDropdownField('Stamp Duty Awareness', [
        'Aware',
        'Needs explanation',
      ]),
      _buildTextField('Current Rent Amount (₹)'),
      _buildTextField('Notice Period in Current Place (months)'),
      _buildDropdownField('School/College Proximity Required?', ['Yes', 'No']),
      _buildDropdownField('Hospital Proximity Required?', ['Yes', 'No']),
      _buildDropdownField('Public Transport Access Required?', ['Yes', 'No']),
      _buildDropdownField('Vastu Preference', ['Yes', 'No', 'Not important']),
      _buildDropdownField('Pet-friendly Required?', ['Yes', 'No']),
      _buildDropdownField('Gated Community Preference', [
        'Yes',
        'No',
        'Preferred',
      ]),
      _buildTextField('Floor Preference Specific'),
      _buildDropdownField('Parking Type Preference', [
        'Covered',
        'Open',
        'Both',
        'Not needed',
      ]),
      _buildDropdownField('Visitor Parking Available?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
    ],
  );
}

Widget _buildEducationFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Course/Program of Interest'),
      _buildTextField('Institution Name'),
      _buildDropdownField('Education Level', [
        'School',
        'Undergraduate',
        'Postgraduate',
        'Diploma',
        'Certificate',
        'PhD',
      ]),
      _buildTextField('Student Name'),
      _buildTextField('Student Age'),
      _buildTextField('Previous Academic Performance'),
      _buildDropdownField('Learning Difficulty or Special Needs?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Special Needs Description (if any)'),
      _buildDropdownField('Preferred Learning Mode', [
        'In-person',
        'Online',
        'Hybrid',
        'Not sure',
      ]),
      _buildTextField('Board Preference'),
      _buildDropdownField('Distance from Home Preferred?', [
        'Same city',
        'Within state',
        'Out of state',
        'Abroad',
      ]),
      _buildTextField('Coaching Center Preference'),
      _buildDropdownField('Previous Coaching Attended?', ['Yes', 'No']),
      _buildTextField('Previous Coaching Name and Rating'),
      _buildDropdownField('Scholarship or Financial Aid Needed?', [
        'Yes',
        'No',
        'Already applied',
      ]),
      _buildTextField('Career Aspiration After Course'),
      _buildTextField('Parent/Guardian Income Range'),
      _buildDropdownField('Sibling Studying?', ['Yes', 'No']),
      _buildTextField('Sibling Institution (if any)'),
      _buildTextField('Reservation Category (SC/ST/OBC/EWS/General)'),
      _buildDropdownField('Sports Quota Applicable?', ['Yes', 'No']),
      _buildTextField('Hostel Food Preference'),
      _buildDropdownField('Transport Required?', ['Yes', 'No']),
      _buildDropdownField('Hostel Mess Food Preference', [
        'Veg',
        'Non-veg',
        'Both',
      ]),
      _buildDropdownField('Local Guardian Available?', ['Yes', 'No']),
      _buildTextField('Transport from Hostel to College'),
      _buildDropdownField('Attendance Requirement Awareness', [
        'Yes',
        'No',
        'Not sure',
      ]),
      _buildTextField('Previous Coaching Institute Attended'),
      _buildDropdownField('Study Material Preference', [
        'Hard copy',
        'Digital',
        'Both',
      ]),
      _buildDropdownField('Doubt-clearing Session Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Parent Occupation'),
      _buildTextField('Family Annual Income'),
      _buildTextField('Community or Caste Certificate'),
      _buildDropdownField('Migration Certificate Needed?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Transfer Certificate Needed?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
    ],
  );
}

Widget _buildSoftwareITFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product/Service of Interest'),
      _buildTextField('Company Size (employees)'),
      _buildTextField('Current System or Process Being Replaced'),
      _buildTextField('Current System Pain Points'),
      _buildDropdownField('Data Migration Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Number of Existing Users'),
      _buildDropdownField('Training Required for Team?', ['Yes', 'No']),
      _buildTextField('Training Count (if required)'),
      _buildDropdownField('Training Mode Preference', [
        'On-site',
        'Online',
        'Recorded videos',
      ]),
      _buildDropdownField('Support Hours Required', [
        'Business hours',
        '24x7',
        'On-call only',
      ]),
      _buildTextField('SLA Required for Support'),
      _buildTextField('Data Security Requirements'),
      _buildTextField('Third-party Vendor Integrations Needed'),
      _buildDropdownField('API Integration Required?', ['Yes', 'No']),
      _buildDropdownField('Mobile App Required?', ['Yes', 'No', 'Maybe']),
      _buildDropdownField('Offline Functionality Required?', ['Yes', 'No']),
      _buildDropdownField('Multi-language Support Required?', ['Yes', 'No']),
      _buildTextField('Languages Required (if any)'),
      _buildDropdownField('Accessibility Compliance Needed?', ['Yes', 'No']),
      _buildTextField('Current Hosting Environment'),
      _buildDropdownField('License Preference', [
        'Open source',
        'Commercial',
        'SaaS',
        'Not sure',
      ]),
      _buildDropdownField('Implementation Timeline Urgency', [
        'ASAP',
        'This quarter',
        'Next quarter',
        'Flexible',
      ]),
    ],
  );
}

Widget _buildHealthcareFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Healthcare Service of Interest'),
      _buildDropdownField('Health Insurance Currently Held?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Current Insurer Name'),
      _buildTextField('Current Sum Insured (₹)'),
      _buildDropdownField('Employer Health Cover Available?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Employer Cover Amount (₹)'),
      _buildTextField('Regular Medications'),
      _buildDropdownField('Recent Medical Reports Available?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Preferred Hospital Network'),
      _buildDropdownField('Cashless Preferred?', ['Yes', 'No', 'Both']),
      _buildDropdownField('Reimbursement Preferred?', ['Yes', 'No', 'Both']),
      _buildDropdownField('Second Opinion Needed?', ['Yes', 'No']),
      _buildDropdownField('Telemedicine Acceptable?', [
        'Yes',
        'No',
        'Sometimes',
      ]),
      _buildTextField('Mental Health History'),
      _buildDropdownField('Disability or Physical Limitation?', ['Yes', 'No']),
      _buildTextField('Disability Description (if any)'),
      _buildDropdownField('Pregnancy Planning?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Recent Surgery in Last 2 Years?', ['Yes', 'No']),
      _buildTextField('Family Doctor Reference'),
      _buildTextField('Blood Group'),
      _buildTextField('Known Allergies'),
      _buildTextField('Vaccination Status'),
    ],
  );
}

Widget _buildAutomotiveFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Vehicle Category', [
        'Two Wheeler',
        'Hatchback',
        'Sedan',
        'SUV',
        'MUV',
        'Luxury',
        'Commercial',
        'EV',
      ]),
      _buildTextField('Preferred Brand'),
      _buildTextField('Budget Range (₹)'),
      _buildDropdownField('Fuel Type', [
        'Petrol',
        'Diesel',
        'CNG',
        'Electric',
        'Hybrid',
      ]),
      _buildDropdownField('Usage Purpose', [
        'Personal',
        'Commercial',
        'Family',
        'Off-road',
      ]),
      _buildDropdownField('Test Drive Already Done?', ['Yes', 'No']),
      _buildTextField('Test Drive Vehicles (if done)'),
      _buildDropdownField('Color Variant Availability Confirmed?', [
        'Yes',
        'No',
        'Not checked',
      ]),
      _buildDropdownField('Insurance from Dealer Preferred?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Extended Warranty Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Service Package Preference', [
        'Standard',
        'Extended',
        'Not Sure',
      ]),
      _buildDropdownField('Exchange Vehicle Valuation Done?', ['Yes', 'No']),
      _buildDropdownField('RC Transfer Assistance Needed?', ['Yes', 'No']),
      _buildDropdownField('Financing Pre-approval Status', [
        'Approved',
        'Applied',
        'Not started',
        'Self-funded',
      ]),
      _buildTextField('Fuel Type Switching Reason'),
      _buildTextField('Driving Experience (years)'),
      _buildTextField('Previous Vehicle Brand Loyalty'),
      _buildTextField('Accessories Budget (₹)'),
      _buildTextField('Number Plate Preference'),
    ],
  );
}

Widget _buildFinancialServicesFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Service Type', [
        'Loan',
        'Investment',
        'Insurance',
        'Mutual Fund',
        'Fixed Deposit',
        'Credit Card',
        'Wealth Management',
      ]),
      _buildTextField('Amount Required (₹)'),
      _buildTextField('Current Bank Relationship'),
      _buildTextField('Existing Credit Card Usage Pattern'),
      _buildTextField('Previous Loan Repayment History'),
      _buildDropdownField('Guarantor Available?', ['Yes', 'No', 'Not sure']),
      _buildDropdownField('Collateral Available?', [
        'Yes',
        'No',
        'Not applicable',
      ]),
      _buildDropdownField('Tax Filing Status', [
        'Regular filer',
        'First time',
        'Non-filer',
      ]),
      _buildDropdownField('ITR Available?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Bank Statements Available?', [
        'Last 3 months',
        'Last 6 months',
        'Not ready',
      ]),
      _buildDropdownField('Previous Investment Experience', [
        'Beginner',
        'Some experience',
        'Experienced',
        'First time',
      ]),
      _buildTextField('Investment Objective'),
      _buildDropdownField('Liquidity Need', [
        'Immediate',
        '1-3 months',
        '6 months',
        'No urgency',
      ]),
      _buildDropdownField('Emergency Fund Already Created?', [
        'Yes',
        'No',
        'In progress',
      ]),
      _buildDropdownField('Insurance Coverage Existing?', [
        'Yes',
        'No',
        'Partial',
      ]),
      _buildDropdownField('Will or Estate Planning Done?', [
        'Yes',
        'No',
        'Considering',
      ]),
    ],
  );
}

Widget _buildRetailFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product Category of Interest'),
      _buildTextField('Specific Product Name'),
      _buildTextField('Budget (₹)'),
      _buildDropdownField('Preferred Store or Marketplace', [
        'Brand store',
        'Amazon',
        'Flipkart',
        'Myntra',
        'Local store',
        'Any',
      ]),
      _buildTextField('Membership or Loyalty Program'),
      _buildDropdownField('Exchange or Trade-in Available?', ['Yes', 'No']),
      _buildDropdownField('Gift Purchase?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Delivery Address Type', [
        'Home',
        'Office',
        'Gift address',
      ]),
      _buildDropdownField('Delivery Time Preference', [
        'Morning',
        'Afternoon',
        'Evening',
        'Anytime',
      ]),
      _buildDropdownField('Installation Required?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Warranty Preference', [
        'Standard',
        'Extended',
        'Not important',
      ]),
      _buildTextField('Return Reason (if replacing)'),
      _buildTextField('Previous Purchase Experience with Brand'),
      _buildDropdownField('EMI Card Available?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Discount Coupon Available?', ['Yes', 'No']),
    ],
  );
}

Widget _buildHospitalityFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Service Type', [
        'Hotel Stay',
        'Restaurant',
        'Event Venue',
        'Catering',
        'Travel Package',
      ]),
      _buildTextField('Check-in Date'),
      _buildTextField('Check-out Date'),
      _buildTextField('Number of Guests'),
      _buildDropdownField('Room Type', [
        'Standard',
        'Deluxe',
        'Suite',
        'Presidential Suite',
      ]),
      _buildDropdownField('Meal Preference', [
        'Veg',
        'Non-veg',
        'Vegan',
        'Jain',
        'Others',
      ]),
      _buildDropdownField('Accessibility Requirement', [
        'None',
        'Wheelchair',
        'Ground floor only',
        'Others',
      ]),
      _buildDropdownField('Special Occasion Celebration', [
        'Birthday',
        'Anniversary',
        'Honeymoon',
        'Corporate',
        'Others',
      ]),
      _buildDropdownField('Early Check-in Required?', ['Yes', 'No']),
      _buildDropdownField('Late Check-out Required?', ['Yes', 'No']),
      _buildDropdownField('Extra Bed Required?', ['Yes', 'No']),
      _buildTextField('Extra Bed Count'),
      _buildDropdownField('Smoking Preference', [
        'Smoking',
        'Non-smoking',
        'Either',
      ]),
      _buildTextField('Floor Preference'),
      _buildDropdownField('Connecting Rooms Needed?', ['Yes', 'No']),
      _buildTextField('Event Decoration Preference'),
      _buildDropdownField('Photographer Required?', ['Yes', 'No']),
      _buildDropdownField('Transportation from Airport Required?', [
        'Yes',
        'No',
        'Own arrangement',
      ]),
      _buildDropdownField('Previous Stay with Same Hotel Chain?', [
        'Yes',
        'No',
      ]),
    ],
  );
}

Widget _buildConsultingB2BFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Service of Interest'),
      _buildTextField('Company Name'),
      _buildTextField('Industry Sector'),
      _buildTextField('Annual Revenue Range'),
      _buildTextField('Current Vendor Contract Expiry Date'),
      _buildDropdownField('Budget Approved by Management?', [
        'Yes',
        'Pending approval',
        'Not yet presented',
      ]),
      _buildDropdownField('Board or Committee Approval Needed?', ['Yes', 'No']),
      _buildDropdownField('RFQ or RFP Process?', ['Yes', 'No', 'Not sure']),
      _buildDropdownField('NDA Required Before Discussion?', ['Yes', 'No']),
      _buildDropdownField('Site Visit Required?', ['Yes', 'No']),
      _buildDropdownField('Pilot Project Acceptable?', ['Yes', 'No']),
      _buildDropdownField('Reference Client Request?', [
        'Yes',
        'No',
        'Not expected',
      ]),
      _buildTextField('Case Study or White Label Interest'),
      _buildDropdownField('IP Rights Concern?', [
        'Yes',
        'No',
        'To be discussed',
      ]),
      _buildTextField('Data Residency Requirement'),
      _buildTextField('Compliance or Audit Requirement'),
      _buildDropdownField('On-site Resource Required?', ['Yes', 'No']),
      _buildDropdownField('Knowledge Transfer Required?', ['Yes', 'No']),
      _buildTextField('Post-project Support Expectation'),
    ],
  );
}

Widget _buildAgricultureFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Land Area (acres/hectares)'),
      _buildDropdownField('Land Type', ['Owned', 'Leased', 'Shared']),
      _buildTextField('Soil Type'),
      _buildDropdownField('Irrigation Method', [
        'Canal',
        'Borewell',
        'Rain-fed',
        'Drip',
        'Sprinkler',
      ]),
      _buildTextField('Current Crop'),
      _buildTextField('Previous Yield'),
      _buildDropdownField('Crop Insurance Currently Held?', ['Yes', 'No']),
      _buildTextField('Equipment Owned'),
      _buildTextField('Livestock Count'),
      _buildDropdownField('Organic Farming?', ['Yes', 'No', 'Converting']),
      _buildTextField('Market Access (nearest mandi distance)'),
      _buildDropdownField('Storage Facility Available?', ['Yes', 'No']),
      _buildDropdownField('Loan for Agriculture Needed?', ['Yes', 'No']),
      _buildDropdownField('Kisan Credit Card?', ['Yes', 'No']),
    ],
  );
}

// ─── Interest Content Builder ─────────────────────────────────────────────────

Widget _buildInterestContent(String industry) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interest Meta (Premium, KYC, Documents, etc.)
        _AccordionSection(
          title: 'Interest Overview & KYC',
          icon: Icons.dashboard_outlined,
          color: const Color(0xFF0891B2),
          content: _InterestMetaSection(industry: industry),
          initiallyExpanded: true,
        ),
        // Universal fields always at top
        _AccordionSection(
          title: 'Universal Fields',
          icon: Icons.tune_rounded,
          color: AppTheme.primary,
          content: const _UniversalFieldsSection(),
          initiallyExpanded: false,
        ),
        // Industry-specific fields
        _AccordionSection(
          title: _getIndustryTitle(industry),
          icon: _getIndustryIcon(industry),
          color: _getIndustryColor(industry),
          content: _getIndustryFields(industry),
          initiallyExpanded: true,
        ),
        // Nominees sub-section (replaces Documents Required)
        _AccordionSection(
          title: 'Nominees',
          icon: Icons.people_alt_rounded,
          color: const Color(0xFF009688),
          content: const _NomineesSection(),
          initiallyExpanded: false,
        ),
        // Agent Activity Tracking
        _AccordionSection(
          title: 'Agent Activity Tracking',
          icon: Icons.track_changes_rounded,
          color: const Color(0xFF0891B2),
          content: _buildAgentActivitySection(),
        ),
        // Competitive Intelligence
        _AccordionSection(
          title: 'Competitive Intelligence',
          icon: Icons.compare_arrows_rounded,
          color: const Color(0xFFD97706),
          content: _buildCompetitiveSection(),
        ),
        // Financial Qualification
        _AccordionSection(
          title: 'Financial Qualification',
          icon: Icons.account_balance_rounded,
          color: AppTheme.success,
          content: _buildFinancialQualificationSection(),
        ),
        // Decision Process
        _AccordionSection(
          title: 'Decision Process',
          icon: Icons.how_to_vote_rounded,
          color: const Color(0xFF7C3AED),
          content: _buildDecisionProcessSection(),
        ),
        // After-Sales Expectations
        _AccordionSection(
          title: 'After-Sales Expectations',
          icon: Icons.support_agent_rounded,
          color: const Color(0xFFE91E63),
          content: _buildAfterSalesSection(),
        ),
      ],
    ),
  );
}

String _getIndustryTitle(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return 'Life Insurance Details';
    case 'Health Insurance':
      return 'Health Insurance Details';
    case 'Motor Insurance':
      return 'Motor Insurance Details';
    case 'Home Insurance':
      return 'Home Insurance Details';
    case 'Travel Insurance':
      return 'Travel Insurance Details';
    case 'Real Estate':
      return 'Real Estate Details';
    case 'Education':
      return 'Education Details';
    case 'Software / IT':
      return 'Software / IT Details';
    case 'Healthcare':
      return 'Healthcare Details';
    case 'Automotive':
      return 'Automotive Details';
    case 'Financial Services':
      return 'Financial Services Details';
    case 'Retail':
      return 'Retail / E-commerce Details';
    case 'Hospitality':
      return 'Hospitality Details';
    case 'Consulting / B2B':
      return 'Consulting / B2B Details';
    case 'Agriculture':
      return 'Agriculture Details';
    default:
      return '$industry Details';
  }
}

IconData _getIndustryIcon(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return Icons.favorite_rounded;
    case 'Health Insurance':
      return Icons.health_and_safety_rounded;
    case 'Motor Insurance':
      return Icons.directions_car_rounded;
    case 'Home Insurance':
      return Icons.home_rounded;
    case 'Travel Insurance':
      return Icons.flight_rounded;
    case 'Real Estate':
      return Icons.apartment_rounded;
    case 'Education':
      return Icons.school_rounded;
    case 'Software / IT':
      return Icons.computer_rounded;
    case 'Healthcare':
      return Icons.local_hospital_rounded;
    case 'Automotive':
      return Icons.car_repair_rounded;
    case 'Financial Services':
      return Icons.account_balance_wallet_rounded;
    case 'Retail':
      return Icons.shopping_bag_rounded;
    case 'Hospitality':
      return Icons.hotel_rounded;
    case 'Consulting / B2B':
      return Icons.business_center_rounded;
    case 'Agriculture':
      return Icons.grass_rounded;
    default:
      return Icons.category_rounded;
  }
}

Color _getIndustryColor(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return const Color(0xFFE91E63);
    case 'Health Insurance':
      return const Color(0xFF4CAF50);
    case 'Motor Insurance':
      return const Color(0xFF2196F3);
    case 'Home Insurance':
      return const Color(0xFFFF9800);
    case 'Travel Insurance':
      return const Color(0xFF00BCD4);
    case 'Real Estate':
      return const Color(0xFF795548);
    case 'Education':
      return const Color(0xFF9C27B0);
    case 'Software / IT':
      return const Color(0xFF607D8B);
    case 'Healthcare':
      return const Color(0xFF009688);
    case 'Automotive':
      return const Color(0xFF3F51B5);
    case 'Financial Services':
      return const Color(0xFFFF5722);
    case 'Retail':
      return const Color(0xFFFF9800);
    case 'Hospitality':
      return const Color(0xFF8BC34A);
    case 'Consulting / B2B':
      return const Color(0xFF673AB7);
    case 'Agriculture':
      return const Color(0xFF4CAF50);
    default:
      return AppTheme.primary;
  }
}

Widget _getIndustryFields(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return _buildLifeInsuranceFields();
    case 'Health Insurance':
      return _buildHealthInsuranceFields();
    case 'Motor Insurance':
      return _buildMotorInsuranceFields();
    case 'Home Insurance':
      return _buildHomeInsuranceFields();
    case 'Travel Insurance':
      return _buildTravelInsuranceFields();
    case 'Real Estate':
      return _buildRealEstateFields();
    case 'Education':
      return _buildEducationFields();
    case 'Software / IT':
      return _buildSoftwareITFields();
    case 'Healthcare':
      return _buildHealthcareFields();
    case 'Automotive':
      return _buildAutomotiveFields();
    case 'Financial Services':
      return _buildFinancialServicesFields();
    case 'Retail':
      return _buildRetailFields();
    case 'Hospitality':
      return _buildHospitalityFields();
    case 'Consulting / B2B':
      return _buildConsultingB2BFields();
    case 'Agriculture':
      return _buildAgricultureFields();
    default:
      return _buildTextField('Details');
  }
}

// ─── Interest Meta Section (Premium, KYC, Documents) ─────────────────────────

class _InterestMetaSection extends StatefulWidget {
  final String industry;
  const _InterestMetaSection({required this.industry});

  @override
  State<_InterestMetaSection> createState() => _InterestMetaSectionState();
}

class _InterestMetaSectionState extends State<_InterestMetaSection> {
  String _interestStatus = 'Exploring';
  String _kycStatus = 'Pending';
  String _paymentFrequency = '';
  String _paymentMode = '';
  String _otherPaymentMode = '';
  double _probability = 50;
  final _premiumCtrl = TextEditingController();
  final _commissionCtrl = TextEditingController();
  final _coApplicantCtrl = TextEditingController();
  DateTime? _quoteExpiry;

  static const _interestStatuses = [
    'Exploring',
    'Quoted',
    'Negotiation',
    'Won',
    'Lost',
  ];
  static const _kycStatuses = ['Pending', 'Submitted', 'Verified', 'Rejected'];
  static const _paymentFrequencies = [
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Annual',
    'Single Premium',
  ];
  static const _paymentModes = [
    'UPI',
    'Credit Card',
    'Debit Card',
    'Net Banking',
    'NACH/Direct Debit',
    'Demand Draft',
    'Cash',
    'Others',
  ];
  static const _docChecklist = [
    'PAN Card',
    'Aadhaar Card',
    'Passport Photo',
    'Cancelled Cheque',
    'Income Proof',
    'Medical Report',
    'Bank Statement',
    'Address Proof',
    'Age Proof',
    'Proposal Form',
  ];

  final Map<String, bool> _docStatus = {};

  @override
  void initState() {
    super.initState();
    for (final doc in _docChecklist) {
      _docStatus[doc] = false;
    }
  }

  @override
  void dispose() {
    _premiumCtrl.dispose();
    _commissionCtrl.dispose();
    _coApplicantCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Won':
        return AppTheme.success;
      case 'Lost':
        return AppTheme.error;
      case 'Negotiation':
        return AppTheme.warning;
      case 'Quoted':
        return AppTheme.primary;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _kycColor(String status) {
    switch (status) {
      case 'Verified':
        return AppTheme.success;
      case 'Rejected':
        return AppTheme.error;
      case 'Submitted':
        return AppTheme.primary;
      default:
        return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final docsCompleted = _docStatus.values.where((v) => v).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interest Status
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withAlpha(40),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interest Status',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _interestStatuses.map((s) {
                  final isSelected = _interestStatus == s;
                  final color = _statusColor(s);
                  return GestureDetector(
                    onTap: () => setState(() => _interestStatus = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withAlpha(30)
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? color : AppTheme.surface200,
                        ),
                      ),
                      child: Text(
                        s,
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
              const SizedBox(height: 12),
              // Probability
              Text(
                'Closing Probability: ${_probability.toInt()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Slider(
                value: _probability,
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: AppTheme.primary,
                onChanged: (v) => setState(() => _probability = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Premium & Commission
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _premiumCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Est. Premium (₹/yr)',
                  prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _commissionCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Est. Commission (₹)',
                  prefixIcon: Icon(Icons.percent_rounded, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Payment Frequency & Mode
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Payment Frequency',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _paymentFrequency.isEmpty ? null : _paymentFrequency,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _paymentFrequencies
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
              onChanged: (v) => setState(() => _paymentFrequency = v ?? ''),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Payment Mode',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _paymentMode.isEmpty ? null : _paymentMode,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _paymentModes
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(
                        m,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _paymentMode = v ?? '';
                if (v != 'Others') _otherPaymentMode = '';
              }),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        Visibility(
          visible: _paymentMode == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Payment Mode *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _paymentMode == 'Others' && (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherPaymentMode = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Quote Expiry
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 30)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _quoteExpiry = picked);
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
                  Icons.event_outlined,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  _quoteExpiry != null
                      ? 'Quote Expiry: ${_quoteExpiry!.day}/${_quoteExpiry!.month}/${_quoteExpiry!.year}'
                      : 'Quote Validity / Expiry Date',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: _quoteExpiry != null
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Co-applicant
        TextFormField(
          controller: _coApplicantCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Co-applicant / Joint Applicant Name',
            prefixIcon: Icon(Icons.person_add_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),

        // KYC Status
        Row(
          children: [
            Text(
              'KYC Status: ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            ...['Pending', 'Submitted', 'Verified', 'Rejected'].map((s) {
              final isSelected = _kycStatus == s;
              final color = _kycColor(s);
              return GestureDetector(
                onTap: () => setState(() => _kycStatus = s),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withAlpha(30)
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? color : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),

        // Documents Checklist
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.checklist_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Documents Checklist',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: docsCompleted == _docChecklist.length
                          ? AppTheme.success.withAlpha(30)
                          : AppTheme.warning.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$docsCompleted/${_docChecklist.length}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: docsCompleted == _docChecklist.length
                            ? AppTheme.success
                            : AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._docChecklist.map((doc) {
                final isChecked = _docStatus[doc] ?? false;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _docStatus[doc] = !isChecked),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isChecked
                                ? AppTheme.success
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isChecked
                                  ? AppTheme.success
                                  : AppTheme.surface200,
                              width: 1.5,
                            ),
                          ),
                          child: isChecked
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          doc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isChecked
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                            decoration: isChecked
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      if (isChecked)
                        const Icon(
                          Icons.upload_file_outlined,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Interest Card with Notes ─────────────────────────────────────────────────

class _InterestCardWithNotes extends StatefulWidget {
  final String industry;
  final void Function(String industry, String notes)? onNotesChanged;

  const _InterestCardWithNotes({
    super.key,
    required this.industry,
    this.onNotesChanged,
  });

  @override
  State<_InterestCardWithNotes> createState() => _InterestCardWithNotesState();
}

class _InterestCardWithNotesState extends State<_InterestCardWithNotes> {
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInterestContent(widget.industry),
        const SizedBox(height: 8),
        // Notes for this interest
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.sticky_note_2_outlined,
                    size: 16,
                    color: AppTheme.warning,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Notes for ${widget.industry}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (val) {
                  widget.onNotesChanged?.call(widget.industry, val);
                },
                decoration: InputDecoration(
                  hintText:
                      'Add notes specific to this ${widget.industry} interest...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.surface200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.surface200),
                  ),
                ),
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Main Section Interests Widget ───────────────────────────────────────────

class SectionInterestsWidget extends StatefulWidget {
  const SectionInterestsWidget({super.key});

  @override
  State<SectionInterestsWidget> createState() => _SectionInterestsWidgetState();
}

class _SectionInterestsWidgetState extends State<SectionInterestsWidget> {
  final List<_InterestCard> _interests = [];
  int _activeInterestIndex = 0;

  static const _allIndustries = [
    'Life Insurance',
    'Health Insurance',
    'Motor Insurance',
    'Home Insurance',
    'Travel Insurance',
    'Real Estate',
    'Education',
    'Software / IT',
    'Healthcare',
    'Automotive',
    'Financial Services',
    'Retail',
    'Hospitality',
    'Consulting / B2B',
    'Agriculture',
    'Mutual Funds',
    'Equity',
    'Fixed Deposits',
    // ATO / Insurance-specific
    'TPD Insurance',
    'Income Protection',
    'Trauma / Critical Illness',
    'Business Expense Cover',
    'Key Person Insurance',
    'Cyber Liability',
    'Professional Indemnity',
    'Public Liability',
    'Workers Compensation',
    'Superannuation / Pension',
    'Estate Planning / SMSF',
    // Financial Products
    'Personal Loan',
    'Home Loan / LAP',
    'Credit Card',
    'Gold Loan',
    'SIP / Mutual Fund Plan',
    'Bonds / Debentures',
    'Tax Planning Services',
    // Others
    'Legal Services',
    'Coaching / Tutoring',
    'Gym / Wellness',
    'Logistics / Shipping',
    'Import / Export',
  ];

  static const _quickAddIndustries = [
    'Life Insurance',
    'Health Insurance',
    'Motor Insurance',
    'Real Estate',
    'Education',
    'Financial Services',
    'Automotive',
  ];

  void _addInterest(String industry) {
    setState(() {
      _interests.add(_InterestCard(industry: industry));
      _activeInterestIndex = _interests.length - 1;
    });
  }

  void _removeInterest(int index) {
    setState(() {
      _interests.removeAt(index);
      if (_activeInterestIndex >= _interests.length) {
        _activeInterestIndex = _interests.length - 1;
      }
    });
  }

  void _showAddInterestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
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
                  'Select Industry',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                itemCount: _allIndustries.length,
                itemBuilder: (_, i) {
                  final industry = _allIndustries[i];
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _getIndustryColor(industry).withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIndustryIcon(industry),
                        size: 18,
                        color: _getIndustryColor(industry),
                      ),
                    ),
                    title: Text(
                      industry,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _addInterest(industry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    if (_interests.isEmpty) {
      return Column(
        children: [
          EmptyStateWidget(
            icon: Icons.star_outline_rounded,
            title: 'No interests added',
            subtitle: 'Add the lead\'s interests to personalise your pitch',
          ),
          const SizedBox(height: 16),
          Text(
            'Quick Add',
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
            children: _quickAddIndustries.map((industry) {
              return GestureDetector(
                onTap: () => _addInterest(industry),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getIndustryColor(industry).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getIndustryColor(industry).withAlpha(77),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIndustryIcon(industry),
                        size: 14,
                        color: _getIndustryColor(industry),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        industry,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getIndustryColor(industry),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showAddInterestSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Browse All Industries',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interest tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(_interests.length, (i) {
                final isActive = i == _activeInterestIndex;
                final color = _getIndustryColor(_interests[i].industry);
                return GestureDetector(
                  onTap: () => setState(() => _activeInterestIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? color : AppTheme.surface100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? color : AppTheme.surface200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIndustryIcon(_interests[i].industry),
                          size: 12,
                          color: isActive ? Colors.white : color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _interests[i].industry,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _removeInterest(i),
                          child: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: isActive
                                ? Colors.white70
                                : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: _showAddInterestSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.surface200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        size: 14,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Active interest content with notes
        if (_interests.isNotEmpty)
          _InterestCardWithNotes(
            key: ValueKey(
              '${_interests[_activeInterestIndex].industry}_$_activeInterestIndex',
            ),
            industry: _interests[_activeInterestIndex].industry,
          ),
      ],
    );
  }
}