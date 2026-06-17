import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../constants/app_routes.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = StorageService.getNotes();

    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.detail,
                arguments: notes[index],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addNote);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
