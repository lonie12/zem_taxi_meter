// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:url_launcher/url_launcher.dart' as u;

void showSnackbar(context, dynamic a) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(a.toString()),
  ));
}

// Calculate distance between points
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  var R = 6371; // Radius of the Earth in kilometers
  final dLat = (lat2 - lat1) * (Math.pi / 180);
  final dLon = (lon2 - lon1) * (Math.pi / 180);
  final a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1 * (Math.pi / 180)) *
          Math.cos(lat2 * (Math.pi / 180)) *
          Math.sin(dLon / 2) *
          Math.sin(dLon / 2);
  final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  final distance = R * c;
  return distance;
  // return distance.toFixed(3);
}

// Launc browser
dynamic launchBrowser(url) async {
  try {
    Uri uri = Uri.parse(url);
    if (await u.canLaunchUrl(uri)) {
      await u.launchUrl(uri, mode: u.LaunchMode.externalNonBrowserApplication);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

int getYear() {
  DateTime now = DateTime.now();
  return now.year;
}
