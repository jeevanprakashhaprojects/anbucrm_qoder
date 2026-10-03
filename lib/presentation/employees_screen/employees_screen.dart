import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

// ─── Access Level Info ────────────────────────────────────────────────────────

const _accessLevelInfo = {
  'Admin': {
    'prefix': 'ADM',
    'color': Color(0xFFEF4444),
    'description':
        'Full system access. Can manage all leads, employees, assignments, reports, and settings.',
    'permissions': [
      'View all leads',
      'Assign leads',
      'Manage employees',
      'View all reports',
      'System settings',
      'Archive/Activate employees',
    ],
  },
  'Manager': {
    'prefix': 'MGR',
    'color': Color(0xFF8B5CF6),
    'description':
        'Manager access. Can oversee team performance, assign tasks, and manage team leads.',
    'permissions': [
      'View team leads',
      'Assign team tasks',
      'View team reports',
      'Manage follow-ups',
      'Schedule sessions',
      'View employee performance',
    ],
  },
  'Senior Rep': {
    'prefix': 'SRP',
    'color': Color(0xFF0891B2),
    'description':
        'Senior representative access. Can manage leads, mentor juniors, and access advanced reports.',
    'permissions': [
      'View assigned leads',
      'Create follow-ups',
      'Schedule sessions',
      'View own reports',
      'Mentor junior agents',
      'Access advanced analytics',
    ],
  },
  'Employee': {
    'prefix': 'EMP',
    'color': Color(0xFF3B82F6),
    'description':
        'Standard employee access. Can manage assigned leads, sessions, follow-ups and tasks.',
    'permissions': [
      'View assigned leads',
      'Create follow-ups',
      'Schedule sessions',
      'View own tasks',
      'Update lead status',
    ],
  },
  'Contact': {
    'prefix': 'CONT',
    'color': Color(0xFF059669),
    'description':
        'Contact-only access. These employees are assigned leads to contact and update status.',
    'permissions': [
      'View assigned leads',
      'Update contact status',
      'Add call notes',
      'Mark leads as contacted',
    ],
  },
};

String _generateUniqueId(
  String accessLevel,
  List<Map<String, dynamic>> existing,
) {
  final prefix = (_accessLevelInfo[accessLevel]?['prefix'] as String?) ?? 'EMP';
  final existingIds = existing
      .where((e) => (e['employeeId'] as String? ?? '').startsWith(prefix))
      .map((e) => e['employeeId'] as String)
      .toList();
  int num = 1000 + existing.length + 1;
  String candidate = '$prefix-$num';
  while (existingIds.contains(candidate)) {
    num++;
    candidate = '$prefix-$num';
  }
  return candidate;
}

// ─── Country Codes ────────────────────────────────────────────────────────────

