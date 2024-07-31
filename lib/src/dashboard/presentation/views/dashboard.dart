import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pacola_quiz/core/common/app/providers/user_provider.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/src/auth/data/models/user_model.dart';
import 'package:pacola_quiz/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:pacola_quiz/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DashboardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data is UserModel) {
          context.read<UserProvider>().user =
              snapshot.data?.map(UserModel.fromMap).first;
          debugPrint('User: ${snapshot.data}');
          debugPrint(context.read<UserProvider>().user.toString());
        }
        return Consumer<DashboardController>(
          builder: (_, controller, __) {
            return Scaffold(
              body: IndexedStack(
                index: controller.currentIndex,
                children: controller.screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.currentIndex,
                showSelectedLabels: false,
                backgroundColor: Colors.white,
                elevation: 8,
                onTap: controller.changeIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 0
                          ? HugeIcons.strokeRoundedHome01
                          : HugeIcons.strokeRoundedHome02,
                      color: controller.currentIndex == 0
                          ? context.theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 1
                          ? HugeIcons.strokeRoundedDocumentCode
                          : HugeIcons.strokeRoundedDocumentCode,
                      color: controller.currentIndex == 1
                          ? context.theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    label: 'Materials',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 2
                          ? HugeIcons.strokeRoundedAiChat01
                          : HugeIcons.strokeRoundedAiChat01,
                      color: controller.currentIndex == 2
                          ? context.theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    label: 'Chat',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 3
                          ? HugeIcons.strokeRoundedProfile
                          : HugeIcons.strokeRoundedProfile,
                      color: controller.currentIndex == 3
                          ? context.theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    label: 'User',
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
