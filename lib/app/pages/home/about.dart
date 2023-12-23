import 'package:flutter/material.dart';
import 'package:kokom/app/widgets/appbar.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/utils.dart';

class About extends StatelessWidget {
  const About({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Appbar("", backbutton: true),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "A propos",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Helper.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "Version 1.0.0 (Bêta)",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Helper.primary,
                              fontSize: 15,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => launchBrowser(""),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 18,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.share,
                              size: 20,
                              color: Helper.greyTextColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Partager avec des potes",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Helper.greyTextColor,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: const Color(0xffdfe6e9),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => launchBrowser("https://wa.me/+22890364358"),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 18,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logo_dev_outlined,
                              size: 20,
                              color: Helper.greyTextColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Proposer des modifications",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Helper.greyTextColor,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: const Color(0xffdfe6e9),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => launchBrowser("https://wa.me/+22890364358"),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 18,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logo_dev_outlined,
                              size: 20,
                              color: Helper.greyTextColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Contactez le développeur",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Helper.greyTextColor,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: const Color(0xffdfe6e9),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => launchBrowser(""),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 18,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.thumb_up_off_alt_rounded,
                              size: 20,
                              color: Helper.greyTextColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Donner nous 5 étoiles sur play store",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Helper.greyTextColor,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: const Color(0xffdfe6e9),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "Made with ❤️ in Togo.\n© Tous droits réservés, Reskode_ 2024.\n",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Helper.greyTextColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
