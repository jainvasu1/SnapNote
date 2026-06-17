import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../constants/app_routes.dart';
import '../models/note.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  // priority color
  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Note> notes = StorageService.getNotes();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Notes"), backgroundColor: Colors.black),

      body: notes.isEmpty
          ? const Center(
              child: Text(
                "No Notes Found",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  color: Colors.black54,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getPriorityColor(note.priority),
                    ),
                    title: Text(
                      note.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      note.date,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: note,
                      );
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addNote);
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
