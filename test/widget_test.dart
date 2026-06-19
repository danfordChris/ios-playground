import 'package:ai_playground/app_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the launcher dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const IpfOSApp());
    await tester.pump(const Duration(seconds: 2));

    expect(
      find.text('Select a workspace to begin your workflow.'),
      findsOneWidget,
    );
    expect(find.text('iPF Meals'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
