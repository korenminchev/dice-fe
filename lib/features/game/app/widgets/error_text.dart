import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String? errorMessage;
  const ErrorText(this.errorMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 18)),
      );
    }

    return Container();
  }
}
