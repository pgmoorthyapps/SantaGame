class Employee {
  String name;
  String email;

  Employee({
    required this.email,
    required this.name,
  });

  // factory Employee.fromMap(Map<String, String> map){
  //   return Employee(name: map['Employee_Name']!, email: map['Employee_EmailID']!);
  // }
}
