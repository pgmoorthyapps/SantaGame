import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'employee.dart';
import 'package:excel/excel.dart';

import 'previous_assignment.dart';

class FileHandler {
  static List<Employee> getEmployeeData({required String filePath}) {
    // try {
      List<Employee> employeeList = [];
      File file = File(filePath);
      
      if (!file.existsSync()) throw Exception('File not found: $filePath');

      Uint8List fileContent = file.readAsBytesSync();
      var excel = Excel.decodeBytes(fileContent);
      for (var e in excel.tables.keys) {
        final sheet = excel.tables[e];

        var rows = sheet!.rows.sublist(1, sheet.rows.length - 1);

        for (var s in rows) {
          String name = s.first!.value.toString();
          String email = s[1]!.value.toString();
          // print('name $name, email $email');
          employeeList.add(Employee(email: email, name: name));
        }
      }
      return employeeList;
    // } catch (e) {
    //   throw Exception("Error reading employee data: $e");
    // }
  }

  static List<PreviousAssignment> parsePreviousAssignments(
      {required String filePath}) {
    try {
      List<PreviousAssignment> previousAssignments = [];
      File file = File(filePath);
      Uint8List fileContent = file.readAsBytesSync();
      var excel = Excel.decodeBytes(fileContent);

      for (var sheetName in excel.tables.keys) {
        final sheet = excel.tables[sheetName];
        if (sheet != null) {
          var rows = sheet.rows.sublist(1);
          for (var row in rows) {
            String employeeName = row[0]?.value?.toString() ?? '';
            String employeeEmail = row[1]?.value?.toString() ?? '';
            String secretChildName = row[2]?.value?.toString() ?? '';
            String secretChildEmail = row[3]?.value?.toString() ?? '';

            if (employeeName.isNotEmpty &&
                employeeEmail.isNotEmpty &&
                secretChildName.isNotEmpty &&
                secretChildEmail.isNotEmpty) {
              previousAssignments.add(PreviousAssignment(
                employeeName: employeeName,
                employeeEmail: employeeEmail,
                secretChildName: secretChildName,
                secretChildEmail: secretChildEmail,
              ));
            }
          }
        }
      }
      return previousAssignments;
    } catch (e) {
      throw Exception("Error reading previous assignments: $e");
    }
  }

  static List<PreviousAssignment> generateResult({
    required List<PreviousAssignment> previousAssignments,
    required List<Employee> employeeList,
  }) {
    List<PreviousAssignment> assignedEmp = [];
    List<Employee> employeeListTemp = List.from(employeeList);

    for (var e in employeeList) {
      final invalidEmp = [
        e.email,
        ...previousAssignments
            .where((a) => a.employeeEmail == e.email)
            .map((b) => b.secretChildEmail),
      ];

      final validEmp =
          employeeListTemp.where((d) => !invalidEmp.contains(d.email)).toList();

      if (validEmp.isEmpty) {
        throw Exception("No valid recipient available for ${e.name}");
      }

      final selectedEmp = validEmp[Random().nextInt(validEmp.length)];

      assignedEmp.add(PreviousAssignment(
        employeeName: e.name,
        employeeEmail: e.email,
        secretChildName: selectedEmp.name,
        secretChildEmail: selectedEmp.email,
      ));

      employeeListTemp.remove(selectedEmp);
    }

    return assignedEmp;
  }

  static void exportAssignmentsToExcel(
    List<PreviousAssignment> assignmentResult,
    String outputPath,
  ) {
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['SecretSantaAssignments'];

      sheet.appendRow([
        TextCellValue("Employee_Name"),
        TextCellValue("Employee_EmailID"),
        TextCellValue("Secret_Child_Name"),
        TextCellValue("Secret_Child_EmailID")
      ]);

      for (var assignment in assignmentResult) {
        sheet.appendRow([
          TextCellValue(assignment.employeeName),
          TextCellValue(assignment.employeeEmail),
          TextCellValue(assignment.secretChildName),
          TextCellValue(assignment.secretChildEmail)
        ]);
      }

      File(outputPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.save()!);
    } catch (e) {
      print(e.toString());
    }
  }
}
