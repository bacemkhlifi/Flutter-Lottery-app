import 'dart:convert';

import 'package:digital_lottery/screens/payment/payment_card.dart';
import 'package:http/http.dart' as http;

class CheckoutPayment {
  static const _tokenUrl = "https://api.sandbox.checkout.com/tokens";
  static const _paymentUrl = "https://api.sandbox.checkout.com/payments";

  static const String _public_key =
      "pk_test_657d68d9-dd09-4371-b9a1-aaea03cdf3e6";
  static const String _private_key =
      "sk_test_2f58bfcc-01c2-4360-96fd-213c912a9929";

  static const Map<String, String> _tokenHeader = {
    'Content-Type': 'Application/json',
    'Authorization': "pk_test_29ed80f6-a48b-46f7-aa77-a2efc4264f27"
  };
  static const Map<String, String> _paymentHeader = {
    'Content-Type': 'Application/json',
    'Authorization': "sk_test_9bd329db-7242-48a8-9725-57f7ee0c1c10"
  };

  Future<String> _getToken(PaymentCard card) async {
    Map<String, String> body = {
      "type": "card",
      "number": card.number,
      "expiry_month": card.expiry_month,
      "expiry_year": card.expiry_year,
    };
    http.Response response = await http.post(Uri.parse(_tokenUrl),
        headers: _tokenHeader, body: jsonEncode(body));
    switch (response.statusCode) {
      case 201:
        var data = jsonDecode(response.body);

        return data['token'];

      default:
        print(response.statusCode);

        throw Exception("Card Invalid");
    }
  }

  Future<bool> makePayment(PaymentCard card, int amount) async {
    String token = await _getToken(card);
    print(token);
    Map<String, dynamic> body = {
      'source': {
        'type': 'token',
        'token': token,
      },
      'amount': amount,
      'currency': 'usd'
    };
    http.Response response = await http.post(Uri.parse(_paymentUrl),
        headers: _paymentHeader, body: jsonEncode(body));
    switch (response.statusCode) {
      case 201:
        var data = jsonDecode(response.body);

        return true;

      default:
        false;
        break;
    }
    return false;
  }
}
