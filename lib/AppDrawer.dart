import 'package:flutter/material.dart';
import 'package:flutter_chat/Connector.dart' as connector;
import 'Model.dart' show FlutterChatModel, model;
import 'package:scoped_model/scoped_model.dart';

class AppDrawer extends StatelessWidget
{
  Widget build(final BuildContext inContext)
  {
    return ScopedModel<FlutterChatModel>(
        model: model, 
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (BuildContext inContext,Widget inChild, FlutterChatModel inModel) {
            return Drawer(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, 
                          image: AssetImage("C:\\Users\\slavik\\StudioProjects\\flutterChat\\assets\\drawback01.jpg")
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Center(
                            child: Text(
                                model.userName ?? "",
                                style: const TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                        subtitle: Center(
                          child: Text(
                            model.currentRoomName, 
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                     padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                     child: ListTile(
                       leading: const Icon(Icons.list),
                       title: const Text("Lobby"),
                       onTap: () {
                         Navigator.of(inContext).pushNamedAndRemoveUntil(
                             '/Lobby', 
                             ModalRoute.withName("/")
                         );
                         connector.listRooms((inRoomList){model.setRoomList(inRoomList);});
                       },
                     ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text("Room"),
                      onTap: () {
                        Navigator.of(inContext).pushNamedAndRemoveUntil(
                            '/Room',
                            ModalRoute.withName("/")
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text("UserList"),
                      onTap: () {
                        Navigator.of(inContext).pushNamedAndRemoveUntil(
                            '/UserList',
                            ModalRoute.withName("/")
                        );
                        connector.listUsers((inUserList){model.setUserList(inUserList);});
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        )
    );
  }
}