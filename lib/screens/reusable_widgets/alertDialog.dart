import 'package:flutter/material.dart';

Future<void> showMyDialog(context,String title, String message,onPressed) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Digital Lottery'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                 Text(title),
                Text(message.split(']').last)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: onPressed(),
            ),
          ],
        );
      });
}
