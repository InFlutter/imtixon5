import 'package:dars67/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("CI/CD Test", (tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text("Salom, CI/CD!"), findsOneWidget);
  });
}