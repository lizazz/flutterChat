import 'package:flutter/material.dart';
import "dart:io";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import 'Model.dart' show FlutterChatModel, model;
import 'FlutterChatMain.dart';
import 'LoginDialog.dart';

void main() {
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    model.docsDir = docsDir;
    String path = model.docsDir?.path ?? "";

    var credentialsFile = File(join(path, "credentials"));
    var exists = await credentialsFile.exists();

    var credentials;

    if (exists) {
      credentials = await credentialsFile.readAsString();
    }

    if (exists) {
      List credParts = credentials.split("============");
      LoginDialog().validateWithStoredCredentials(credParts[0], credParts[1]);
    } else {
      await showDialog(
          context: model.rootBuildContext,
          builder: (BuildContext inDialogContext) {
            return LoginDialog();
          }
      );
    }
  }

  runApp(FlutterChat());
  startMeUp();
}

class FlutterChat extends StatelessWidget
{
  @override
  Widget build(final BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(body: FlutterChatMain()),
    );
  }
}
