import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          title: Text('IMAGE WIDGET'),
        ),
        body: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "assets/image1.jpg",
            width: 150,
            height: 150,
          ),
          SizedBox(height: 40),
          Text(
            "Hello Flutter",
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color(0xffff03c1)),
          )
        ]))),
  ));
}
