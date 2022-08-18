import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import "dart:io";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import 'Model.dart' show FlutterChatModel, model;
import 'Connector.dart' as connector;

class LoginDialog extends StatelessWidget
{
  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String _userName = '';
  String _password = '';

  Widget build(final BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (BuildContext inContext, Widget inChild, FlutterChatModel inModel) {
            return AlertDialog(
              content: Container(
                height: 220,
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      Text(
                        "Enter a username and password to register with the server",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(model.rootBuildContext).colorScheme.secondary,
                          fontSize : 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (String? inValue) {
                          if (inValue == null || inValue.isEmpty || inValue.length > 10) {
                            return "Please enter a username no more than 10 "
                                "characters long";
                          }

                          return null;
                        },
                        onSaved: (String? inValue) {_userName = inValue ?? '';},
                        decoration: const InputDecoration(
                            hintText: "UserName",
                            labelText: "Username"
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (String? inValue) {
                          if (inValue == null || inValue.isEmpty) {
                            return "Please enter a password";
                          }

                          return null;
                        },
                        onSaved: (String? inValue) { _password = inValue ?? '';},
                        decoration: const InputDecoration(
                            hintText: "Password",
                            labelText: "Password"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                      if (_loginFormKey.currentState != null && _loginFormKey.currentState?.validate() == true) {
                        _loginFormKey.currentState?.save();
                        connector.connectToServer(inContext, () {
                          connector.validate(
                              _userName,
                              _password,
                              (inStatus) async {
                                if (inStatus == "ok") {
                                  model.setUserName(_userName);
                                  Navigator.of(model.rootBuildContext).pop();
                                  model.setGreeting("Welcome back, $_userName");
                                }  else if (inStatus == "fail") {
                                  ScaffoldMessenger
                                      .of(model.rootBuildContext)
                                      .showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                                "Sorry, that username is already taken"
                                            )
                                        )
                                      );
                                } else if (inStatus == "created") {
                                  String path = model.docsDir?.path ?? '';
                                  var credentialsFile = File(join(
                                    path, "credentials"
                                  ));
                                  await credentialsFile.writeAsString(
                                      "$_userName============$_password"
                                  );
                                  model.setUserName(_userName);
                                  Navigator.of(model.rootBuildContext).pop();
                                  model.setGreeting(
                                      "Welcome to the server, $_userName!"
                                  );
                                }
                              }
                          );
                        });
                      }

                  },
                  child: const Text("Log In"),
                )
              ],
            );
          }
        )
    );
  }

  void validateWithStoredCredentials(final String inUserName, final String inPassword)
  {
    connector.connectToServer(model.rootBuildContext, () {
      connector.validate(inUserName, inPassword, (inStatus) {
        if (inStatus == "ok" || inStatus == "created") {
          model.setUserName(inUserName);
          model.setGreeting("Welcome back, $inUserName");
        } else if (inStatus == "fail") {
          showDialog(
              context: model.rootBuildContext,
              barrierDismissible: false,
              builder: (final BuildContext inDialogContext) =>
                  AlertDialog(
                    title: const Text("Validation failed"),
                    content: const Text(
                     "It appears that the server has "
                     "restarted and the username you last used "
                     "was subsequently taken by someone else. "
                     "\n\nPlease re-start FlutterChat and choose "
                     "a different username."
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            String path = model.docsDir?.path ?? '';
                            var credentialsFile = File(join(path, "credentials"));
                            credentialsFile.deleteSync();
                            exit(0);
                          },
                          child: Text("Ok")
                      )
                    ]
                  ),
          );
        }
      }
      );
    });
  }
}