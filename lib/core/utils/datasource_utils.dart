import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataSourceUtils {
  DataSourceUtils._();

  static Future<void> authorizeUser(SupabaseClient supabaseClient) async {
    final currentUser = supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw const ServerException(
        message: 'User is not authenticated',
        statusCode: 'auth/unauthenticated',
      );
    }
  }

  static Future<void> checkInternetConnection(Connectivity connectivity) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw const ServerException(
        message:
            'No internet connection. Please check your network settings and try again.',
        statusCode: 'no_internet',
      );
    }
  }
}
