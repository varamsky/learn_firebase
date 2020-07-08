import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_firebase/screens/edit-screen.dart';

// testing dummySnapshot
final List<Map<String, dynamic>> dummySnapshot = [
  {'name': 'Filip', 'votes':25},
  {'name': 'Harry', 'votes':46},
  {'name': 'Danny', 'votes':99},
  {'name': 'Richard', 'votes':85},
  {'name': 'Ron', 'votes':23},
];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Firebase'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              // getting reference to firebase collection
              CollectionReference reference = Firestore.instance.collection('baby');
              _addRecord(reference);
              },
          )
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context){
    //return buildList(context,dummySnapshot);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (BuildContext context, snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();

        return buildList(context, snapshot.data.documents);
      },

    );
  }

  Widget buildList(BuildContext context,List<DocumentSnapshot> snapshot){
    return ListView(
      children:
        snapshot.map((data) => buildListItem(context, data)).toList());
  }

  Widget buildListItem(BuildContext context,DocumentSnapshot documentSnapshot){
    // creating a new Record object
    Record record = Record.fromSnapshot(documentSnapshot);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),side: BorderSide(style: BorderStyle.solid)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text((record.name != null)?record.name:'null'),
                trailing: Text(record.votes.toString()),
                onTap: () {
                  //This creates problem of race-condition i.e., if 2 people use app to increase data at the same time only one of the votes will be counted!!
                  //record.reference.updateData({'votes': record.votes + 1});

                  //this is better as it doesn't lead to race-condition
                  record.reference.updateData({'votes': FieldValue.increment(2)});

                  //this is better as it doesn't lead to race-condition. IT IS BETTER THAN ABOVE AND USED IN COMPLEX APPS.
                  /*Firestore.instance.runTransaction((transaction) async {

                    final freshSnapshot = await transaction.get(record.reference);

                    final fresh = Record.fromSnapshot(freshSnapshot);

                    await transaction
                        .update(record.reference, {'votes': fresh.votes + 1});
                  });*/

                  //print(record);
                }
              ),
            ),

            // edit record
            IconButton(icon: Icon(Icons.edit), onPressed: () => _editRecord(record)),

            // delete record
            IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: () => _deleteRecord(record)),
          ],
        ),
      ),
    );

  }

  _editRecord(Record record) async{
    // navigating to editing screen
    Map<String, dynamic> newData = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EditScreen(name: record.name,votes: record.votes,)));

    if (newData != null) {
      if(newData['name'] != record.name || newData['votes'] != record.votes)
        // updating data to firebase document
        record.reference.updateData({'name': newData['name'],'votes': newData['votes']});
    }
  }

  _deleteRecord(Record record) async{
    // deleting record from firebase document
    record.reference.delete();
  }

  void _addRecord(CollectionReference reference) async{
    // navigating to editing screen
    Map<String, dynamic> newData = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EditScreen(name: 'null',votes: 0,)));

    if(newData != null)
      // adding new data to firebase document
      // if a record with the particular newData['name'] already exists then the available record is updated
      reference.document(newData['name']).setData(newData);
  }

}

// a model class for the record on firebase
class Record{
  final String name;
  final int votes;
  final DocumentReference reference; // reference to the firebase document

  // This is a named constructor
  Record.fromMap(Map map,{this.reference}):this.name = map['name'],this.votes = map['votes']; // after : is the initializer list. It runs before the constructor body begins to execute.

  // This is a named constructor
  Record.fromSnapshot(DocumentSnapshot snapshot):this.fromMap(snapshot.data,reference: snapshot.reference); // after : is the initializer list. It runs before the constructor body begins to execute.

  @override
  String toString() {
    return 'Record{name: $name, votes: $votes}';
  }

}


