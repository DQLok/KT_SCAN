import 'dart:convert';
import 'package:flutter/material.dart';

class PrettyJsonScreen extends StatelessWidget {
  const PrettyJsonScreen({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final prettyJson = const JsonEncoder.withIndent('  ').convert(text);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            child: SelectableText(
              prettyJson,
              style: const TextStyle(
                fontFamily: 'Courier', // Monospaced font
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
