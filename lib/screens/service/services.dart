import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_lottery/screens/reusable_widgets/alertDialog.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  //insert data
  void insertData(context,name,amount,soldTicket,winners) async {
    var db = FirebaseFirestore.instance.collection("rounds");
    Map<String, dynamic> rounds = {
      "name": name,
      "sold_out":soldTicket,
      "amount": amount ,
      "start_date": DateFormat('yyyy/MM/dd | HH:mm:ss').format(DateTime.now()),
      "end_date": DateFormat('yyyy/MM/dd | HH:mm:ss')
          .format(DateTime.now().add(const Duration(hours: 24))),
      "sold_ticket": soldTicket,
      "participants_ids":[],
      "winners": winners
    };
    db.add(rounds).then((value) =>
        showMyDialog(context, "Success", "Round was added successfully", () {
          Navigator.of(context).pop();
        }));
    //get data
  }
}
