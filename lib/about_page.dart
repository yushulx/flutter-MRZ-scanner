import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'global.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = Container(
      padding: const EdgeInsets.only(top: 50, left: 39, bottom: 5, right: 39),
      child: Row(
        children: [
          Image.asset(
            "images/logo-dlr.png",
            width: MediaQuery.of(context).size.width - 80,
          ),
        ],
      ),
    );

    final version = Container(
      height: 40,
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Text(
        'App Version 2.2.20',
        style: TextStyle(color: colorText),
      ),
    );

    final description = Container(
        padding: const EdgeInsets.only(left: 44, right: 39),
        child: const Center(
          child: Text(
            'Recognizes MRZ code & extracts data from 1D-codes, passports, and visas. Supports TD-1, TD-2, TD-3, MRV-A, and MRV-B standards.',
            style: TextStyle(color: Colors.white, wordSpacing: 2),
            textAlign: TextAlign.center,
          ),
        ));

    final button = Container(
      padding: const EdgeInsets.only(top: 48, left: 91, right: 91, bottom: 69),
      child: MaterialButton(
        minWidth: 208,
        height: 44,
        color: colorOrange,
        onPressed: () {
          launchUrlString('https://www.dynamsoft.com/downloads/');
        },
        child: const Text(
          'GET FREE TRIAL SDK',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    final links = Container(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 13, bottom: 15),
            child: InkWell(
                onTap: () {
                  launchUrlString(
                      'https://www.dynamsoft.com/label-recognition/overview/');
                },
                child: Text(
                  'Dynamsoft Label Recognizer overview >',
                  style: TextStyle(color: colorOrange),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13, bottom: 15),
            child: InkWell(
                onTap: () {
                  launchUrlString('https://www.dynamsoft.com/company/about/');
                },
                child: Text(
                  'Contact us >',
                  style: TextStyle(color: colorOrange),
                )),
          ),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('About',
              style: TextStyle(
                fontSize: 22,
                color: colorTitle,
              )),
          centerTitle: true,
          backgroundColor: colorMainTheme,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            title,
            version,
            description,
            button,
            links,
          ],
        )));
  }
}
