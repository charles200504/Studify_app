import 'package:flutter/material.dart';
import '../../../models/assignment_model.dart';

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;
  const AssignmentTile({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(Icons.assignment, color: assignment.color),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(assignment.title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(assignment.dueDate, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
        ],
      ),
    );
  }
}