import 'package:flutter_test/flutter_test.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/services/firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'profile_provider_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirestoreService>()])
void main() {

  testWidgets('Should load and save profile correctly', (WidgetTester tester) async {
    final mockFireService = MockFirestoreService();
    final profileProvider = AppProfileProvider(firestoreService: mockFireService);
    final mockProfile = Profile(
      "11",
      "test@example.com",
      "Test User",
      "http://example.com/avatar.png",
      3,
      5,
    );

    when(mockFireService.getById("11")).thenAnswer((_) async {
      return mockProfile;
    });

    await profileProvider.loadAndSaveProfile("11");
    expect(profileProvider.getData, isNotNull);
    expect(profileProvider.getData!.id, equals("11"));
  });
}