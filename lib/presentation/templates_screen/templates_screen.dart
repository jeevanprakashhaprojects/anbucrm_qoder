import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../leads_list_screen/leads_list_screen.dart' as leads_list;

// ─── Template Data ────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> globalTemplateMaps = [
  {
    'id': 'tpl-001',
    'name': 'Welcome Message',
    'category': 'WhatsApp',
    'body':
        'Hi @customer_name! 👋 Welcome to AnbuCRM. I\'m @agent_name from our team. I\'d love to help you with @interest_name. When would be a good time to connect?',
    'createdAt': DateTime.now().subtract(const Duration(days: 10)),
    'usageCount': 24,
    'color': const Color(0xFF25D366),
    'icon': Icons.chat_rounded,
  },
  {
    'id': 'tpl-002',
    'name': 'Follow-up Reminder',
    'category': 'Email',
    'body':
        'Dear @customer_name,\n\nThis is a gentle reminder regarding our discussion on @last_contact_date about @interest_name.\n\nAs discussed, I\'m sharing the details for your review. Please feel free to reach out at @agent_phone.\n\nBest regards,\n@agent_name\n@company_name',
    'createdAt': DateTime.now().subtract(const Duration(days: 7)),
    'usageCount': 18,
    'color': const Color(0xFF3B82F6),
    'icon': Icons.email_rounded,
  },
  {
    'id': 'tpl-003',
    'name': 'Policy Renewal',
    'category': 'SMS',
    'body':
        'Hi @customer_name, your @policy_name is due for renewal on @renewal_date. Contact @agent_name at @agent_phone to renew. - @company_name',
    'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    'usageCount': 31,
    'color': const Color(0xFFF59E0B),
    'icon': Icons.sms_rounded,
  },
  {
    'id': 'tpl-004',
    'name': 'Meeting Confirmation',
    'category': 'WhatsApp',
    'body':
        'Hi @customer_name! ✅ Confirming our meeting on @meeting_date at @meeting_time.\n\nAgenda: @meeting_agenda\n\nLooking forward to speaking with you!\n\n— @agent_name',
    'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    'usageCount': 12,
    'color': const Color(0xFF25D366),
    'icon': Icons.chat_rounded,
  },
  {
    'id': 'tpl-005',
    'name': 'Birthday Greeting',
    'category': 'WhatsApp',
    'body':
        'Happy Birthday @customer_name! 🎂🎉\n\nWishing you a wonderful day filled with joy. As a valued customer, we have a special offer for you this month.\n\nContact me anytime — @agent_name (@agent_phone)',
    'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    'usageCount': 9,
    'color': const Color(0xFF25D366),
    'icon': Icons.cake_rounded,
  },
  {
    'id': 'tpl-006',
    'name': 'Proposal Sent',
    'category': 'Email',
    'body':
        'Dear @customer_name,\n\nThank you for your time today. As discussed, I\'ve attached the proposal for @interest_name worth ₹@deal_value.\n\nPlease review and let me know your thoughts by @follow_up_date.\n\nWarm regards,\n@agent_name\n@agent_email\n@company_name',
    'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    'usageCount': 7,
    'color': const Color(0xFF3B82F6),
    'icon': Icons.description_rounded,
  },
];

// ─── Available Attributes — derived from Add Lead fields ─────────────────────
// These map @attribute_name → lead map key
const _kAttributeMap = {
  '@customer_name': 'name',
  '@first_name': 'firstName',
  '@last_name': 'lastName',
  '@customer_phone': 'primaryMobile',
  '@customer_email': 'primaryEmail',
  '@company_name': 'companyName',
  '@designation': 'designation',
  '@city': 'city',
  '@state': 'state',
  '@country': 'country',
  '@interest_name': 'interests',
  '@deal_value': 'dealValue',
  '@pipeline_stage': 'pipelineStage',
  '@source': 'source',
  '@annual_income': 'annualIncome',
  '@occupation': 'occupation',
  '@dob': 'dob',
  '@gender': 'gender',
  '@marital_status': 'maritalStatus',
  '@spouse_name': 'spouseName',
  '@linkedin': 'linkedin',
  '@instagram': 'instagram',
  '@facebook': 'facebook',
  '@twitter': 'twitter',
  '@telegram': 'telegram',
  '@whatsapp': 'whatsapp',
  '@agent_name': null,
  '@agent_phone': null,
  '@agent_email': null,
  '@meeting_date': null,
  '@meeting_time': null,
  '@meeting_agenda': null,
  '@last_contact_date': null,
  '@follow_up_date': null,
  '@renewal_date': null,
  '@policy_name': null,
};

