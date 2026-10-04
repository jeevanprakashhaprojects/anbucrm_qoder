import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionNotesWidget extends StatefulWidget {
  final Map<String, dynamic>? prefillData;
  const SectionNotesWidget({super.key, this.prefillData});

  @override
  State<SectionNotesWidget> createState() => _SectionNotesWidgetState();
}

class _SectionNotesWidgetState extends State<SectionNotesWidget>
    with SingleTickerProviderStateMixin {
  final _notesCtrl = TextEditingController();
  bool _isRecording = false;
  bool _isPrivate = false;
  static const int _maxChars = 1000;

  String _selectedCategory = 'General';
  final String _selectedTemplate = '';
  DateTime? _reminderDate;

  final List<Map<String, dynamic>> _voiceRecordings = [];
  final List<Map<String, dynamic>> _notesList = [];
  final List<String> _selectedTags = [];
  final List<Map<String, dynamic>> _attachments = [];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const _categories = [
    'General',
    'Call Summary',
    'Meeting',
    'Email',
    'Objection',
    'Competitor Intel',
    'Follow-up',
    'Others',
  ];

  static const _tags = [
    'Important',
    'Action Required',
    'Pending',
    'Resolved',
    'Escalated',
  ];

  static const _templates = [
    'Call Summary: Spoke with [Name] on [Date]. Discussed [Topic]. Next step: [Action].',
    'Meeting Notes: Met at [Location] on [Date]. Key points: [Points]. Follow-up: [Date].',
    'Objection Handling: Lead raised concern about [Issue]. Response: [Response]. Status: [Status].',
    'Competitor Intel: Lead mentioned [Competitor]. Their offer: [Offer]. Our advantage: [Advantage].',
    'Follow-up Note: Attempted contact on [Date] via [Channel]. Result: [Result]. Next attempt: [Date].',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.prefillData != null) {
      _notesCtrl.text = widget.prefillData!['notes'] as String? ?? '';
    }
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleVoiceRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      _pulseController.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isRecording) _stopRecording();
      });
    } else {
      _stopRecording();
    }
  }

  void _stopRecording() {
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _isRecording = false;
      _voiceRecordings.insert(0, {
        'label': 'Voice Recording ${_voiceRecordings.length + 1}',
        'duration': '0:05',
        'time': 'Just now',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mic_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Voice recording saved',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _saveNote() {
    if (_notesCtrl.text.trim().isEmpty) return;
    setState(() {
      _notesList.insert(0, {
        'text': _notesCtrl.text.trim(),
        'category': _selectedCategory,
        'isPrivate': _isPrivate,
        'tags': List.from(_selectedTags),
        'isPinned': false,
        'time': 'Just now',
        'reminder': _reminderDate,
      });
      _notesCtrl.clear();
      _selectedTags.clear();
      _reminderDate = null;
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
              'Note saved',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _notesCtrl.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Note Category
        Text(
          'Note Category',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((c) {
              final isSelected = _selectedCategory == c;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = c),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
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
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    c,
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
        ),
        const SizedBox(height: 12),

        // Privacy toggle
        Row(
          children: [
            Icon(
              _isPrivate ? Icons.lock_rounded : Icons.lock_open_rounded,
              size: 16,
              color: _isPrivate ? AppTheme.error : AppTheme.success,
            ),
            const SizedBox(width: 8),
            Text(
              _isPrivate
                  ? 'Private (visible to you only)'
                  : 'Shared (visible to team)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: _isPrivate ? AppTheme.error : AppTheme.success,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Switch(
              value: _isPrivate,
              onChanged: (v) => setState(() => _isPrivate = v),
              activeThumbColor: AppTheme.error,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Template Library
        GestureDetector(
          onTap: () => _showTemplateSheet(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.library_books_outlined,
                  size: 16,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Use Template',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Notes textarea
        TextFormField(
          controller: _notesCtrl,
          maxLines: 6,
          maxLength: _maxChars,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Notes',
            alignLabelWithHint: true,
            hintText: 'Add notes about this lead...',
            counterText: '${_notesCtrl.text.length}/$_maxChars',
            counterStyle: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: charCount > _maxChars * 0.9
                  ? AppTheme.error
                  : AppTheme.textMuted,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),

        // Tags on note
        Text(
          'Tags',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _tags.map((t) {
            final isSelected = _selectedTags.contains(t);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  _selectedTags.remove(t);
                } else {
                  _selectedTags.add(t);
                }
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

        // Reminder
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _reminderDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _reminderDate != null
                  ? AppTheme.primaryContainer.withAlpha(60)
                  : AppTheme.surface100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _reminderDate != null
                    ? AppTheme.primary.withAlpha(80)
                    : AppTheme.surface200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.alarm_rounded,
                  size: 16,
                  color: _reminderDate != null
                      ? AppTheme.primary
                      : AppTheme.textMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  _reminderDate != null
                      ? 'Reminder: ${_reminderDate!.day}/${_reminderDate!.month}/${_reminderDate!.year}'
                      : 'Set Reminder',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: _reminderDate != null
                        ? AppTheme.primary
                        : AppTheme.textMuted,
                    fontWeight: _reminderDate != null
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),
                if (_reminderDate != null) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _reminderDate = null),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Attach File
        GestureDetector(
          onTap: () => setState(() {
            _attachments.add({
              'name': 'Document_${_attachments.length + 1}.pdf',
              'size': '1.2 MB',
              'type': 'pdf',
            });
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Attach File (PDF, DOCX, Image)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_attachments.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._attachments.map(
            (a) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withAlpha(40),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      a['name'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    a['size'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _attachments.remove(a)),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppTheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),

        // Action row — no Save Note button; note is saved with lead creation
        Row(
          children: [
            // Voice input
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: _isRecording ? _pulseAnimation.value : 1.0,
                child: child,
              ),
              child: InkWell(
                onTap: _toggleVoiceRecording,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? AppTheme.error.withAlpha(26)
                        : AppTheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isRecording
                          ? AppTheme.error.withAlpha(128)
                          : AppTheme.primary.withAlpha(77),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isRecording
                            ? Icons.stop_circle_rounded
                            : Icons.mic_rounded,
                        size: 16,
                        color: _isRecording ? AppTheme.error : AppTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isRecording ? 'Stop' : 'Voice',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isRecording
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
            // AI Summary
            InkWell(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'AI Summary: Lead is interested in Life Insurance and Health coverage. Follow-up scheduled.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  ),
                  backgroundColor: AppTheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withAlpha(80),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: Color(0xFF7C3AED),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI Summary',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Info chip: notes saved with lead
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.success.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.success.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: AppTheme.success,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Saved with lead',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Saved Notes List
        if (_notesList.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Notes (${_notesList.length})',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ..._notesList.asMap().entries.map((entry) {
            final i = entry.key;
            final note = entry.value;
            final isPinned = note['isPinned'] as bool;
            final isPrivate = note['isPrivate'] as bool;
            final category = note['category'] as String;
            final noteTags = note['tags'] as List<String>;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPinned ? const Color(0xFFFFFBEB) : AppTheme.surface100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isPinned
                      ? const Color(0xFFB45309).withAlpha(80)
                      : AppTheme.surface200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
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
                          category,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isPrivate)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lock_rounded,
                                size: 10,
                                color: AppTheme.error,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Private',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppTheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(
                          () => _notesList[i]['isPinned'] = !isPinned,
                        ),
                        child: Icon(
                          isPinned
                              ? Icons.push_pin_rounded
                              : Icons.push_pin_outlined,
                          size: 16,
                          color: isPinned
                              ? const Color(0xFFB45309)
                              : AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _notesList.removeAt(i)),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note['text'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (noteTags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: noteTags
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surface200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                t,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    note['time'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],

        // Voice recordings list
        if (_voiceRecordings.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Voice Recordings',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ..._voiceRecordings.map(
            (r) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withAlpha(40)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['label'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${r['duration']} · ${r['time']}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.play_circle_rounded,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showTemplateSheet() {
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
                  'Note Templates',
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
                itemCount: _templates.length,
                itemBuilder: (_, i) => ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                  ),
                  title: Text(
                    'Template ${i + 1}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    _templates[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    setState(() => _notesCtrl.text = _templates[i]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
