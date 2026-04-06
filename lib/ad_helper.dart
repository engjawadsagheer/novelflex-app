import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/6300978111';
      return 'ca-app-pub-1911709436746841/3122571956';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1911709436746841/5731022022';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1911709436746841/2544536195";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1911709436746841/2234630145";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1911709436746841/2234630145";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}