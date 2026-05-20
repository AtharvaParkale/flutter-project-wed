import 'package:flutter/material.dart';

class LayoutPractice extends StatefulWidget {
  const LayoutPractice({super.key});

  @override
  State<LayoutPractice> createState() => _LayoutPracticeState();
}

class _LayoutPracticeState extends State<LayoutPractice> {
  final List<Item> items = [
    Item(name: "Item 1", id: 1),
    Item(name: "Item 2", id: 2),
    Item(name: "Item 3", id: 2),
    Item(name: "Item 4", id: 2),
    Item(name: "Item 5", id: 2),
    Item(name: "Item 6", id: 2),
    Item(name: "Item 7", id: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Practice")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ColoredBox(
              color: Colors.yellowAccent,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int count) {
                  return ListTile(title: Text(items[count].name));
                },
              ),
            ),
            Container(
              color: Colors.redAccent,
              height: 100, // Required for horizontal ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int count) {
                  return SizedBox(
                    width: 120,
                    child: ListTile(title: Text(items[count].name)),
                  );
                },
              ),
            ),

            ColoredBox(
              color: Colors.blue,
              child: GridView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int count) {
                  return ListTile(title: Text(items[count].name));
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final int id;

  Item({required this.name, required this.id});
}
