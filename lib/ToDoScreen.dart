import 'package:app/widgets/CreateTodoButton.dart';
import 'package:app/widgets/ReadTodoButton.dart';
import 'package:flutter/material.dart';

class ToDoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: Text('Create a todo'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/taskk.png"),
                        fit: BoxFit.contain))),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(child: CreateTodoButton()),
                SizedBox(width: 20),
                Expanded(child: ReadTodoButton()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
