import 'package:flutter/material.dart';
import 'package:app/model/Todo.dart';
import 'package:app/db/database_provider.dart';
import 'package:app/DetailTodoScreen.dart';
import 'package:share/share.dart';

class ReadTodoScreen extends StatefulWidget {
  @override
  _ReadTodoScreenState createState() => _ReadTodoScreenState();
}

class _ReadTodoScreenState extends State<ReadTodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Saved Todos'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: DatabaseHelper.instance.retrieveTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Text(
                    snapshot.data[index].id.toString(),
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.green),
                  ),
                  subtitle: Text(snapshot.data[index].content ?? "None"),
                  onTap: () => _navigateToDetail(context, snapshot.data[index]),
                  onLongPress: () {
                    Share.share(snapshot.data[index].content);
                  },
                  trailing: Wrap(
                    spacing: 10, // space between two icons
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Share.share(snapshot.data[index].content);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteTodo(snapshot.data[index]);
                          setState(() {});
                        },
                      ),
                      // icon-2
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Oops!");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

_deleteTodo(Todo todo) {
  DatabaseHelper.instance.deleteTodo(todo.id);
}

_navigateToDetail(BuildContext context, Todo todo) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DetailTodoScreen(todo: todo)),
  );
}
