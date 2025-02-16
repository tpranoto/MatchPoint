import 'package:flutter/material.dart';

import '../models/category.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color textColor;
  const IconWithText({
    super.key,
    required this.icon,
    required this.text,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Icon(icon, color: Colors.blueAccent),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}

class ImageWithDefault extends StatelessWidget {
  final String? photoUrl;
  final String defaultAsset;
  final double size;
  const ImageWithDefault(
      {super.key,
      required this.photoUrl,
      required this.defaultAsset,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image(
        height: size,
        width: size,
        fit: BoxFit.fill,
        image: photoUrl != null
            ? NetworkImage(photoUrl!)
            : AssetImage(
                defaultAsset,
              ),
      ),
    );
  }
}

class CenteredLoading extends StatelessWidget {
  const CenteredLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CenteredTitle extends StatelessWidget {
  final String text;
  final double size;
  const CenteredTitle(this.text, {super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
      ),
    );
  }
}

class SquaredButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  final Widget icon;
  final Color bg;
  final Color fg;

  const SquaredButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.bg = Colors.white,
    this.fg = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      icon: icon,
      label: Text(text),
    );
  }
}

void errorDialog(BuildContext ctx, String text) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  });
}

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

void showSportsFilterDialog(
  BuildContext context,
  String title,
  SportsCategories selectedFilter,
  Function(SportsCategories) onFilterSelected,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...SportsCategories.values.map(
              (value) {
                return RadioListTile(
                  title: Text(value.categoryString),
                  value: value,
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    onFilterSelected(value!);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

void showConfirmationDialog(
  BuildContext context,
  String action,
  Function callback,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(action),
        content: Text('Are you sure you want to ${action.toLowerCase()}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              callback();
              Navigator.of(context).pop();
            },
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}
