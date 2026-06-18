import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

class NotesDetailScreen extends StatefulWidget {
  const NotesDetailScreen({super.key});

  @override
  State<NotesDetailScreen> createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late Note note;

  String priority = "Low";
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    note = ModalRoute.of(context)!.settings.arguments as Note;

    titleController = TextEditingController(text: note.title);
    contentController = TextEditingController(text: note.content);
    priority = note.priority;

    _initialized = true;
  }

  void _saveNote() {
    final updatedNote = Note(
      id: note.id,
      title: titleController.text,
      content: contentController.text,
      date: note.date,
      priority: priority,
    );
    List<Note> notes = StorageService.getNotes();
    int index = notes.indexWhere((n) => n.id == note.id);

    if (index != -1) {
      notes[index] = updatedNote;
      StorageService.saveNotes(notes);
    }

    Navigator.pop(context, updatedNote);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Edit Note", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveNote,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Title"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: contentController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Description"),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: priority,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Priority"),
              items: const [
                DropdownMenuItem(value: "Low", child: Text("Low")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "High", child: Text("High")),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  priority = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
