import 'package:test/test.dart';
import '../employee.dart';
import '../file_handler.dart';
import '../previous_assignment.dart';

void main() {
  test('Secret Santa assignments meet constraints', () {
     final employees = [
      Employee(name: 'Hamish Murray', email: 'hamish.murray@acme.com'),
      Employee(name: 'Layla Graham', email: 'layla.graham@acme.com'),
    ];

     final previousAssignments = [
      PreviousAssignment(
        employeeName: 'Hamish Murray',
        employeeEmail: 'hamish.murray@acme.com',
        secretChildName: 'Benjamin Collins',
        secretChildEmail: 'benjamin.collins@acme.com',
      ),
      PreviousAssignment(
        employeeName: 'Layla Graham',
        employeeEmail: 'layla.graham@acme.com',
        secretChildName: 'Piper Stewart',
        secretChildEmail: 'piper.stewart@acme.com',
      ),
    ];

    final assignments = FileHandler.generateResult(
      previousAssignments: previousAssignments,
      employeeList: employees,
    );

    expect(assignments.length, employees.length);

    for (final assignment in assignments) {
      expect(assignment.employeeEmail != assignment.secretChildEmail, true);
    }

    for (final assignment in assignments) {
      final prevAssignment = previousAssignments.firstWhere(
        (pa) => pa.employeeEmail == assignment.employeeEmail,
      );
      expect(assignment.secretChildEmail != prevAssignment.secretChildEmail, true);
    }
  });
}
