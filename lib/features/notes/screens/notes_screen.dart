import 'package:flutter/material.dart';
import '../widgets/note_grid_item.dart';
import '../../../models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // This is our "Live" list of notes
  final List<Note> _myNotes = [
    Note(id: '1', title: "Newton's 3 Laws", content: "Summary of physics laws...", subject: "Physics", isPinned: true),
  ];

  // Controllers to grab text from the popup
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addNewNote() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Create New Note", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(controller: _titleController, decoration: const InputDecoration(hintText: "Title")),
            TextField(controller: _contentController, decoration: const InputDecoration(hintText: "Content"), maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9E8CF2), minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                setState(() {
                  _myNotes.add(Note(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    content: _contentController.text,
                    subject: "General",
                  ));
                });
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
              },
              child: const Text("Save Note", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER (Keep your existing gradient header code here) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 60, 25, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0D2B45), Color(0xFF163E5F)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  const Text("My Notes", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 25),
                // Search bar...
              ],
            ),
          ),

          // --- DYNAMIC LIST ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _myNotes.length,
              itemBuilder: (context, index) {
                return NoteGridItem(note: _myNotes[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote, // Trigger the popup!
        backgroundColor: const Color(0xFF9E8CF2),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}