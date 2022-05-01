import 'package:digital_lottery/my_tickets_screen.dart';
import 'package:digital_lottery/screens/home_screen.dart';
import 'package:digital_lottery/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



import '../../utils/utils_color.dart';
import '../signin_screen.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
          
       
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                   
                  ),
                  child: Icon(Icons.person),
                  margin: EdgeInsets.all(5),
                  width: 50,
                  height: 50,
                  // child: Transform(
                  //     alignment: Alignment.center,
                  //     child: FittedBox(
                  //       fit: BoxFit.cover,
                  //       child: Image.file(File(imagePath)),
                  //     ),
                  //     transform: Matrix4.rotationY(mirror)),
                ),
                const Text(
                  'Hi !',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading:const Icon(Icons.home_sharp),
            onTap: () {
               Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            leading:const Icon(Icons.account_box),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          ListTile(
            title: const Text('Wallet'),
            leading: const Icon(Icons.wallet_travel),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
         
          ListTile(
            title: const Text('My Tickets'),
            leading:const  Icon(Icons.credit_card),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyTickets()));
            },
          ),
          ListTile(
            title: const Text('History'),
            leading:const  Icon(Icons.history),
            onTap: () {
             Navigator.pop;
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            leading:const  Icon(Icons.policy),
            onTap: () {
             Navigator.pop;
            },
          ),
          ListTile(
            title: const Text(' Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
            },
          ),
        ],
      ),
    );
  }
}
