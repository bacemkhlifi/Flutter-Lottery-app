import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_lottery/screens/reusable_widgets/alertDialog.dart';
import 'package:digital_lottery/screens/reusable_widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils_color.dart';
import 'reusable_widgets/custom_app_bar.dart';
import 'reusable_widgets/custom_widget.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userID = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  String curentuser = FirebaseAuth.instance.currentUser!.uid;

  fetchUserInfo() async {
    FirebaseAuth getUser = await FirebaseAuth.instance;
    userID = getUser.currentUser!.uid;
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    late Image _image;
    Future getImage() async {
      var image =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        _image = image as Image;
        print('Image Path $_image');
      });
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80), child: AppBarCustom()),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(curentuser)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData != true) {
                return Center(
                    child: Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator()));
              }
              final data = snapshot.data as DocumentSnapshot;
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4")
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xff476cfb),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 180.0,
                                  height: 180.0,
                                  child: Column(
                                    children: [
                                      Image(
                                          image: NetworkImage(
                                        "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                      )),
                                      Container(
                                        height: 20,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera,
                                            size: 30.0,
                                          ),
                                          onPressed: () {
                                            getImage();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          reusableTextField(
                              snapshot.hasData
                                  ? "${data['username']}"
                                  : "username",
                              (Icons.person),
                              false,
                              TextInputType.name,
                              _nameController),
                          const SizedBox(
                            height: 10,
                          ),
                          reusableTextField(
                              snapshot.hasError == false || snapshot.hasData
                                  ? "${data['phone']}"
                                  : "Phone",
                              (Icons.phone),
                              false,
                              TextInputType.number,
                              _phoneController),
                          const SizedBox(
                            height: 10,
                          ),
                          reusableTextField(
                              snapshot.hasError == false || snapshot.hasData
                                  ? "${data['country']}"
                                  : "country",
                              (Icons.flag),
                              false,
                              TextInputType.name,
                              _countryController),
                          const SizedBox(
                            height: 20.0,
                          ),
                          firebaseUIButton(context, "update", () {
                            var collection =
                                FirebaseFirestore.instance.collection('Users');
                            collection
                                .doc(
                                    curentuser) // <-- Doc ID where data should be updated.
                                .update({
                              'username': _nameController.text == ''
                                  ? "${data['username']}"
                                  : _nameController.text,
                              'phone': _phoneController.text == ""
                                  ? "${data['phone']}"
                                  : _phoneController.text,
                              'country': _countryController.text == ""
                                  ? "${data['country']}"
                                  : _countryController.text
                            });
                            print("added successfully");
                            showMyDialog(context, "Digital Lottery",
                                "Profile was updated successfully", () {
                              Navigator.of(context).pop();
                            });
                          }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
