//Test Packages Imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

//Pages Imports
import 'package:test_app/pages/auth/auth_page.dart';
import 'package:test_app/pages/login_page.dart';
import 'package:test_app/pages/register_page.dart';

//MAIN
void main() {
  testWidgets('Testing page switch between Login and Register',
      (WidgetTester tester) async {
    // declare bool value (mock togglePages from AuthPage)
    ValueNotifier<bool> pageSwitch = ValueNotifier<bool>(true);
    void pageSwitcher() {
      pageSwitch;
    }

    //Create an LoginPage instance
    LoginPage loginPage = LoginPage(
      key: null,
      title: 'TestLogin',
      showRegisterPage: pageSwitcher,
    );

    //Add instance(s) to tester
    await tester.pumpWidget(loginPage);

    //Find the login page
    expect(find.text('Login Page'), findsOneWidget);

    //Rebuild widget
    await tester.pump();
  });
}