const _kAttributes = [
  {
    'name': '@customer_name',
    'desc': 'Customer\'s full name',
    'example': 'Rahul Mehta',
  },
  {'name': '@first_name', 'desc': 'Customer\'s first name', 'example': 'Rahul'},
  {'name': '@last_name', 'desc': 'Customer\'s last name', 'example': 'Mehta'},
  {
    'name': '@customer_phone',
    'desc': 'Customer phone number',
    'example': '+91 98765 43210',
  },
  {
    'name': '@customer_email',
    'desc': 'Customer email address',
    'example': 'rahul@example.com',
  },
  {
    'name': '@company_name',
    'desc': 'Company name',
    'example': 'TechCorp Solutions',
  },
  {'name': '@designation', 'desc': 'Customer designation', 'example': 'CTO'},
  {'name': '@city', 'desc': 'Customer city', 'example': 'Bangalore'},
  {'name': '@state', 'desc': 'Customer state', 'example': 'Karnataka'},
  {'name': '@country', 'desc': 'Customer country', 'example': 'India'},
  {
    'name': '@interest_name',
    'desc': 'Product/interest name',
    'example': 'Term Life Insurance',
  },
  {'name': '@deal_value', 'desc': 'Deal/premium value', 'example': '1,25,000'},
  {
    'name': '@pipeline_stage',
    'desc': 'Current pipeline stage',
    'example': 'Proposal',
  },
  {'name': '@source', 'desc': 'Lead source', 'example': 'LinkedIn'},
  {'name': '@annual_income', 'desc': 'Annual income', 'example': '₹18,00,000'},
  {'name': '@occupation', 'desc': 'Occupation', 'example': 'Software Engineer'},
  {'name': '@dob', 'desc': 'Date of birth', 'example': '15/03/1985'},
  {'name': '@gender', 'desc': 'Gender', 'example': 'Male'},
  {'name': '@marital_status', 'desc': 'Marital status', 'example': 'Married'},
  {'name': '@spouse_name', 'desc': 'Spouse name', 'example': 'Priya Mehta'},
  {
    'name': '@linkedin',
    'desc': 'LinkedIn profile',
    'example': 'linkedin.com/in/rahul',
  },
  {'name': '@instagram', 'desc': 'Instagram handle', 'example': '@rahulmehta'},
  {
    'name': '@facebook',
    'desc': 'Facebook profile',
    'example': 'facebook.com/rahul',
  },
  {'name': '@twitter', 'desc': 'Twitter handle', 'example': '@rahulmehta_tech'},
  {'name': '@telegram', 'desc': 'Telegram handle', 'example': '@rahulmehta_tg'},
  {
    'name': '@whatsapp',
    'desc': 'WhatsApp number',
    'example': '+91 98765 43210',
  },
  {
    'name': '@agent_name',
    'desc': 'Agent\'s full name',
    'example': 'Priya Sharma',
  },
  {
    'name': '@agent_phone',
    'desc': 'Agent\'s phone number',
    'example': '+91 98765 11111',
  },
  {
    'name': '@agent_email',
    'desc': 'Agent\'s email address',
    'example': 'priya@anbucrm.in',
  },
  {
    'name': '@meeting_date',
    'desc': 'Scheduled meeting date',
    'example': '20 Sep 2025',
  },
  {
    'name': '@meeting_time',
    'desc': 'Scheduled meeting time',
    'example': '3:00 PM',
  },
  {
    'name': '@meeting_agenda',
    'desc': 'Meeting agenda',
    'example': 'Policy review',
  },
  {
    'name': '@last_contact_date',
    'desc': 'Last contact date',
    'example': '10 Sep 2025',
  },
  {
    'name': '@follow_up_date',
    'desc': 'Follow-up due date',
    'example': '25 Sep 2025',
  },
  {
    'name': '@renewal_date',
    'desc': 'Policy renewal date',
    'example': '15 Jan 2026',
  },
  {
    'name': '@policy_name',
    'desc': 'Policy name',
    'example': 'LIC Jeevan Anand',
  },
];