const _countryCodes = [
  {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
  {'code': '+1', 'flag': '🇺🇸', 'name': 'USA'},
  {'code': '+44', 'flag': '🇬🇧', 'name': 'UK'},
  {'code': '+971', 'flag': '🇦🇪', 'name': 'UAE'},
  {'code': '+65', 'flag': '🇸🇬', 'name': 'Singapore'},
  {'code': '+60', 'flag': '🇲🇾', 'name': 'Malaysia'},
  {'code': '+61', 'flag': '🇦🇺', 'name': 'Australia'},
  {'code': '+49', 'flag': '🇩🇪', 'name': 'Germany'},
  {'code': '+33', 'flag': '🇫🇷', 'name': 'France'},
  {'code': '+81', 'flag': '🇯🇵', 'name': 'Japan'},
];

// ─── Country Code Data for Employee ──────────────────────────────────────────

class _ECountry {
  final String name;
  final String code;
  final String flag;
  const _ECountry(this.name, this.code, this.flag);
}

const List<_ECountry> _eAllCountries = [
  _ECountry('India', '+91', '🇮🇳'),
  _ECountry('United States', '+1', '🇺🇸'),
  _ECountry('United Kingdom', '+44', '🇬🇧'),
  _ECountry('United Arab Emirates', '+971', '🇦🇪'),
  _ECountry('Singapore', '+65', '🇸🇬'),
  _ECountry('Malaysia', '+60', '🇲🇾'),
  _ECountry('Australia', '+61', '🇦🇺'),
  _ECountry('Germany', '+49', '🇩🇪'),
  _ECountry('France', '+33', '🇫🇷'),
  _ECountry('Japan', '+81', '🇯🇵'),
  _ECountry('Canada', '+1', '🇨🇦'),
  _ECountry('Saudi Arabia', '+966', '🇸🇦'),
  _ECountry('Qatar', '+974', '🇶🇦'),
];

class _ECountryCodePicker extends StatefulWidget {
  final _ECountry selected;
  final ValueChanged<_ECountry> onChanged;
  const _ECountryCodePicker({required this.selected, required this.onChanged});

  @override
  State<_ECountryCodePicker> createState() => _ECountryCodePickerState();
}

class _ECountryCodePickerState extends State<_ECountryCodePicker> {
  void _openPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _ECountryPickerSheet(
          selected: widget.selected,
          onSelect: (c) {
            widget.onChanged(c);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPicker,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surface200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.selected.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              widget.selected.code,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ECountryPickerSheet extends StatefulWidget {
  final _ECountry selected;
  final ValueChanged<_ECountry> onSelect;
  const _ECountryPickerSheet({required this.selected, required this.onSelect});

  @override
  State<_ECountryPickerSheet> createState() => _ECountryPickerSheetState();
}

class _ECountryPickerSheetState extends State<_ECountryPickerSheet> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  List<_ECountry> get _filtered {
    if (_query.isEmpty) return _eAllCountries;
    final q = _query.toLowerCase();
    return _eAllCountries
        .where((c) => c.name.toLowerCase().contains(q) || c.code.contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
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
              'Select Country Code',
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
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search country...',
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
                final c = _filtered[i];
                final isSelected =
                    c.code == widget.selected.code &&
                    c.name == widget.selected.name;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(
                    c.name,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                  ),
                  trailing: Text(
                    c.code,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppTheme.primaryContainer.withAlpha(60),
                  onTap: () => widget.onSelect(c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> globalEmployeeMaps = [
  {
    'id': 'emp-001',
    'name': 'Priya Sharma',
    'initials': 'PS',
    'role': 'Senior Sales Agent',
    'department': 'Sales',
    'employeeId': 'EMP-1001',
    'email': 'priya.sharma@anbucrm.com',
    'personalEmail': 'priya.sharma@gmail.com',
    'personalPhone': '+91 98765 99999',
    'phone': '+91 98765 11111',
    'companyPhone': '+91 98765 11111',
    'companyEmail': 'priya.sharma@anbucrm.com',
    'alternatePhone': '+91 98765 22222',
    'reportingManager': 'Anbu Raj (CEO)',
    'team': 'Enterprise Team',
    'territory': 'South India',
    'status': 'Active',
    'accessLevel': 'Employee',
    'joinDate': DateTime(2021, 3, 15),
    'profilePhoto':
        'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
    'leadsAssigned': 42,
    'leadsConverted': 18,
    'leadsFollowUp': 12,
    'sessionsCompleted': 67,
    'followUpsDone': 89,
    'callsDone': 156,
    'targetAmount': 5000000.0,
    'achievedAmount': 4250000.0,
    'commission': 127500.0,
    'commissionRate': '3%',
    'conversionRate': 42.8,
    'avgDealValue': 236111.0,
    'lastActivity': DateTime.now().subtract(const Duration(minutes: 30)),
    'incomingCalls': 89,
    'outgoingCalls': 67,
    'incomingAttended': 82,
    'outgoingAttended': 61,
    'missedCalls': 13,
    'avgCallDuration': 4.5,
    'phoneModel': 'iPhone 14 Pro',
    'imeiNumber': '352099001761481',
    'passwordHash': '••••••••',
    'appActivityDays': [
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'minutes': 245,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'minutes': 312,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'minutes': 198,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'minutes': 420,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'minutes': 356,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'minutes': 289,
      },
      {'date': DateTime.now(), 'minutes': 142},
    ],
    'activityLog': [
      {
        'action': 'Closed deal — Rahul Mehta',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'type': 'deal',
      },
      {
        'action': 'Session completed — Vikram Singh',
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'type': 'session',
      },
      {
        'action': 'Follow-up sent — Sneha Kapoor',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'followup',
      },
      {
        'action': 'New lead added — Arjun Mehta',
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        'type': 'lead',
      },
      {
        'action': 'Call logged — Mohammed Al-Rashid',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'type': 'call',
      },
    ],
    'skills': [
      'Life Insurance',
      'Health Cover',
      'Corporate Plans',
      'Negotiation',
    ],
    'certifications': ['IRDA Licensed', 'AMFI Certified', 'CFP'],
    'languages': ['English', 'Hindi', 'Tamil'],
    'location': 'Bangalore',
    'workMode': 'Hybrid',
    'gender': 'Female',
    'dob': '12/05/1990',
    'emergencyContact': 'Raj Sharma — +91 98765 33333',
    'bankAccount': 'HDFC Bank — ****4521',
    'pfNumber': 'KA/BAN/12345/001',
    'panNumber': 'ABCPS1234D',
    'isArchived': false,
  },
  {
    'id': 'emp-002',
    'name': 'Rahul Singh',
    'initials': 'RS',
    'role': 'Sales Agent',
    'department': 'Sales',
    'employeeId': 'EMP-1002',
    'email': 'rahul.singh@anbucrm.com',
    'personalEmail': 'rahul.singh@yahoo.com',
    'personalPhone': '+91 87654 88888',
    'phone': '+91 87654 22222',
    'companyPhone': '+91 87654 22222',
    'companyEmail': 'rahul.singh@anbucrm.com',
    'alternatePhone': '',
    'reportingManager': 'Priya Sharma (Senior Agent)',
    'team': 'SME Team',
    'territory': 'West India',
    'status': 'Active',
    'accessLevel': 'Employee',
    'joinDate': DateTime(2022, 7, 1),
    'profilePhoto':
        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg',
    'leadsAssigned': 28,
    'leadsConverted': 9,
    'leadsFollowUp': 8,
    'sessionsCompleted': 41,
    'followUpsDone': 55,
    'callsDone': 98,
    'targetAmount': 3000000.0,
    'achievedAmount': 1800000.0,
    'commission': 54000.0,
    'commissionRate': '3%',
    'conversionRate': 32.1,
    'avgDealValue': 200000.0,
    'lastActivity': DateTime.now().subtract(const Duration(hours: 1)),
    'incomingCalls': 54,
    'outgoingCalls': 44,
    'incomingAttended': 48,
    'outgoingAttended': 39,
    'missedCalls': 11,
    'avgCallDuration': 3.2,
    'phoneModel': 'Samsung Galaxy S23',
    'imeiNumber': '490154203237518',
    'passwordHash': '••••••••',
    'appActivityDays': [
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'minutes': 180,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'minutes': 220,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'minutes': 165,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'minutes': 290,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'minutes': 245,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'minutes': 198,
      },
      {'date': DateTime.now(), 'minutes': 87},
    ],
    'activityLog': [
      {
        'action': 'Call logged — Sneha Kapoor',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
        'type': 'call',
      },
      {
        'action': 'Follow-up scheduled — Deepa Nair',
        'time': DateTime.now().subtract(const Duration(hours: 3)),
        'type': 'followup',
      },
      {
        'action': 'Lead updated — Contacted',
        'time': DateTime.now().subtract(const Duration(hours: 6)),
        'type': 'lead',
      },
    ],
    'skills': ['Health Cover', 'Motor Insurance', 'Cold Calling'],
    'certifications': ['IRDA Licensed'],
    'languages': ['English', 'Hindi', 'Marathi'],
    'location': 'Mumbai',
    'workMode': 'On-site',
    'gender': 'Male',
    'dob': '25/08/1994',
    'emergencyContact': 'Sunita Singh — +91 87654 33333',
    'bankAccount': 'SBI — ****7823',
    'pfNumber': 'MH/MUM/23456/002',
    'panNumber': 'ABCRS5678E',
    'isArchived': false,
  },
  {
    'id': 'emp-003',
    'name': 'Ananya Patel',
    'initials': 'AP',
    'role': 'Sales Agent',
    'department': 'Sales',
    'employeeId': 'EMP-1003',
    'email': 'ananya.patel@anbucrm.com',
    'personalEmail': 'ananya.patel@gmail.com',
    'personalPhone': '+91 76543 77777',
    'phone': '+91 76543 33333',
    'companyPhone': '+91 76543 33333',
    'companyEmail': 'ananya.patel@anbucrm.com',
    'alternatePhone': '+91 76543 44444',
    'reportingManager': 'Priya Sharma (Senior Agent)',
    'team': 'Retail Team',
    'territory': 'North India',
    'status': 'Active',
    'accessLevel': 'Employee',
    'joinDate': DateTime(2022, 1, 10),
    'profilePhoto':
        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
    'leadsAssigned': 35,
    'leadsConverted': 14,
    'leadsFollowUp': 9,
    'sessionsCompleted': 52,
    'followUpsDone': 71,
    'callsDone': 124,
    'targetAmount': 3500000.0,
    'achievedAmount': 2800000.0,
    'commission': 84000.0,
    'commissionRate': '3%',
    'conversionRate': 40.0,
    'avgDealValue': 200000.0,
    'lastActivity': DateTime.now().subtract(const Duration(hours: 2)),
    'incomingCalls': 68,
    'outgoingCalls': 56,
    'incomingAttended': 63,
    'outgoingAttended': 51,
    'missedCalls': 10,
    'avgCallDuration': 5.1,
    'phoneModel': 'OnePlus 11',
    'imeiNumber': '358043085829104',
    'passwordHash': '••••••••',
    'appActivityDays': [
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'minutes': 210,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'minutes': 275,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'minutes': 190,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'minutes': 340,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'minutes': 298,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'minutes': 225,
      },
      {'date': DateTime.now(), 'minutes': 110},
    ],
    'activityLog': [
      {
        'action': 'Deal closed — Anita Desai',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'type': 'deal',
      },
      {
        'action': 'Session scheduled — New lead',
        'time': DateTime.now().subtract(const Duration(hours: 4)),
        'type': 'session',
      },
    ],
    'skills': [
      'Mutual Funds',
      'SIP',
      'Retail Insurance',
      'Relationship Building',
    ],
    'certifications': ['IRDA Licensed', 'AMFI Certified'],
    'languages': ['English', 'Hindi', 'Gujarati'],
    'location': 'Delhi',
    'workMode': 'Hybrid',
    'gender': 'Female',
    'dob': '03/11/1993',
    'emergencyContact': 'Ravi Patel — +91 76543 55555',
    'bankAccount': 'ICICI Bank — ****3456',
    'pfNumber': 'DL/DEL/34567/003',
    'panNumber': 'ABCAP9012F',
    'isArchived': false,
  },
  {
    'id': 'emp-004',
    'name': 'Kavya Menon',
    'initials': 'KM',
    'role': 'Junior Sales Agent',
    'department': 'Sales',
    'employeeId': 'CONT-1001',
    'email': 'kavya.menon@anbucrm.com',
    'personalEmail': 'kavya.menon@gmail.com',
    'personalPhone': '+91 65432 66666',
    'phone': '+91 65432 44444',
    'companyPhone': '+91 65432 44444',
    'companyEmail': 'kavya.menon@anbucrm.com',
    'alternatePhone': '',
    'reportingManager': 'Priya Sharma (Senior Agent)',
    'team': 'SME Team',
    'territory': 'South India',
    'status': 'Active',
    'accessLevel': 'Contact',
    'joinDate': DateTime(2023, 4, 20),
    'profilePhoto':
        'https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg',
    'leadsAssigned': 18,
    'leadsConverted': 5,
    'leadsFollowUp': 4,
    'sessionsCompleted': 22,
    'followUpsDone': 31,
    'callsDone': 67,
    'targetAmount': 2000000.0,
    'achievedAmount': 950000.0,
    'commission': 28500.0,
    'commissionRate': '3%',
    'conversionRate': 27.7,
    'avgDealValue': 190000.0,
    'lastActivity': DateTime.now().subtract(const Duration(hours: 3)),
    'incomingCalls': 38,
    'outgoingCalls': 29,
    'incomingAttended': 34,
    'outgoingAttended': 25,
    'missedCalls': 8,
    'avgCallDuration': 2.8,
    'phoneModel': 'Realme GT 5',
    'imeiNumber': '867686021710800',
    'passwordHash': '••••••••',
    'appActivityDays': [
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'minutes': 145,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'minutes': 178,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'minutes': 132,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'minutes': 210,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'minutes': 189,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'minutes': 156,
      },
      {'date': DateTime.now(), 'minutes': 72},
    ],
    'activityLog': [
      {
        'action': 'Session completed — Karan Joshi',
        'time': DateTime.now().subtract(const Duration(hours: 3)),
        'type': 'session',
      },
      {
        'action': 'Reminder set — SIP review',
        'time': DateTime.now().subtract(const Duration(hours: 6)),
        'type': 'reminder',
      },
    ],
    'skills': ['SIP', 'Education Plans', 'Customer Service'],
    'certifications': ['IRDA Licensed (In Progress)'],
    'languages': ['English', 'Malayalam', 'Tamil'],
    'location': 'Kochi',
    'workMode': 'Remote',
    'gender': 'Female',
    'dob': '18/02/1998',
    'emergencyContact': 'Suresh Menon — +91 65432 55555',
    'bankAccount': 'Federal Bank — ****8901',
    'pfNumber': 'KL/KOC/45678/004',
    'panNumber': 'ABCKM3456G',
    'isArchived': false,
  },
  {
    'id': 'emp-005',
    'name': 'Arjun Nair',
    'initials': 'AN',
    'role': 'Team Lead',
    'department': 'Sales',
    'employeeId': 'ADM-1001',
    'email': 'arjun.nair@anbucrm.com',
    'personalEmail': 'arjun.nair@outlook.com',
    'personalPhone': '+91 54321 66666',
    'phone': '+91 54321 55555',
    'companyPhone': '+91 54321 55555',
    'companyEmail': 'arjun.nair@anbucrm.com',
    'alternatePhone': '+91 54321 66666',
    'reportingManager': 'Anbu Raj (CEO)',
    'team': 'Enterprise Team',
    'territory': 'Pan India',
    'status': 'Active',
    'accessLevel': 'Admin',
    'joinDate': DateTime(2020, 6, 1),
    'profilePhoto':
        'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg',
    'leadsAssigned': 55,
    'leadsConverted': 28,
    'leadsFollowUp': 15,
    'sessionsCompleted': 92,
    'followUpsDone': 120,
    'callsDone': 210,
    'targetAmount': 8000000.0,
    'achievedAmount': 7200000.0,
    'commission': 216000.0,
    'commissionRate': '3%',
    'conversionRate': 50.9,
    'avgDealValue': 257142.0,
    'lastActivity': DateTime.now().subtract(const Duration(minutes: 10)),
    'incomingCalls': 118,
    'outgoingCalls': 92,
    'incomingAttended': 112,
    'outgoingAttended': 87,
    'missedCalls': 11,
    'avgCallDuration': 6.3,
    'phoneModel': 'iPhone 15',
    'imeiNumber': '013254006578901',
    'passwordHash': '••••••••',
    'appActivityDays': [
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'minutes': 320,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'minutes': 385,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'minutes': 298,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'minutes': 445,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'minutes': 412,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'minutes': 356,
      },
      {'date': DateTime.now(), 'minutes': 178},
    ],
    'activityLog': [
      {
        'action': 'Team review completed',
        'time': DateTime.now().subtract(const Duration(minutes: 10)),
        'type': 'session',
      },
      {
        'action': 'Deal closed — Mohammed Al-Rashid',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
        'type': 'deal',
      },
      {
        'action': 'Pipeline review — team',
        'time': DateTime.now().subtract(const Duration(hours: 4)),
        'type': 'session',
      },
      {
        'action': 'New employee onboarded',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'lead',
      },
      {
        'action': 'Monthly report submitted',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'type': 'reminder',
      },
    ],
    'skills': [
      'Corporate Insurance',
      'Key Man Insurance',
      'Team Management',
      'Strategic Sales',
    ],
    'certifications': ['IRDA Licensed', 'AMFI Certified', 'CFP', 'PMP'],
    'languages': ['English', 'Hindi', 'Malayalam'],
    'location': 'Bangalore',
    'workMode': 'Hybrid',
    'gender': 'Male',
    'dob': '07/09/1988',
    'emergencyContact': 'Meera Nair — +91 54321 77777',
    'bankAccount': 'Axis Bank — ****2345',
    'pfNumber': 'KA/BAN/56789/005',
    'panNumber': 'ABCAN7890H',
    'isArchived': false,
  },
  {
    'id': 'emp-006',
    'name': 'Deepa Krishnan',
    'initials': 'DK',
    'role': 'CRM Administrator',
    'department': 'Operations',
    'employeeId': 'ADM-1002',
    'email': 'deepa.krishnan@anbucrm.com',
    'personalEmail': 'deepa.krishnan@gmail.com',
    'personalPhone': '+91 43210 77777',
    'phone': '+91 43210 66666',
    'companyPhone': '+91 43210 66666',
    'companyEmail': 'deepa.krishnan@anbucrm.com',
    'alternatePhone': '',
    'reportingManager': 'Anbu Raj (CEO)',
    'team': 'Operations',
    'territory': 'All',
    'status': 'Active',
    'accessLevel': 'Admin',
    'joinDate': DateTime(2021, 9, 1),
    'profilePhoto':
        'https://images.pexels.com/photos/1181424/pexels-photo-1181424.jpeg',
    'leadsAssigned': 0,
    'leadsConverted': 0,
    'leadsFollowUp': 0,
    'sessionsCompleted': 12,
    'followUpsDone': 45,
    'callsDone': 34,
    'targetAmount': 0.0,
    'achievedAmount': 0.0,
    'commission': 0.0,
    'commissionRate': 'N/A',
    'conversionRate': 0.0,
    'avgDealValue': 0.0,
    'lastActivity': DateTime.now().subtract(const Duration(hours: 1)),
    'incomingCalls': 20,
    'outgoingCalls': 14,
    'incomingAttended': 19,
    'outgoingAttended': 13,
    'missedCalls': 2,
    'avgCallDuration': 3.8,
    'phoneModel': 'Google Pixel 8',
    'imeiNumber': '354678091234567',
    'passwordHash': '••••••••',
    'appActivityDays': [
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'minutes': 390,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'minutes': 420,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'minutes': 365,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'minutes': 480,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'minutes': 445,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'minutes': 398,
      },
      {'date': DateTime.now(), 'minutes': 210},
    ],
    'activityLog': [
      {
        'action': 'System configuration updated',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
        'type': 'reminder',
      },
      {
        'action': 'User access review completed',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'session',
      },
    ],
    'skills': ['CRM Management', 'Data Analysis', 'Process Optimization'],
    'certifications': ['Salesforce Admin', 'Google Analytics'],
    'languages': ['English', 'Tamil', 'Kannada'],
    'location': 'Bangalore',
    'workMode': 'On-site',
    'gender': 'Female',
    'dob': '22/04/1992',
    'emergencyContact': 'Ravi Krishnan — +91 43210 77777',
    'bankAccount': 'Kotak Bank — ****6789',
    'pfNumber': 'KA/BAN/67890/006',
    'panNumber': 'ABCDK2345I',
    'isArchived': false,
  },
  {
    'id': 'emp-007',
    'name': 'Suresh Pillai',
    'initials': 'SP',
    'role': 'Sales Agent',
    'department': 'Sales',
    'employeeId': 'EMP-1004',
    'email': 'suresh.pillai@anbucrm.com',
    'personalEmail': 'suresh.pillai@gmail.com',
    'personalPhone': '+91 32109 88888',
    'phone': '+91 32109 77777',
    'companyPhone': '+91 32109 77777',
    'companyEmail': 'suresh.pillai@anbucrm.com',
    'alternatePhone': '',
    'reportingManager': 'Arjun Nair (Team Lead)',
    'team': 'Enterprise Team',
    'territory': 'East India',
    'status': 'Inactive',
    'accessLevel': 'Employee',
    'joinDate': DateTime(2022, 11, 15),
    'profilePhoto':
        'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg',
    'leadsAssigned': 22,
    'leadsConverted': 7,
    'leadsFollowUp': 5,
    'sessionsCompleted': 30,
    'followUpsDone': 42,
    'callsDone': 78,
    'targetAmount': 2500000.0,
    'achievedAmount': 1400000.0,
    'commission': 42000.0,
    'commissionRate': '3%',
    'conversionRate': 31.8,
    'avgDealValue': 200000.0,
    'lastActivity': DateTime.now().subtract(const Duration(days: 3)),
    'incomingCalls': 42,
    'outgoingCalls': 36,
    'incomingAttended': 38,
    'outgoingAttended': 32,
    'missedCalls': 8,
    'avgCallDuration': 3.5,
    'phoneModel': 'Xiaomi 13 Pro',
    'imeiNumber': '869765032145678',
    'passwordHash': '••••••••',
    'appActivityDays': [
      {'date': DateTime.now().subtract(const Duration(days: 6)), 'minutes': 0},
      {'date': DateTime.now().subtract(const Duration(days: 5)), 'minutes': 0},
      {'date': DateTime.now().subtract(const Duration(days: 4)), 'minutes': 0},
      {'date': DateTime.now().subtract(const Duration(days: 3)), 'minutes': 45},
      {'date': DateTime.now().subtract(const Duration(days: 2)), 'minutes': 0},
      {'date': DateTime.now().subtract(const Duration(days: 1)), 'minutes': 0},
      {'date': DateTime.now(), 'minutes': 0},
    ],
    'activityLog': [
      {
        'action': 'Account deactivated',
        'time': DateTime.now().subtract(const Duration(days: 3)),
        'type': 'reminder',
      },
    ],
    'skills': ['Life Insurance', 'Term Plans', 'Bengali Market'],
    'certifications': ['IRDA Licensed'],
    'languages': ['English', 'Hindi', 'Bengali'],
    'location': 'Kolkata',
    'workMode': 'On-site',
    'gender': 'Male',
    'dob': '14/06/1991',
    'emergencyContact': 'Latha Pillai — +91 32109 88888',
    'bankAccount': 'UCO Bank — ****1234',
    'pfNumber': 'WB/KOL/78901/007',
    'panNumber': 'ABCSP6789J',
    'isArchived': true,
  },
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

enum _EmployeeSortOption {
  nameAZ,
  nameZA,
  conversionHigh,
  leadsAssignedHigh,
  achievementHigh,
  joinDateNewest,
}

class _EmployeesScreenState extends State<EmployeesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'Active';
  bool _isSearchActive = false;
  _EmployeeSortOption _sortOption = _EmployeeSortOption.conversionHigh;
  List<String> _selectedDepts = [];
  List<String> _selectedAccessLevels = [];
  List<String> _selectedHosts = [];
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _employees = [];

  // Removed 'Archive' from status filters — inactive goes to Inactive filter
  final _statusFilters = ['Active', 'Inactive', 'All'];
  final _deptOptions = ['Sales', 'Operations', 'Marketing', 'Support'];
  // 5 access levels now
  final _accessLevelOptions = [
    'Admin',
    'Manager',
    'Senior Rep',
    'Employee',
    'Contact',
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadEmployees();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _employees = List.from(globalEmployeeMaps);
        _isLoading = false;
      });
    }
  }

  bool get _hasActiveFilters =>
      _selectedDepts.isNotEmpty ||
      _selectedAccessLevels.isNotEmpty ||
      _selectedHosts.isNotEmpty ||
      _dateFrom != null ||
      _dateTo != null;

  List<Map<String, dynamic>> get _filteredEmployees {
    List<Map<String, dynamic>> result = _employees.where((e) {
      final isArchived = e['isArchived'] as bool? ?? false;
      final status = e['status'] as String? ?? '';
      if (_selectedFilter == 'Archive') {
        if (!isArchived) return false;
      } else if (_selectedFilter == 'All') {
        if (isArchived) return false;
      } else if (_selectedFilter == 'Active') {
        if (isArchived || status != 'Active') return false;
      } else if (_selectedFilter == 'Inactive') {
        if (isArchived || status != 'Inactive') return false;
      }
      final matchesSearch =
          _searchQuery.isEmpty ||
          (e['name'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (e['role'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (e['employeeId'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          (e['department'] as String).toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesDept =
          _selectedDepts.isEmpty || _selectedDepts.contains(e['department']);
      final matchesAccess =
          _selectedAccessLevels.isEmpty ||
          _selectedAccessLevels.contains(e['accessLevel']);
      final matchesHost =
          _selectedHosts.isEmpty || _selectedHosts.contains(e['name']);
      bool matchesDate = true;
      if (_dateFrom != null) {
        final joined = e['joinDate'] as DateTime;
        if (joined.isBefore(_dateFrom!)) matchesDate = false;
      }
      if (_dateTo != null) {
        final joined = e['joinDate'] as DateTime;
        if (joined.isAfter(_dateTo!.add(const Duration(days: 1)))) {
          matchesDate = false;
        }
      }
      return matchesSearch &&
          matchesDept &&
          matchesAccess &&
          matchesHost &&
          matchesDate;
    }).toList();

    switch (_sortOption) {
      case _EmployeeSortOption.nameAZ:
        result.sort(
          (a, b) => (a['name'] as String).compareTo(b['name'] as String),
        );
        break;
      case _EmployeeSortOption.nameZA:
        result.sort(
          (a, b) => (b['name'] as String).compareTo(a['name'] as String),
        );
        break;
      case _EmployeeSortOption.conversionHigh:
        result.sort(
          (a, b) => (b['conversionRate'] as double).compareTo(
            a['conversionRate'] as double,
          ),
        );
        break;
      case _EmployeeSortOption.leadsAssignedHigh:
        result.sort(
          (a, b) =>
              (b['leadsAssigned'] as int).compareTo(a['leadsAssigned'] as int),
        );
        break;
      case _EmployeeSortOption.achievementHigh:
        result.sort(
          (a, b) => (b['achievedAmount'] as double).compareTo(
            a['achievedAmount'] as double,
          ),
        );
        break;
      case _EmployeeSortOption.joinDateNewest:
        result.sort(
          (a, b) =>
              (b['joinDate'] as DateTime).compareTo(a['joinDate'] as DateTime),
        );
        break;
    }
    return result;
  }

  int get _totalCount =>
      _employees.where((e) => !(e['isArchived'] as bool? ?? false)).length;
  int get _activeCount => _employees
      .where(
        (e) => e['status'] == 'Active' && !(e['isArchived'] as bool? ?? false),
      )
      .length;
  int get _inactiveCount => _employees
      .where(
        (e) =>
            e['status'] == 'Inactive' && !(e['isArchived'] as bool? ?? false),
      )
      .length;
  int get _archivedCount =>
      _employees.where((e) => e['isArchived'] as bool? ?? false).length;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _EmpFilterSheet(
          selectedDepts: List.from(_selectedDepts),
          selectedAccessLevels: List.from(_selectedAccessLevels),
          selectedHosts: List.from(_selectedHosts),
          deptOptions: _deptOptions,
          accessLevelOptions: _accessLevelOptions,
          allEmployees: _employees
              .where((e) => !(e['isArchived'] as bool? ?? false))
              .toList(),
          dateFrom: _dateFrom,
          dateTo: _dateTo,
          onApply: (depts, accessLevels, hosts, from, to) => setState(() {
            _selectedDepts = depts;
            _selectedAccessLevels = accessLevels;
            _selectedHosts = hosts;
            _dateFrom = from;
            _dateTo = to;
          }),
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _EmpSortSheet(
          current: _sortOption,
          onSelect: (o) => setState(() => _sortOption = o),
        ),
      ),
    );
  }

  void _showAddEmployeeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8),
        child: _AddEmployeeSheet(
          existingEmployees: _employees,
          onSave: (empData) {
            globalEmployeeMaps.insert(0, empData);
            setState(() => _employees = List.from(globalEmployeeMaps));
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
                    Text('Employee ${empData['employeeId']} account created!'),
                  ],
                ),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEmployees;
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
                  context.go(AppRoutes.dashboardScreen);
                }
              },
            ),
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withAlpha(31),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.badge_rounded,
                    color: Color(0xFF059669),
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
                          'Employees',
                          maxLines: 1,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${filtered.length} of $_totalCount employees',
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
              _EHeaderBtn(
                icon: Icons.filter_list_rounded,
                hasActive: _hasActiveFilters,
                onTap: _showFilterSheet,
              ),
              const SizedBox(width: 6),
              _EHeaderBtn(
                icon: Icons.sort_rounded,
                hasActive: false,
                onTap: _showSortSheet,
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (_isSearchActive) _buildSearchBar(),
                _buildKpiRow(),
                _buildStatusFilterBar(),
                if (_hasActiveFilters) _buildActiveFilterChips(),
              ],
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filtered.isEmpty)
            SliverFillRemaining(
              child: _buildEmpty(),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, navBarHeight + 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _EmployeeCard(
                    employee: filtered[i],
                    index: i,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EmployeeDetailPage(employee: filtered[i]),
                        ),
                      ).then(
                        (_) => setState(
                          () =>
                              _employees = List.from(globalEmployeeMaps),
                        ),
                      );
                    },
                    onToggleStatus: (emp) {
                      setState(() {
                        final idx = globalEmployeeMaps.indexWhere(
                          (e) => e['id'] == emp['id'],
                        );
                        if (idx >= 0) {
                          if (emp['status'] == 'Active') {
                            globalEmployeeMaps[idx]['status'] =
                                'Inactive';
                            globalEmployeeMaps[idx]['isArchived'] = false;
                          } else {
                            globalEmployeeMaps[idx]['status'] = 'Active';
                            globalEmployeeMaps[idx]['isArchived'] = false;
                          }
                        }
                        _employees = List.from(globalEmployeeMaps);
                      });
                    },
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEmployeeSheet,
        backgroundColor: const Color(0xFF059669),
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: Text(
          'Add Employee',
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
          hintText: 'Search employees, roles, ID...',
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

  // KPI row — horizontal scroll matching follow-ups reference image 1
  Widget _buildKpiRow() {
    final kpis = [
      _EKpiData(
        'Total',
        '$_totalCount',
        Icons.badge_rounded,
        const Color(0xFF059669),
        '+${_totalCount > 0 ? (_totalCount * 0.1).round() : 0}',
        true,
      ),
      _EKpiData(
        'Active',
        '$_activeCount',
        Icons.check_circle_rounded,
        AppTheme.primary,
        '${_totalCount > 0 ? ((_activeCount / _totalCount) * 100).round() : 0}%',
        true,
      ),
      _EKpiData(
        'Inactive',
        '$_inactiveCount',
        Icons.pause_circle_rounded,
        AppTheme.warning,
        '-$_inactiveCount',
        false,
      ),
      _EKpiData(
        'Archive',
        '$_archivedCount',
        Icons.archive_rounded,
        AppTheme.textMuted,
        '-$_archivedCount',
        false,
      ),
    ];
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _EKpiCard(data: kpis[i]),
      ),
    );
  }

  Widget _buildStatusFilterBar() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statusFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _statusFilters[i];
          final selected = _selectedFilter == f;
          return Center(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF059669)
                      : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF059669)
                        : AppTheme.surface200,
                  ),
                ),
                child: Text(
                  f,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _clearAllFilters() => setState(() {
    _selectedDepts = [];
    _selectedAccessLevels = [];
    _selectedHosts = [];
    _dateFrom = null;
    _dateTo = null;
  });

  Widget _buildActiveFilterChips() {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          ..._selectedDepts.map(
            (d) => _ActiveFilterChip(
              label: 'Dept: $d',
              onRemove: () => setState(() => _selectedDepts.remove(d)),
            ),
          ),
          ..._selectedAccessLevels.map(
            (r) => _ActiveFilterChip(
              label: 'Access: $r',
              onRemove: () => setState(() => _selectedAccessLevels.remove(r)),
            ),
          ),
          ..._selectedHosts.map(
            (h) => _ActiveFilterChip(
              label: 'Host: $h',
              onRemove: () => setState(() => _selectedHosts.remove(h)),
            ),
          ),
          if (_dateFrom != null)
            _ActiveFilterChip(
              label:
                  'From: ${_dateFrom!.day}/${_dateFrom!.month}/${_dateFrom!.year}',
              onRemove: () => setState(() => _dateFrom = null),
            ),
          if (_dateTo != null)
            _ActiveFilterChip(
              label: 'To: ${_dateTo!.day}/${_dateTo!.month}/${_dateTo!.year}',
              onRemove: () => setState(() => _dateTo = null),
            ),
          GestureDetector(
            onTap: _clearAllFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.error.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.clear_all_rounded,
                    size: 14,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.badge_rounded, size: 56, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          Text(
            'No employees found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

// ─── Employee Card — matches reference image 2 ────────────────────────────────

class _EmployeeCard extends StatefulWidget {
  final Map<String, dynamic> employee;
  final int index;
  final VoidCallback onTap;
  final void Function(Map<String, dynamic>) onToggleStatus;
  const _EmployeeCard({
    required this.employee,
    required this.index,
    required this.onTap,
    required this.onToggleStatus,
  });

  @override
  State<_EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<_EmployeeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(
      Duration(milliseconds: (widget.index * 50).clamp(0, 350)),
      () {
        if (mounted) _ctrl.forward();
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _accessColor(String a) {
    switch (a) {
      case 'Admin':
        return const Color(0xFFEF4444);
      case 'Contact':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.employee;
    final isActive = e['status'] == 'Active';
    final accessColor = _accessColor(e['accessLevel'] as String);
    final isArchived = e['isArchived'] as bool? ?? false;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isArchived ? AppTheme.surface100 : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surface200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: avatar + info + Active badge + toggle + arrow
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(
                          e['profilePhoto'] as String,
                        ),
                        backgroundColor: AppTheme.primaryContainer,
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e['name'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              e['role'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            if ((e['personalPhone'] as String? ?? '')
                                .isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_rounded,
                                    size: 10,
                                    color: Color(0xFF8B5CF6),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    e['personalPhone'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: const Color(0xFF8B5CF6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if ((e['companyPhone'] as String? ?? '')
                                .isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.sim_card_rounded,
                                    size: 10,
                                    color: Color(0xFF0891B2),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    e['companyPhone'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: const Color(0xFF0891B2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF0891B2,
                                      ).withAlpha(20),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'SIM',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0891B2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  e['employeeId'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accessColor.withAlpha(20),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    e['accessLevel'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: accessColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Active badge + toggle + arrow column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isActive ? 'Active' : 'Inactive',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? const Color(0xFF16A34A)
                                    : AppTheme.error,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.scale(
                                scale: 0.72,
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: Text(
                                          isActive
                                              ? 'Deactivate Employee?'
                                              : 'Activate Employee?',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        content: Text(
                                          isActive
                                              ? 'This will deactivate ${e['name']} and move them to Archive.'
                                              : 'This will reactivate ${e['name']} and remove from Archive.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              'Cancel',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color:
                                                        AppTheme.textSecondary,
                                                  ),
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.onToggleStatus(e);
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor: isActive
                                                  ? AppTheme.error
                                                  : AppTheme.success,
                                            ),
                                            child: Text(
                                              isActive
                                                  ? 'Deactivate'
                                                  : 'Activate',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Switch(
                                    value: isActive,
                                    onChanged: (_) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          title: Text(
                                            isActive
                                                ? 'Deactivate Employee?'
                                                : 'Activate Employee?',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                          content: Text(
                                            isActive
                                                ? 'This will deactivate ${e['name']} and move them to Archive.'
                                                : 'This will reactivate ${e['name']} and remove from Archive.',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'Cancel',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: AppTheme
                                                          .textSecondary,
                                                    ),
                                              ),
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                widget.onToggleStatus(e);
                                              },
                                              style: FilledButton.styleFrom(
                                                backgroundColor: isActive
                                                    ? AppTheme.error
                                                    : AppTheme.success,
                                              ),
                                              child: Text(
                                                isActive
                                                    ? 'Deactivate'
                                                    : 'Activate',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    activeThumbColor: const Color(0xFF059669),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ), // Transform.scale
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppTheme.textMuted,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Stats row — all same size, 5 boxes
                  Row(
                    children: [
                      _EMetricBox(
                        label: 'Leads',
                        value: '${e['leadsAssigned']}',
                        sub: '${e['leadsConverted']} conv.',
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 5),
                      _EMetricBox(
                        label: 'Sessions',
                        value: '${e['sessionsCompleted']}',
                        sub: 'done',
                        color: const Color(0xFF8B5CF6),
                      ),
                      const SizedBox(width: 5),
                      _EMetricBox(
                        label: 'Follow-ups',
                        value: '${e['followUpsDone']}',
                        sub: 'done',
                        color: AppTheme.warning,
                      ),
                      const SizedBox(width: 5),
                      _EMetricBox(
                        label: 'Calls Done',
                        value: '${e['callsDone']}',
                        sub: '(Attended)',
                        color: AppTheme.success,
                      ),
                      const SizedBox(width: 5),
                      _EMetricBox(
                        label: 'Conv. Rate',
                        value:
                            '${(e['conversionRate'] as double).toStringAsFixed(1)}%',
                        sub: '',
                        color: const Color(0xFF0891B2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _EInfoChip(
                        icon: Icons.location_on_rounded,
                        label: e['location'] as String,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      _EInfoChip(
                        icon: Icons.work_outline_rounded,
                        label: e['workMode'] as String,
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Employee Detail Page ─────────────────────────────────────────────────────

class EmployeeDetailPage extends StatefulWidget {
  final Map<String, dynamic> employee;
  const EmployeeDetailPage({super.key, required this.employee});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final bool _showPassword = false;
  final bool _showImei = false;
  late Map<String, dynamic> e;

  @override
  void initState() {
    super.initState();
    e = widget.employee;
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Active':
        return AppTheme.success;
      case 'Inactive':
        return AppTheme.error;
      default:
        return AppTheme.textMuted;
    }
  }

  Color _accessColor(String a) {
    switch (a) {
      case 'Admin':
        return const Color(0xFFEF4444);
      case 'Contact':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:${dt.minute.toString().padLeft(2, '0')} $ampm';
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  String _formatMinutes(int m) {
    if (m == 0) return 'Inactive';
    if (m < 60) return '${m}m';
    return '${m ~/ 60}h ${m % 60}m';
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'deal':
        return Icons.handshake_rounded;
      case 'session':
        return Icons.event_note_rounded;
      case 'followup':
        return Icons.repeat_rounded;
      case 'lead':
        return Icons.person_add_rounded;
      case 'call':
        return Icons.phone_rounded;
      case 'reminder':
        return Icons.alarm_rounded;
      default:
        return Icons.circle_rounded;
    }
  }

  Color _activityColor(String type) {
    switch (type) {
      case 'deal':
        return AppTheme.success;
      case 'session':
        return const Color(0xFF8B5CF6);
      case 'followup':
        return AppTheme.warning;
      case 'lead':
        return AppTheme.primary;
      case 'call':
        return const Color(0xFF0891B2);
      case 'reminder':
        return AppTheme.error;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showChangePasswordDialog() {
    final emailCtrl = TextEditingController(text: e['email'] as String? ?? '');
    final otpCtrl = TextEditingController();
    int step = 0;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.lock_reset_rounded, color: AppTheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Change Password',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    2,
                    (i) => Expanded(
                      child: Container(
                        height: 3,
                        margin: EdgeInsets.only(
                          right: i == 0 ? 4 : 0,
                          left: i == 1 ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: step >= i
                              ? AppTheme.primary
                              : AppTheme.surface200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (step == 0) ...[
                  Text(
                    'Step 1: Verify via OTP',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter email to send OTP:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailCtrl,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Email address',
                      prefixIcon: const Icon(Icons.email_rounded, size: 16),
                      filled: true,
                      fillColor: AppTheme.surface100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Step 2: Enter OTP',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.success,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'OTP sent to ${emailCtrl.text}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: otpCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Enter 6-digit OTP',
                      prefixIcon: const Icon(Icons.pin_rounded, size: 16),
                      filled: true,
                      fillColor: AppTheme.surface100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'After verifying OTP, you will be redirected to the password change link sent to your email.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                if (step == 0) {
                  setS(() => step = 1);
                } else {
                  if (otpCtrl.text.length >= 4) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'OTP verified! Password change link sent to your email.',
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: AppTheme.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invalid OTP. Please try again.'),
                        backgroundColor: AppTheme.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              child: Text(
                step == 0 ? 'Send OTP' : 'Verify OTP & Get Link',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(e['status'] as String);
    final accessColor = _accessColor(e['accessLevel'] as String);
    final activityLog = (e['activityLog'] as List).cast<Map<String, dynamic>>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppTheme.surfaceLight,
              padding: const EdgeInsets.fromLTRB(4, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 22),
                    color: AppTheme.textPrimary,
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(e['profilePhoto'] as String),
                    backgroundColor: AppTheme.primaryContainer,
                    onBackgroundImageError: (_, __) {},
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['name'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            _EStatusBadge(
                              label: e['status'] as String,
                              color: statusColor,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: accessColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                e['accessLevel'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: accessColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              e['employeeId'] as String,
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
                ],
              ),
            ),
            Container(
              color: AppTheme.surfaceLight,
              child: TabBar(
                controller: _tabCtrl,
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                labelColor: AppTheme.primary,
                unselectedLabelColor: AppTheme.textSecondary,
                indicatorColor: AppTheme.primary,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Call Details'),
                  Tab(text: 'Activity'),
                  Tab(text: 'Device & Security'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  // ── Tab 1: Overview ──
                  _buildOverviewTab(),
                  // ── Tab 2: Call Details ──
                  _buildCallDetailsTab(),
                  // ── Tab 3: Activity Timeline ──
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _DetailSectionHeader('Full Activity Timeline'),
                      const SizedBox(height: 12),
                      ...activityLog.asMap().entries.map((entry) {
                        final i = entry.key;
                        final log = entry.value;
                        final type = log['type'] as String? ?? 'lead';
                        final color = _activityColor(type);
                        final icon = _activityIcon(type);
                        final isLast = i == activityLog.length - 1;
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: color.withAlpha(25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, size: 16, color: color),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: AppTheme.surface200,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isLast ? 0 : 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        log['action'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatDateTime(
                                          log['time'] as DateTime,
                                        ),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _relativeTime(log['time'] as DateTime),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          color: color,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  // ── Tab 4: Device & Security ──
                  _buildDeviceSecurityTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surface200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: children),
    );
  }

  Widget _buildModernPerformanceSection(Map<String, dynamic> emp) {
    final followUpsDone = emp['followUpsDone'] as int? ?? 0;
    final sessionsCompleted = emp['sessionsCompleted'] as int? ?? 0;
    final leadsAssigned = emp['leadsAssigned'] as int? ?? 0;
    final leadsConverted = emp['leadsConverted'] as int? ?? 0;
    final callsDone = emp['callsDone'] as int? ?? 0;
    final convRate = (emp['conversionRate'] as double? ?? 0.0);

    // Single consistent purple color for all numbers
    const numColor = Color(0xFF8B5CF6);

    final sections = [
      {
        'title': 'Follow-ups',
        'icon': Icons.repeat_rounded,
        'color': const Color(0xFF8B5CF6),
        'stats': [
          {'label': 'Total Done', 'value': '$followUpsDone'},
          {'label': 'On Time', 'value': '${(followUpsDone * 0.72).round()}'},
          {'label': 'Overdue', 'value': '${(followUpsDone * 0.18).round()}'},
          {'label': 'Rate', 'value': '72%'},
        ],
      },
      {
        'title': 'Sessions',
        'icon': Icons.video_call_rounded,
        'color': const Color(0xFF8B5CF6),
        'stats': [
          {'label': 'Total', 'value': '$sessionsCompleted'},
          {
            'label': 'Completed',
            'value': '${(sessionsCompleted * 0.85).round()}',
          },
          {
            'label': 'Cancelled',
            'value': '${(sessionsCompleted * 0.15).round()}',
          },
          {
            'label': 'Avg/Week',
            'value': (sessionsCompleted / 4.0).toStringAsFixed(1),
          },
        ],
      },
      {
        'title': 'Leads',
        'icon': Icons.people_rounded,
        'color': const Color(0xFF8B5CF6),
        'stats': [
          {'label': 'Assigned', 'value': '$leadsAssigned'},
          {'label': 'Converted', 'value': '$leadsConverted'},
          {'label': 'Conv. Rate', 'value': '${convRate.toStringAsFixed(1)}%'},
          {'label': 'Pending', 'value': '${leadsAssigned - leadsConverted}'},
        ],
      },
      {
        'title': 'Tasks',
        'icon': Icons.task_alt_rounded,
        'color': const Color(0xFF8B5CF6),
        'stats': [
          {'label': 'Assigned', 'value': '${(leadsAssigned * 0.6).round()}'},
          {'label': 'Completed', 'value': '${(leadsAssigned * 0.45).round()}'},
          {'label': 'Pending', 'value': '${(leadsAssigned * 0.15).round()}'},
          {'label': 'On-Time %', 'value': '68%'},
        ],
      },
      {
        'title': 'Calls',
        'icon': Icons.call_rounded,
        'color': const Color(0xFF8B5CF6),
        'stats': [
          {'label': 'Total Calls', 'value': '$callsDone'},
          {'label': 'Incoming', 'value': '${emp['incomingCalls'] ?? 0}'},
          {'label': 'Outgoing', 'value': '${emp['outgoingCalls'] ?? 0}'},
          {'label': 'Missed', 'value': '${emp['missedCalls'] ?? 0}'},
        ],
      },
    ];

    return Column(
      children: sections.map((section) {
        final stats = (section['stats'] as List).cast<Map<String, dynamic>>();
        final sectionColor = section['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: sectionColor.withAlpha(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: sectionColor.withAlpha(18),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: sectionColor.withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        section['icon'] as IconData,
                        size: 14,
                        color: sectionColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      section['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: sectionColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: stats.asMap().entries.map((entry) {
                    final stat = entry.value;
                    return Expanded(
                      child: Column(
                        children: [
                          Text(
                            stat['value'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            stat['label'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCallDetailsTab() {
    final incomingCalls = e['incomingCalls'] as int? ?? 0;
    final outgoingCalls = e['outgoingCalls'] as int? ?? 0;
    final incomingAttended = e['incomingAttended'] as int? ?? 0;
    final outgoingAttended = e['outgoingAttended'] as int? ?? 0;
    final missedCalls = e['missedCalls'] as int? ?? 0;
    final avgCallDuration = e['avgCallDuration'] as double? ?? 0.0;
    final callsDone = e['callsDone'] as int? ?? 0;
    const numColor = Color(0xFF8B5CF6);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DetailSectionHeader('Call Statistics'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(40)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(18),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.call_rounded,
                        size: 14,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Call Overview',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$callsDone',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total Calls',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$incomingCalls',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Incoming',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$outgoingCalls',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Outgoing',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$missedCalls',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.error,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Missed',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(40)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(18),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.phone_in_talk_rounded,
                        size: 14,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Attended Calls',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$incomingAttended',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Incoming\nAttended',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$outgoingAttended',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Outgoing\nAttended',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${avgCallDuration.toStringAsFixed(1)}m',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Avg Duration',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            incomingCalls > 0
                                ? '${((incomingAttended / incomingCalls) * 100).round()}%'
                                : '0%',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: numColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Answer Rate',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceSecurityTab() {
    final phoneModel = e['phoneModel'] as String? ?? 'N/A';
    final imeiNumber = e['imeiNumber'] as String? ?? 'N/A';
    final simSlot = e['simSlot'] as String? ?? 'SIM 1';
    final telecom = e['telecom'] as String? ?? 'N/A';
    final passwordHash = e['passwordHash'] as String? ?? '••••••••';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Device Information ──
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(20),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone_android_rounded,
                      size: 16,
                      color: Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Device Information',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _DeviceInfoRow(
                      icon: Icons.phone_android_rounded,
                      label: 'Phone Model',
                      value: phoneModel,
                    ),
                    const Divider(height: 20),
                    _DeviceInfoRow(
                      icon: Icons.fingerprint_rounded,
                      label: 'IMEI Number',
                      value: imeiNumber,
                    ),
                    const Divider(height: 20),
                    _DeviceInfoRow(
                      icon: Icons.sim_card_rounded,
                      label: 'SIM Slot',
                      value: simSlot,
                    ),
                    const Divider(height: 20),
                    _DeviceInfoRow(
                      icon: Icons.signal_cellular_alt_rounded,
                      label: 'Telecom Operator',
                      value: telecom,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Security ──
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(20),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      size: 16,
                      color: Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Security',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _DeviceInfoRow(
                      icon: Icons.password_rounded,
                      label: 'App Password',
                      value: passwordHash,
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            size: 16,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Two-Factor Authentication',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                'Not configured',
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
                            color: const Color(0xFFF59E0B).withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Pending',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.devices_rounded,
                            size: 16,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Sessions',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                '1 device logged in',
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
                            color: const Color(0xFF059669).withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Active',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    final salary = e['salary'] as double? ?? 0.0;
    final targetAmount = e['targetAmount'] as double? ?? 0.0;
    final achievedAmount = e['achievedAmount'] as double? ?? 0.0;
    final commission = e['commission'] as double? ?? 0.0;
    final commissionRate = e['commissionRate'] as String? ?? 'N/A';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DetailSectionHeader('Performance Metrics'),
        const SizedBox(height: 8),
        Row(
          children: [
            _EMetricBox(
              label: 'Leads',
              value: '${e['leadsAssigned']}',
              sub: '${e['leadsConverted']} conv.',
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 5),
            _EMetricBox(
              label: 'Sessions',
              value: '${e['sessionsCompleted']}',
              sub: 'done',
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 5),
            _EMetricBox(
              label: 'Follow-ups',
              value: '${e['followUpsDone']}',
              sub: 'done',
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 5),
            _EMetricBox(
              label: 'Calls Done',
              value: '${e['callsDone']}',
              sub: '(Attended)',
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 5),
            _EMetricBox(
              label: 'Conv. Rate',
              value: '${(e['conversionRate'] as double).toStringAsFixed(1)}%',
              sub: '',
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _DetailSectionHeader('Performance Overview'),
        const SizedBox(height: 10),
        _buildModernPerformanceSection(e),
        const SizedBox(height: 16),
        // ── Salary Details — same card design as Leads performance card ──
        _DetailSectionHeader('Salary Details'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row matching leads performance card style
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(18),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 14,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Salary',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SalaryStatBox(
                            label: 'Monthly Salary',
                            value: salary > 0
                                ? '₹${_formatSalary(salary)}'
                                : '₹${_formatSalary(targetAmount * 0.02)}',
                            icon: Icons.currency_rupee_rounded,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SalaryStatBox(
                            label: 'Annual CTC',
                            value: salary > 0
                                ? '₹${_formatSalary(salary * 12)}'
                                : '₹${_formatSalary(targetAmount * 0.24)}',
                            icon: Icons.account_balance_wallet_rounded,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _SalaryStatBox(
                            label: 'Target Amount',
                            value: '₹${_formatSalary(targetAmount)}',
                            icon: Icons.flag_rounded,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SalaryStatBox(
                            label: 'Achieved',
                            value: '₹${_formatSalary(achievedAmount)}',
                            icon: Icons.emoji_events_rounded,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _SalaryStatBox(
                            label: 'Commission',
                            value: '₹${_formatSalary(commission)}',
                            icon: Icons.percent_rounded,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SalaryStatBox(
                            label: 'Commission Rate',
                            value: commissionRate,
                            icon: Icons.trending_up_rounded,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surface100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bar_chart_rounded,
                            size: 14,
                            color: Color(0xFF8B5CF6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Achievement: ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            targetAmount > 0
                                ? '${((achievedAmount / targetAmount) * 100).toStringAsFixed(1)}%'
                                : 'N/A',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: achievedAmount >= targetAmount
                                  ? AppTheme.success
                                  : AppTheme.warning,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: 6,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppTheme.surface200,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: targetAmount > 0
                                  ? (achievedAmount / targetAmount).clamp(
                                      0.0,
                                      1.0,
                                    )
                                  : 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: achievedAmount >= targetAmount
                                      ? AppTheme.success
                                      : const Color(0xFF8B5CF6),
                                  borderRadius: BorderRadius.circular(3),
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
            ],
          ),
        ),
        const SizedBox(height: 16),
        _DetailSectionHeader('Personal Info'),
        _DetailRow(
          icon: Icons.badge_rounded,
          label: 'Employee ID',
          value: e['employeeId'] as String,
        ),
        _DetailRow(
          icon: Icons.work_rounded,
          label: 'Role',
          value: e['role'] as String,
        ),
        _DetailRow(
          icon: Icons.business_rounded,
          label: 'Department',
          value: e['department'] as String,
        ),
        _DetailRow(
          icon: Icons.people_rounded,
          label: 'Team',
          value: e['team'] as String,
        ),
        _DetailRow(
          icon: Icons.map_rounded,
          label: 'Territory',
          value: e['territory'] as String,
        ),
        _DetailRow(
          icon: Icons.supervisor_account_rounded,
          label: 'Reports To',
          value: e['reportingManager'] as String,
        ),
        _DetailRow(
          icon: Icons.calendar_today_rounded,
          label: 'Joined',
          value: _formatDate(e['joinDate'] as DateTime),
        ),
        _DetailRow(
          icon: Icons.location_on_rounded,
          label: 'Location',
          value: e['location'] as String,
        ),
        _DetailRow(
          icon: Icons.work_outline_rounded,
          label: 'Work Mode',
          value: e['workMode'] as String,
        ),
        const SizedBox(height: 16),
        _DetailSectionHeader('Personal Contact'),
        if ((e['personalPhone'] as String? ?? '').isNotEmpty)
          _DetailRow(
            icon: Icons.phone_rounded,
            label: 'Personal Phone',
            value: e['personalPhone'] as String,
          ),
        _DetailRow(
          icon: Icons.email_outlined,
          label: 'Personal Email',
          value: e['personalEmail'] as String? ?? 'N/A',
        ),
        const SizedBox(height: 16),
        _DetailSectionHeader('Company Contact'),
        _DetailRowWithBadge(
          icon: Icons.sim_card_rounded,
          label: 'SIM Tracking No.',
          value: e['companyPhone'] as String? ?? 'N/A',
          badge: 'SIM',
        ),
        _DetailRow(
          icon: Icons.email_rounded,
          label: 'Company Email',
          value: e['companyEmail'] as String? ?? e['email'] as String,
        ),
        if ((e['alternatePhone'] as String? ?? '').isNotEmpty)
          _DetailRow(
            icon: Icons.phone_in_talk_rounded,
            label: 'Alt Phone',
            value: e['alternatePhone'] as String,
          ),
        const SizedBox(height: 16),
        _DetailSectionHeader('Skills & Certifications'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: (e['skills'] as List)
              .cast<String>()
              .map(
                (s) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: (e['certifications'] as List)
              .cast<String>()
              .map(
                (c) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    c,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  String _formatSalary(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

// ─── Lead Performance Cell — matches reference image 3 ───────────────────────

class _LeadPerfCell extends StatelessWidget {
  final String label, value;
  final Color color;
  const _LeadPerfCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Detail Section Header ────────────────────────────────────────────────────

class _DetailSectionHeader extends StatelessWidget {
  final String title;
  const _DetailSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: AppTheme.surface200, height: 1)),
        ],
      ),
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Detail Row With Badge ────────────────────────────────────────────────────

class _DetailRowWithBadge extends StatelessWidget {
  final IconData icon;
  final String label, value, badge;
  const _DetailRowWithBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withAlpha(20),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0891B2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add Employee Sheet — updated access levels ────────────────────────────────────────────────────────────────────────

class _AddEmployeeSheet extends StatefulWidget {
  final List<Map<String, dynamic>> existingEmployees;
  final void Function(Map<String, dynamic>) onSave;
  const _AddEmployeeSheet({
    required this.existingEmployees,
    required this.onSave,
  });

  @override
  State<_AddEmployeeSheet> createState() => _AddEmployeeSheetState();
}

class _AddEmployeeSheetState extends State<_AddEmployeeSheet> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _personalEmailCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String _department = 'Sales';
  String _accessLevel = 'Employee';
  String _workMode = 'On-site';
  _ECountry _mobileCountry = _eAllCountries.first; // India default
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  static const _depts = ['Sales', 'Operations', 'Marketing', 'Support'];
  static const _accessLevels = [
    'Admin',
    'Manager',
    'Senior Rep',
    'Employee',
    'Contact',
  ];
  static const _workModes = ['On-site', 'Remote', 'Hybrid'];

  bool get _passwordsMatch => _passwordCtrl.text == _confirmPasswordCtrl.text;
  bool get _canSave =>
      _nameCtrl.text.trim().isNotEmpty &&
      _emailCtrl.text.trim().isNotEmpty &&
      _passwordCtrl.text.length >= 6 &&
      _passwordsMatch &&
      _mobileCtrl.text.trim().isNotEmpty;

  String get _previewId =>
      _generateUniqueId(_accessLevel, widget.existingEmployees);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _mobileCtrl.dispose();
    _personalEmailCtrl.dispose();
    _roleCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _showAccessLevelInfo(String level) {
    final info = _accessLevelInfo[level];
    if (info == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: (info['color'] as Color).withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shield_rounded,
                size: 16,
                color: info['color'] as Color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$level Access',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              info['description'] as String,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Permissions:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ...(info['permissions'] as List<String>).map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        p,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
            child: Text(
              'Got it',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surface200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Employee Account',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Creates login credentials for the employee',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.surface100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildLabel('Access Level / Role'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ..._accessLevels.map((a) {
                    final sel = _accessLevel == a;
                    final color =
                        (_accessLevelInfo[a]?['color'] as Color?) ??
                        AppTheme.primary;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _accessLevel = a),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? color.withAlpha(20)
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? color : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            a,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel ? color : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () => _showAccessLevelInfo(_accessLevel),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(40),
                        ),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.surface200),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.badge_rounded,
                      size: 14,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Auto-generated ID: ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      _previewId,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withAlpha(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Login Credentials',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildField('Full Name *', _nameCtrl, 'e.g. Priya Sharma'),
                    const SizedBox(height: 10),
                    _buildField(
                      'Company Email *',
                      _emailCtrl,
                      'e.g. name@company.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    _buildLabel('Password *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: !_showPassword,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Min 6 characters',
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 16,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
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
                    const SizedBox(height: 10),
                    _buildLabel('Confirm Password *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _confirmPasswordCtrl,
                      obscureText: !_showConfirmPassword,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Re-enter password',
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 16,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_confirmPasswordCtrl.text.isNotEmpty)
                              Icon(
                                _passwordsMatch
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                size: 16,
                                color: _passwordsMatch
                                    ? AppTheme.success
                                    : AppTheme.error,
                              ),
                            IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 16,
                              ),
                              onPressed: () => setState(
                                () => _showConfirmPassword =
                                    !_showConfirmPassword,
                              ),
                            ),
                          ],
                        ),
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              _confirmPasswordCtrl.text.isNotEmpty &&
                                  !_passwordsMatch
                              ? const BorderSide(color: AppTheme.error)
                              : BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              _confirmPasswordCtrl.text.isNotEmpty &&
                                  !_passwordsMatch
                              ? const BorderSide(color: AppTheme.error)
                              : BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                    if (_confirmPasswordCtrl.text.isNotEmpty &&
                        !_passwordsMatch) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Passwords do not match',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Mobile number — same design as Add Lead phone input
              _buildLabel('Mobile Number *'),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ECountryCodePicker(
                    selected: _mobileCountry,
                    onChanged: (c) => setState(() => _mobileCountry = c),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _mobileCtrl,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Mobile number',
                        filled: true,
                        fillColor: AppTheme.surface100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildField(
                'Personal Email',
                _personalEmailCtrl,
                'e.g. name@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildField('Role / Designation', _roleCtrl, 'e.g. Sales Agent'),
              const SizedBox(height: 12),
              _buildField('Location', _locationCtrl, 'e.g. Bangalore'),
              const SizedBox(height: 12),
              _buildLabel('Department'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _depts.map((d) {
                  final sel = _department == d;
                  return GestureDetector(
                    onTap: () => setState(() => _department = d),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.primaryContainer
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppTheme.primary : AppTheme.surface200,
                        ),
                      ),
                      child: Text(
                        d,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: sel
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              _buildLabel('Work Mode'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _workModes.map((w) {
                  final sel = _workMode == w;
                  return GestureDetector(
                    onTap: () => setState(() => _workMode = w),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.primaryContainer
                            : AppTheme.surface100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppTheme.primary : AppTheme.surface200,
                        ),
                      ),
                      child: Text(
                        w,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: sel
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave
                      ? () {
                          final name = _nameCtrl.text.trim();
                          final initials = name
                              .split(' ')
                              .map((w) => w.isNotEmpty ? w[0] : '')
                              .take(2)
                              .join()
                              .toUpperCase();
                          final newId = _generateUniqueId(
                            _accessLevel,
                            widget.existingEmployees,
                          );
                          final mobileWithCode =
                              '${_mobileCountry.code} ${_mobileCtrl.text.trim()}';
                          final newEmp = {
                            'id':
                                'emp-${DateTime.now().millisecondsSinceEpoch}',
                            'name': name,
                            'initials': initials,
                            'role': _roleCtrl.text.trim().isNotEmpty
                                ? _roleCtrl.text.trim()
                                : 'Sales Agent',
                            'department': _department,
                            'employeeId': newId,
                            'email': _emailCtrl.text.trim(),
                            'personalEmail': _personalEmailCtrl.text.trim(),
                            'personalPhone': '',
                            'phone': mobileWithCode,
                            'companyPhone': mobileWithCode,
                            'companyEmail': _emailCtrl.text.trim(),
                            'alternatePhone': '',
                            'reportingManager': 'Admin',
                            'team': _department,
                            'territory': 'All',
                            'status': 'Active',
                            'accessLevel': _accessLevel,
                            'joinDate': DateTime.now(),
                            'profilePhoto':
                                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg',
                            'leadsAssigned': 0,
                            'leadsConverted': 0,
                            'leadsFollowUp': 0,
                            'sessionsCompleted': 0,
                            'followUpsDone': 0,
                            'callsDone': 0,
                            'targetAmount': 0.0,
                            'achievedAmount': 0.0,
                            'commission': 0.0,
                            'commissionRate': '3%',
                            'conversionRate': 0.0,
                            'avgDealValue': 0.0,
                            'avgCallDuration': 0.0,
                            'lastActivity': DateTime.now(),
                            'incomingCalls': 0,
                            'outgoingCalls': 0,
                            'incomingAttended': 0,
                            'outgoingAttended': 0,
                            'missedCalls': 0,
                            'phoneModel': 'Unknown',
                            'imeiNumber': 'N/A',
                            'simSlot': 'SIM 1',
                            'telecom': 'Unknown',
                            'salary': 0.0,
                            'passwordHash': '••••••••',
                            'appActivityDays': List.generate(
                              7,
                              (i) => {
                                'date': DateTime.now().subtract(
                                  Duration(days: 6 - i),
                                ),
                                'minutes': 0,
                              },
                            ),
                            'activityLog': [
                              {
                                'action': 'Employee account created',
                                'time': DateTime.now(),
                                'type': 'lead',
                              },
                            ],
                            'skills': <String>[],
                            'certifications': <String>[],
                            'languages': ['English'],
                            'location': _locationCtrl.text.trim().isNotEmpty
                                ? _locationCtrl.text.trim()
                                : 'N/A',
                            'workMode': _workMode,
                            'gender': 'N/A',
                            'dob': 'N/A',
                            'emergencyContact': 'N/A',
                            'bankAccount': 'N/A',
                            'pfNumber': 'N/A',
                            'panNumber': 'N/A',
                            'isArchived': false,
                          };
                          Navigator.pop(context);
                          widget.onSave(newEmp);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    disabledBackgroundColor: AppTheme.surface200,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Employee Account',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: _canSave ? Colors.white : AppTheme.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
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
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _EHeaderBtn extends StatelessWidget {
  final IconData icon;
  final bool hasActive;
  final VoidCallback onTap;
  const _EHeaderBtn({
    required this.icon,
    required this.hasActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hasActive ? AppTheme.primaryContainer : AppTheme.surface100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasActive ? AppTheme.primary : AppTheme.surface200,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: hasActive ? AppTheme.primary : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _EStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _EStatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EMetricBox extends StatelessWidget {
  final String label, value, sub;
  final Color color;
  const _EMetricBox({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 8,
                color: AppTheme.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            if (sub.isNotEmpty)
              Text(
                sub,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 7,
                  color: AppTheme.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _EInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _EInfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: color),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _EKpiData {
  final String label, value;
  final IconData icon;
  final Color color;
  final String sub;
  final bool trendUp;
  const _EKpiData(
    this.label,
    this.value,
    this.icon,
    this.color, [
    this.sub = '',
    this.trendUp = false,
  ]);
}

// KPI Card — matches follow-ups _KpiCard exactly (width 120, icon box top-left, trend arrow top-right, big bold number, label below)
class _EKpiCard extends StatelessWidget {
  final _EKpiData data;
  const _EKpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: data.color.withAlpha(31),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 14, color: data.color),
              ),
              if (data.sub.isNotEmpty)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.trendUp
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 11,
                        color: data.trendUp ? AppTheme.success : AppTheme.warning,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          data.sub,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: data.trendUp
                                ? AppTheme.success
                                : AppTheme.warning,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Sheet ─────────────────────────────────────────────────────────────

class _EmpFilterSheet extends StatefulWidget {
  final List<String> selectedDepts,
      selectedAccessLevels,
      selectedHosts,
      deptOptions,
      accessLevelOptions;
  final List<Map<String, dynamic>> allEmployees;
  final DateTime? dateFrom, dateTo;
  final Function(List<String>, List<String>, List<String>, DateTime?, DateTime?)
  onApply;
  const _EmpFilterSheet({
    required this.selectedDepts,
    required this.selectedAccessLevels,
    required this.selectedHosts,
    required this.deptOptions,
    required this.accessLevelOptions,
    required this.allEmployees,
    required this.dateFrom,
    required this.dateTo,
    required this.onApply,
  });

  @override
  State<_EmpFilterSheet> createState() => _EmpFilterSheetState();
}

class _EmpFilterSheetState extends State<_EmpFilterSheet> {
  late List<String> _depts, _accessLevels, _hosts;
  DateTime? _from, _to;
  String _hostSearch = '';
  final _hostSearchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _depts = List.from(widget.selectedDepts);
    _accessLevels = List.from(widget.selectedAccessLevels);
    _hosts = List.from(widget.selectedHosts);
    _from = widget.dateFrom;
    _to = widget.dateTo;
  }

  @override
  void dispose() {
    _hostSearchCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  List<Map<String, dynamic>> get _filteredHosts {
    final q = _hostSearch.toLowerCase();
    return widget.allEmployees.where((e) {
      final name = (e['name'] as String).toLowerCase();
      final role = (e['role'] as String).toLowerCase();
      return q.isEmpty || name.contains(q) || role.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedHostEmps = widget.allEmployees
        .where((e) => _hosts.contains(e['name']))
        .toList();
    final unselectedHostEmps = _filteredHosts
        .where((e) => !_hosts.contains(e['name']))
        .toList();
    final orderedHosts = [...selectedHostEmps, ...unselectedHostEmps];

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                Text(
                  'Filter Employees',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _depts = [];
                    _accessLevels = [];
                    _hosts = [];
                    _from = null;
                    _to = null;
                  }),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.error,
                    ),
                  ),
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
                  Text(
                    'Assigned Host',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.surface200),
                    ),
                    child: TextField(
                      controller: _hostSearchCtrl,
                      onChanged: (v) => setState(() => _hostSearch = v),
                      decoration: InputDecoration(
                        hintText: 'Search agents...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 16,
                          color: AppTheme.textMuted,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () =>
                        setState(() => _hosts.isEmpty ? null : _hosts.clear()),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      decoration: _hosts.isEmpty
                          ? BoxDecoration(
                              color: AppTheme.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.primary.withAlpha(40),
                            child: Text(
                              'AL',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'All Agents',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Select all agents',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_hosts.isEmpty)
                            const Icon(
                              Icons.check_rounded,
                              color: AppTheme.primary,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                  ...orderedHosts.map((emp) {
                    final name = emp['name'] as String;
                    final role = emp['role'] as String;
                    final initials = emp['initials'] as String;
                    final sel = _hosts.contains(name);
                    const color = AppTheme.primary;
                    return InkWell(
                      onTap: () => setState(
                        () => sel ? _hosts.remove(name) : _hosts.add(name),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                        decoration: sel
                            ? BoxDecoration(
                                color: color.withAlpha(20),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: color.withAlpha(40),
                              child: Text(
                                initials,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    role,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (sel)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: color,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  Text(
                    'Department',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.deptOptions.map((d) {
                      final sel = _depts.contains(d);
                      return GestureDetector(
                        onTap: () => setState(
                          () => sel ? _depts.remove(d) : _depts.add(d),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppTheme.primaryContainer
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? AppTheme.primary
                                  : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            d,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Access Level',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.accessLevelOptions.map((a) {
                      final sel = _accessLevels.contains(a);
                      final color =
                          (_accessLevelInfo[a]?['color'] as Color?) ??
                          AppTheme.primary;
                      return GestureDetector(
                        onTap: () => setState(
                          () => sel
                              ? _accessLevels.remove(a)
                              : _accessLevels.add(a),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? color.withAlpha(20)
                                : AppTheme.surface100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? color : AppTheme.surface200,
                            ),
                          ),
                          child: Text(
                            a,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel ? color : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date Joined',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
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
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _from ?? DateTime(2020),
                              firstDate: DateTime(2018),
                              lastDate: DateTime.now(),
                            );
                            if (d != null) setState(() => _from = d);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surface100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _from != null
                                    ? AppTheme.primary.withAlpha(60)
                                    : AppTheme.surface200,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _from != null
                                      ? _formatDate(_from!)
                                      : 'From date',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: _from != null
                                        ? AppTheme.textPrimary
                                        : AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _to ?? DateTime.now(),
                              firstDate: DateTime(2018),
                              lastDate: DateTime.now(),
                            );
                            if (d != null) setState(() => _to = d);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surface100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _to != null
                                    ? AppTheme.primary.withAlpha(60)
                                    : AppTheme.surface200,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: AppTheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _to != null ? _formatDate(_to!) : 'To date',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: _to != null
                                        ? AppTheme.textPrimary
                                        : AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(
                          _depts,
                          _accessLevels,
                          _hosts,
                          _from,
                          _to,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
    );
  }
}

class _EmpSortSheet extends StatelessWidget {
  final _EmployeeSortOption current;
  final ValueChanged<_EmployeeSortOption> onSelect;
  const _EmpSortSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        _EmployeeSortOption.conversionHigh,
        'Conversion Rate — High to Low',
        Icons.trending_up_rounded,
      ),
      (
        _EmployeeSortOption.leadsAssignedHigh,
        'Leads Assigned — High to Low',
        Icons.people_rounded,
      ),
      (
        _EmployeeSortOption.achievementHigh,
        'Achievement — High to Low',
        Icons.emoji_events_rounded,
      ),
      (
        _EmployeeSortOption.nameAZ,
        'Name — A to Z',
        Icons.sort_by_alpha_rounded,
      ),
      (
        _EmployeeSortOption.nameZA,
        'Name — Z to A',
        Icons.sort_by_alpha_rounded,
      ),
      (
        _EmployeeSortOption.joinDateNewest,
        'Join Date — Newest First',
        Icons.fiber_new_rounded,
      ),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sort Employees',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...options.map((o) {
            final sel = current == o.$1;
            return ListTile(
              leading: Icon(
                o.$3,
                color: sel ? const Color(0xFF059669) : AppTheme.textSecondary,
                size: 20,
              ),
              title: Text(
                o.$2,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color: sel ? const Color(0xFF059669) : AppTheme.textPrimary,
                ),
              ),
              trailing: sel
                  ? const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF059669),
                      size: 18,
                    )
                  : null,
              onTap: () {
                onSelect(o.$1);
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }
}

// ─── Salary Stat Box ──────────────────────────────────────────────────────────

class _SalaryStatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _SalaryStatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DeviceInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF8B5CF6)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
