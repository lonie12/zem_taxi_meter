import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static bool kDebugMode = true;

  static Color darkColor = const Color(0xFF212121);

  static Color kPrimaryColor = const Color(0xFF000000);
  static List<String> daysFr = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];
  // static Color primary = Color(0XFF1929FF);
  static Color primary = const Color(0XFF24292E);
  static Color blue = const Color(0XFFFFB534);
  // static Color primary = Color(0xFFD23F57);
  static Color otherPrimaryColor = const Color(0xFF1C38FF);
  static Color secondary = const Color(0xFFDF2218);
  // static Color secondary = warning;
  static Color danger = const Color(0xFFF40A23);
  static Color warning = const Color(0xFFF4AA0A);
  static Color purple = const Color.fromARGB(255, 136, 13, 213);
  static Color success = const Color.fromARGB(255, 56, 206, 51);
  static Color textColor = const Color.fromRGBO(43, 52, 69, 1);

  static Color greyColor = const Color(0xFF8D8D8E);

  static const double defaultPadding = 14.0;

  static Color get greyTextColor =>
      const Color.fromARGB(255, 53, 52, 52).withOpacity(0.7);

  static const String apiKey = "";

  static const Color primaryColor = Color(0XFF043AFE);
  static const Color secondColor = Color(0XFF24292E);
  static const Color textColorLightTheme = Color(0xFF0D0D0E);

  static const Color secondaryColor80LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor60LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor40LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor10LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor5LightTheme = Color(0xFFF8F8F8);

  static String appicon = "assets/images/vooom.png";

  static String onboard0 = "assets/images/position.json";
  static String onboard1 = "assets/images/bluetooth.json";
  static String onboard2 = "assets/images/cast.json";

  static String welcome = "assets/images/Yad.svg";

  static String playstoreurl =
      "https://play.google.com/store/search?q=reskode_&c=apps";
  static String supabaseurl = "";
  static String supabasekey = "";

  //
  static String exitwarning = "Appuyer encore une fois pour quitter";

  static String apiUrl = "";
  static String officialUrl = "";
  // static String fileManagerUrl = "http://cdn.file-manager.youaps.com/";

  static const String lorem =
      "Lorem, ipsum dolor sit amet consectetur adipisicing elit. Excepturi minus reiciendis cum impedit error eius ullam consequuntur dolore sit necessitatibus. Et quis repellat ex reiciendis sapiente. Accusantium neque maxime odio.";

  static parseDateToMMDDYYYY(DateTime? date) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    if (date is DateTime) {
      return formatter.format(date);
    } else {
      return date;
    }
  }

  static Codec<String, String> stringToBase64 = utf8.fuse(base64);
}
