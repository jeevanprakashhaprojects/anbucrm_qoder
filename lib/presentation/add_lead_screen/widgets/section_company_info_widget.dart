import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionCompanyInfoWidget extends StatefulWidget {
  final void Function(int filledCount)? onCompulsoryChanged;
  final void Function(Map<String, dynamic>)? onDataChanged;
  final Map<String, dynamic>? prefillData;
  const SectionCompanyInfoWidget({
    super.key,
    this.onCompulsoryChanged,
    this.onDataChanged,
    this.prefillData,
  });

  @override
  State<SectionCompanyInfoWidget> createState() =>
      _SectionCompanyInfoWidgetState();
}

class _SectionCompanyInfoWidgetState extends State<SectionCompanyInfoWidget> {
  String _selectedIndustry = '';
  String _selectedCompanySize = '';
  String _selectedDepartment = '';
  String _selectedDecisionLevel = '';
  String _selectedCompanyType = '';
  String _selectedBusinessModel = '';
  String _selectedFundingStage = '';
  String _selectedStockExchange = '';
  final List<String> _selectedTechnologies = [];
  final List<String> _selectedExistingInsurance = [];

  bool _showRegistration = false;
  bool _showAdvanced = false;
  bool _showTech = false;

  void _notifyParent() {
    widget.onCompulsoryChanged?.call(0);
  }

  static const _industries = [
    'Technology',
    'Finance',
    'Healthcare',
    'Manufacturing',
    'Retail',
    'Education',
    'Real Estate',
    'Automotive',
    'FMCG',
    'Telecom',
    'Insurance',
    'Consulting',
    'Others',
  ];
  static const _companySizes = [
    '1–10',
    '11–50',
    '51–200',
    '201–500',
    '501–1000',
    '1000+',
    'Others',
  ];
  static const _departments = [
    'Sales',
    'Marketing',
    'Operations',
    'Finance',
    'HR',
    'IT',
    'Legal',
    'Product',
    'Customer Success',
    'Others',
  ];
  static const _decisionLevels = [
    'C-Suite',
    'VP / Director',
    'Manager',
    'Individual Contributor',
    'Others',
  ];
  static const _companyTypes = [
    'Pvt Ltd',
    'Public Ltd',
    'LLP',
    'Partnership',
    'Proprietorship',
    'Trust',
    'Society',
    'HUF',
    'NGO',
    'Others',
  ];
  static const _businessModels = [
    'B2B',
    'B2C',
    'D2C',
    'Marketplace',
    'SaaS',
    'B2B2C',
    'Others',
  ];
  static const _fundingStages = [
    'Bootstrap',
    'Pre-Seed',
    'Seed',
    'Series A',
    'Series B',
    'Series C',
    'Series D+',
    'Public (IPO)',
    'Others',
  ];
  static const _stockExchanges = [
    'BSE',
    'NSE',
    'ASX',
    'NYSE',
    'NASDAQ',
    'LSE',
    'None',
    'Others',
  ];
  static const _technologies = [
    'Salesforce',
    'HubSpot',
    'SAP',
    'Oracle',
    'Zoho',
    'AWS',
    'Azure',
    'Google Cloud',
    'Tally',
    'QuickBooks',
    'Others',
  ];
  static const _existingInsuranceTypes = [
    'Health Insurance',
    'Life Insurance',
    'Motor Insurance',
    'Cyber Liability',
    'Professional Indemnity',
    'Public Liability',
    'Workers Compensation',
    'None',
  ];

