import 'package:flutter/material.dart';
import 'package:jobee/screens/home/home.dart';
import 'package:jobee/screens/shared/logo.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/shared/constants.dart';

class SubmitPublicProfileData extends StatefulWidget {
  const SubmitPublicProfileData({Key? key}) : super(key: key);

  @override
  _SubmitPublicProfileDataState createState() => _SubmitPublicProfileDataState();
}

class _SubmitPublicProfileDataState extends State<SubmitPublicProfileData> {
  bool hasRegisteredUserData = false;

  // Form constants
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _formNotSubmitted = true;
  String? _currentlyFocusedField;

  // text field state
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String? _gender;
  List<String> genders = ['Male', 'Female', 'Other', "I'd rather not say"];
  DateTime? _birthday;
  TextEditingController _birthdayController = new TextEditingController();

  // error state
  String error = '';
  double errorSizedBoxSizeFirstName = 0.0;
  double errorSizedBoxSizeLastName = 0.0;
  double errorSizedBoxSizeGender = 0.0;
  double errorSizedBoxSizeBirthday = 0.0;

  // validator
  String? _validateNotEmpty({required String text, required String field, required bool formNotSubmitted, required String? currentlyFocusedField, Function()? successFunction, Function()? errorFunction}) {
    if (formNotSubmitted) {
      /* user did not submit form yet */
      return null;
    }

    Map<String, String> fieldErrorMap = {
      "firstName": "Enter your first name",
      "lastName": "Enter your last name",
      "gender": "Enter your gender",
      "birthday": "Enter your birthday",
    };
    assert(fieldErrorMap[field]!=null, "You must specify a correctly mapped field error");

    // error case
    if (text.isEmpty && currentlyFocusedField!=field) {
      if (errorFunction!=null) errorFunction();
      return fieldErrorMap[field]!;
    }

    // normal submission
    if (successFunction!=null) successFunction();
    return null;
  }

  // Open Dropdown
  GlobalKey _dropdownButtonKey = GlobalKey();

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // form info
    const double defaultFormFieldSpacing = 10.0;
    const double formVerticalPadding = 20.0;
    const double formHorizontalPadding = 30.0;
    double formWidth = (queryData.size.width - formHorizontalPadding*2);
    double formHeight = (queryData.size.height - formVerticalPadding*2);

    // specific field info
    const double birthdayTopPadding = 4.0;

    // etc.
    DateTime today = DateTime.now();
    Locale userLocale = Localizations.localeOf(context);

