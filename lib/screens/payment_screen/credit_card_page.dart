import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_lottery/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import '../payment/checkout.dart';
import '../payment/payment_card.dart';
import '../reusable_widgets/alertDialog.dart';
import '../reusable_widgets/custom_app_bar.dart';
import './utils/profile_tile.dart';
import './utils/uidata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './credit_card_bloc.dart';
import 'package:flare_flutter/flare_actor.dart';

class CreditCardPage extends StatefulWidget {
  CreditCardPage({Key? key, required this.docId, required this.amount})
      : super(key: key);
  final int amount;
  final String docId;

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  bool isDataAvailable = true;
  bool isLoading = false;
  TextEditingController cardNumber = TextEditingController();

  String card = "*";
  int soldoutupdated = 0;

  var typeinitialValue = {
    'niceType': 'Visa',
    'type': 'visa',
    'patterns': [4],
    'gaps': [4, 8, 12],
    'lengths': [16, 18, 19],
    'code': {'name': 'CVV', 'size': 3},
    'icon': FontAwesomeIcons.ccVisa
  };

  late BuildContext _context;

  CreditCardBloc cardBloc = CreditCardBloc();

  // TextEditingController card_number = TextEditingController();
  MaskedTextController ccMask =
      MaskedTextController(mask: "0000 0000 0000 0000");

  MaskedTextController expMask = MaskedTextController(mask: "00/00");

