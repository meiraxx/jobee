import 'package:flutter/material.dart';

class DatePickerFormFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function() validate;

  const DatePickerFormFieldWidget({
    Key? key,
    required this.label,
    required this.text,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.validate,
  }) : super(key: key);

  @override
  _DatePickerFormFieldWidgetState createState() => _DatePickerFormFieldWidgetState();
}

class _DatePickerFormFieldWidgetState extends State<DatePickerFormFieldWidget> {
  DateTime? _currentDate;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // etc.
    final DateTime today = DateTime.now();
    final Locale userLocale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: () async {
        // await for user to pick the date
        final DateTime? picked = await showDatePicker(
          context: context,
          // initialDate is set to
          initialDate: _currentDate ?? widget.initialDate ?? DateTime(today.year-18, today.month, today.day),
          // assumption: no person above 120
          // years-old will be using this app
          // TODO-BackEnd: force age between below 120
          firstDate: widget.firstDate ?? DateTime(today.year-120, today.month, today.day),
          // assumption: it should be a requirement to be
          // at least 18 years-old to be using this app
          // TODO-BackEnd: force age between above 16
          lastDate: widget.lastDate ?? DateTime(today.year-18, today.month, today.day),
          locale: userLocale,
        );
        /* if date isn't null and isn't the same picked before,
                                                  * build the page again with the picked value */
        if(picked != null && picked != _currentDate) {
          _currentDate = picked;
          _controller.value = TextEditingValue(
              text: "${picked.year}"
                  "/${picked.month>=10?picked.month:('0${picked.month}')}"
                  "/${picked.day>=10?picked.day:('0${picked.day}')}"
          );
          if (this.mounted) setState(() {});
        }
        // remove focus
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: "Birthday",
            errorText: widget.validate(),
          ),
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}
