import 'package:flutter/material.dart';

import '../payment/checkout.dart';
import '../payment/payment_card.dart';
import '../reusable_widgets/custom_app_bar.dart';
import '../reusable_widgets/drawer.dart';

class Payment extends StatelessWidget {
   Payment({Key? key,required this.amount}) : super(key: key);
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80), child: AppBarCustom()),
        drawer: MenuDrawer(),
        body: TextButton(
          child: Text("payment"),
          onPressed: () {
            PaymentCard card = PaymentCard('4543474002249996', '10', '2026');
            CheckoutPayment checkout = CheckoutPayment();
            checkout.makePayment(card,amount*100);
          },
        ));
  }
}
