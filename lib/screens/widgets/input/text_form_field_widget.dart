import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final int maxLines;
  final double multipleLineBorderRadius;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  final String? Function() validate;
  final Iterable<String>? autofillHints;
  final TextInputType? textInputType;

  const TextFormFieldWidget({
    Key? key,
    this.maxLines = 1,
    this.multipleLineBorderRadius = 6.0,
    required this.label,
    required this.text,
    required this.onChanged,
    required this.validate,
    this.autofillHints,
    this.textInputType,
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
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
  Widget build(BuildContext context) => TextFormField(
    controller: _controller,
    keyboardType: widget.textInputType,
    decoration: InputDecoration(
      labelText: widget.label,
      errorText: widget.validate(),
      contentPadding: widget.maxLines==1 ? null : const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      border: widget.maxLines==1 ? null : OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.multipleLineBorderRadius),
      ),
    ),
    textAlignVertical: TextAlignVertical.center,
    autofillHints: widget.autofillHints,
    // cleanse errors by rebuilding widget on... :
    onTap: () => setState(() {}),
    onChanged: (String _) {
      setState(() {
        widget.onChanged(_);
      });
    },
    maxLines: widget.maxLines,
  );
}


