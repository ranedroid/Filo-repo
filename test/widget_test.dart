import 'package:flutter_test/flutter_test.dart';

import 'package:filo_app/main.dart';

void main() {
  testWidgets('FiloApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FiloApp());
    await tester.pumpAndSettle();

    // Verify that FiloApp renders
    expect(find.byType(FiloApp), findsOneWidget);
  });
}
