import 'package:flutter/material.dart';
import '../theme/os_colors.dart';

class OsUtils {
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical':
        return OsColors.red;
      case 'High':
        return OsColors.orange;
      case 'Medium':
        return OsColors.blue;
      default:
        return OsColors.green;
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'Open':
      case 'In-Progress':
      case 'In Progress':
      case 'Active':
        return OsColors.blue;
      case 'Review':
      case 'Pending':
      case 'Draft':
        return OsColors.amber;
      case 'Blocked':
      case 'At Risk':
        return OsColors.red;
      case 'Completed':
      case 'Resolved':
      case 'Closed':
      case 'Achieved':
      case 'Submitted':
        return OsColors.green;
      default:
        return OsColors.slate;
    }
  }

  static Color getTargetColor(String status) {
    switch (status) {
      case 'Achieved':
      case 'On Track':
        return OsColors.green;
      case 'Behind':
        return OsColors.amber;
      default:
        return OsColors.red;
    }
  }
}
