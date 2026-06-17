import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String selectedPriority = "Low";
  String currentDate = DateFormat.yMMMd().format(DateTime.now());

  final Map<String, Color> priorityColors = {
    "High": Colors.red,
    "Medium": Colors.orange,
    "Low": Colors.green,
  };

  void saveNote() {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    StorageService.addNote(
      Note(
        id: DateTime.now().toString(),
        title: titleController.text,
        content: contentController.text,
        date: currentDate,
        priority: selectedPriority,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ✅ FIXED APPBAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "Add Note",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ✅ SCROLL
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currentDate, style: const TextStyle(color: Colors.white)),

              const SizedBox(height: 20),

              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: contentController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ PRIORITY
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: priorityColors.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPriority = entry.key;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                        border: selectedPriority == entry.key
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  "Priority: $selectedPriority",
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: saveNote,
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
