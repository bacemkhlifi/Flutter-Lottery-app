import 'dart:async';
import 'package:flutter/widgets.dart';
import './utils/card_type.dart';

class CreditCardBloc {
  final ccInputController = StreamController<String>();
  final expInputController = StreamController<String>();
  final cvvInputController = StreamController<String>();
  final nameInputController = StreamController<String>();
  final cardTypes = CardTypes();
  Sink<String> get ccInputSink => ccInputController.sink;
  Sink<String> get expInputSink => expInputController.sink;
  Sink<String> get cvvInputSink => cvvInputController.sink;
  Sink<String> get nameInputSink => nameInputController.sink;

  final ccOutputController = StreamController<String>();
  final expOutputController = StreamController<String>();
  final cvvOutputController = StreamController<String>();
  final nameOutputController = StreamController<String>();
  final ccTypeOutputController = StreamController<Map<String, Object>>();

  Stream<String> get ccOutputStream => ccOutputController.stream;
  Stream<String> get expOutputStream => expOutputController.stream;
  Stream<String> get cvvOutputStream => cvvOutputController.stream;
  Stream<String> get nameOutputStream => nameOutputController.stream;
  Stream<Map<String, Object>> get ccTypeOutputStream =>
      ccTypeOutputController.stream;

  CreditCardBloc() {
    ccInputController.stream.listen(onCCInput);
    expInputController.stream.listen(onExpInput);
    cvvInputController.stream.listen(onCvvInput);
    nameInputController.stream.listen(onNameInput);
  }

  onCCInput(String input) {
    var c = cardTypes.findBestmatch(input);
    debugPrint('$c');
    ccTypeOutputController.add(c);
    ccOutputController.add(input.toString());
  }

  onExpInput(String input) {
    expOutputController.add(input);
  }

  onCvvInput(String input) {
    cvvOutputController.add(input);
  }

  onNameInput(String input) {
    nameOutputController.add(input);
  }

  void ccFormat(String s) {
    ccInputSink.add(s);
  }

  void dispose() {
    ccInputController.close();
    cvvInputController.close();
    expInputController.close();
    nameInputController.close();
  }
}
