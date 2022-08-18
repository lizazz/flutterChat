import 'package:flutter/material.dart';
import 'package:flutter_chat/AppDrawer.dart';
import 'package:flutter_chat/Connector.dart' as connector;
import 'Model.dart' show FlutterChatModel, model;
import 'package:scoped_model/scoped_model.dart';

class Lobby extends StatelessWidget
{
  Widget build(final BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
            return Scaffold(
              drawer: AppDrawer(),
              appBar: AppBar(title: const Text("Lobby")),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(inContext, "/CreateRoom");
                },
              ),
              body: model.roomList.isEmpty ?
                const Center(
                  child: Text("There are no rooms yet. Why not add one?")
                ) :
                ListView.builder(
                    itemCount: model.roomList.length,
                    itemBuilder: (BuildContext inBuildContext, int inIndex) {
                      Map room = model.roomList[inIndex];
                      String roomName = room["roomName"];
                      return Column(
                        children: [
                          ListTile(
                            leading: room['private'] == "true" ?
                             Image.asset("C:\\Users\\slavik\\StudioProjects\\flutterChat\\assets\\private.png") :
                             Image.asset("C:\\Users\\slavik\\StudioProjects\\flutterChat\\assets\\public.png"),
                            title: Text(roomName),
                            subtitle: Text(room["description"] ?? room['adminName']),
                            onTap: () {
                              String creator = room['creator'] ?? room['userName'];

                              if (room["private"] == 'true' &&
                                  !model.roomInvites.containsKey(roomName) &&
                                  (creator != model.userName)
                              ) {
                                ScaffoldMessenger.of(inBuildContext).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                            "Sorry, you can't "
                                            "enter a private room without an invite"
                                        )
                                    )
                                );
                              } else {
                                String userName = model.userName ?? '';
                                connector.join(
                                    userName,
                                    roomName,
                                    (inStatus, inRoomDescriptor) {
                                      if (inStatus == "joined") {
                                        model.setCurrentRoomName(inRoomDescriptor['roomName']);
                                        model.setCurrentRoomUserList(inRoomDescriptor['users']);
                                        model.setCurrentRoomEnabled(true);
                                        model.clearCurrentRoomMessages();

                                        if (inRoomDescriptor['creator'] == model.userName || inRoomDescriptor['userName'] == model.userName) {
                                          model.setCreatorFunctionsEnabled(true);
                                        } else {
                                          model.setCreatorFunctionsEnabled(false);
                                        }

                                        Navigator.pushNamed(inContext, "/Room");
                                      }  else if (inStatus == 'full') {
                                        ScaffoldMessenger.of(inBuildContext).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 2),
                                              content: Text("Sorry, that room is full")
                                            )
                                        );
                                      }
                                    }
                                );
                              }
                            },
                          )
                        ],
                      );
                    }
                ),
            );
          },
        )
    );
  }
}