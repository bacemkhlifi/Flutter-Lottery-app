
import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key? key,required this.backgroundColor, required this.title, required this.onPressed})
      : super(key: key);
  final GestureTapCallback onPressed;
  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: backgroundColor,
      splashColor: Colors.greenAccent,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              maxLines: 1,
              style:FlutterFlowTheme.subtitle2.override(color: Colors.white,fontFamily: 'Lexend Deca',),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
