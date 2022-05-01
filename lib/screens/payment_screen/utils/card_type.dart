import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardTypes {
  var bestMatch;
  var matchstrength = 0;
  CardTypes() {
    bestMatch = Types[0];
  }
  //var results = [];
  final Types = [
    {
      'niceType': 'Visa',
      'type': 'visa',
      'patterns': [4],
      'gaps': [4, 8, 12],
      'lengths': [16, 18, 19],
      'code': {'name': 'CVV', 'size': 3},
      'icon': FontAwesomeIcons.ccVisa
    },
    {
      'niceType': 'Mastercard',
      'type': 'mastercard',
      'patterns': [
        [51, 55],
        [2221, 2229],
        [223, 229],
        [23, 26],
        [270, 271],
        2720
      ],
      'gaps': [4, 8, 12],
      'lengths': [16],
      'code': {'name': 'CVC', 'size': 3},
      'icon': FontAwesomeIcons.ccMastercard
    },
    {
      'niceType': 'American Express',
      'type': 'american-express',
      'patterns': [34, 37],
      'gaps': [4, 10],
      'lengths': [15],
      'code': {'name': 'CID', 'size': 4},
      'icon': FontAwesomeIcons.ccMastercard
    },
    {
      'niceType': 'Diners Club',
      'type': 'diners-club',
      'patterns': [
        [300, 305],
        36,
        38,
        39
      ],
      'gaps': [4, 10],
      'lengths': [14, 16, 19],
      'code': {'name': 'CVV', 'size': 3},
      'icon': FontAwesomeIcons.ccDinersClub
    },
    {
      'niceType': 'Discover',
      'type': 'discover',
      'patterns': [
        6011,
        [644, 649],
        65
      ],
      'gaps': [4, 8, 12],
      'lengths': [16, 19],
      'code': {'name': 'CID', 'size': 3},
      'icon': FontAwesomeIcons.ccDiscover
    },
    {
      'niceType': 'JCB',
      'type': 'jcb',
      'patterns': [
        2131,
        1800,
        [3528, 3589]
      ],
      'gaps': [4, 8, 12],
      'lengths': [16, 17, 18, 19],
      'code': {'name': 'CVV', 'size': 3},
      'icon': FontAwesomeIcons.ccJcb
    },
    {
      'niceType': 'UnionPay',
      'type': 'unionpay',
      'patterns': [
        620,
        [624, 626],
        [62100, 62182],
        [62184, 62187],
        [62185, 62197],
        [62200, 62205],
        [622010, 622999],
        622018,
        [622019, 622999],
        [62207, 62209],
        [622126, 622925],
        [623, 626],
        6270,
        6272,
        6276,
        [627700, 627779],
        [627781, 627799],
        [6282, 6289],
        6291,
        6292
      ],
      'gaps': [4, 8, 12],
      'lengths': [16, 17, 18, 19],
      'code': {'name': 'CVN', 'size': 3},
      'icon': FontAwesomeIcons.creditCard
    },
    {
      'niceType': 'Maestro',
      'type': 'maestro',
      'patterns': [
        493698,
        [500000, 506698],
        [506779, 508999],
        [56, 59],
        63,
        67,
        6
      ],
      'gaps': [4, 8, 12],
      'lengths': [12, 13, 14, 15, 16, 17, 18, 19],
      'code': {'name': 'CVC', 'size': 3},
      'icon': FontAwesomeIcons.creditCard
    },
    {
      'niceType': 'Elo',
      'type': 'elo',
      'patterns': [
        401178,
        401179,
        438935,
        457631,
        457632,
        431274,
        451416,
        457393,
        504175,
        [506699, 506778],
        [509000, 509999],
        627780,
        636297,
        636368,
        [650031, 650033],
        [650035, 650051],
        [650405, 650439],
        [650485, 650538],
        [650541, 650598],
        [650700, 650718],
        [650720, 650727],
        [650901, 650978],
        [651652, 651679],
        [655000, 655019],
        [655021, 655058]
      ],
      'gaps': [4, 8, 12],
      'lengths': [16],
      'code': {'name': 'CVE', 'size': 3},
      'icon': FontAwesomeIcons.creditCard
    },
    {
      'niceType': 'Mir',
      'type': 'mir',
      'patterns': [
        [2200, 2204]
      ],
      'gaps': [4, 8, 12],
      'lengths': [16, 17, 18, 19],
      'code': {'name': 'CVP2', 'size': 3},
      'icon': FontAwesomeIcons.creditCard
    },
    {
      'niceType': 'Hiper',
      'type': 'hiper',
      'patterns': [637095, 637568, 637599, 637609, 637612],
      'gaps': [4, 8, 12],
      'lengths': [16],
      'code': {'name': 'CVC', 'size': 3},
      'icon': FontAwesomeIcons.creditCard
    },
    {
      'niceType': 'Hipercard',
      'type': 'hipercard',
      'patterns': [60], //606282
      'gaps': [4, 8, 12],
      'lengths': [16],
      'code': {'name': 'CVC', 'size': 3},
      'icon': FontAwesomeIcons.creditCard
    }
  ];

  bool hasEnoughResultsToDetermineBestMatch(results) {
    return (results.length == 0 && results is String);
  }

  Map<String, Object> findBestmatch(String results) {
    if (hasEnoughResultsToDetermineBestMatch(results)) {
      return Types[0];
    } else {
      Map<String, Object> vbestmach;
      var cardNumber = results.replaceAll(' ', '');
      for (var i = 0; i < Types.length; i++) {
        var l = (Types[i]['patterns']) as List;
        for (var j = 0; j < l.length; j++) {
          var s = l[j].toString();
          //debugPrint('s' + (l[j] is int).toString());
          if (l[j] is int) {
            try {
              if (matchesPattern(cardNumber, l[j].toString())) {
                vbestmach = Types[i];
              }
            } catch (e) {}
          } else {
            try {
              if (matchesRange(cardNumber, l[j][0], l[j][1]))
                vbestmach = Types[i];
            } catch (e) {}
          }
        }
      }
      
        bestMatch = Types[0];
      return (bestMatch);
    }
  }

  bool matchesRange(String cardNumber, min, max) {
    var maxLengthToCheck = min.toString().length;
    var substr = cardNumber.substring(0, maxLengthToCheck);
    var integerRepresentationOfCardNumber = int.tryParse(substr);

    var vmin = int.tryParse(min.toString().substring(0, substr.length));
    var vmax = int.tryParse(max.toString().substring(0, substr.length));
    var re = ((integerRepresentationOfCardNumber! >= vmin!) &&
        (integerRepresentationOfCardNumber <= vmax!));
    if (re && matchstrength <= substr.length) {
      matchstrength = substr.length;
      return re;
    } else
      return false;
  }

  bool matchesPattern(String cardNumber, patternx) {
    var pattern = patternx.toString();
    if (cardNumber.length > pattern.length) {
      var t = cardNumber.substring(0, pattern.length);
      var re = (pattern == t);
      if (re && matchstrength <= t.length) {
        matchstrength = t.length;
        return re;
      } else
        return false;
    } else {
      var t = pattern.substring(0, cardNumber.length);
      var re = (cardNumber == t);
      if (re && matchstrength <= t.length) {
        matchstrength = t.length;
        return re;
      } else
        return false;
    }
  }
}
