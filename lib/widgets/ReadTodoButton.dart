import 'package:app/ReadTodoScreen.dart';
import 'package:flutter/material.dart';

class ReadTodoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () {
          _navigateToReadTodoScreen(context);
        },
        child: Text("List Todo"),
        color: Color(0xFF242E66),
        textColor: Colors.white);
  }

  _navigateToReadTodoScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReadTodoScreen()),
    );
  }
}
