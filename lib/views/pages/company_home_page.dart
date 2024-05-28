import 'package:dars4/controllers/company_controller.dart';
import 'package:dars4/models/employee.dart';
import 'package:dars4/views/widgets/company_widgets.dart';
import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final _controller = CompanyContoller();

  @override
  void initState() {
    super.initState();
    _controller.getProducts();
  }

  void _editEmployee(int index) {
    final employee = _controller.list[0].employees[index];
    TextEditingController nameController =
        TextEditingController(text: employee.name);
    TextEditingController ageController =
        TextEditingController(text: employee.age.toString());
    TextEditingController positionController =
        TextEditingController(text: employee.position);
    TextEditingController skillsController =
        TextEditingController(text: employee.skills.join(', '));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Edit Employee'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                _buildTextField(ageController, 'Age', TextInputType.number),
                _buildTextField(positionController, 'Position'),
                _buildTextField(skillsController, 'Skills (comma separated)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  employee.name = nameController.text;
                  employee.age = int.parse(ageController.text);
                  employee.position = positionController.text;
                  employee.skills = skillsController.text
                      .split(',')
                      .map((skill) => skill.trim())
                      .toList();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEmployee(int index) {
    setState(() {
      _controller.deleteEmployee(index);
    });
  }

  void _addEmployee() {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController positionController = TextEditingController();
    TextEditingController skillsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Add Employee'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                _buildTextField(ageController, 'Age', TextInputType.number),
                _buildTextField(positionController, 'Position'),
                _buildTextField(skillsController, 'Skills (comma separated)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final newEmployee = Employee(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    position: positionController.text,
                    skills: skillsController.text
                        .split(',')
                        .map((skill) => skill.trim())
                        .toList(),
                  );
                  _controller.addEmployee(newEmployee);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _controller.list[0];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Company Information",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompanyWidgets(name: data.company, title: "Company:"),
                    const SizedBox(height: 10),
                    CompanyWidgets(name: data.location, title: "Location:"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Employees",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10.0),
                itemCount: data.employees.length,
                itemBuilder: (context, i) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              data.employees[i].name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Age: ${data.employees[i].age}  •  Position: ${data.employees[i].position}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => _editEmployee(i),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteEmployee(i),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.blueGrey),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "Skills",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: data.employees[i].skills
                                .map((skill) => Chip(
                                      side: BorderSide.none,
                                      label: Text(skill),
                                      backgroundColor: Colors.blueGrey,
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
