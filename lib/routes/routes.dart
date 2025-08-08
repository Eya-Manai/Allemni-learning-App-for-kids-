import 'package:allemni/interfaces/addchild.dart';
import 'package:allemni/interfaces/characterselection.dart';
import 'package:allemni/interfaces/choose_module.dart';
import 'package:allemni/interfaces/choose_class.dart';
import 'package:allemni/interfaces/choose_subject.dart';
import 'package:allemni/interfaces/courses_map.dart';
import 'package:allemni/interfaces/forgotpassword.dart';
import 'package:allemni/interfaces/game_start.dart';
import 'package:allemni/interfaces/lesson.dart';
import 'package:allemni/interfaces/login.dart';
import 'package:allemni/interfaces/parenthome.dart';
import 'package:allemni/interfaces/signup.dart';
import 'package:allemni/models/lesson_model.dart';

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
  static const String coursesMap = '/coursesMap';
  static const String lesson = '/lesson';
  static const String gameStart = '/gameStart';

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
    gameStart: (context) => const GameStart(),
    coursesMap: (context) => const CoursesMap(),
    lesson: (context) {
      final lesson = ModalRoute.of(context)!.settings.arguments as LessonModel;
      return Lesson(lesson: lesson);
    },
  };
}
