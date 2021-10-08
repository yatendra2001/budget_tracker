import 'package:flutter/material.dart';

Color homeColor = const Color(0xff2D4059);
Color transportColor = const Color(0xff1b633e);
Color foodColor = const Color(0xffF07B3F);
Color othersColor = const Color(0xffFFD460);
String kExpenseImageUrl = 'assets/icons/expense.png';
String kIncomeImageUrl = 'assets/icons/income.png';

TextStyle kHintTextStyle = const TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

TextStyle kLabelStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

BoxDecoration kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