const _kCategories = [
  'All',
  'WhatsApp',
  'Email',
  'SMS',
  'Calls',
  'Telegram',
  'Instagram',
  'X (Twitter)',
  'Facebook',
  'Messages',
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isSearchActive = false;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _templates = [];

  @override
  void initState() {
    super.initState();
    _templates = List.from(globalTemplateMaps);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    return _templates.where((t) {
      final matchCat =
          _selectedCategory == 'All' || t['category'] == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchSearch =
          q.isEmpty ||
          (t['name'] as String).toLowerCase().contains(q) ||
          (t['body'] as String).toLowerCase().contains(q) ||
          (t['category'] as String).toLowerCase().contains(q);
      return matchCat && matchSearch;
    }).toList();
  }

  void _showCreateSheet({Map<String, dynamic>? editTemplate}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _TemplateCreateSheet(
          editTemplate: editTemplate,
          onSave: (tpl) {
          setState(() {
            if (editTemplate != null) {
              final idx = globalTemplateMaps.indexWhere(
                (t) => t['id'] == editTemplate['id'],
              );
              if (idx >= 0) {
                globalTemplateMaps[idx] = tpl;
              }
            } else {
              globalTemplateMaps.add(tpl);
            }
            _templates = List.from(globalTemplateMaps);
          });
        },
      ),
      ),
    );
  }

  void _deleteTemplate(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Template?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This template will be permanently deleted.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                globalTemplateMaps.removeWhere((t) => t['id'] == id);
                _templates = List.from(globalTemplateMaps);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Template deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _copyAndUseTemplate(Map<String, dynamic> tpl) {
    // Show lead selection dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _LeadSelectSheet(
          template: tpl,
        onLeadSelected: (leadMap) {
          _processCopyWithLead(tpl, leadMap);
        },
        onCopyRaw: () {
          Clipboard.setData(ClipboardData(text: tpl['body'] as String));
          _incrementUsage(tpl);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Template copied to clipboard'),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  void _processCopyWithLead(
    Map<String, dynamic> tpl,
    Map<String, dynamic> leadMap,
  ) {
    final body = tpl['body'] as String;
    // Find all @attributes in the template
    final attrRegex = RegExp(r'@\w+');
    final usedAttrs = attrRegex
        .allMatches(body)
        .map((m) => m.group(0)!)
        .toSet();

    // Check which attributes are missing from the lead
    final missingAttrs = <String>[];
    for (final attr in usedAttrs) {
      final leadKey = _kAttributeMap[attr];
      if (leadKey != null) {
        final val = leadMap[leadKey];
        if (val == null ||
            val.toString().isEmpty ||
            (val is List && (val).isEmpty)) {
          missingAttrs.add(attr);
        }
      }
    }

    if (missingAttrs.isNotEmpty) {
      // Show warning dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.warning,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Missing Attributes',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The following attributes are not available for ${leadMap['name'] ?? 'this lead'}:',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: missingAttrs
                    .map(
                      (a) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.error.withAlpha(60),
                          ),
                        ),
                        child: Text(
                          a,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              Text(
                'These will remain as placeholders. Do you want to copy anyway?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _fillAndCopy(tpl, leadMap);
              },
              style: FilledButton.styleFrom(backgroundColor: AppTheme.warning),
              child: Text(
                'Copy Anyway',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    } else {
      _fillAndCopy(tpl, leadMap);
    }
  }

  void _fillAndCopy(Map<String, dynamic> tpl, Map<String, dynamic> leadMap) {
    String body = tpl['body'] as String;
    // Replace all known attributes
    for (final entry in _kAttributeMap.entries) {
      final attr = entry.key;
      final leadKey = entry.value;
      if (leadKey != null) {
        final val = leadMap[leadKey];
        if (val != null && val.toString().isNotEmpty) {
          String replacement;
          if (val is List) {
            replacement = (val).isNotEmpty ? (val).first.toString() : attr;
          } else {
            replacement = val.toString();
          }
          body = body.replaceAll(attr, replacement);
        }
      }
    }
    Clipboard.setData(ClipboardData(text: body));
    _incrementUsage(tpl);
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
              'Filled & copied for ${leadMap['name'] ?? 'lead'}',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _incrementUsage(Map<String, dynamic> tpl) {
    final idx = globalTemplateMaps.indexWhere((t) => t['id'] == tpl['id']);
    if (idx >= 0) {
      setState(() {
        globalTemplateMaps[idx]['usageCount'] =
            (globalTemplateMaps[idx]['usageCount'] as int) + 1;
        _templates = List.from(globalTemplateMaps);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final navBarHeight = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight),
        child: CustomScrollView(
          controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppTheme.surfaceLight,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: AppTheme.surface200,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 22),
              color: AppTheme.textPrimary,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go('/dashboard-screen');
                }
              },
            ),
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(31),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.library_books_rounded,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Message Templates',
                          maxLines: 1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${filtered.length} template${filtered.length != 1 ? 's' : ''}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearchActive
                      ? Icons.search_off_rounded
                      : Icons.search_rounded,
                  color: AppTheme.textSecondary,
                  size: 22,
                ),
                onPressed: () => setState(() {
                  _isSearchActive = !_isSearchActive;
                  if (!_isSearchActive) {
                    _searchQuery = '';
                    _searchController.clear();
                  }
                }),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, size: 22),
                color: AppTheme.textSecondary,
                onPressed: () => _showAttributesSheet(),
                tooltip: 'Available Attributes',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (_isSearchActive) _buildSearchBar(),
                _buildCategoryTabs(),
                _buildStatsRow(filtered.length),
              ],
            ),
          ),
          if (filtered.isEmpty)
            SliverFillRemaining(
              child: _buildEmpty(),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, navBarHeight + 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _TemplateCard(
                    template: filtered[i],
                    onEdit: () =>
                        _showCreateSheet(editTemplate: filtered[i]),
                    onDelete: () =>
                        _deleteTemplate(filtered[i]['id'] as String),
                    onCopyAndUse: () => _copyAndUseTemplate(filtered[i]),
                    onPreview: () => _showPreviewSheet(filtered[i]),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'New Template',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      );
  }


  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.plusJakartaSans(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search templates...',
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          filled: true,
          fillColor: AppTheme.surface100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: AppTheme.surfaceLight,
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _kCategories.length,
        itemBuilder: (_, i) {
          final cat = _kCategories[i];
          final isSelected = _selectedCategory == cat;
          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.surface200,
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(int count) {
    final totalUsage = _templates.fold<int>(
      0,
      (sum, t) => sum + (t['usageCount'] as int),
    );
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Flexible(child: _StatPill(
            label: '$count Templates',
            icon: Icons.library_books_rounded,
            color: AppTheme.primary,
          )),
          const SizedBox(width: 8),
          Flexible(child: _StatPill(
            label: '$totalUsage Uses',
            icon: Icons.send_rounded,
            color: AppTheme.success,
          )),
          const SizedBox(width: 8),
          Flexible(child: _StatPill(
            label: '${_kAttributes.length} Attributes',
            icon: Icons.code_rounded,
            color: AppTheme.warning,
          )),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.library_books_rounded,
              color: AppTheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No templates found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first template with\n@attribute_name placeholders',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _showCreateSheet(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Template'),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  void _showPreviewSheet(Map<String, dynamic> tpl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _TemplatePreviewSheet(template: tpl),
      ),
    );
  }

  void _showAttributesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: const _AttributesSheet(),
      ),
    );
  }
}

