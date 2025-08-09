import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/di/service_locator.dart';
import '../settings/providers/user_settings_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider<UserSettingsProvider>(
      create: (_) => UserSettingsProvider(
        repository: getIt(),
        notificationService: getIt(),
        analyticsService: getIt(),
        securityService: getIt(),
      ),
    ),
  ];
}
