import 'package:flutter/material.dart';

class DropdownButtonFormFieldWidget extends StatefulWidget {
  final String label;
  final List<String> optionList;
  final String? initialOption;
  final ValueChanged<String?> onChanged;
  final String? Function() validate;

  const DropdownButtonFormFieldWidget({
    Key? key,
    required this.label,
    required this.optionList,
    required this.initialOption,
    required this.onChanged,
    required this.validate,
  }) : super(key: key);

  @override
  _DropdownButtonFormFieldWidgetState createState() => _DropdownButtonFormFieldWidgetState();
}

class _DropdownButtonFormFieldWidgetState extends State<DropdownButtonFormFieldWidget> {
  // Open Dropdown
  final GlobalKey _dropdownButtonKey = GlobalKey();

  String? _currentOption;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // manually activate dropdown button
        _openDropdownMethod2(_dropdownButtonKey);
      },
      child: DropdownButtonFormField<String>(
        key: _dropdownButtonKey,
        iconSize: 0.0,
        value: _currentOption ?? widget.initialOption,
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: widget.validate(),
        ),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (String? optionVal) {
          widget.onChanged(optionVal);
          _currentOption = optionVal;
          setState((){});
        },
        items: widget.optionList.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(growable: false),
      ),
    );
  }

  /*
  void _openDropdownMethod1(GlobalKey dropdownButtonKey) {
    dropdownButtonKey.currentContext!.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          debugPrint("hello1");
          debugPrint(element);
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              debugPrint("hello");
              debugPrint(element);
            });
          }
        });
      }
    });
  }*/

  void _openDropdownMethod2(GlobalKey dropdownButtonKey) {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((Element element) {
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

}
