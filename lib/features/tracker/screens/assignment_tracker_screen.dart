import 'package:flutter/material.dart';
import '../widgets/assignment_tile.dart';
import '../../../models/assignment_model.dart';

class AssignmentTrackerScreen extends StatefulWidget {
  const AssignmentTrackerScreen({super.key});

  @override
  State<AssignmentTrackerScreen> createState() => _AssignmentTrackerScreenState();
}

class _AssignmentTrackerScreenState extends State<AssignmentTrackerScreen> {
  // 1. THE DYNAMIC LIST
  final List<Assignment> _assignments = [
    Assignment(
      title: "Lab Report - Physics",
      subject: "Physics",
      dueDate: "Due: 7 days left",
      status: AssignmentStatus.pending,
      color: Colors.red,
    ),
  ];

  // 2. CONTROLLERS FOR THE POPUP
  final TextEditingController _taskController = TextEditingController();

  // 3. LOGIC TO ADD A TASK
  void _showAddAssignment() {
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
            TextField(controller: _taskController, decoration: const InputDecoration(hintText: "Assignment Title")),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D2B45), minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                setState(() {
                  _assignments.add(Assignment(
                    title: _taskController.text,
                    subject: "General",
                    dueDate: "Due: Today",
                    status: AssignmentStatus.pending,
                    color: Colors.blue,
                  ));
                });
                _taskController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add to List", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 4. CALCULATE STATS DYNAMICALLY
    int total = _assignments.length;
    int pending = _assignments.where((a) => a.status == AssignmentStatus.pending).length;
    int completed = _assignments.where((a) => a.status == AssignmentStatus.done).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D2B45),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 60, 25, 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22), onPressed: () => Navigator.pop(context)),
                      const Text("Assignments", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))
                    ]),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.white, size: 30),
                      onPressed: _showAddAssignment,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // The stats boxes now use the variables calculated above!
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(total.toString(), "Total"),
                      _buildStatBox(pending.toString(), "Pending"),
                      _buildStatBox(completed.toString(), "Completed"),
                    ]
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: _assignments.isEmpty
                  ? const Center(child: Text("No assignments yet!"))
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _assignments.length,
                itemBuilder: (context, index) => AssignmentTile(assignment: _assignments[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String count, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}