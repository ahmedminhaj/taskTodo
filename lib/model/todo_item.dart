import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  //bool _done;
  int _id;

  ToDoItem(
    this._itemName,
    this._dateCreated,
    //this._done,
  );

  ToDoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    //this._done = obj["done"];
    this._id = obj["id"];
  }

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  //bool get done => _done;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['itemName'] = _itemName;
    map['dateCreated'] = _dateCreated;
    //map['done'] = _done;

    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  ToDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    //this._done = map["done"];
    this._id = map['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _itemName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 24,
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 5.0),
          //   child: Text(
          //     "Added on: $_dateCreated",
          //     style: TextStyle(
          //       color: Colors.black54,
          //       fontSize: 14,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
