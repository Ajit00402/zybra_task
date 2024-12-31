import 'package:ajit_task_managment_zybra_task/Models/UserPreferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ajit_task_managment_zybra_task/services/user_preferences_service.dart';

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(UserPreferences());

  // Update theme mode
  void toggleThemeMode() {
    state = UserPreferences(isDarkMode: !state.isDarkMode, sortOrder: state.sortOrder);
    UserPreferencesService().saveUserPreferences(state);
  }

  // Update sort order
  void changeSortOrder(String newSortOrder) {
    state = UserPreferences(isDarkMode: state.isDarkMode, sortOrder: newSortOrder);
    UserPreferencesService().saveUserPreferences(state);
  }
}

final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) => UserPreferencesNotifier());
