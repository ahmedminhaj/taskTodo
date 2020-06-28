import 'package:flutter/material.dart';
import 'package:todolist/model/todo_item.dart';
import 'package:todolist/util/database_helper.dart';
import 'package:todolist/util/date_formatted.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];
  String currentDate = dateFormatted();

  @override
  void initState() {
    super.initState();
    _readTodoList();
  }

  _readTodoList() async {
    List items = await db.getAllItem();
    items.forEach((item) {
      setState(() {
        _itemList.add(ToDoItem.map(item));
      });
    });
  }

  _deleteTodo(int id, int index) async {
    debugPrint("Dleted");
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  void _updateTodo(int index, ToDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }

  _updateTodoHandler(ToDoItem item, int index) async {
    var alert = AlertDialog(
      title: Text("Update ToDo"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                helperText: "${item.itemName}",
                icon: Icon(Icons.update),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            ToDoItem updatedTodo = ToDoItem.fromMap({
              "itemName": _textEditingController.text,
              "dateCreated": dateFormatted(),
              "id": item.id,
            });
            _updateTodo(index, item);
            await db.updateItem(updatedTodo);
            setState(() {
              _readTodoList();
            });
            Navigator.pop(context);
            _textEditingController.clear();
          },
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _addTodoItem(String text) async {
    _textEditingController.clear();
    ToDoItem toDoItem = ToDoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(toDoItem);
    ToDoItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });
    print("Todo item ID: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[500],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 45.0, left: 30.0),
            child: Text(
              "$currentDate",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0, left: 30.0),
            child: Text(
              "Let's Plan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 4.0
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: _itemList[index],
                    onLongPress: () =>
                        _updateTodoHandler(_itemList[index], index),
                    trailing: Listener(
                      key: Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red[800],
                      ),
                      onPointerDown: (pointerEvent) =>
                          _deleteTodo(_itemList[index].id, index),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1.0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Todo",
        backgroundColor: Colors.white,
        child: ListTile(
          title: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        onPressed: _showFromDialog,
      ),
    );
  }

  void _showFromDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                helperText: "eg. Get ready for work",
                icon: Icon(Icons.note_add),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _addTodoItem(_textEditingController.text);
            _textEditingController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
