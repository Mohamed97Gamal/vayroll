import 'dart:math';

class VPayImages {
  static const String walkthrough_01 = "assets/pictures/images/walkthrough_01.svg";
  static const String walkthrough_02 = "assets/pictures/images/walkthrough_02.svg";
  static const String doc = "assets/pictures/images/doc.svg";
  static const String metaphor = "assets/pictures/images/metaphor.svg";
  static const String fingerprint_block = "assets/pictures/images/fingerprint_block.svg";
  static const String image_gallery = "assets/pictures/images/image_gallery.svg";
  static const String verify = "assets/pictures/images/verify.svg";
  static const String key = "assets/pictures/images/key.svg";
  static const String forget_password = "assets/pictures/images/forget_password.svg";
  static const String splach_Image = "assets/pictures/images/splachIcon.svg";
  static const String login_Image = "assets/pictures/images/loginIcon.svg";
  static const String check_Mail = "assets/pictures/images/checkMail.svg";
  static const String home_header = "assets/pictures/images/home_header_bg.svg";
  static const String avatar = "assets/pictures/images/avatar.png";
  static const String empty = "assets/pictures/images/empty.svg";
  static const String balloons = "assets/pictures/images/balloons.svg";
  static const List<String> stillErrorOptions = [
    "assets/pictures/images/still_error1.svg",
    "assets/pictures/images/still_error2.svg",
    "assets/pictures/images/still_error3.svg",
    "assets/pictures/images/still_error4.svg",
  ];

  static String get stillError {
    final _random = new Random();
    return stillErrorOptions[_random.nextInt(stillErrorOptions.length)];
  }
}
