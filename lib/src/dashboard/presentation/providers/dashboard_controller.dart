import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/app/providers/tab_navigator.dart';
import 'package:pacola_quiz/core/common/views/persistent_view.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: const [
              // BlocProvider(create: (_) => sl<CourseCubit>()),
              // BlocProvider(create: (_) => sl<VideoCubit>()),
              // BlocProvider.value(value: sl<NotificationCubit>()),
            ],
            child: Container(
              child: const Center(
                child: Text('Home View'),
              ),
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
            child: Text('Antother 1 View'),
          ),
        )),
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
      create: (_) => TabNavigator(
        TabItem(
            child: Container(
          child: const Center(
            child: Text('Profileiew'),
          ),
        )),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  int _currentIndex = 3;

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
