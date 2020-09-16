import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'view_document.dart';
import 'package:example/Utilities/constants.dart';
import 'package:flutter/services.dart';

class PasswordSet extends StatefulWidget {
  @override
  _PasswordSetState createState() => _PasswordSetState();
}

class _PasswordSetState extends State<PasswordSet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4280033838),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            "Set  Password",
            style: TextStyle(
                fontSize: 25, fontFamily: "space", color: Colors.white),
          ),
          SizedBox(
            height: 60,
          ),
          Center(
            child: Container(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                title: Text('Set Passsword'),
                content: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    password = '$value';
                  },
                  cursorColor: secondaryColor,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor)),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  FlatButton(
                    onPressed: () async {
                      savepass();

                      setState(() {
                        enablepass = true;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    },
                    child: Text(
                      'Set Password',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
