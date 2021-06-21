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
  double errorSizedBoxHeightFirstName = 0.0;
  double errorSizedBoxHeightLastName = 0.0;

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

    DateTime today = DateTime.now();
    Locale userLocale = Localizations.localeOf(context);

    //print(Theme.of(context).cursorColor);

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
                                    errorSizedBoxHeightFirstName = defaultFormFieldSpacing;
                                  });
                                },
                                errorFunction: () {
                                  setState(() {
                                    errorSizedBoxHeightFirstName = 0.0;
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
                        SizedBox(height: errorSizedBoxHeightFirstName),
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
                                      errorSizedBoxHeightLastName = defaultFormFieldSpacing;
                                    });
                                  },
                                  errorFunction: () {
                                    setState(() {
                                      errorSizedBoxHeightLastName = 0.0;
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
                        SizedBox(height: errorSizedBoxHeightLastName),
                      ],
                    ),
                    SizedBox(height: defaultFormFieldSpacing),
                    // - Row 2
                    Row(
                      children: [
                        // - Gender
                        Container(
                          width: formWidth/2 - defaultFormFieldSpacing/2,
                          height: defaultFormFieldSpacing*6,
                          child: DropdownButtonFormField(
                            value: _gender,
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              //errorText: _validateNotEmpty(text: _gender??'', field: 'gender', formNotSubmitted: _formNotSubmitted)
                            ),
                            validator: (String? genderVal) {
                              // TODO: display Gender error while maintaining dropdown functionality (for some unknown reason it is not working)
                              //return _validateNotEmpty(text: genderVal??'', field: 'gender', formNotSubmitted: _formNotSubmitted, currentlyFocusedField: _currentlyFocusedField);
                              return null;
                              //return "Enter your gender";
                            },
                            onChanged: (String? genderVal) => setState((){}),
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
                        SizedBox(width: defaultFormFieldSpacing),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: formWidth/2 - defaultFormFieldSpacing/2,
                              height: defaultFormFieldSpacing*6,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  primaryColor: Colors.amber,
                                ),
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
                                        errorText: _validateNotEmpty(text: _birthdayController.text, field: 'birthday', formNotSubmitted: _formNotSubmitted, currentlyFocusedField: _currentlyFocusedField)
                                      ),
                                      textAlignVertical: TextAlignVertical.bottom,
                                      controller: _birthdayController,
                                      keyboardType: TextInputType.datetime,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                          child: Text(
                            "Submit data",
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
