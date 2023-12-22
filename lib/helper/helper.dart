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

  static const String apiKey = "AIzaSyBdE4MKTM_Sy0_oL05KpnY8sf8LAR3_M_U";

  static const Color primaryColor = Color(0XFF043AFE);
  static const Color secondColor = Color(0XFF24292E);
  static const Color textColorLightTheme = Color(0xFF0D0D0E);

  static const Color secondaryColor80LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor60LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor40LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor10LightTheme = Color(0xFFF8F8F8);
  static const Color secondaryColor5LightTheme = Color(0xFFF8F8F8);

  static String googleApiKey = "AIzaSyBdE4MKTM_Sy0_oL05KpnY8sf8LAR3_M_U";
  static String appicon = "assets/images/icon.png";

  /// Navigation buttom icons
  static String bactivity = "assets/images/b-activity.svg";
  static String bhome = "assets/images/b-home.svg";
  static String bmessages = "assets/images/b-messages.svg";
  static String buser = "assets/images/b-user.svg";
  static String bwallet = "assets/images/b-wallet.svg";

  static String bstore = "assets/images/bstore.svg";
  static String bsearch = "assets/images/bsearch.svg";
  static String bsearch1 = "assets/images/bsearch1.svg";
  static String bcart = "assets/images/bcart.svg";
  static String border = "assets/images/border.svg";

  ///

  static String aleft = "assets/images/alignleft.svg";
  static String userwallet = "assets/images/user_wallet.svg";
  static String kokom = "assets/images/kokom.png";
  static String maplenou = "assets/images/maplenou.png";
  static String domla = "assets/images/dom_la.png";
  static String banner_2 = "assets/images/banner_2.jpeg";
  static String banner_3 = "assets/images/banner_3.jpeg";
  static String banner_4 = "assets/images/banner_4.jpeg";
  static String banner_5 = "assets/images/banner_5.jpeg";
  static String kokomindex = "assets/images/kokomindex.jpg";
  static String moto = "assets/images/moto.png";
  static String jakarta = "assets/images/jakarta.png";
  static String careco = "assets/images/car_eco.png";
  static String carconfort = "assets/images/car_confort.png";
  static String headerback = "assets/images/headerback.png";
  static String abonnement = "assets/images/abonnement.jpg";
  static String promo1 = "assets/images/promo1.webp";
  static String promo2 = "assets/images/promo2.webp";
  static String pin = "assets/images/pin.png";
  static String sos = "assets/images/appsos.png";
  static String scooter = "assets/images/scooter.png";
  static String messages = "assets/images/messages.svg";
  static String whatsapp = "assets/images/whatsapp.svg";
  static String calling = "assets/images/calling.svg";
  static String wallet = "assets/images/wallet.svg";
  static String logo = "assets/images/logo.png";
  static String onboard1 = "assets/images/kokom2.svg";
  static String onboard2 = "assets/images/maplenou2.svg";
  static String onboard3 = "assets/images/Dom-la2.svg";
  static String otp = "assets/images/otp.png";
  static String welcome = "assets/images/Yad.svg";
  static String radio = "assets/images/radio.png";
  static String cdinaryCloudName = "djyasogm6";
  static String cdinaryCloudPreset = "albhbcs0";
  static String location = "assets/images/location.png";
  static String midjopay = "assets/images/midjopay.png";
  static String bell = "assets/images/bell.png";
  static String walletic = "assets/images/wallet.png";
  static String history = "assets/images/history.png";
  static String lottiesuccess = "assets/images/success.json";
  static String lottienotification = "assets/images/notification.json";
  static String lottietransaction = "assets/images/transaction.json";
  static String lottieactivity = "assets/images/activity.json";
  static String lottieupgrade = "assets/images/upgrade.json";
  static String lottielocation = "assets/images/location.json";
  static String lottiehome = "assets/images/home.json";
  static String lottienophone = "assets/images/nophone.json";
  static String agbedouvi = "assets/images/agbedouvi.webp";
  static String carvert = "assets/images/car_vert.png";
  static String porigin = "assets/images/porigin.png";
  static String pposition = "assets/images/pposition.png";
  static String pdestination = "assets/images/pdestination.png";
  static String playstoreurl =
      "https://play.google.com/store/search?q=midjo&c=apps";
  static String supabaseurl = "https://ghsanqqshrpagjvcopsi.supabase.co";
  static String supabasekey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdoc2FucXFzaHJwYWdqdmNvcHNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU5MjEzMjcsImV4cCI6MjAxMTQ5NzMyN30.AuAwI70mWWCAqW8pcRxLvf3ryLmCEb5EDNZRvk5LX5k";

  //
  static String exitwarning = "Appuyer encore une fois pour quitter";

  static String apiUrl = "https://midjoapi-8ef74092ad6d.herokuapp.com";
  //  static String apiUrl = "https://api.midjo-africa.com";
  static String officialUrl = "https://midjo-africa.com";
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
