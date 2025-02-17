import 'package:flutter/material.dart';
import 'centered_loading.dart';
import 'error_dialog.dart';

class MPFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T? data) onSuccess;

  const MPFutureBuilder({
    super.key,
    required this.future,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CenteredLoading();
        }

        if (snapshot.hasError) {
          errorDialog(context, "${snapshot.error}");
          return SizedBox.shrink();
        }

        return onSuccess(context, snapshot.data);
      },
    );
  }
}
