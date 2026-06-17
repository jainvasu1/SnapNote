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

  // DELETE CONFIRM DIALOG
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

  @override
  Widget build(BuildContext context) {
    List<Note> notes = StorageService.getNotes();

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Dismissible(
                  key: Key(note.title + index.toString()),

                  // 👉 EDIT (LEFT SWIPE)
                  background: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  // DELETE (RIGHT SWIPE)
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return await confirmDelete();
                    } else {
                      // EDIT NAVIGATION
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: note,
                      ).then((_) {
                        setState(() {});
                      });
                      return false;
                    }
                  },

                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        notes.removeAt(index);
                        StorageService.saveNotes(notes);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Note Deleted")),
                      );
                    }
                  },

                  child: Card(
                    color: Colors.black54,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getPriorityColor(note.priority),
                      ),

                      title: Text(
                        note.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      subtitle: Text(
                        note.date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.detail,
                          arguments: note,
                        );
                      },

                      //  ICON BUTTONS ALSO
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
                              ).then((_) {
                                setState(() {});
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool? confirm = await confirmDelete();
                              if (confirm == true) {
                                setState(() {
                                  notes.removeAt(index);
                                  StorageService.saveNotes(notes);
                                });
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
          Navigator.pushNamed(context, AppRoutes.addNote).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
