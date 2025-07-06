import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_event.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_view_model.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({super.key});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool _isFocused = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitSchedule() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event title cannot be empty.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final currentUser = context.read<AuthProvider>().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<ScheduleViewModel>().add(
      CreateSchedule(
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        eventDate: _selectedDate,
        userId: currentUser.id,
      ),
    );
    // Clear form
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedDate = null;
      _isFocused = false;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _isFocused ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            onTap: () => setState(() => _isFocused = true),
            onSubmitted: (_) => _submitSchedule(),
            decoration: const InputDecoration(
              hintText: 'Add a new event...',
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description (optional)',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              IconButton(
                onPressed: _selectDate,
                icon: Icon(
                  Icons.calendar_today,
                  color: _selectedDate != null ? Colors.blue : Colors.grey,
                ),
                tooltip: 'Set event date',
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed:
                    _titleController.text.trim().isNotEmpty
                        ? _submitSchedule
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
          if (_selectedDate != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'Event: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _selectedDate = null),
                  child: const Text(
                    'Remove',
                    style: TextStyle(fontSize: 12, color: Colors.red),
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
