import 'dart:io';

import 'employee.dart';
import 'file_handler.dart';
import 'previous_assignment.dart';

void main() {
  Main();
}

class Main {
  List<Employee> employeeList = [];
  List<PreviousAssignment> previousAssignments = [];
  List<PreviousAssignment> generateResult = [];

  Main() {

    employeeList = FileHandler.getEmployeeData(
        filePath: 'F:\\dart\\sandagame\\Employee-List.xlsx');
    previousAssignments = FileHandler.parsePreviousAssignments(
        filePath: 'F:\\dart\\sandagame\\Secret-Santa-Game-Result-2023.xlsx');
    generateResult = FileHandler.generateResult(
        employeeList: employeeList, previousAssignments: previousAssignments);

    FileHandler.exportAssignmentsToExcel(generateResult,
        'F:\\dart\\sandagame\\Secret-Santa-Game-Result-2024.xlsx');
  }
}
