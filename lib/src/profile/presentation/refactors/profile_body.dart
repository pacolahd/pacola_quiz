import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:pacola_quiz/core/common/app/providers/user_provider.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/services/injection_container.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/views/add_materials_view.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/add_quiz_view.dart';
import 'package:pacola_quiz/src/course/presentation/bloc/course_cubit.dart';
import 'package:pacola_quiz/src/course/presentation/widgets/add_course_sheet.dart';
import 'package:pacola_quiz/src/profile/presentation/widgets/admin_button.dart';
import 'package:pacola_quiz/src/profile/presentation/widgets/user_info_card.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: UserInfoCard(
                    infoThemeColour: Colors.green,
                    infoIcon: Icon(
                      IconlyLight.document,
                      size: 24,
                      color: Color(0xFF767DFF),
                    ),
                    infoTitle: 'Courses',
                    infoValue: '5',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: UserInfoCard(
                    infoThemeColour: Colors.purple,
                    infoIcon: Image.asset(
                      MediaRes.scoreboard,
                      height: 24,
                      width: 24,
                    ),
                    infoTitle: 'Score',
                    infoValue: '50',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                    infoThemeColour: Colors.blue,
                    infoIcon: Icon(
                      IconlyLight.user,
                      color: Color(0xFF56AEFF),
                      size: 24,
                    ),
                    infoTitle: 'Followers',
                    infoValue: '3',
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: UserInfoCard(
                      infoThemeColour: Colors.orange,
                      infoIcon: Icon(
                        IconlyLight.user,
                        color: Color(0xFFFF84AA),
                        size: 24,
                      ),
                      infoTitle: 'Following',
                      infoValue: '2'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            AdminButton(
              label: 'Add Course',
              icon: IconlyLight.paper_upload,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  showDragHandle: true,
                  elevation: 0,
                  useSafeArea: true,
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => sl<CourseCubit>()),
                      // BlocProvider(create: (_) => sl<NotificationCubit>()),
                    ],
                    child: const AddCourseSheet(),
                  ),
                );
              },
            ),
            AdminButton(
              label: 'Add Materials',
              icon: IconlyLight.paper_download,
              onPressed: () {
                Navigator.pushNamed(context, AddMaterialsView.routeName);
              },
            ),
            AdminButton(
              label: 'Add Exam',
              icon: IconlyLight.document,
              onPressed: () {
                Navigator.pushNamed(context, AddQuizView.routeName);
              },
            ),
          ],
        );
      },
    );
  }
}
