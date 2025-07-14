import 'package:allemni/interfaces/addchild.dart';
import 'package:allemni/interfaces/characterselection.dart';
import 'package:allemni/interfaces/choose_module.dart';
import 'package:allemni/interfaces/choose_class.dart';
import 'package:allemni/interfaces/choose_subject.dart';
import 'package:allemni/interfaces/forgotpassword.dart';
import 'package:allemni/interfaces/login.dart';
import 'package:allemni/interfaces/parenthome.dart';
import 'package:allemni/interfaces/signup.dart';

import 'package:flutter/material.dart';

class Routes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String parentHome = '/parentHome';
  static const String forgetPassword = '/forgetpassword';
  static const String addChild = '/addchild';
  static const String characterSelection = '/characterSelection';
  static const String chooseclass = '/chooseclass';
  static const String chooseSubject = '/chooseSubject';
  static const String chooseModule = '/chooseModule';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginInterface(),
    signup: (context) => const Signup(),
    parentHome: (context) => const Parenthome(),
    forgetPassword: (context) => const Forgotpassword(),
    addChild: (context) => const AddChildPage(),
    characterSelection: (context) => const Characterselection(),
    chooseclass: (context) => const ChooseClass(),
    chooseSubject: (context) => const ChooseSubject(),
    chooseModule: (context) => const ChooseModule(),
  };
}
