import 'package:flutter/material.dart';
import 'package:flutter_project/practice/item.dart';

class FormPractice extends StatefulWidget {
  const FormPractice({super.key});

  @override
  State<FormPractice> createState() => _FormPracticeState();
}

class _FormPracticeState extends State<FormPractice> {
  final nameController = TextEditingController(text: "");
  final idController = TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();

  List<Item> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Practice")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(nameController.text),
                      Text(idController.text),
                    ],
                  ),
                  Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            nameController.text = value;
                          });
                        },
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            idController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              items.add(
                                Item(
                                  name: nameController.text,
                                  id: int.tryParse(nameController.text) ?? 0,
                                ),
                              );

                              nameController.clear();
                              idController.clear();
                            });
                          }
                        },
                        child: Text("Submit"),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int count) {
                return ListTile(title: Text(items[count].name));
              },
            ),
          ],
        ),
      ),
    );
  }
}
