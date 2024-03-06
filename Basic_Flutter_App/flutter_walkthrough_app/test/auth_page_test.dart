//Test Packages Imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

//Pages Imports
import 'package:test_app/pages/auth/auth_page.dart';
import 'package:test_app/pages/login_page.dart';
import 'package:test_app/pages/register_page.dart';

//

void main() {
  testWidgets('Testing page switch between Login and Register',
      (WidgetTester tester) async {
    // declare bool value (mock togglePages from AuthPage)
    ValueNotifier<bool> pageSwitch = ValueNotifier<bool>(true);
    void pageSwitcher() {
      pageSwitch;
    }

    //Create an AuthPage instance
    AuthPage authPage = AuthPage();

    //Create an LoginPage instance
    LoginPage loginPage = LoginPage(
      key: null,
      title: 'TestLogin',
      showRegisterPage: pageSwitcher,
    );

    //Add instances to tester
    await tester.pumpWidget(authPage);
    await tester.pumpWidget(loginPage);

    //Execute Switch (true --> false)
    //

    //Rebuild widget
    await tester.pump();
  });
}
