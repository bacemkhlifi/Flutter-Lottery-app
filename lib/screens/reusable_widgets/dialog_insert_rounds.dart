import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_theme.dart';

import '../service/services.dart';
import 'custom_button.dart';

Future<void> InsertDataFromDialog(context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        TextEditingController nameRoundController = TextEditingController();
        TextEditingController amount = TextEditingController();
        TextEditingController numberoftickets = TextEditingController();
        TextEditingController winners = TextEditingController();

        return AlertDialog(
          title: const Text('Digital Lottery'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
               const Text("Add a new round"),
                Padding(
                    padding:const  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Column(
                      children: [
                        custom_text_field(
                            nameRoundController, 'Round Name', 'name'),
                            const SizedBox(height:5),
                        custom_text_field(amount, 'Price', 'price'),const SizedBox(height:5),
                        custom_text_field(numberoftickets, 'Tickets',
                            'Enter the number of tickets'),const SizedBox(height:5),
                        custom_text_field(
                            winners, 'Winners', 'Enter the number of winners')
                      ],
                    ))
              ],
            ),
          ),
          actions: <Widget>[
          CustomButton(  onPressed: () {  Navigator.pop(context); }, title: 'Cancel', backgroundColor: Colors.red,),
           CustomButton(  onPressed: () {  FirebaseService().insertData(context, nameRoundController.text,
                    int.parse(amount.text), int.parse(numberoftickets.text), int.parse(winners.text));
                Navigator.pop(context); }, title: 'Save', backgroundColor: Colors.green,),
       
           
          ],
        );
      });
}

TextField custom_text_field(customController, title, hint_text) {
  return TextField(
    controller: customController,
    obscureText: false,
    decoration: InputDecoration(
      labelText: title,
      labelStyle: FlutterFlowTheme.bodyText1.override(
        fontFamily: 'Lexend Deca',
        color: Color(0x98FFFFFF),
      ),
      hintText: hint_text,
      hintStyle: FlutterFlowTheme.bodyText1.override(
        fontFamily: 'Lexend Deca',
        color: Color(0x98FFFFFF),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.darkBackground,
      contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
    ),
    style: FlutterFlowTheme.bodyText1.override(
      fontFamily: 'Lexend Deca',
      color: FlutterFlowTheme.textColor,
    ),
  );
}
