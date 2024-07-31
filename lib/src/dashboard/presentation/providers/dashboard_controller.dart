import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/app/providers/tab_navigator.dart';
import 'package:pacola_quiz/core/common/views/persistent_view.dart';
import 'package:pacola_quiz/core/services/injection_container.dart';
import 'package:pacola_quiz/src/course/presentation/bloc/course_cubit.dart';
import 'package:pacola_quiz/src/home/presentation/views/home_view.dart';
import 'package:pacola_quiz/src/profile/presentation/views/profile_view.dart';
import 'package:pacola_quiz/src/quick_access/presentation/providers/quick_access_tab_controller.dart';
import 'package:pacola_quiz/src/quick_access/presentation/views/quick_access_view.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CourseCubit>()),
            ],
            child: const HomeView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: BlocProvider(
            create: (context) => sl<CourseCubit>(),
            child: ChangeNotifierProvider(
              create: (_) => QuickAccessTabController(),
              child: const QuickAccessView(),
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
            child: Container(
          child: const Center(
            child: Text('Antother 2 View'),
          ),
        )),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const ProfileView())),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
