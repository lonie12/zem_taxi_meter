import 'package:flutter/material.dart';
import 'package:kokom/helper/helper.dart';

class Go extends StatelessWidget {
  const Go({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Helper.primary,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Text(
          'GO',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
