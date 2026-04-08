import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/assignment_model.dart';
import '../../../main_navigation.dart';

class AssignmentTrackerScreen extends StatefulWidget {
  const AssignmentTrackerScreen({super.key});

  @override
  State<AssignmentTrackerScreen> createState() => _AssignmentTrackerScreenState();
}

class _AssignmentTrackerScreenState extends State<AssignmentTrackerScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = true;
  String _activeFilter = "All";

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('saved_assignments');
    if (saved != null) {
      final List<dynamic> decoded = json.decode(saved);
      setState(() {
        globalAssignments = decoded.map((item) => Assignment(
          title: item['title'],
          subject: item['subject'] ?? "General",
          dueDate: DateTime.parse(item['dueDate']),
          status: AssignmentStatus.values[item['status']],
          color: Colors.blue,
        )).toList();
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(globalAssignments.map((a) => {
      'title': a.title,
      'subject': a.subject,
      'dueDate': a.dueDate.toIso8601String(),
      'status': a.status.index,
    }).toList());
    await prefs.setString('saved_assignments', encoded);
  }

  // Logic to determine display status
  String _getDisplayStatus(Assignment a) {
    if (a.status == AssignmentStatus.done) return "Done";
    if (a.dueDate.isBefore(DateTime.now())) return "Overdue";
    return "Pending";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Filter Logic
    final filteredList = globalAssignments.where((a) {
      if (_activeFilter == "All") return true;
      return _getDisplayStatus(a) == _activeFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER SECTION (Navy Gradient) ---
          Container(
            padding: const EdgeInsets.fromLTRB(15, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D2B45), Color(0xFF163E5F)],
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainNavigation())),
                        ),
                        const Text("Assignments", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.white, size: 35),
                      onPressed: _showAddAssignment,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Status Summary Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard(globalAssignments.length.toString(), "Total"),
                    _buildSummaryCard(globalAssignments.where((a) => _getDisplayStatus(a) == "Pending").length.toString(), "Pending"),
                    _buildSummaryCard(globalAssignments.where((a) => _getDisplayStatus(a) == "Done").length.toString(), "Completed"),
                  ],
                ),
              ],
            ),
          ),

          // --- FILTER CHIPS ---
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: ["All", "Pending", "Completed", "Overdue"].map((filter) {
                bool isSel = _activeFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSel,
                    onSelected: (val) => setState(() => _activeFilter = filter),
                    selectedColor: const Color(0xFF8E8CD8),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),

          // --- ASSIGNMENT LIST ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredList.length,
              itemBuilder: (context, i) => _buildAssignmentCard(filteredList[i]),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSummaryCard(String count, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: Colors.white.withAlpha(200), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment a) {
    String status = _getDisplayStatus(a);
    Color statusColor = status == "Overdue" ? Colors.red.shade300 : (status == "Done" ? Colors.green.shade400 : Colors.yellow.shade600);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC3D4EE), // Light Blue tint from your image
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF102A43))),
                    Text(a.subject, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(10)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 20, color: status == "Overdue" ? Colors.red : Colors.blue),
              const SizedBox(width: 10),
              Text(
                status == "Done" ? "Submitted on ${DateFormat('MMMM d').format(a.dueDate)}" : "Due: ${status == "Overdue" ? 'Expired' : DateFormat('MMM d').format(a.dueDate)}",
                style: TextStyle(
                  color: status == "Overdue" ? Colors.red : Colors.blue.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Toggle "Done" status
          if (status != "Done")
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() => a.status = AssignmentStatus.done);
                  _saveToStorage();
                },
                child: const Text("Mark as Done", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddAssignment() {
    // Keep your existing _showAddAssignment logic here, but ensure subject is saved!
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("New Assignment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(controller: _taskController, decoration: const InputDecoration(labelText: "Assignment Title")),
            ListTile(
              title: Text(_selectedDate == null ? "Pick Date" : DateFormat('yMMMd').format(_selectedDate!)),
              onTap: () async {
                final p = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2025), lastDate: DateTime(2030));
                if (p != null) setState(() => _selectedDate = p);
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty && _selectedDate != null) {
                  setState(() => globalAssignments.add(Assignment(
                    title: _taskController.text,
                    subject: "General",
                    dueDate: _selectedDate!,
                    status: AssignmentStatus.pending,
                    color: Colors.blue,
                  )));
                  _saveToStorage();
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}