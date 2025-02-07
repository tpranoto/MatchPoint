import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/widgets/common.dart';

void main(){

  testWidgets('IconWithText displays icon and text correctly', (WidgetTester tester) async {
    const testIcon = Icons.home;
    const testText = 'Home';
    const testTextColor = Colors.red;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: IconWithText(
            icon: testIcon,
            text: testText,
            textColor: testTextColor,
          ),
        ),
      ),
    );
    expect(find.byIcon(testIcon), findsOneWidget);
    expect(find.text(testText), findsOneWidget);
  });

  testWidgets('ImageWithDefault shows correct image', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ImageWithDefault(
            photoUrl: null,
            defaultAsset: 'assets/matchpoint.png',
            size: 50.0,
          ),
        ),
      ),
    );
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<AssetImage>());
  });
}