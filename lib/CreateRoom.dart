import 'package:flutter/material.dart';
import 'package:flutter_chat/AppDrawer.dart';
import 'package:flutter_chat/Connector.dart' as connector;
import 'package:flutter_chat/Model.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateRoom extends StatefulWidget
{
  const CreateRoom({Key? key}) : super(key: key);

  @override
  _CreateRoom createState() => _CreateRoom();
}

class _CreateRoom extends State
{
  String _title = '';
  String _description = '';
  bool _private = false;
  double _maxPeople = 25;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(final BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text("Create Room"),
              ),
              drawer: AppDrawer(),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10
                ),
                child: SingleChildScrollView(
                  child: Row(children: [
                    TextButton(
                        onPressed: () {
                          FocusScope.of(inContext).requestFocus(FocusNode());
                          Navigator.of(inContext).pop();
                        },
                        child: const Text("Cancel")
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState == null
                              || _formKey.currentState?.validate() == false) {
                            return;
                          }

                          _formKey.currentState?.save();
                          int maxPeople = _maxPeople.truncate();
                          String userName = model.userName ?? '';
                          connector.create(
                              _title,
                              _description,
                              maxPeople,
                              _private,
                             userName,
                              (inStatus, inRoomList) {

                                if (inStatus == "created") {
                                  model.setRoomList(inRoomList);
                                  FocusScope.of(inContext).canRequestFocus;
                                  Navigator.of(inContext).pop();
                                } else {
                                  ScaffoldMessenger.of(inContext).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                        content: Text("Sorry,that room already exists"),
                                  ));
                                }
                              }
                          );
                        },
                        child: const Text("Save")
                    ),
                  ],),
                ),
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.subject),
                      title: TextFormField(
                        decoration: const InputDecoration(hintText: "Name"),
                        validator: (String? inValue) {
                          String name = inValue ?? '';

                          if (name.length > 14) {
                            return "Please enter a name no more "
                                "that 14 characters long";
                          }

                          return null;
                        },
                        onSaved: (String? inValue) {setState((){_title = inValue ?? '';});},
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: TextFormField(
                        decoration: const InputDecoration(hintText: "Description"),
                        onSaved: (String? inValue) {
                          setState((){_description = inValue ?? '';});
                        },
                      ),
                    ),
                    ListTile(
                      title: Row(children: [
                        const Text("Max\nPeople"),
                        Slider(
                            min: 0,
                            max: 99,
                            value: _maxPeople,
                            onChanged: (double inValue) {
                              setState(() {_maxPeople = inValue;});
                            }
                        )
                      ],),
                      trailing: Text(_maxPeople.toStringAsFixed(0)),
                    ),
                    ListTile(
                      title: Row(children: [
                        const Text("Private"),
                        Switch(
                            value: _private,
                            onChanged: (inValue) {setState((){_private = inValue;});}
                        )
                      ],),
                    )
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}