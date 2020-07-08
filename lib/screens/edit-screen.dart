import 'package:flutter/material.dart';

class EditScreen extends StatelessWidget {
  String name;
  int votes;

  EditScreen({this.name,this.votes});



  @override
  Widget build(BuildContext context) {

    TextEditingController nameEdit = TextEditingController(text: name);
    TextEditingController votesEdit = TextEditingController(text: votes.toString());

    return Scaffold(
      appBar: AppBar(title: Text('Edit record'),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextField(
                controller: nameEdit,
                onSubmitted: (value){
                  nameEdit.text = value;
                },
              ),
              TextField(
                controller: votesEdit,
                onSubmitted: (value){
                  votesEdit.text = value;
                },
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: () => Navigator.of(context).pop({'name' : (nameEdit.text != null)?nameEdit.text:name,'votes':(votesEdit.text != null)?int.parse(votesEdit.text):votes}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
