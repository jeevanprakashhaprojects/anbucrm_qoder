import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../follow_ups_screen/follow_ups_screen.dart' as fu_screen;
import './widgets/section_address_widget.dart';
import './widgets/section_company_info_widget.dart';
import './widgets/section_contact_info_widget.dart';
import './widgets/section_lead_details_widget.dart';
import './widgets/section_interests_widget.dart';
import './widgets/section_notes_widget.dart';
import './widgets/section_relations_widget.dart';
import './widgets/section_social_widget.dart';
import './widgets/tablet_step_sidebar_widget.dart';
import './widgets/wizard_bottom_bar_widget.dart';
import './widgets/wizard_progress_fab_widget.dart';
import './widgets/wizard_step_indicator_widget.dart';

// Global callback for leads changes
VoidCallback? onLeadsChanged;

List<Map<String, dynamic>> globalLeadMaps = [];

class AddLeadScreen extends StatefulWidget {
  /// If provided, this lead will be pre-filled for editing
  final Map<String, dynamic>? editLead;
  final void Function()? onLeadsChanged;
  const AddLeadScreen({super.key, this.editLead, this.onLeadsChanged});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  int _currentStep = 0;
  bool _isSaving = false;
  String _autoSaveStatus = '';
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Whether we are editing an existing lead
  bool get _isEditing => widget.editLead != null;

  // Expandable section states
  final List<bool> _sectionExpanded = List.filled(8, true);

  static const List<WizardStep> _steps = [
    WizardStep('Contact Info', Icons.person_outline_rounded),
    WizardStep('Business Details', Icons.business_outlined),
    WizardStep('Lead Details', Icons.trending_up_rounded),
    WizardStep('Address', Icons.location_on_outlined),
    WizardStep('Social', Icons.share_outlined),
    WizardStep('Notes', Icons.notes_rounded),
    WizardStep('Interests', Icons.star_outline_rounded),
    WizardStep('Relations', Icons.group_outlined),
  ];

  // Completion state per step
  final List<bool> _stepCompleted = List.filled(8, false);

  // Track field fill counts per section for progress calculation
  final List<List<int>> _sectionProgress = [
    [0, 2], // Contact Info: firstName + primaryMobile (email optional)
    [0, 0], // Business Details: optional
    [0, 1], // Lead Details: scheduledAction only
    [0, 0], // Address: optional
    [0, 0], // Social: optional
    [0, 0], // Notes: optional
    [0, 0], // Interests: optional
    [0, 0], // Relations: optional
  ];

  // Collected form data across all steps
  final Map<String, dynamic> _formData = {};

