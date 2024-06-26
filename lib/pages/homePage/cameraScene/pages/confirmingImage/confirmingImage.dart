import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:collect_the_world/footer/cameraButton.dart';
import 'package:collect_the_world/generatedCode/api.dart';
import 'package:collect_the_world/globals/globalScripts/systems/itemToFindUpdater.dart';
import 'package:collect_the_world/globals/globalWidgets/header/dailyStreak.dart';
import 'package:collect_the_world/pages/homePage/cameraScene/confirm/widgets/confettiWidget.dart';
import 'package:collect_the_world/pages/homePage/cameraScene/pages/confirmingImage/displayRewards.dart';
import 'package:collect_the_world/pages/homePage/cameraScene/pages/confirmingImage/rewardWidgets/header/rewardTopWidget.dart';
import 'package:confetti/confetti.dart';
import 'package:http/http.dart' as http;
import 'package:collect_the_world/globals/globalScripts/systems/authClient.dart'
    as authclie;
import 'package:collect_the_world/globals/globalScripts/systems/imageUploader.dart'
    as imageUploader;
import 'package:collect_the_world/background/backgroundGradiant.dart';
import 'package:collect_the_world/footer/footerMain.dart';
import 'package:collect_the_world/globals/globalWidgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import "package:collect_the_world/globals/globalScripts/globals.dart"
    as globals;


class ConfirmingimagePage extends StatefulWidget {
  final String searchBarContent;
  final bool isDescription;
  final String description;

  const ConfirmingimagePage(
      {super.key,
      required this.searchBarContent,
      this.isDescription = false,
      this.description = ""});

  @override
  ConfirmingimagePageState createState() => ConfirmingimagePageState();
}

class ConfirmingimagePageState extends State<ConfirmingimagePage> {
  bool isLoading = true;
  late ConfettiController confettiController;

  int totalReward = 0;
  int baseReward = 0;
  int remainingSkips = 0;
  int streak = 0;
  double multi = 0;
  int dailyQuestProgress = 0;
  int timesCollected = 0;
  int dailyReward = 0;

  @override
  void initState() {
    super.initState();
    makeHttpCall();

    confettiController =
        ConfettiController(duration: const Duration(milliseconds: 50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const BackgroundGradiant(),
        Center(
          child: Loadingwidget(isVisible: isLoading),
        ),
        Center(
          child: CustomConfettiWidget(confettiController: confettiController),
        ),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(),
            RewardTopWidget(
                streak: streak, score: totalReward, skips: remainingSkips),
            DisplayRewards(
              baseReward: baseReward,
              multi: multi,
              dailyQuestProgress: dailyQuestProgress,
              timesCollected: timesCollected,
              dailyReward: dailyReward,
            ),
            const SizedBox(),
          ],
        )),
        const Footer(),
      ]),
      floatingActionButton: const CameraButtonFooter(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void makeHttpCall() async {
    if (widget.isDescription) {
      descriptionEndpoint();
      return;
    }
    var image = await globals.image!.readAsBytes();
    var url = Uri.parse(
        "https://ctw.coflnet.com/api/images/${widget.searchBarContent}");

    var request = http.MultipartRequest("POST", url);
    var token = (await authclie.Authclient().tokenRequest())!;

    request.headers["Authorization"] = 'Bearer $token';

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      image,
      filename: 'image.jpg',
    ));
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseString);
      print(jsonResponse);
      setState(() {
        baseReward = jsonResponse["rewards"]["imageBonus"] ?? 69;
        totalReward = jsonResponse["rewards"]["total"] ?? 69;
        multi = (jsonResponse["rewards"]["multiplier"] == 0)
            ? 1.0
            : jsonResponse["rewards"]["multiplier"] ?? 69;
      });
      successfullReqeust();
    } else {
      print(
          'Failed to upload image. Status code: ${await response.stream.bytesToString()}\n${response.statusCode}');
    }
  }

  void successfullReqeust() {
    confettiController.play();
    setState(() {
      isLoading = false;
    });
  }

  void descriptionEndpoint() async {
    if (!imageUploader.imageUploader().finnishedLoading) {
      sleep(const Duration(milliseconds: 300));
      descriptionEndpoint();
    }

    var token = (await authclie.Authclient().tokenRequest())!;
    var authclient = HttpBearerAuth();
    authclient.accessToken = token;
    final client = ApiClient(
        basePath: "https://ctw.coflnet.com", authentication: authclient);

    final apiInstance = ImageApi(client);

    try {
      final result = await apiInstance.addDescription(
          imageUploader.imageUploader().objectId,
          body: widget.description);
      confettiController.play();
    } catch (e) {
      print('Exception when calling ImageApi->addDescription: $e\n');
    }
  }
}