  Widget bodyData() => SingleChildScrollView(
        child: isLoading
            ? Container(
                alignment: Alignment.center,
                child: Center(child: CircularProgressIndicator()))
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[creditCardWidget(), fillEntries()],
              ),
      );

  Widget creditCardWidget() {
    var deviceSize = MediaQuery.of(_context).size;
    return Container(
      height: deviceSize.height * 0.3,
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: FlareActor(
                  "assets/images/ccbackground.flr",
                  animation: "Untitled",
                  fit: BoxFit.fill,
                ),
                //decoration: BoxDecoration(gradient: LinearGradient(colors: UIData.kitGradients)),
              ),
              Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "assets/images/map.png",
                  fit: BoxFit.cover,
                ),
              ),
              MediaQuery.of(_context).orientation == Orientation.portrait
                  ? cardEntries()
                  : FittedBox(
                      child: cardEntries(),
                    ),
              Positioned(
                right: 10.0,
                top: 10.0,
                child: StreamBuilder<Map<String, Object>>(
                    stream: cardBloc.ccTypeOutputStream,
                    initialData: typeinitialValue,
                    builder: (context, snapshots) {
                      return (Icon(
                        snapshots.hasData
                            ? FontAwesomeIcons.creditCard
                            : FontAwesomeIcons.creditCard,
                        size: 30.0,
                        color: Colors.white,
                      ));
                    }),
              ),
              Positioned(
                right: 10.0,
                bottom: 10.0,
                child: StreamBuilder<String>(
                  stream: cardBloc.nameOutputStream,
                  initialData: "Your Name",
                  builder: (context, snapshot) => Text(
                    snapshot.hasData ? snapshot.data! : "Your Name",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: UIData.ralewayFont,
                        fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardEntries() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<String>(
                stream: cardBloc.ccOutputStream,
                initialData: "**** **** **** ****",
                builder: (context, snapshot) {
                  snapshot.hasData ? ccMask.updateText(snapshot.data!) : null;
                  return Text(
                    snapshot.hasData ? snapshot.data! : "**** **** **** ****",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<String>(
                    stream: cardBloc.expOutputStream,
                    initialData: "MM/YY",
                    builder: (context, snapshot) {
                      snapshot.hasData
                          ? expMask.updateText(snapshot.data!)
                          : null;
                      return ProfileTile(
                        textColor: Colors.white,
                        title: "Expiry",
                        subtitle: snapshot.hasData ? snapshot.data : "MM/YY",
                      );
                    }),
                SizedBox(
                  width: 30.0,
                ),
                StreamBuilder<String>(
                    stream: cardBloc.cvvOutputStream,
                    initialData: "***",
                    builder: (context, snapshot) => ProfileTile(
                          textColor: Colors.white,
                          title: "CVV",
                          subtitle: snapshot.hasData ? snapshot.data : "***",
                        )),
              ],
            ),
          ],
        ),
      );

  Widget fillEntries() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: ccMask,
              keyboardType: TextInputType.number,
              maxLength: 19,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) {
                cardBloc.ccInputSink.add(ccMask.text);
                card = ccMask.text[ccMask.text.length - 1];
              },
              decoration: InputDecoration(
                  labelText: "Credit Card Number",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder()),
            ),
            TextField(
              controller: expMask,
              keyboardType: TextInputType.number,
              maxLength: 5,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => cardBloc.expInputSink.add(expMask.text),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "MM/YY",
                  border: OutlineInputBorder()),
            ),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 3,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => cardBloc.cvvInputSink.add(out),
              decoration: InputDecoration(
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  labelText: "CVV",
                  border: OutlineInputBorder()),
            ),
            TextField(
              keyboardType: TextInputType.text,
              maxLength: 20,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => cardBloc.nameInputSink.add(out),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "Name on card",
                  border: OutlineInputBorder()),
            ),
          ],
        ),
      );

  Widget floatingBar(int amount, String ccMask, String expMask) => Ink(
        decoration: ShapeDecoration(
            shape: StadiumBorder(),
            gradient: LinearGradient(colors: UIData.kitGradients)),
        child: FloatingActionButton.extended(
          onPressed: () async {
            print("/////////");
            String carta = ccMask.replaceAll(' ', '');
            String expMonth = expMask.split("/")[0];
            String expYear = expMask.split("/")[1];

            PaymentCard card = PaymentCard(carta, expMonth, expYear);
            CheckoutPayment checkout = CheckoutPayment();

            checkout.makePayment(card, amount * 100).then((value) {
              showSuccessDialog();

              var db = FirebaseFirestore.instance
                  .collection("rounds")
                  .doc(widget.docId.toString());
              db.get().then((DocumentSnapshot ds) {
                if (ds.exists) {
                  var soldout = (ds.data() as dynamic)['sold_out'];
                  // print(ds.data());
                  //add user to round
                  final String uid = FirebaseAuth.instance.currentUser!.uid;
                  List participants_ids =
                      (ds.data() as dynamic)['participants_ids'];
                  participants_ids.add(uid.toString());
                  db.update({"participants_ids": participants_ids});

                  // ticket sold out;
                  db.update({"sold_out": soldout - 1});

                  //add ticket to user
                  var dbUser = FirebaseFirestore.instance
                      .collection("Users")
                      .doc(uid.toString());

                  dbUser.get().then((DocumentSnapshot ds) {
                    List tickets_ids = (ds.data() as dynamic)['tickets_ids'];
                    tickets_ids.add(widget.docId);
                    dbUser.update({
                      "tickets_ids":tickets_ids
                    });
                  });
                  //end adding tickt to user
                } else {
                  print("data doesnt exists");
                }
              });
            }).catchError((onError) {
              print("failed");

              showFailedDialog();
            });
          },
          backgroundColor: Colors.transparent,
          icon: Icon(
            FontAwesomeIcons.amazonPay,
            color: Colors.white,
          ),
          label: Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    _context = context;
    cardBloc = CreditCardBloc();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80), child: AppBarCustom()),
      body: bodyData(),
      floatingActionButton:
          floatingBar(widget.amount, ccMask.text, expMask.text),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  successTicket() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ProfileTile(
                  title: "Thank You!",
                  textColor: Colors.green,
                  subtitle: "Your transaction was successful",
                ),
                ListTile(
                  title: Text("Date"),
                  subtitle: Text(
                      "${DateFormat('yyyy/MM/dd ').format(DateTime.now())}"),
                  trailing:
                      Text("${DateFormat('HH:mm:ss').format(DateTime.now())}"),
                ),
                ListTile(
                    title: Text("Lottery Direct"),
                    subtitle: Text("bacemkhlifi001@gmail.com"),
                    trailing: CircleAvatar(
                      radius: 20.0,
                    )),
                ListTile(
                  title: Text("Amount"),
                  subtitle: Text("\$${widget.amount}"),
                  trailing: Text("Completed"),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0.0,
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.ccJcb,
                      color: Colors.green,
                    ),
                    title: Text("Credit/Debit Card"),
                    subtitle: Text("JCB Card ending ***" + card.toString()),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  void showSuccessDialog() {
    goToDialog();
  }

  void showFailedDialog() {
    goToDialogFailed();
  }

  goToDialog() {
    showDialog(
        context: _context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successTicket(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.lightGreen.shade900,
                      child: FlareActor(
                        "assets/images/ds.flr",
                        animation: "Untitled",
                        fit: BoxFit.fill,
                      ),
                      onPressed: () {
                        Center(child: CircularProgressIndicator());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  failedTicket() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ProfileTile(
                  title: "Error!",
                  textColor: Colors.red,
                  subtitle: "Your transaction was failed",
                ),
                ListTile(
                  title: Text("Date"),
                  subtitle: Text(
                      "${DateFormat('yyyy/MM/dd ').format(DateTime.now())}"),
                  trailing:
                      Text("${DateFormat('HH:mm:ss').format(DateTime.now())}"),
                ),
                ListTile(
                    title: Text("Lottery Direct"),
                    subtitle: Text("bacemkhlifi001@gmail.com"),
                    trailing: CircleAvatar(
                      radius: 20.0,
                    )),
                ListTile(
                  title: Text("Amount"),
                  subtitle: Text("\$${widget.amount}"),
                  trailing: Text("Failed"),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0.0,
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.ccJcb,
                      color: Colors.red,
                    ),
                    title: Text("Credit/Debit Card"),
                    subtitle: Text("JCB Card ending ***" + card.toString()),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  goToDialogFailed() {
    showDialog(
        context: _context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    failedTicket(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: FlareActor(
                        "assets/images/ds.flr",
                        animation: "Untitled",
                        fit: BoxFit.fill,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                    )
                  ],
                ),
              ),
            ));
  }
}
