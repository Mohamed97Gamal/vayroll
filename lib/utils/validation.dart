import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/utils/utils.dart';

class Validation {
  String? checkEmail(String value, BuildContext context) {
    value = value.trim();
    if (value.isNotEmpty == true) {
      final emailValid = EmailValidator.validate(value);
      if (emailValid)
        return null;
      else
        return "Email is not valid";
    } else {
      return context.appStrings!.requiredField;
    }
  }

  String? checkPassword(String? value, BuildContext context) {
    if (value?.isNotEmpty == true) {
      String error = "";
      if (value!.length < 8 || value.length > 20) {
        error = error + "8 to 20 characters. ";
      }
      if (!RegExp(r"^(?=.*?[a-z])").hasMatch(value)) {
        error = error + "at least one lowercase character. ";
      }
      if (!RegExp(r"^(?=.*?[A-Z])").hasMatch(value)) {
        error = error + "at least one uppercase character. ";
      }
      if (!RegExp(r"^(?=.*?[0-9])").hasMatch(value)) {
        error = error + "at least one digit. ";
      }
      if (!RegExp(r"^(?=.*?[#?!@$%^&*-])").hasMatch(value)) {
        error = error + "at least one special character. ";
      }

      return error.isEmpty ? null : "Password must be $error";
    } else {
      return context.appStrings!.requiredField;
    }
  }
}
