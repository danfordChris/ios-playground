import 'package:ai_playground/app_root.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('renders IpfOS login and launcher', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const IpfOSApp());

    expect(find.text('IpfOS'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    await tester.tap(find.text('Sign In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('IpfOS'), findsOneWidget);
    expect(find.text('iPF Meals'), findsOneWidget);
    expect(find.text('PMO'), findsOneWidget);
    expect(find.text('My Tasks'), findsOneWidget);
  });
}
