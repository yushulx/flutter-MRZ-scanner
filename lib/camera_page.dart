import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ocr_sdk/mrz_line.dart';
import 'package:flutter_ocr_sdk/mrz_parser.dart';

import 'camera/camera_manager.dart';
import 'global.dart';
import 'dart:math';

import 'result_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late CameraManager _mobileCamera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _mobileCamera = CameraManager(
        context: context,
        cbRefreshUi: refreshUI,
        cbIsMounted: isMounted,
        cbNavigation: navigation);
    _mobileCamera.initState();
  }

  void navigation(dynamic order) {
    // Navigator.of(context).pop();
    List<MrzLine> area = order;
    var information;
    if (area.length == 2) {
      information = MRZ.parseTwoLines(area[0].text, area[1].text);
      information.lines = '${area[0].text}\n${area[1].text}';
    } else if (area.length == 3) {
      information =
          MRZ.parseThreeLines(area[0].text, area[1].text, area[2].text);
      information.lines = '${area[0].text}\n${area[1].text}\n${area[2].text}';
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(information: information),
        ));
  }

  void refreshUI() {
    setState(() {});
  }

  bool isMounted() {
    return mounted;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mobileCamera.stopVideo();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_mobileCamera.controller == null ||
        !_mobileCamera.controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _mobileCamera.controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _mobileCamera.toggleCamera(0);
    }
  }

  List<Widget> createCameraPreview() {
    if (_mobileCamera.controller != null && _mobileCamera.previewSize != null) {
      return [
        SizedBox(
            width: MediaQuery.of(context).size.width <
                    MediaQuery.of(context).size.height
                ? _mobileCamera.previewSize!.height
                : _mobileCamera.previewSize!.width,
            height: MediaQuery.of(context).size.width <
                    MediaQuery.of(context).size.height
                ? _mobileCamera.previewSize!.width
                : _mobileCamera.previewSize!.height,
            child: _mobileCamera.getPreview()),
        Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0,
          left: 0.0,
          child: createOverlay(
            _mobileCamera.mrzLines,
          ),
        ),
      ];
    } else {
      return [const CircularProgressIndicator()];
    }
  }

  @override
  Widget build(BuildContext context) {
    const hint = Text(
        'P<CANAMAN<<RITA<TANIA<<<<<<<<<<<<<<<<<<<<<<<\nERE82721<9CAN8412070M2405252<<<<<<<<<<<<<<08',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ));

    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'MRZ Scanner',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Stack(
            children: <Widget>[
              if (_mobileCamera.controller != null &&
                  _mobileCamera.previewSize != null)
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Stack(
                      children: createCameraPreview(),
                    ),
                  ),
                ),
              const Positioned(
                left: 122,
                right: 122,
                bottom: 28,
                child: Text('Powered by Dynamsoft',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
              // Positioned(
              //   top: 100,
              //   left: MediaQuery.of(context).size.width / 4,
              //   right: MediaQuery.of(context).size.width / 4,
              //   bottom: 100,
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Colors.white,
              //         width: 3.0,
              //       ),
              //       borderRadius: BorderRadius.circular(10.0),
              //       color: Colors.transparent,
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: (MediaQuery.of(context).size.height - 41 * 3) / 2,
                left: !kIsWeb && (Platform.isAndroid)
                    ? 0
                    : (MediaQuery.of(context).size.width - 41 * 9) / 2,
                child: !kIsWeb && (Platform.isAndroid)
                    ? Transform.rotate(
                        angle: pi / 2,
                        child: hint,
                      )
                    : hint,
              ),
            ],
          ),
        ));
  }
}
