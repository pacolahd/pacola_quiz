import 'package:pacola_quiz/core/services/injection_container.dart';
import 'package:pacola_quiz/src/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardUtils {
  const DashboardUtils._();

  static Stream<UserModel> get userDataStream => sl<SupabaseClient>()
      .from('users')
      .stream(primaryKey: ['id'])
      .eq('id', sl<SupabaseClient>().auth.currentUser!.id)
      .map((event) => UserModel.fromMap(event.first));
}