// ─── Lead Select Sheet ────────────────────────────────────────────────────────

class _LeadSelectSheet extends StatefulWidget {
  final Map<String, dynamic> template;
  final void Function(Map<String, dynamic> leadMap) onLeadSelected;
  final VoidCallback onCopyRaw;

  const _LeadSelectSheet({
    required this.template,
    required this.onLeadSelected,
    required this.onCopyRaw,
  });

  @override
  State<_LeadSelectSheet> createState() => _LeadSelectSheetState();
}

class _LeadSelectSheetState extends State<_LeadSelectSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLeads {
    final q = _query.toLowerCase();
    return leads_list.dummyLeads.where((m) {
      final name = (m['name'] as String? ?? '').toLowerCase();
      final phone = (m['phone'] as String? ?? '').toLowerCase();
      return q.isEmpty || name.contains(q) || phone.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLeads;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_search_rounded,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Lead',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Fill template with lead data',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onCopyRaw();
                  },
                  child: Text(
                    'Copy Raw',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search leads by name or phone...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 16),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                filled: true,
                fillColor: AppTheme.surface100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No leads found',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final lead = filtered[i];
                      final name = lead['name'] as String? ?? '';
                      final phone = lead['phone'] as String? ?? '';
                      final initial = name.isNotEmpty
                          ? name[0].toUpperCase()
                          : '?';
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onLeadSelected(lead);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surface100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.surface200),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppTheme.primary.withAlpha(30),
                                child: Text(
                                  initial,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    if (phone.isNotEmpty)
                                      Text(
                                        phone,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppTheme.textMuted,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Template Card ────────────────────────────────────────────────────────────

class _TemplateCard extends StatelessWidget {
  final Map<String, dynamic> template;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCopyAndUse;
  final VoidCallback onPreview;

  const _TemplateCard({
    required this.template,
    required this.onEdit,
    required this.onDelete,
    required this.onCopyAndUse,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final color = template['color'] as Color;
    final body = template['body'] as String;
    final usageCount = template['usageCount'] as int;

    // Highlight @attributes in preview
    final attributeRegex = RegExp(r'@\w+');
    final spans = <TextSpan>[];
    int lastEnd = 0;
    final preview = body.length > 120 ? '${body.substring(0, 120)}...' : body;
    for (final match in attributeRegex.allMatches(preview)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: preview.substring(lastEnd, match.start),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            backgroundColor: AppTheme.primaryContainer,
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < preview.length) {
      spans.add(
        TextSpan(
          text: preview.substring(lastEnd),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onPreview,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surface200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
              decoration: BoxDecoration(
                color: color.withAlpha(15),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                border: Border(bottom: BorderSide(color: color.withAlpha(40))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      template['icon'] as IconData,
                      color: color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template['name'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withAlpha(25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                template['category'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.send_rounded,
                              size: 10,
                              color: AppTheme.textMuted,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$usageCount uses',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (v) {
                      if (v == 'edit') onEdit();
                      if (v == 'delete') onDelete();
                      if (v == 'copy') onCopyAndUse();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'copy',
                        child: Row(
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Copy & Use',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 16,
                              color: AppTheme.warning,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Edit',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              size: 16,
                              color: AppTheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Body preview
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: RichText(
                text: TextSpan(children: spans),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPreview,
                      icon: const Icon(Icons.visibility_rounded, size: 14),
                      label: Text(
                        'Preview',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: BorderSide(color: AppTheme.surface200),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onCopyAndUse,
                      icon: const Icon(Icons.copy_rounded, size: 14),
                      label: Text(
                        'Copy & Use',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: color,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Template Create/Edit Sheet ───────────────────────────────────────────────

class _TemplateCreateSheet extends StatefulWidget {
  final Map<String, dynamic>? editTemplate;
  final void Function(Map<String, dynamic>) onSave;

  const _TemplateCreateSheet({this.editTemplate, required this.onSave});

  @override
  State<_TemplateCreateSheet> createState() => _TemplateCreateSheetState();
}

class _TemplateCreateSheetState extends State<_TemplateCreateSheet> {
  final _nameCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _bodyFocusNode = FocusNode();
  String _category = 'WhatsApp';

  // @ mention dropdown state
  bool _showAtDropdown = false;
  String _atQuery = '';
  int _atStartIndex = -1;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.editTemplate != null) {
      _nameCtrl.text = widget.editTemplate!['name'] as String;
      _bodyCtrl.text = widget.editTemplate!['body'] as String;
      _subjectCtrl.text = widget.editTemplate!['subject'] as String? ?? '';
      _category = widget.editTemplate!['category'] as String;
    }
    _bodyCtrl.addListener(_onBodyChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _nameCtrl.dispose();
    _bodyCtrl.removeListener(_onBodyChanged);
    _bodyCtrl.dispose();
    _subjectCtrl.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  void _onBodyChanged() {
    final text = _bodyCtrl.text;
    final cursor = _bodyCtrl.selection.baseOffset;
    if (cursor < 0) return;

    // Find the last @ before cursor
    int atIdx = -1;
    for (int i = cursor - 1; i >= 0; i--) {
      if (text[i] == '@') {
        atIdx = i;
        break;
      }
      // Stop if we hit a space or newline
      if (text[i] == ' ' || text[i] == '\n') break;
    }

    if (atIdx >= 0) {
      final query = text.substring(atIdx + 1, cursor).toLowerCase();
      setState(() {
        _showAtDropdown = true;
        _atQuery = query;
        _atStartIndex = atIdx;
      });
      _showOverlay();
    } else {
      _hideDropdown();
    }
  }

  List<Map<String, dynamic>> get _filteredAttributes {
    if (_atQuery.isEmpty) return _kAttributes;
    return _kAttributes
        .where(
          (a) =>
              (a['name'] as String).toLowerCase().contains(_atQuery) ||
              (a['desc'] as String).toLowerCase().contains(_atQuery),
        )
        .toList();
  }

  void _selectAttribute(String attrName) {
    _removeOverlay();
    final text = _bodyCtrl.text;
    final cursor = _bodyCtrl.selection.baseOffset;
    if (_atStartIndex < 0 || _atStartIndex >= text.length) return;

    final before = text.substring(0, _atStartIndex);
    final after = text.substring(cursor);
    final newText = '$before$attrName$after';
    _bodyCtrl.text = newText;
    _bodyCtrl.selection = TextSelection.collapsed(
      offset: before.length + attrName.length,
    );
    setState(() {
      _showAtDropdown = false;
      _atQuery = '';
      _atStartIndex = -1;
    });
  }

  void _hideDropdown() {
    _removeOverlay();
    setState(() {
      _showAtDropdown = false;
      _atQuery = '';
      _atStartIndex = -1;
    });
  }

  void _showOverlay() {
    _removeOverlay();
    final filtered = _filteredAttributes;
    if (filtered.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        width: MediaQuery.of(context).size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -200),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withAlpha(60)),
              ),
              child: StatefulBuilder(
                builder: (_, setS) {
                  final attrs = _filteredAttributes;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.code_rounded,
                              size: 14,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Insert Attribute',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _hideDropdown,
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: attrs.length,
                          itemBuilder: (_, i) {
                            final attr = attrs[i];
                            return InkWell(
                              onTap: () =>
                                  _selectAttribute(attr['name'] as String),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.surface200,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary.withAlpha(15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        attr['name'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        attr['desc'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppTheme.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  bool get _canSave =>
      _nameCtrl.text.trim().isNotEmpty &&
      _bodyCtrl.text.trim().isNotEmpty &&
      (_category != 'Email' || _subjectCtrl.text.trim().isNotEmpty);

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'WhatsApp':
        return const Color(0xFF25D366);
      case 'Email':
        return const Color(0xFF3B82F6);
      case 'SMS':
        return const Color(0xFFF59E0B);
      case 'Calls':
        return AppTheme.primary;
      case 'Telegram':
        return const Color(0xFF0088CC);
      case 'Instagram':
        return const Color(0xFFE1306C);
      case 'X (Twitter)':
        return const Color(0xFF000000);
      case 'Facebook':
        return const Color(0xFF1877F2);
      case 'Messages':
        return const Color(0xFF8B5CF6);
      default:
        return AppTheme.primary;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'WhatsApp':
        return Icons.chat_rounded;
      case 'Email':
        return Icons.email_rounded;
      case 'SMS':
        return Icons.sms_rounded;
      case 'Calls':
        return Icons.phone_rounded;
      case 'Telegram':
        return Icons.send_rounded;
      case 'Instagram':
        return Icons.camera_alt_rounded;
      case 'X (Twitter)':
        return Icons.close_rounded;
      case 'Facebook':
        return Icons.facebook_rounded;
      case 'Messages':
        return Icons.message_rounded;
      default:
        return Icons.library_books_rounded;
    }
  }

  void _save() {
    if (!_canSave) return;
    _removeOverlay();
    final isEdit = widget.editTemplate != null;
    final tpl = {
      'id': isEdit
          ? widget.editTemplate!['id']
          : 'tpl-${DateTime.now().millisecondsSinceEpoch}',
      'name': _nameCtrl.text.trim(),
      'category': _category,
      'body': _bodyCtrl.text.trim(),
      'subject': _category == 'Email' ? _subjectCtrl.text.trim() : '',
      'createdAt': isEdit ? widget.editTemplate!['createdAt'] : DateTime.now(),
      'usageCount': isEdit ? widget.editTemplate!['usageCount'] : 0,
      'color': _categoryColor(_category),
      'icon': _categoryIcon(_category),
    };
    widget.onSave(tpl);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEdit ? 'Template updated' : 'Template created'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _bodyLabel() {
    switch (_category) {
      case 'Email':
        return 'Email Body *';
      case 'Calls':
        return 'Call Script *';
      case 'WhatsApp':
        return 'WhatsApp Message *';
      case 'SMS':
        return 'SMS Message *';
      case 'Telegram':
        return 'Telegram Message *';
      case 'Instagram':
        return 'Instagram DM *';
      case 'X (Twitter)':
        return 'X (Twitter) Message *';
      case 'Facebook':
        return 'Facebook Message *';
      case 'Messages':
        return 'Message Body *';
      default:
        return 'Message Body *';
    }
  }

  String _bodyHint() {
    switch (_category) {
      case 'Email':
        return 'Dear @customer_name,\n\nThank you for your time...\n\nBest regards,\n@agent_name';
      case 'Calls':
        return 'Opening: Hi @customer_name, this is @agent_name from @company_name...\n\nKey points:\n1. ...\n2. ...\n\nClosing: ...';
      case 'WhatsApp':
        return 'Hi @customer_name! 👋 I\'m @agent_name from @company_name...';
      case 'SMS':
        return 'Hi @customer_name, @agent_name from @company_name. ...';
      case 'Telegram':
        return 'Hello @customer_name! I\'m @agent_name from @company_name...';
      case 'Instagram':
        return 'Hey @customer_name! 👋 Saw your interest in @interest_name...';
      case 'X (Twitter)':
        return 'Hi @customer_name, @agent_name here from @company_name. DM\'d you about @interest_name...';
      case 'Facebook':
        return 'Hi @customer_name! I\'m @agent_name from @company_name. Reaching out about @interest_name...';
      case 'Messages':
        return 'Hi @customer_name, this is @agent_name from @company_name...';
      default:
        return 'Hi @customer_name...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editTemplate != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isEdit ? Icons.edit_rounded : Icons.add_rounded,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEdit ? 'Edit Template' : 'Create Template',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      _removeOverlay();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Template Name
                    Text(
                      'Template Name *',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameCtrl,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'e.g. Welcome Message, Policy Renewal...',
                        filled: true,
                        fillColor: AppTheme.surface100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Category / Platform
                    Text(
                      'Platform *',
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
                      children:
                          [
                            'WhatsApp',
                            'Email',
                            'SMS',
                            'Calls',
                            'Telegram',
                            'Instagram',
                            'X (Twitter)',
                            'Facebook',
                            'Messages',
                          ].map((cat) {
                            final isSelected = _category == cat;
                            final color = _categoryColor(cat);
                            return GestureDetector(
                              onTap: () => setState(() => _category = cat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withAlpha(25)
                                      : AppTheme.surface100,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : AppTheme.surface200,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _categoryIcon(cat),
                                      size: 14,
                                      color: isSelected
                                          ? color
                                          : AppTheme.textMuted,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      cat,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? color
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Email: Subject + Body
                    if (_category == 'Email') ...[
                      Text(
                        'Email Subject *',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _subjectCtrl,
                        onChanged: (_) => setState(() {}),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Policy Renewal Reminder — @customer_name',
                          filled: true,
                          fillColor: AppTheme.surface100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Calls: show a "Call Script" info banner
                    if (_category == 'Calls') ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primary.withAlpha(40),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 14,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Write a call script with opening, key talking points, and closing. Use @attributes for dynamic values.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Instagram/X/Facebook/Telegram: platform info banner
                    if ([
                      'Instagram',
                      'X (Twitter)',
                      'Facebook',
                      'Telegram',
                    ].contains(_category)) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _categoryColor(_category).withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _categoryColor(_category).withAlpha(40),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _categoryIcon(_category),
                              size: 14,
                              color: _categoryColor(_category),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _category == 'X (Twitter)'
                                    ? 'Keep it concise (280 chars). Use @attributes for personalization.'
                                    : _category == 'Instagram'
                                    ? 'Write a friendly DM. Use @attributes for personalization.'
                                    : _category == 'Telegram'
                                    ? 'Telegram supports rich text. Use @attributes for personalization.'
                                    : 'Write a Facebook message. Use @attributes for personalization.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: _categoryColor(_category),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Message Body field with @ mention hint
                    Row(
                      children: [
                        Text(
                          _bodyLabel(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.alternate_email_rounded,
                                size: 12,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Type @ to insert',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // @ mention hint
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.surface100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.surface200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 13,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Type @ in the message body to see a live list of all available attributes. Start typing to filter.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Body text field with overlay anchor
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: TextField(
                        controller: _bodyCtrl,
                        focusNode: _bodyFocusNode,
                        onChanged: (_) => setState(() {}),
                        maxLines: _category == 'Calls'
                            ? 8
                            : _category == 'Email'
                            ? 8
                            : 6,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: _bodyHint(),
                          filled: true,
                          fillColor: AppTheme.surface100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: _showAtDropdown
                                ? BorderSide(
                                    color: AppTheme.primary,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: _showAtDropdown
                                ? BorderSide(
                                    color: AppTheme.primary,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _canSave ? _save : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEdit ? 'Update Template' : 'Create Template',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Template Preview Sheet ───────────────────────────────────────────────────

class _TemplatePreviewSheet extends StatefulWidget {
  final Map<String, dynamic> template;
  const _TemplatePreviewSheet({required this.template});

  @override
  State<_TemplatePreviewSheet> createState() => _TemplatePreviewSheetState();
}

class _TemplatePreviewSheetState extends State<_TemplatePreviewSheet> {
  bool _showFilled = false;

  String _fillTemplate(String body) {
    return body
        .replaceAll('@customer_name', 'Rahul Mehta')
        .replaceAll('@first_name', 'Rahul')
        .replaceAll('@last_name', 'Mehta')
        .replaceAll('@agent_name', 'Priya Sharma')
        .replaceAll('@agent_phone', '+91 98765 11111')
        .replaceAll('@agent_email', 'priya@anbucrm.in')
        .replaceAll('@company_name', 'AnbuCRM')
        .replaceAll('@interest_name', 'Term Life Insurance')
        .replaceAll('@policy_name', 'LIC Jeevan Anand')
        .replaceAll('@renewal_date', '15 Jan 2026')
        .replaceAll('@deal_value', '1,25,000')
        .replaceAll('@meeting_date', '20 Sep 2025')
        .replaceAll('@meeting_time', '3:00 PM')
        .replaceAll('@meeting_agenda', 'Policy review & proposal')
        .replaceAll('@last_contact_date', '10 Sep 2025')
        .replaceAll('@follow_up_date', '25 Sep 2025')
        .replaceAll('@customer_phone', '+91 98765 43210')
        .replaceAll('@pipeline_stage', 'Proposal')
        .replaceAll('@city', 'Bangalore')
        .replaceAll('@state', 'Karnataka')
        .replaceAll('@country', 'India')
        .replaceAll('@designation', 'CTO')
        .replaceAll('@occupation', 'Software Engineer')
        .replaceAll('@annual_income', '₹18,00,000')
        .replaceAll('@gender', 'Male')
        .replaceAll('@marital_status', 'Married')
        .replaceAll('@spouse_name', 'Priya Mehta')
        .replaceAll('@source', 'LinkedIn');
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.template['color'] as Color;
    final body = widget.template['body'] as String;
    final displayBody = _showFilled ? _fillTemplate(body) : body;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.template['icon'] as IconData,
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.template['name'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showFilled = !_showFilled),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _showFilled
                          ? AppTheme.success.withAlpha(20)
                          : AppTheme.surface100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _showFilled
                            ? AppTheme.success
                            : AppTheme.surface200,
                      ),
                    ),
                    child: Text(
                      _showFilled ? 'With Data' : 'Raw',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _showFilled
                            ? AppTheme.success
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withAlpha(15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withAlpha(40)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.template['icon'] as IconData,
                              size: 14,
                              color: color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.template['category'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                            const Spacer(),
                            if (!_showFilled)
                              Text(
                                'Placeholders shown',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppTheme.textMuted,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _showFilled
                            ? Text(
                                displayBody,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                  height: 1.6,
                                ),
                              )
                            : _buildHighlightedBody(displayBody),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded, size: 14),
                          label: Text(
                            'Close',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: displayBody));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Copied to clipboard'),
                                backgroundColor: AppTheme.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 14),
                          label: Text(
                            'Copy & Use',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: color,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedBody(String body) {
    final attributeRegex = RegExp(r'@\w+');
    final spans = <TextSpan>[];
    int lastEnd = 0;
    for (final match in attributeRegex.allMatches(body)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: body.substring(lastEnd, match.start),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.primary,
            fontWeight: FontWeight.w700,
            backgroundColor: AppTheme.primaryContainer,
            height: 1.6,
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < body.length) {
      spans.add(
        TextSpan(
          text: body.substring(lastEnd),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textPrimary,
            height: 1.6,
          ),
        ),
      );
    }
    return RichText(text: TextSpan(children: spans));
  }
}

// ─── Attributes Sheet ─────────────────────────────────────────────────────────

class _AttributesSheet extends StatelessWidget {
  const _AttributesSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.code_rounded,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Attributes',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Use these in your templates',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _kAttributes.length,
              itemBuilder: (_, i) {
                final attr = _kAttributes[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surface100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.surface200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attr['name']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              attr['desc']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
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
                          color: AppTheme.success.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          attr['example']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppTheme.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: attr['name']!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${attr['name']} copied'),
                              backgroundColor: AppTheme.primary,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── Stat Pill ────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatPill({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