  String _otherIndustry = '';
  String _otherCompanySize = '';
  String _otherDepartment = '';
  String _otherDecisionLevel = '';
  String _otherCompanyType = '';
  String _otherBusinessModel = '';
  String _otherFundingStage = '';
  String _otherStockExchange = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Text(
            'All fields optional — fill only if applicable',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Company Name
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            prefixIcon: Icon(Icons.business_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Trademark / Brand Name',
            prefixIcon: Icon(Icons.verified_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),

        // Industry
        _DropdownFormField(
          label: 'Industry',
          value: _selectedIndustry,
          items: _industries,
          onChanged: (v) => setState(() {
            _selectedIndustry = v;
            if (v != 'Others') _otherIndustry = '';
          }),
        ),
        Visibility(
          visible: _selectedIndustry == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Industry *',
                hintText: 'Please specify...',
              ),
              validator: (v) =>
                  _selectedIndustry == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherIndustry = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Company Type
        _DropdownFormField(
          label: 'Company Type',
          value: _selectedCompanyType,
          items: _companyTypes,
          onChanged: (v) => setState(() {
            _selectedCompanyType = v;
            if (v != 'Others') _otherCompanyType = '';
          }),
        ),
        Visibility(
          visible: _selectedCompanyType == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Company Type *',
              ),
              validator: (v) =>
                  _selectedCompanyType == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherCompanyType = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Job Title
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Job Title',
            prefixIcon: Icon(Icons.work_outline_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),

        // Department
        _DropdownFormField(
          label: 'Department',
          value: _selectedDepartment,
          items: _departments,
          onChanged: (v) => setState(() {
            _selectedDepartment = v;
            if (v != 'Others') _otherDepartment = '';
          }),
        ),
        Visibility(
          visible: _selectedDepartment == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Department *',
              ),
              validator: (v) =>
                  _selectedDepartment == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherDepartment = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Company Size
        _DropdownFormField(
          label: 'Company Size',
          value: _selectedCompanySize,
          items: _companySizes,
          onChanged: (v) => setState(() {
            _selectedCompanySize = v;
            if (v != 'Others') _otherCompanySize = '';
          }),
        ),
        Visibility(
          visible: _selectedCompanySize == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Company Size *',
              ),
              validator: (v) =>
                  _selectedCompanySize == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherCompanySize = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Year Established',
                  prefixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'No. of Branches',
                  prefixIcon: Icon(Icons.account_tree_outlined, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Annual Revenue
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Annual Revenue',
            prefixText: '₹ ',
            prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),

        // Business Model
        _DropdownFormField(
          label: 'Business Model',
          value: _selectedBusinessModel,
          items: _businessModels,
          onChanged: (v) => setState(() {
            _selectedBusinessModel = v;
            if (v != 'Others') _otherBusinessModel = '';
          }),
        ),
        Visibility(
          visible: _selectedBusinessModel == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Business Model *',
              ),
              validator: (v) =>
                  _selectedBusinessModel == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherBusinessModel = v),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Company Phone & Email
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Company Phone',
            prefixIcon: Icon(Icons.phone_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Company Email',
            prefixIcon: Icon(Icons.email_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),

        // Website
        TextFormField(
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: 'Website URL',
            prefixIcon: Icon(Icons.language_rounded, size: 18),
            hintText: 'https://example.com',
          ),
        ),
        const SizedBox(height: 12),

        // Parent Company
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Parent Company / Group',
            prefixIcon: Icon(Icons.corporate_fare_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),

        // Key Competitors
        TextFormField(
          textCapitalization: TextCapitalization.words,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Key Competitors (comma-separated)',
            prefixIcon: Icon(Icons.compare_arrows_rounded, size: 18),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),

        // Decision Maker
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withAlpha(77),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withAlpha(51)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Decision Maker',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Role / Title'),
              ),
              const SizedBox(height: 12),
              _DropdownFormField(
                label: 'Decision Level',
                value: _selectedDecisionLevel,
                items: _decisionLevels,
                onChanged: (v) => setState(() {
                  _selectedDecisionLevel = v;
                  if (v != 'Others') _otherDecisionLevel = '';
                }),
              ),
              Visibility(
                visible: _selectedDecisionLevel == 'Others',
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Specify Decision Level *',
                    ),
                    validator: (v) =>
                        _selectedDecisionLevel == 'Others' &&
                            (v == null || v.trim().isEmpty)
                        ? 'Required'
                        : null,
                    onChanged: (v) => setState(() => _otherDecisionLevel = v),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Registration & Compliance accordion
        _buildAccordion(
          title: 'Registration & Compliance',
          icon: Icons.assignment_outlined,
          isExpanded: _showRegistration,
          onTap: () => setState(() => _showRegistration = !_showRegistration),
          child: _buildRegistrationFields(),
        ),
        const SizedBox(height: 8),

        // Funding & Market accordion
        _buildAccordion(
          title: 'Funding, Market & Technologies',
          icon: Icons.trending_up_rounded,
          isExpanded: _showAdvanced,
          onTap: () => setState(() => _showAdvanced = !_showAdvanced),
          child: _buildAdvancedFields(),
        ),
        const SizedBox(height: 8),

        // Existing Insurance accordion
        _buildAccordion(
          title: 'Existing Insurance Policies',
          icon: Icons.shield_outlined,
          isExpanded: _showTech,
          onTap: () => setState(() => _showTech = !_showTech),
          child: _buildInsuranceFields(),
        ),
        const SizedBox(height: 12),

        // Company Address
        TextFormField(
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Company Address',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.location_on_outlined, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccordion({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
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
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: child,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationFields() {
    return Column(
      children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'CIN / LLPIN / Registration No.',
            prefixIcon: Icon(Icons.numbers_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'GST Number',
            prefixIcon: Icon(Icons.receipt_long_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Company PAN',
            prefixIcon: Icon(Icons.credit_card_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'TAN',
            prefixIcon: Icon(Icons.assignment_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'ABN (Australian Business Number)',
            prefixIcon: Icon(Icons.business_center_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'ACN (Australian Company Number)',
            prefixIcon: Icon(Icons.business_center_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'MSME / Udyam Registration No.',
            prefixIcon: Icon(Icons.factory_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 10),
        // Stock Exchange
        _DropdownFormField(
          label: 'Listed on Stock Exchange',
          value: _selectedStockExchange,
          items: _stockExchanges,
          onChanged: (v) => setState(() {
            _selectedStockExchange = v;
            if (v != 'Others') _otherStockExchange = '';
          }),
        ),
        Visibility(
          visible: _selectedStockExchange == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Exchange *',
              ),
              validator: (v) =>
                  _selectedStockExchange == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherStockExchange = v),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        _DropdownFormField(
          label: 'Funding Stage',
          value: _selectedFundingStage,
          items: _fundingStages,
          onChanged: (v) => setState(() {
            _selectedFundingStage = v;
            if (v != 'Others') _otherFundingStage = '';
          }),
        ),
        Visibility(
          visible: _selectedFundingStage == 'Others',
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Specify Funding Stage *',
              ),
              validator: (v) =>
                  _selectedFundingStage == 'Others' &&
                      (v == null || v.trim().isEmpty)
                  ? 'Required'
                  : null,
              onChanged: (v) => setState(() => _otherFundingStage = v),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Investors / VCs',
            prefixIcon: Icon(Icons.people_outline_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Technologies Used',
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
          children: _technologies.map((t) {
            final isSelected = _selectedTechnologies.contains(t);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  _selectedTechnologies.remove(t);
                } else {
                  _selectedTechnologies.add(t);
                }
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
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
                    fontSize: 11,
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
        const SizedBox(height: 12),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Procurement Cycle / Vendor Notes',
            prefixIcon: Icon(Icons.inventory_2_outlined, size: 18),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 12),
        Text(
          'Select existing policies:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _existingInsuranceTypes.map((t) {
            final isSelected = _selectedExistingInsurance.contains(t);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  _selectedExistingInsurance.remove(t);
                } else {
                  _selectedExistingInsurance.add(t);
                }
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFECFDF5)
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.success : AppTheme.surface200,
                  ),
                ),
                child: Text(
                  t,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.success
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedExistingInsurance.isNotEmpty) ...[
          const SizedBox(height: 12),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Existing Insurer Name(s)',
              prefixIcon: Icon(Icons.shield_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Policy Renewal Date',
              prefixIcon: Icon(Icons.event_outlined, size: 18),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Reusable Dropdown ────────────────────────────────────────────────────────

class _DropdownFormField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownFormField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          isExpanded: true,
          isDense: true,
          hint: Text(
            'Select $label',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          icon: const Icon(Icons.expand_more_rounded, size: 16),
        ),
      ),
    );
  }
}