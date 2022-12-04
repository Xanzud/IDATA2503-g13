import 'package:flutter_test/flutter_test.dart';
import 'package:project/signInPage.dart';

void main(){
  testWidgets("Login has Username and password field", (widgetTester) async{
    widgetTester.pumpWidget(SignInPage());
  });
}