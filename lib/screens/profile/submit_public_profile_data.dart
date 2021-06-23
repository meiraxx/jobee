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
  List<String> _genders = ['Male', 'Female', 'Other', "I'd rather not say"];
  DateTime? _birthDay;
  TextEditingController _birthDayController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  // error state
  String _error = '';
  double _errorSizedBoxSizeFirstName = 0.0;
  double _errorSizedBoxSizeLastName = 0.0;
  double _errorSizedBoxSizeGender = 0.0;
  double _errorSizedBoxSizeBirthday = 0.0;
  double _errorSizedBoxSizeUserName = 0.0;
  Map<String, String> _fieldErrorMap = {
    "firstName": "Enter your first name",
    "lastName": "Enter your last name",
    "gender": "Enter your gender",
    "birthDay": "Enter your birthday",
    "userName": "Enter your username"
  };

  // error state - field padding correction
  final double _birthDayTopPadding = 4.0;
  final bool _spacedFormFields = false;
  
  // validator
  String? _validateNotEmpty({required String text, required String field, required Map<String, String> fieldErrorMap, required bool formNotSubmitted, required String? currentlyFocusedField, Function()? successFunction, Function()? errorFunction}) {
    if (formNotSubmitted) {
      /* user did not submit form yet */
      return null;
    }

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
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => build(context));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // form info
    final double defaultFormFieldSpacing = Theme.of(context).textTheme.caption!.fontSize!;
    const double formVerticalPadding = 20.0;
    const double formHorizontalPadding = 30.0;
    double formWidth = (queryData.size.width - formHorizontalPadding*2);
    double formHeight = (queryData.size.height - formVerticalPadding*2);
    
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
                    // - userName row
                    Row(
                      children: <Widget>[
                        /*SizeProviderWidget(
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blueGrey[500],
                          ),
                          onChildSize: (size) {
                            print(size.width);
                          },
                        ),
                        SizedBox(width: 4.0),*/
                        // - userName form field
                        Container(
                          width: formWidth,
                          height: defaultFormFieldSpacing*6,
                          child: TextFormField(
                            controller: _userNameController,
                            decoration: InputDecoration(
                              labelText: "Username",
                              errorText: _validateNotEmpty(
                                  text: _userNameController.text,
                                  field: 'userName',
                                  fieldErrorMap: _fieldErrorMap,
                                  formNotSubmitted: _formNotSubmitted,
                                  successFunction: () {
                                    _errorSizedBoxSizeUserName = defaultFormFieldSpacing;
                                  },
                                  errorFunction: () {
                                    _errorSizedBoxSizeUserName = 0.0;
                                  },
                                  currentlyFocusedField: _currentlyFocusedField
                              ),
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            onTap: () {
                              setState((){
                                _currentlyFocusedField = 'userName';
                              });
                            },
                          ),
                        ),
                        SizedBox(height: _errorSizedBoxSizeUserName),
                      ],
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return _spacedFormFields?SizedBox(height: defaultFormFieldSpacing):SizedBox(height: 0.0);
                      }
                    ),
                    // - firstName+lastName row
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
                                  fieldErrorMap: _fieldErrorMap,
                                  formNotSubmitted: _formNotSubmitted,
                                  successFunction: () {
                                    _errorSizedBoxSizeFirstName = defaultFormFieldSpacing;
                                  },
                                  errorFunction: () {
                                    _errorSizedBoxSizeFirstName = 0.0;
                                  },
                                  currentlyFocusedField: _currentlyFocusedField
                              ) ,
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            onTap: () {
                              setState((){
                                _currentlyFocusedField = 'firstName';
                              });
                            },
                          ),
                        ),
                        SizedBox(height: _errorSizedBoxSizeFirstName),
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
                                  fieldErrorMap: _fieldErrorMap,
                                  formNotSubmitted: _formNotSubmitted,
                                  successFunction: () {
                                    _errorSizedBoxSizeLastName = defaultFormFieldSpacing;
                                  },
                                  errorFunction: () {
                                    _errorSizedBoxSizeLastName = 0.0;
                                  },
                                  currentlyFocusedField: _currentlyFocusedField
                              ),
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            onTap: () {
                              setState((){
                                _currentlyFocusedField = 'lastName';
                              });
                            },
                          ),
                        ),
                        SizedBox(height: _errorSizedBoxSizeLastName),
                      ],
                    ),
                    Builder(
                        builder: (BuildContext context) {
                          return _spacedFormFields?SizedBox(height: defaultFormFieldSpacing):SizedBox(height: 0.0);
                        }
                    ),
                    // - gender+birthDay row
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
                            height: defaultFormFieldSpacing*6,
                            child: DropdownButtonFormField(
                              key: _dropdownButtonKey,
                              //iconSize: 0.0,
                              value: _gender,
                              isDense: true,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                errorText: _validateNotEmpty(
                                    text: _gender??'',
                                    field: 'gender',
                                    fieldErrorMap: _fieldErrorMap,
                                    formNotSubmitted: _formNotSubmitted, currentlyFocusedField: _currentlyFocusedField,
                                    successFunction: () {
                                      _errorSizedBoxSizeGender = defaultFormFieldSpacing;
                                    },
                                    errorFunction: () {
                                      _errorSizedBoxSizeGender = 0.0;
                                    }
                                ),
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
                              items: _genders.map((String gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: _errorSizedBoxSizeGender),
                        SizedBox(width: defaultFormFieldSpacing),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: formWidth/2 - defaultFormFieldSpacing/2,
                              height: defaultFormFieldSpacing*6 + _birthDayTopPadding,
                              padding: EdgeInsets.only(top: _birthDayTopPadding),
                              child: GestureDetector(
                                onTap: () async {
                                  // await for user to pick the date
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _birthDay??DateTime.now(),
                                    firstDate: DateTime(today.year-100, today.month, today.day),
                                    lastDate: DateTime.now(),
                                    locale: userLocale
                                  );
                                  /* if date isn't null and isn't the same picked before,
                                  * build the page again with the picked value */
                                  if(picked != null && picked != _birthDay) {
                                    setState(() {
                                      _birthDay = picked;
                                      _birthDayController.value =
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
                                      labelText: "Birthday",
                                      errorText: _validateNotEmpty(
                                        text: _birthDayController.text,
                                        field: 'birthDay',
                                        fieldErrorMap: _fieldErrorMap,
                                        formNotSubmitted: _formNotSubmitted,
                                        currentlyFocusedField: _currentlyFocusedField,
                                        successFunction: () {
                                          _errorSizedBoxSizeBirthday = 0.0;
                                        },
                                        errorFunction: () {
                                          _errorSizedBoxSizeBirthday = 0.0;
                                        },
                                      ),
                                    ),
                                    textAlignVertical: TextAlignVertical.bottom,
                                    controller: _birthDayController,
                                    keyboardType: TextInputType.datetime,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: _errorSizedBoxSizeBirthday),
                          ],
                        )
                      ],
                    ),
                    Builder(
                        builder: (BuildContext context) {
                          return _spacedFormFields?SizedBox(height: defaultFormFieldSpacing):SizedBox(height: 0.0);
                        }
                    ),
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
                            //setState(() {});
                            if (_formKey.currentState!.validate()) {
                              // while submitting data, set loading to true
                              setState(() => loading = true);
                              // TODO: Store data in Firestore

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
                      _error,
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
            // - End Row
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
    //_birthDayController.dispose();
    _userNameController.dispose();
    super.dispose();
  }
}
