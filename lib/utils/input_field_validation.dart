import 'math_operations.dart' show generateRandomInteger;

String? validateNotEmpty({required String text, required String field, required String errorMessage, bool formNotSubmitted = false, void Function()? successFunction, void Function()? errorFunction}) {
  // formNotSubmitted must be used when using errorText instead of validator
  // formNotSubmitted defaults to false, so it is not needed when using validator
  if (formNotSubmitted) {
    /* if user did not submit form yet */
    return null;
  }

  // error case
  if (text.isEmpty) {
    if (errorFunction!=null) errorFunction();
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

List<dynamic> validatePhoneNumber({required String phoneCountryDialCode, required String phoneNumber}) {
  final Map<String, Map<String, dynamic>> phoneCountryDialCodePropertiesMap = <String, Map<String, dynamic>>{
    // Portugal properties
    '+351': <String, dynamic>{
      'countryName': 'Portugal',
      'numberLength': 9,
      'firstMobileDigitsList': <String>['91', '92', '93', '96']
    },
  };

  // country code is not supported
  if (!phoneCountryDialCodePropertiesMap.containsKey(phoneCountryDialCode)) {
    //String phoneCountryDialCodePropertiesMapKeysString = phoneCountryDialCodePropertiesMap.keys.toString();
    //String supportedPhoneCountryDialCodes = phoneCountryDialCodePropertiesMapKeysString.substring(1, phoneCountryDialCodePropertiesMapKeysString.length-1);
    return <dynamic>[
      false,
      "Dial code '$phoneCountryDialCode' not yet supported"
    ];
  }

  // since the country code is supported, we select its map
  final Map<String, dynamic> currentCountryCodeInfo = phoneCountryDialCodePropertiesMap[phoneCountryDialCode]!;

  // country properties
  final String countryName = currentCountryCodeInfo['countryName']! as String;
  final int numberLength = currentCountryCodeInfo['numberLength']! as int;
  final List<String> firstMobileDigitsList = currentCountryCodeInfo['firstMobileDigitsList']! as List<String>;

  /* ----------------
  |  PT Validation  |
  ---------------- */
  // typed phone number's length cannot be different than numberLength
  if (phoneNumber.length != 9) {
    return <dynamic>[
      false,
      "$countryName numbers require $numberLength digits"
    ];
  }

  bool firstMobileDigitsCheck = false;
  // typed phone number's first digits cannot be different than firstMobileDigitsList
  for (final String digits in firstMobileDigitsList) {
    // for-in loop instead of for-each loop just because I feel like it

    /* at this point, we have a phoneNumber
      with the expected number of digits */
    if ( phoneNumber.substring(0,digits.length) == digits ) {
      firstMobileDigitsCheck = true;
    }
  }

  if (!firstMobileDigitsCheck) {
    return <dynamic>[
      false,
      "Insert valid first digits (e.g., ${firstMobileDigitsList[generateRandomInteger(0, firstMobileDigitsList.length)]})"
    ];
  }

  return <dynamic>[true, ''];
}