    return hasRegisteredUserData
    ?Home()
    :GestureDetector(
      onTap: () {
        /* removes focus from focused node when
        * the AppBar or Scaffold are touched */
        FocusManager.instance.primaryFocus?.unfocus();
        _currentlyFocusedField = null;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1.0,
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Logo(),
              SizedBox(width: 16.0),
              Text(
                "|   Public information",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          )
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: formVerticalPadding, horizontal: formHorizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    // - Row 1
                    Row(
                      children: <Widget>[
                        // - First name
                        Container(
                          width: formWidth/2 - defaultFormFieldSpacing/2,
                          height: defaultFormFieldSpacing*6,
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: "First name",
                              errorText: _validateNotEmpty(
                                text: _firstNameController.text,
                                field: 'firstName',
                                formNotSubmitted: _formNotSubmitted,
                                successFunction: () {
                                  setState(() {
                                    errorSizedBoxSizeFirstName = defaultFormFieldSpacing;
                                  });
                                },
                                errorFunction: () {
                                  setState(() {
                                    errorSizedBoxSizeFirstName = 0.0;
                                  });
                                },
                                currentlyFocusedField: _currentlyFocusedField
                              )
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            cursorColor: lightPaletteColors["crispYellow"],
                            onTap: () {
                              setState((){
                                _currentlyFocusedField = 'firstName';
                              });
                            },
                            onChanged: (String? firstNameVal) {setState((){}); },
                          ),
                        ),
                        SizedBox(height: errorSizedBoxSizeFirstName),
                        SizedBox(width: defaultFormFieldSpacing),
                        // - Last name
                        Container(
                          width: formWidth/2 - defaultFormFieldSpacing/2,
                          height: defaultFormFieldSpacing*6,
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                                labelText: "Last name",
                                errorText: _validateNotEmpty(
                                  text: _lastNameController.text,
                                  field: 'lastName',
                                  formNotSubmitted: _formNotSubmitted,
                                  successFunction: () {
                                    setState(() {
                                      errorSizedBoxSizeLastName = defaultFormFieldSpacing;
                                    });
                                  },
                                  errorFunction: () {
                                    setState(() {
                                      errorSizedBoxSizeLastName = 0.0;
                                    });
                                  },
                                  currentlyFocusedField: _currentlyFocusedField
                                )
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            cursorColor: lightPaletteColors["crispYellow"],
                            onTap: () {
                              setState((){
                                _currentlyFocusedField = 'lastName';
                              });
                            },
                            onChanged: (String? lastNameVal) {setState((){}); },
                          ),
                        ),
                        SizedBox(height: errorSizedBoxSizeLastName),
                      ],
                    ),
                    SizedBox(height: defaultFormFieldSpacing),
                    // - Row 2
                    Row(
                      children: [
                        // - Gender
                        GestureDetector(
                          onTap: () {
                            // print("Manually activate dropdown button");
                            openDropdownMethod2(_dropdownButtonKey); // manually activate dropdown button
                          },
                          child: Container(
                            width: formWidth/2 - defaultFormFieldSpacing/2,
                            height: defaultFormFieldSpacing*6 + birthdayTopPadding,
                            child: DropdownButtonFormField(
                              key: _dropdownButtonKey,
                              iconSize: 0.0,
                              value: _gender,
                              isDense: true,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                errorText: _validateNotEmpty(text: _gender??'', field: 'gender', formNotSubmitted: _formNotSubmitted, currentlyFocusedField: _currentlyFocusedField,
                                  successFunction: () {
                                    setState(() {
                                      errorSizedBoxSizeGender = defaultFormFieldSpacing;
                                    });
                                  },
                                  errorFunction: () {
                                    setState(() {
                                      errorSizedBoxSizeGender = 0.0;
                                    });
                                  },),
                              ),
                              onChanged: (String? genderVal) {
                                setState((){
                                  _gender = genderVal;
                                });
                              },
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState((){
                                  _currentlyFocusedField = null;
                                });
                              },
                              items: genders.map((String gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Row(
                                    children: <Widget>[
                                      Builder(
                                          builder: (BuildContext context) {
                                            if (gender=='Male') {
                                              return Icon(Icons.male_outlined);
                                            } else if (gender=='Female') {
                                              return Icon(Icons.female_outlined);
                                            } else if (gender=='Other') {
                                              return Icon(Icons.star_outline);
                                            } else {
                                              return SizedBox();
                                            }
                                          }
                                      ),
                                      SizedBox(width: 2.0),
                                      Text(gender),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: errorSizedBoxSizeGender),
                        SizedBox(width: defaultFormFieldSpacing),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: formWidth/2 - defaultFormFieldSpacing/2,
                              height: defaultFormFieldSpacing*6 + birthdayTopPadding,
                              padding: const EdgeInsets.only(top: birthdayTopPadding),
                              child: GestureDetector(
                                onTap: () async {
                                  // await for user to pick the date
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _birthday??DateTime.now(),
                                    firstDate: DateTime(today.year-100, today.month, today.day),
                                    lastDate: DateTime.now(),
                                    locale: userLocale
                                  );
                                  /* if date isn't null and isn't the same picked before,
                                  * build the page again with the picked value */
                                  if(picked != null && picked != _birthday) {
                                    setState(() {
                                      _birthday = picked;
                                      _birthdayController.value =
                                        TextEditingValue(
                                          text: "${picked.year}"
                                              "/${picked.month>=10?picked.month:('0'+picked.month.toString())}"
                                              "/${picked.day>=10?picked.day:('0'+picked.day.toString())}"
                                        );
                                    });
                                  }
                                  // remove focus and update focus information
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState((){
                                    _currentlyFocusedField = null;
                                  });
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Date of Birth",
                                      errorText: _validateNotEmpty(text: _birthdayController.text, field: 'birthday', formNotSubmitted: _formNotSubmitted, currentlyFocusedField: _currentlyFocusedField,
                                        successFunction: () {
                                          setState(() {
                                            errorSizedBoxSizeBirthday = 0.0;
                                          });
                                        },
                                        errorFunction: () {
                                          setState(() {
                                            errorSizedBoxSizeBirthday = 0.0;
                                          });
                                        },
                                      )
                                    ),
                                    textAlignVertical: TextAlignVertical.bottom,
                                    controller: _birthdayController,
                                    keyboardType: TextInputType.datetime,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: errorSizedBoxSizeBirthday),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: defaultFormFieldSpacing),
                    Center(
                      child: Builder(builder: (BuildContext context) {
                        return loading
                        ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(lightPaletteColors["crispYellow"]!),
                        )
                        : ElevatedButton(
                          style: orangeElevatedButtonStyle,
                          onPressed: () async {
                            _formNotSubmitted = false;
                            setState(() {});
                            if (_formKey.currentState!.validate()) {
                              // while submitting data, set loading to true
                              setState(() => loading = true);
                              // TODO: do stuff

                              // after everything is done, set loading back to false
                              setState(() => loading = false);
                            }
                          },
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.public),
                              SizedBox(width: 4.0),
                              Text(
                                "Submit data",
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            // - Row 3
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Want to switch account?"
                ),
                TextButton(
                  style: ButtonStyle( overlayColor: MaterialStateProperty.all(Colors.transparent) ),
                  child: Text(
                    "Sign out",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    await AuthService.signOut(context: context);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    //_genderController.dispose();
    //_birthdayController.dispose();
    super.dispose();
  }
}
