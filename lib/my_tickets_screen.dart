import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_lottery/utils/utils_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'screens/flutter_flow/flutter_flow_theme.dart';
import 'screens/reusable_widgets/custom_app_bar.dart';
import 'screens/reusable_widgets/custom_button.dart';
import 'screens/reusable_widgets/drawer.dart';

class MyTickets extends StatefulWidget {
  MyTickets({Key? key}) : super(key: key);

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  //get data from firebase
  Stream<QuerySnapshot> records =
      FirebaseFirestore.instance.collection("rounds").snapshots();
  //get tickets ids
  String uid = FirebaseAuth.instance.currentUser!.uid;

  List<String> list_tickets_ids = [];
  @override
  Widget build(BuildContext context) {
    //print("enaaaaaa");
    // print(uid);
    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 80,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
      title: const Text('My Tickets '),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add_alert),
          tooltip: 'Notifications enabled',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications enabled')));
          },
        ),
        IconButton(
          icon: const Icon(Icons.navigate_next),
          tooltip: 'Go to the next page',
          onPressed: () {},
        ),
      ],
    ),
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
          FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .get()
              .then((DocumentSnapshot ds) {
            var tickets_ids =
                (ds.data() as dynamic)['tickets_ids'].cast<String>();
            setState(() {
              list_tickets_ids = tickets_ids;
            });
          });
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
                // print(docId);

                return list_tickets_ids.contains(docId)
                    ? Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Color.fromARGB(255, 255, 255, 255),
                        elevation: 10,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading:
                                  const Icon(Icons.rounded_corner, size: 60),
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
                                      style: FlutterFlowTheme.bodyText1
                                          .override(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.black)),
                                  Text(
                                      "End ${data.docs[reversedIndex]['end_date']} ",
                                      style: FlutterFlowTheme.bodyText1
                                          .override(
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
                                      style: FlutterFlowTheme.subtitle2
                                          .override(
                                              fontFamily: 'Lexend Deca',
                                              color: Colors.black))
                                  : Text("Finshed",
                                      style: FlutterFlowTheme.subtitle2.override(
                                          fontFamily: 'Lexend Deca',
                                          color: Colors
                                              .black)), //Text("${data.docs[index]['state']}"),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(""),
                      );
              });
        },
      ),
    );
  }
}
