import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Model.dart' show FlutterChatModel, model;
import 'Home.dart';
import 'Lobby.dart';
import 'CreateRoom.dart';
import 'UserList.dart';
import 'Room.dart';

class FlutterChatMain extends StatelessWidget
{
  @override
  Widget build(final BuildContext inContext)
  {
    model.rootBuildContext = inContext;

    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
            return MaterialApp(
              initialRoute: "/",
              routes: {
                 "/Lobby" : (screenContext) => Lobby(),
                 "/Room" : (screenContext) => Room(),
                 "/UserList" : (screenContext) => UserList(),
                 "/CreateRoom" : (screenContext) => CreateRoom()
              },
              home: Home(),
            );
          },
        )
    );
  }
}