import '../screens/login_screen.dart';
import '../screens/notes_list_screen.dart';
import '../screens/add_note_screen.dart';
import '../screens/notes_detail_screen.dart';

class AppRoutes {
  static const login = '/';
  static const notesList = '/notes';
  static const addNote = '/add';
  static const detail = '/detail';

  static final routes = {
    login: (context) => const LoginScreen(),
    notesList: (context) => const NotesListScreen(),
    addNote: (context) => const AddNoteScreen(),
    detail: (context) => const NotesDetailScreen(),
  };
}
