import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import '../../../models/assignment_model.dart';

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;

  const AssignmentTile({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    // Logic to determine if it is overdue
    final bool isOverdue = assignment.status != AssignmentStatus.done &&
        assignment.dueDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15), // Adjusted padding to fit content better
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.assignment_outlined,
            color: isOverdue ? Colors.red : assignment.color,
            size: 28,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                // FIX: Use DateFormat to convert DateTime to String
                Text(
                  isOverdue
                      ? "Overdue: ${DateFormat('MMM d').format(assignment.dueDate)}"
                      : "Due: ${DateFormat('MMM d').format(assignment.dueDate)}",
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Add a small status indicator
          if (assignment.status == AssignmentStatus.done)
            const Icon(Icons.check_circle, color: Colors.green, size: 20)
        ],
      ),
    );
  }
}
