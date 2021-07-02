import 'package:flutter/cupertino.dart';

import 'math_utils.dart';

/* --------------------------
|         Validators        |
-------------------------- */
String? validateNotEmpty({required String text, required String field, required String errorMessage, bool formNotSubmitted = false, String? currentlyFocusedField, Function()? successFunction, Function()? errorFunction}) {
  // formNotSubmitted must be used when using errorText instead of validator
  // formNotSubmitted defaults to false, so it is not needed when using validator
  if (formNotSubmitted) {
    /* if user did not submit form yet */
    return null;
  }

  // error case
  if (text.isEmpty) {
    if (errorFunction!=null) errorFunction();
    //if (currentlyFocusedField != null && currentlyFocusedField!=field) return errorMessage;
    return errorMessage;
  }

  // normal submission
  if (successFunction!=null) successFunction();
  return null;
}

String? validatePassword({required String password, required int minLength, Function()? successFunction, Function()? errorFunction}) {
  // error case
  if (password.length < minLength) {
    if (errorFunction!=null) errorFunction();
    return "Enter a password with at least $minLength characters";
  }

  // normal submission
  if (successFunction!=null) successFunction();
  return null;
}

List<Object> validatePhoneNumber({required String phoneCountryDialCode, required String phoneNumber}) {
  Map<String, Map<String, Object>> phoneCountryDialCodePropertiesMap = {
    // Portugal properties
    '+351': {
      'countryName': 'Portugal',
      'numberLength': 9,
      'firstMobileDigitsList': ['91', '92', '93', '96']
    },
  };

  // country code is not supported
  if (!phoneCountryDialCodePropertiesMap.containsKey(phoneCountryDialCode)) {
    //String phoneCountryDialCodePropertiesMapKeysString = phoneCountryDialCodePropertiesMap.keys.toString();
    //String supportedPhoneCountryDialCodes = phoneCountryDialCodePropertiesMapKeysString.substring(1, phoneCountryDialCodePropertiesMapKeysString.length-1);
    return [false, "Dial code '$phoneCountryDialCode' not yet supported"];
  }

  // since the country code is supported, we select its map
  Map<String, Object> currentCountryCodeInfo = phoneCountryDialCodePropertiesMap[phoneCountryDialCode]!;

  // country properties
  String countryName = (currentCountryCodeInfo['countryName'] as String);
  int numberLength = (currentCountryCodeInfo['numberLength'] as int);
  List<String> firstMobileDigitsList = (currentCountryCodeInfo['firstMobileDigitsList'] as List<String>);

  /* -------------
  |  Validation  |
  ------------- */
  // typed phone number's length cannot be different than numberLength
  if (phoneNumber.length != 9) {
    return [false, "$countryName numbers require $numberLength digits"];
  }

  bool firstMobileDigitsCheck = false;
  // typed phone number's first digits cannot be different than firstMobileDigitsList
  for (String digits in firstMobileDigitsList) {
    // for-in loop instead of for-each loop just because I feel like it

    /* at this point, we have a phoneNumber
      with the expected number of digits */
    if ( phoneNumber.substring(0,digits.length) == digits ) {
      firstMobileDigitsCheck = true;
    }
  }

  if (!firstMobileDigitsCheck) {
    String firstMobileDigitsString = firstMobileDigitsList.toString();
    return [false, "Insert valid first digits (e.g., "
      "${firstMobileDigitsList[generateRandomInteger(0, firstMobileDigitsList.length)]})"];
  }

  return [true, ''];
}

/* ---------------------------
|        Widget utils        |
--------------------------- */

void openDropdownMethod1(GlobalKey dropdownButtonKey) {
  dropdownButtonKey.currentContext!.visitChildElements((element) {
    if (element.widget is Semantics) {
      element.visitChildElements((element) {
        print("hello1");
        print(element);
        if (element.widget is Actions) {
          element.visitChildElements((element) {
            print("hello");
            print(element);
          });
        }
      });
    }
  });
}

void openDropdownMethod2(GlobalKey dropdownButtonKey) {
  GestureDetector? detector;
  void searchForGestureDetector(BuildContext element) {
    element.visitChildElements((element) {
      if (element.widget is GestureDetector) {
        detector = element.widget as GestureDetector?;
      } else {
        searchForGestureDetector(element);
      }
    });
  }

  searchForGestureDetector(dropdownButtonKey.currentContext!);
  assert(detector != null);

  detector!.onTap!();
}