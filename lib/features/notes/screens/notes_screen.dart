import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  bool _loading = true;
  String _searchQuery = "";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('saved_notes');
    if (saved != null) {
      final List<dynamic> decoded = json.decode(saved);
      setState(() {
        _notes = decoded.map((n) => Note(
            id: DateTime.now().toString(),
            title: n['title'],
            content: n['content'],
            subject: n['subject'] ?? "General",
            isPinned: n['isPinned'] ?? false
        )).toList();
      });
    }
    setState(() => _loading = false);
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_notes.map((n) => {
      'title': n.title,
      'content': n.content,
      'subject': n.subject,
      'isPinned': n.isPinned
    }).toList());
    await prefs.setString('saved_notes', encoded);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Filter Logic
    final filteredNotes = _notes.where((n) {
      final matchesSearch = n.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == "All" || n.subject == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER WITH SEARCH ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D2B45), Color(0xFF163E5F)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("My Notes",
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                // SEARCH BAR
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search Notes......",
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- CATEGORY FILTERS ---
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: ["All", "Physics", "Maths", "Literature"].map((cat) {
                bool isSel = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSel,
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                    selectedColor: const Color(0xFF8E8CD8),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                        color: isSel ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // --- NOTES LIST ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                const Row(
                  children: [
                    Icon(Icons.push_pin, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Text("Pinned", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                ...filteredNotes.map((note) => _buildNoteCard(note)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8E8CD8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: _showAdd,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECF1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              if (note.isPinned) const Icon(Icons.push_pin, color: Colors.red, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(note.content,
              style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4)),
          const SizedBox(height: 15),
          // SUBJECT TAG
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFC7CCDC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(note.subject,
                style: const TextStyle(color: Color(0xFF7E8494), fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAdd() {
    final tC = TextEditingController();
    final cC = TextEditingController();
    String tempSub = "Physics"; // Default for new note

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
            TextField(controller: tC, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: cC, decoration: const InputDecoration(labelText: "Content"), maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E8CD8),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (tC.text.isNotEmpty) {
                  setState(() {
                    _notes.add(Note(
                        id: DateTime.now().toString(),
                        title: tC.text,
                        content: cC.text,
                        subject: tempSub,
                        isPinned: false
                    ));
                  });
                  _saveNotes();
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Note", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}