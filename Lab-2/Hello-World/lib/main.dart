import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Layouts"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Row Widget",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home),
                Icon(Icons.star),
                Icon(Icons.person),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Stack Widget",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  color: Color(0xfff806a7),
                ),
                Container(
                  width: 60,
                  height: 60,
                  color: Color(0xffc8ff00),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
