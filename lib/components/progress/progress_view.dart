import 'package:flutter/material.dart';

import 'progress.dart';

class ProgressView extends StatelessWidget {
  final String message;

  const ProgressView({
    this.message = 'Sending...',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Processing'),
      ),
      body: Progress(message: this.message),
    );
  }
}
