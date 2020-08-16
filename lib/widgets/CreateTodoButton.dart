import 'package:app/DetailTodoScreen.dart';
import 'package:flutter/material.dart';

class CreateTodoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () {
          _navigateToCreateTodoScreen(context);
        },
        child: Text('Create a todo'),
        color: Color(0xFF242E66),
        textColor: Colors.white);
  }

  // A method that launches the SelectionScreen and awaits the
  // result from Navigator.pop.
  _navigateToCreateTodoScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => DetailTodoScreen()),
    );
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
  }
}
