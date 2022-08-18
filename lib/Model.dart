import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import "dart:io";

class FlutterChatModel extends Model
{
  late BuildContext rootBuildContext;
  Directory? docsDir;
  String greeting = "";
  String? userName = "";
  static const String DEFAULT_ROOM_NAME = "Not currently in a room";
  String currentRoomName = DEFAULT_ROOM_NAME;
  List currentRoomUserList = [];
  bool currentRoomEnabled = false;
  List currentRoomMessages = [];
  List roomList = [];
  List userList = [];
  bool creatorFunctionsEnabled= false;
  Map roomInvites = {};

  void setGreeting(final String inGreeting)
  {
    greeting = inGreeting;
    notifyListeners();
  }

  void setUserName(String inUserName)
  {
    userName = inUserName;
    notifyListeners();
  }

  void setCurrentRoomName(String inCurrentRoomName)
  {
    currentRoomName = inCurrentRoomName;
    notifyListeners();
  }

  void setCreatorFunctionsEnabled(bool inCreatorFunctionEnabled)
  {
    creatorFunctionsEnabled = inCreatorFunctionEnabled;
    notifyListeners();
  }

  void setCurrentRoomEnabled(bool inCurrentRoomEnabled)
  {
    currentRoomEnabled = inCurrentRoomEnabled;
    notifyListeners();
  }

  void addMessage(final String inUserName, final String inMessage)
  {
    currentRoomMessages.add({"userName" : inUserName, "message" : inMessage});
    notifyListeners();
  }

  void setRoomList(final Map inRoomList)
  {
    List rooms = [];

    for (String roomName in inRoomList.keys) {
      Map room = inRoomList[roomName];
      rooms.add(room);
    }

    roomList = rooms;

    notifyListeners();
  }

  void setUserList(final Map inUserList)
  {
    List users = [];

    for (String userName in inUserList.keys) {
      Map user = inUserList[userName];
      users.add(user);
    }

    userList = users;
    notifyListeners();
  }

  void setCurrentRoomUserList(final Map inCurrentRoomUserList)
  {
    List users = [];

    for (String userName in inCurrentRoomUserList.keys) {
      Map user = inCurrentRoomUserList[userName];
      users.add(user);
    }

    currentRoomUserList = users;

    notifyListeners();
  }

  void addRoomInvite(final String inRoomName)
  {
    roomInvites[inRoomName] = true;
  }

  void removeRoomInvite(final String inRoomName)
  {
    roomInvites.remove(inRoomName);
  }

  void clearCurrentRoomMessages()
  {
    currentRoomMessages = [];
  }

  BuildContext getRootBuildContext()
  {
    return rootBuildContext;
  }
}

FlutterChatModel model = FlutterChatModel();