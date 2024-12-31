import 'package:ajit_task_managment_zybra_task/Models/UserPreferences.dart';
import 'package:hive/hive.dart';

class UserPreferencesService {
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    var box = await Hive.openBox('user_preferences');
    box.put('isDarkMode', preferences.isDarkMode);
    box.put('sortOrder', preferences.sortOrder);
  }

  Future<UserPreferences> getUserPreferences() async {
    var box = await Hive.openBox('user_preferences');
    bool isDarkMode = box.get('isDarkMode', defaultValue: false);
    String sortOrder = box.get('sortOrder', defaultValue: 'date');
    return UserPreferences(isDarkMode: isDarkMode, sortOrder: sortOrder);
  }
}
