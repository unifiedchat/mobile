import "package:get/get.dart";

class CounterController extends GetxController {
  var twitchCounter = 0.obs;
  var youtubeCounter = 0.obs;
  var otherCounter = 0.obs;

  void incrementOtherCounter() {
    otherCounter++;
  }

  void incrementTwitchCounter() {
    twitchCounter++;
  }

  void incrementYoutubeCounter() {
    youtubeCounter++;
  }
}
