import 'package:flutter/material.dart';
import 'centered_loading.dart';

class MPFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, AsyncSnapshot<T> x) onSuccess;

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

        return onSuccess(context, snapshot);
      },
    );
  }
}
