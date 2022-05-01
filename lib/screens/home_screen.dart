import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_lottery/screens/payment_screen/payment.dart';
import 'package:digital_lottery/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import '../utils/utils_color.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'payment_screen/credit_card_page.dart';
import 'reusable_widgets/custom_app_bar.dart';
import 'reusable_widgets/dialog_insert_rounds.dart';
import './reusable_widgets/custom_button.dart';

import 'package:flutter/material.dart';

import 'reusable_widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //get data from firebase
  Stream<QuerySnapshot> records =
      FirebaseFirestore.instance.collection("rounds").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80), child: AppBarCustom()),
      drawer: MenuDrawer(),
      body: StreamBuilder(
        stream: records,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong.!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator()));
          }
          final data = snapshot.requireData;
          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                
                int itemCount = data.size;
                int reversedIndex = itemCount - 1 - index;
                DateTime now = DateTime.now();
                DateTime enddate = DateFormat('yyyy/MM/dd | HH:mm:ss')
                    .parse(data.docs[reversedIndex]['end_date']);
                bool valDate = now.isBefore(enddate);
                var docId = snapshot.data.docs[reversedIndex].id;
                print(docId);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                  elevation: 10,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.rounded_corner, size: 60),
                        title: Text("${data.docs[reversedIndex]['name']}",
                            style: FlutterFlowTheme.title2),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Amount: ${data.docs[reversedIndex]['amount']} \$",
                              style: FlutterFlowTheme.subtitle2.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black),
                            ),
                            Text(
                              "tickets available: ${data.docs[reversedIndex]['sold_out']}/${data.docs[reversedIndex]['sold_ticket']}",
                              style: FlutterFlowTheme.subtitle2.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black),
                            ),
                            
                            Text(
                                "Start ${data.docs[reversedIndex]['start_date']} ",
                                style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black)),
                            Text("End ${data.docs[reversedIndex]['end_date']} ",
                                style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black)),
                            Text(
                              "Winners ${data.docs[reversedIndex]['winners']}  ",
                              style: FlutterFlowTheme.subtitle2.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.black),
                            )
                          ],
                        ),
                        trailing: valDate
                            ? Text("on Progress",
                                style: FlutterFlowTheme.subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black))
                            : Text("Finshed",
                                style: FlutterFlowTheme.subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors
                                        .black)), //Text("${data.docs[index]['state']}"),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          CustomButton(
                            backgroundColor: Colors.green,
                            title: 'Buy',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreditCardPage(docId :docId,
                                          amount: data.docs[index]['amount'])));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          InsertDataFromDialog(context);
          // FirebaseService().insertData(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }
}
