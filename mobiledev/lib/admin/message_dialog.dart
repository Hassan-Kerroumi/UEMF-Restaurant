import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';

class MessageDialog extends StatefulWidget {
  final Map<String, dynamic> order;

  const MessageDialog({super.key, required this.order});

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  late TextEditingController _messageController;
  String? _selectedTime;

  final List<String> _timeSlots = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
    '11:00', '11:30', '12:00', '12:30', '13:00', '13:30',
    '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
    '17:00', '17:30', '18:00',
  ];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            settings.t('sendMessage'),
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${settings.t('to')}: ${widget.order['studentName']}',
            style: const TextStyle(
              color: Color(0xFF9ca3af),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Suggested Time Section
            Text(
              settings.t('suggestAlternativeTime'),
              style: TextStyle(
                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.transparent,
                ),
              ),
              child: DropdownButton<String>(
                value: _selectedTime,
                hint: Text(
                  settings.t('selectTimeSlot'),
                  style: const TextStyle(color: Color(0xFF9ca3af)),
                ),
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                style: TextStyle(
                  color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                  fontSize: 14,
                ),
                underline: const SizedBox(),
                items: _timeSlots.map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Message Section
            Text(
              settings.t('message'),
              style: TextStyle(
                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.transparent,
                ),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                maxLength: 200,
                style: TextStyle(
                  color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: settings.t('typeMessage'),
                  hintStyle: const TextStyle(
                    color: Color(0xFF9ca3af),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                  counterStyle: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Info box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.7),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      settings.t('studentNotification'),
                      style: TextStyle(
                        color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            settings.t('cancel'),
            style: const TextStyle(color: Color(0xFF9ca3af)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _messageController.text.trim().isEmpty
              ? null
              : () {
                  final message = _messageController.text.trim();
                  final timeInfo = _selectedTime != null 
                      ? ' (${settings.t('suggestedTime')}: $_selectedTime)'
                      : '';
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${settings.t('messageSent')} ${widget.order['studentName']}$timeInfo',
                      ),
                      backgroundColor: const Color(0xFF3cad2a),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
          icon: const Icon(Icons.send_rounded, size: 18),
          label: Text(settings.t('sendMessage')),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF9ca3af).withOpacity(0.3),
            disabledForegroundColor: const Color(0xFF9ca3af),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
