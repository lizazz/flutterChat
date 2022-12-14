import 'package:flutter/material.dart';
import 'package:flutter_chat/AppDrawer.dart';
import 'package:flutter_chat/Model.dart';
import 'package:scoped_model/scoped_model.dart';

class UserList extends StatelessWidget
{
  Widget build(final BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
            return Scaffold(
              drawer: AppDrawer(),
              appBar: AppBar(title: const Text("User List")),
              body: GridView.builder(
                  itemCount: model.userList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3
                  ),
                  itemBuilder: (BuildContext inContext, int inIndex) {
                    Map user = model.userList[inIndex];
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: GridTile(
                            footer: Text(user["userName"], textAlign: TextAlign.center,),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Image.asset("C:\\Users\\slavik\\StudioProjects\\flutterChat\\assets\\user.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            );
          },
        )
    );
  }
}