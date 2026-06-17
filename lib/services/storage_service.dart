import '../models/note.dart';

class StorageService {
  static List<Note> notes = [];

  static void addNote(Note note) {
    notes.add(note);
  }

  static List<Note> getNotes() {
    return notes;
  }

  static void saveNotes(List<Note> updatedNotes) {
    notes = updatedNotes;
  }
}
