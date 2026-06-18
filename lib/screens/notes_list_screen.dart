import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/storage_service.dart';
import '../models/note.dart';
import '../constants/app_routes.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late List<Note> notes;

  @override
  void initState() {
    super.initState();
    notes = StorageService.getNotes();
  }

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

  Future<bool?> confirmDelete() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure you want to delete?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void refreshNotes() {
    setState(() {
      notes = StorageService.getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Notes", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", false);

              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),

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

                return Dismissible(
                  key: Key(note.id.toString()),

                  // EDIT (LEFT)
                  background: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),

                  // DELETE (RIGHT)
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return await confirmDelete();
                    } else {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: note,
                      ).then((_) => refreshNotes());

                      return false;
                    }
                  },

                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      notes.removeAt(index);
                      StorageService.saveNotes(notes);

                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Note Deleted")),
                      );
                    }
                  },

                  child: Card(
                    color: Colors.black54,
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
                        ).then((_) => refreshNotes());
                      },

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.detail,
                                arguments: note,
                              ).then((_) => refreshNotes());
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool? confirm = await confirmDelete();
                              if (confirm == true) {
                                notes.removeAt(index);
                                StorageService.saveNotes(notes);

                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.addNote,
          ).then((_) => refreshNotes());
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
