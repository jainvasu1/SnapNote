import 'package:flutter/material.dart';
import '../models/note.dart';

class NotesDetailScreen extends StatelessWidget {
  const NotesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final note = ModalRoute.of(context)!.settings.arguments as Note;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(note.content),
          ],
        ),
      ),
    );
  }
}