  Key _formInstanceKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Pre-fill form data if editing
    if (_isEditing && widget.editLead != null) {
      _formData.addAll(widget.editLead!);
    }
    _scheduleAutoSave();
  }

  void _updateSectionProgress(int sectionIndex, int filledCount) {
    setState(() {
      _sectionProgress[sectionIndex][0] = filledCount;
      _stepCompleted[sectionIndex] =
          filledCount >= _sectionProgress[sectionIndex][1];
    });
  }

  void _updateFormData(Map<String, dynamic> data) {
    _formData.addAll(data);
    // Dynamically update required total for contact info when Others is selected
    if (data.containsKey('_contactRequiredTotal')) {
      final newTotal = data['_contactRequiredTotal'] as int;
      if (_sectionProgress[0][1] != newTotal) {
        setState(() {
          _sectionProgress[0][1] = newTotal;
          _stepCompleted[0] = _sectionProgress[0][0] >= newTotal;
        });
      }
    }
    // Dynamically update required total for lead details when Others is selected
    if (data.containsKey('_leadDetailsRequiredTotal')) {
      final newTotal = data['_leadDetailsRequiredTotal'] as int;
      if (_sectionProgress[2][1] != newTotal) {
        setState(() {
          _sectionProgress[2][1] = newTotal;
          _stepCompleted[2] = _sectionProgress[2][0] >= newTotal;
        });
      }
    }
  }

  double get _overallProgress {
    int totalFilled = 0;
    int totalRequired = 0;
    for (final p in _sectionProgress) {
      totalFilled += p[0];
      totalRequired += p[1];
    }
    if (totalRequired == 0) return 0;
    return (totalFilled / totalRequired).clamp(0.0, 1.0);
  }

  void _scheduleAutoSave() async {
    await Future.delayed(const Duration(seconds: 30));
    if (mounted) {
      setState(() => _autoSaveStatus = 'Saved \u2713');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _autoSaveStatus = '');
      _scheduleAutoSave();
    }
  }

  void _onStepTap(int index) {
    if (index > _currentStep) {
      for (int i = _currentStep; i < index; i++) {
        if (_sectionProgress[i][1] > 0 && !_stepCompleted[i]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Complete "${_steps[i].label}" first before jumping ahead.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.warning,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return;
        }
      }
    }
    setState(() {
      _currentStep = index;
      _sectionExpanded[index] = true;
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _onContinue() {
    if (_sectionProgress[_currentStep][1] > 0 &&
        _sectionProgress[_currentStep][0] < _sectionProgress[_currentStep][1]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please fill all required fields in ${_steps[_currentStep].label} before continuing.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _stepCompleted[_currentStep] = true;
        _currentStep++;
        _sectionExpanded[_currentStep] = true;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _onSubmit();
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      _confirmDiscard();
    }
  }

  void _confirmDiscard() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          _isEditing ? 'Discard Changes?' : 'Discard Lead?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          _isEditing
              ? 'All changes will be lost. Are you sure?'
              : 'All entered data will be cleared. Are you sure you want to discard?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _clearAndExit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAndExit() {
    setState(() {
      _currentStep = 0;
      _formInstanceKey = UniqueKey();
      for (int i = 0; i < _stepCompleted.length; i++) {
        _stepCompleted[i] = false;
      }
      for (int i = 0; i < _sectionProgress.length; i++) {
        _sectionProgress[i][0] = 0;
      }
      for (int i = 0; i < _sectionExpanded.length; i++) {
        _sectionExpanded[i] = true;
      }
    });
    context.go(AppRoutes.leadsListScreen);
  }

  Future<void> _onSubmit() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isSaving = false);

      // Build the lead map from collected form data
      final firstName = _formData['firstName'] as String? ?? '';
      final lastName = _formData['lastName'] as String? ?? '';
      final fullName = [
        firstName,
        lastName,
      ].where((s) => s.isNotEmpty).join(' ');
      final phone = _formData['primaryMobile'] as String? ?? '';
      final email = _formData['primaryEmail'] as String? ?? '';
      final company = _formData['companyName'] as String? ?? '';
      final industry = _formData['industry'] as String? ?? '';
      final dealValue = (_formData['dealValue'] as num?)?.toDouble() ?? 0.0;
      final priority = _formData['priority'] as String? ?? 'Medium';
      final status = _formData['status'] as String? ?? 'New';
      final ownerName = _formData['ownerName'] as String? ?? 'Priya Sharma';
      final ownerInitials = _formData['ownerInitials'] as String? ?? 'PS';
      final notes = _formData['notes'] as String? ?? '';

      if (_isEditing) {
        // Update existing lead in global list
        final existingId = widget.editLead!['id'] as String;
        final idx = globalLeadMaps.indexWhere((m) => m['id'] == existingId);
        if (idx >= 0) {
          globalLeadMaps[idx] = {
            ...globalLeadMaps[idx],
            'name': fullName.isNotEmpty
                ? fullName
                : globalLeadMaps[idx]['name'],
            'phone': phone.isNotEmpty ? phone : globalLeadMaps[idx]['phone'],
            'email': email.isNotEmpty ? email : globalLeadMaps[idx]['email'],
            'company': company.isNotEmpty
                ? company
                : globalLeadMaps[idx]['company'],
            'industry': industry.isNotEmpty
                ? industry
                : globalLeadMaps[idx]['industry'],
            'dealValue': dealValue > 0
                ? dealValue
                : globalLeadMaps[idx]['dealValue'],
            'priority': priority,
            'status': status,
            'ownerName': ownerName,
            'ownerInitials': ownerInitials,
            'lastContact': 'Just now',
            if (notes.isNotEmpty) 'notes': notes,
            ..._formData,
          };
        }
        // Notify leads list to refresh
        widget.onLeadsChanged?.call();
        onLeadsChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text('Lead updated successfully!'),
              ],
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        // Create new lead
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        // Get interests from form data and use as tags
        final interests = _formData['interests'] as List<dynamic>? ?? [];
        final interestTags = interests.map((e) => e.toString()).toList();
        globalLeadMaps.insert(0, {
          'id': newId,
          'name': fullName.isNotEmpty ? fullName : 'New Lead',
          'company': company.isNotEmpty ? company : '',
          'status': status,
          'priority': priority,
          'score': 50,
          'dealValue': dealValue,
          'ownerInitials': ownerInitials,
          'ownerName': ownerName,
          'lastContact': 'Just now',
          'phone': phone,
          'email': email,
          'industry': industry,
          'tags': interestTags.isNotEmpty ? interestTags : [],
          if (notes.isNotEmpty) 'notes': notes,
          ..._formData,
        });

        // Auto-create follow-up if scheduled action is set
        final scheduledAction = _formData['scheduledAction'] as String? ?? '';
        final scheduledActionDate =
            _formData['scheduledActionDate'] as String? ?? '';
        final scheduledActionTime =
            _formData['scheduledActionTime'] as String? ?? '';
        final actionNotes = _formData['actionNotes'] as String? ?? '';
        final scheduledFrequency =
            _formData['scheduledFrequency'] as String? ?? 'Weekly';
        final preferredContact =
            (_formData['preferredContact'] as List?)?.cast<String>() ??
            ['Calls'];

        if (scheduledAction.isNotEmpty && scheduledAction != 'Not Interested') {
          // Parse date
          DateTime dueDate = DateTime.now().add(const Duration(days: 1));
          try {
            if (scheduledActionDate.isNotEmpty) {
              final parts = scheduledActionDate.split('/');
              if (parts.length == 3) {
                dueDate = DateTime(
                  int.parse(parts[2]),
                  int.parse(parts[1]),
                  int.parse(parts[0]),
                );
              }
            }
            if (scheduledActionTime.isNotEmpty) {
              final timeParts = scheduledActionTime.split(':');
              if (timeParts.length >= 2) {
                dueDate = DateTime(
                  dueDate.year,
                  dueDate.month,
                  dueDate.day,
                  int.parse(timeParts[0]),
                  int.parse(timeParts[1].split(' ')[0]),
                );
              }
            }
          } catch (_) {}

          // Map action to follow-up type
          String fuType = 'Calls';
          if (scheduledAction.toLowerCase().contains('email')) {
            fuType = 'Email';
          } else if (scheduledAction.toLowerCase().contains('whatsapp'))
            fuType = 'WhatsApp Messages';
          else if (scheduledAction.toLowerCase().contains('video'))
            fuType = 'Video Call';
          else if (scheduledAction.toLowerCase().contains('message'))
            fuType = 'Messages';
          else if (preferredContact.isNotEmpty)
            fuType = preferredContact.first;

          final newFollowUp = {
            'id': 'fu-${DateTime.now().millisecondsSinceEpoch}',
            'title': actionNotes.isNotEmpty
                ? actionNotes
                : 'Follow up with ${fullName.isNotEmpty ? fullName : 'New Lead'}',
            'type': fuType,
            'status': 'Upcoming',
            'priority': priority,
            'dueDate': dueDate,
            'assignedAgent': ownerName,
            'agentInitials': ownerInitials,
            'linkedLead': fullName.isNotEmpty ? fullName : 'New Lead',
            'linkedLeadId': newId,
            'customerPhone': phone,
            'notes': actionNotes,
            'outcome': '',
            'isRecurring':
                scheduledFrequency != 'None' && scheduledFrequency.isNotEmpty,
            'recurringFrequency': scheduledFrequency.isNotEmpty
                ? scheduledFrequency
                : 'Weekly',
            'isOverdue': false,
            'completedAt': null,
            'createdAt': DateTime.now(),
            'tags': interestTags,
            'preferredContact': preferredContact.isNotEmpty
                ? preferredContact
                : ['Calls'],
            'contactMethod': preferredContact.isNotEmpty
                ? preferredContact.first
                : 'Calls',
            'reminderBefore': '1 day',
            'isExistingCustomer': false,
            'callsDone': 0,
            'messagesDone': 0,
            'whatsappDone': 0,
            'emailDone': 0,
            'videoDone': 0,
            'upcomingFollowUps': <String>[],
          };
          fu_screen.globalFollowUpMaps.add(newFollowUp);
        }

        // Notify leads list to refresh
        widget.onLeadsChanged?.call();
        onLeadsChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text('Lead created successfully!'),
              ],
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      _clearAndExit();
    }
  }

  Widget _buildSectionContent(int index) {
    final prefill = _isEditing ? widget.editLead : null;
    switch (index) {
      case 0:
        return SectionContactInfoWidget(
          prefillData: prefill,
          onCompulsoryChanged: (filled) => _updateSectionProgress(0, filled),
          onDataChanged: _updateFormData,
        );
      case 1:
        return SectionCompanyInfoWidget(
          prefillData: prefill,
          onCompulsoryChanged: (filled) => _updateSectionProgress(1, filled),
          onDataChanged: _updateFormData,
        );
      case 2:
        return SectionLeadDetailsWidget(
          prefillData: prefill,
          onCompulsoryChanged: (filled) => _updateSectionProgress(2, filled),
          onDataChanged: _updateFormData,
        );
      case 3:
        return SectionAddressWidget(prefillData: prefill);
      case 4:
        return SectionSocialWidget(
          prefillData: prefill,
          onDataChanged: _updateFormData,
        );
      case 5:
        return SectionNotesWidget(prefillData: prefill);
      case 6:
        return const SectionInterestsWidget();
      case 7:
        return const SectionRelationsWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final theme = Theme.of(context);

    if (isTablet) {
      return _buildTabletLayout(theme);
    }
    return _buildPhoneLayout(theme);
  }

  Widget _buildPhoneLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _onBack,
          tooltip: 'Back',
        ),
        title: Text(
          _isEditing ? 'Edit Lead' : 'Add New Lead',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_autoSaveStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  _autoSaveStatus,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: _confirmDiscard,
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.error,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            WizardStepIndicatorWidget(
              steps: _steps.map((s) => s.label).toList(),
              currentStep: _currentStep,
              completedSteps: _stepCompleted,
              onStepTap: _onStepTap,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.04, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey('${_formInstanceKey}_$_currentStep'),
                    child: _buildSectionCard(_currentStep),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: WizardProgressFabWidget(
        currentStep: _currentStep,
        totalSteps: _steps.length,
        completedSteps: _stepCompleted,
        overallProgress: _overallProgress,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: WizardBottomBarWidget(
        currentStep: _currentStep,
        totalSteps: _steps.length,
        stepLabel: _steps[_currentStep].label,
        isLastStep: _currentStep == _steps.length - 1,
        isSaving: _isSaving,
        onBack: _onBack,
        onContinue: _onContinue,
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _confirmDiscard(),
          tooltip: 'Back',
        ),
        title: Text(
          _isEditing ? 'Edit Lead' : 'Add New Lead',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_autoSaveStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  _autoSaveStatus,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: _confirmDiscard,
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.error,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          TabletStepSidebarWidget(
            steps: _steps,
            currentStep: _currentStep,
            completedSteps: _stepCompleted,
            onStepTap: _onStepTap,
          ),
          Container(width: 1, color: AppTheme.surface200),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: KeyedSubtree(
                          key: ValueKey('${_formInstanceKey}_$_currentStep'),
                          child: _buildSectionCard(_currentStep),
                        ),
                      ),
                    ),
                  ),
                  WizardBottomBarWidget(
                    currentStep: _currentStep,
                    totalSteps: _steps.length,
                    stepLabel: _steps[_currentStep].label,
                    isLastStep: _currentStep == _steps.length - 1,
                    isSaving: _isSaving,
                    onBack: _onBack,
                    onContinue: _onContinue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(int index) {
    final isCompleted = _stepCompleted[index];
    final progress = _sectionProgress[index];
    final hasRequired = progress[1] > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(
              () => _sectionExpanded[index] = !_sectionExpanded[index],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.success
                          : AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
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
                          _steps[index].label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        if (hasRequired)
                          Text(
                            '${progress[0]}/${progress[1]} required fields filled',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isCompleted
                                  ? AppTheme.success
                                  : AppTheme.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _sectionExpanded[index] ? 0 : -0.5,
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
            child: _sectionExpanded[index]
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: _buildSectionContent(index),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
