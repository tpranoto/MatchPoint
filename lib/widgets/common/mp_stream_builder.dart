import 'package:flutter/material.dart';
import 'centered_loading.dart';
import 'error_dialog.dart';

class MPStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, AsyncSnapshot<T> data) onSuccess;
  final Function() streamContinuation;

  const MPStreamBuilder({
    super.key,
    required this.stream,
    required this.onSuccess,
    required this.streamContinuation,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          streamContinuation();
          return CenteredLoading();
        }

        if (snapshot.hasError) {
          errorDialog(context, snapshot.error.toString());
          return SizedBox.shrink();
        }

        return onSuccess(context, snapshot);
      },
    );
  }
}
