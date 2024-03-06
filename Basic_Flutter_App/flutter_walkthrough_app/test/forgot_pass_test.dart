//Test Packages Imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

//Pages Imports
import 'package:test_app/pages/forgot_pass_page.dart';

//MAIN
void main() {
  testWidgets('Testing Forgot Password Functionality',
      (WidgetTester tester) async {
    Widget testWidget = MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        home: ForgotPasswordPage(title: 'Forgot Password'),
      ),
    );

    await tester.pumpWidget(testWidget);

    expect(find.byWidget(testWidget), findsOneWidget);

    await tester.pump();
  });
}
