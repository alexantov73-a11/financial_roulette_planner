import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/storage_service.dart';
import 'data/services/camera_service.dart';
import 'presentation/screens/preloader/preloader_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/roulette/roulette_screen.dart';
import 'presentation/screens/goals_list/goals_list_screen.dart';
import 'presentation/screens/goal_detail/goal_detail_screen.dart';
import 'presentation/screens/goal_edit/goal_edit_screen.dart';
import 'presentation/screens/allocation_detail/allocation_detail_screen.dart';
import 'presentation/screens/analytics/analytics_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/profile_edit/profile_edit_screen.dart';
import 'presentation/viewmodels/preloader_viewmodel.dart';
import 'presentation/viewmodels/onboarding_viewmodel.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/roulette_viewmodel.dart';
import 'presentation/viewmodels/goals_viewmodel.dart';
import 'presentation/viewmodels/goal_detail_viewmodel.dart';
import 'presentation/viewmodels/goal_edit_viewmodel.dart';
import 'presentation/viewmodels/allocation_detail_viewmodel.dart';
import 'presentation/viewmodels/analytics_viewmodel.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/viewmodels/profile_edit_viewmodel.dart';
import 'presentation/viewmodels/theme_viewmodel.dart';
import 'data/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones(); // ← И здесь

  final storageService = StorageService();
  final cameraService = CameraService();
  final notificationService = NotificationService();

  await storageService.init();
  await cameraService.init();
  await notificationService.init(); // ← ДОБАВЬ ЭТО

  runApp(
    MyApp(
      storageService: storageService,
      cameraService: cameraService,
      notificationService: notificationService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final CameraService cameraService;
  final NotificationService notificationService;

  const MyApp({
    super.key,
    required this.storageService,
    required this.cameraService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>(create: (_) => storageService),
        Provider<CameraService>(create: (_) => cameraService),
        Provider<NotificationService>(create: (_) => notificationService),
        ChangeNotifierProvider(create: (_) => ThemeViewModel(storageService)),
        ChangeNotifierProvider(
          create: (_) => PreloaderViewModel(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(storageService),
        ),
        ChangeNotifierProvider(create: (_) => HomeViewModel(storageService)),
        ChangeNotifierProvider(create: (_) => RouletteViewModel()),
        ChangeNotifierProvider(create: (_) => GoalsViewModel(storageService)),
        ChangeNotifierProvider(
          create: (_) => GoalDetailViewModel(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalEditViewModel(storageService, cameraService),
        ),
        ChangeNotifierProvider(create: (_) => AllocationDetailViewModel()),
        ChangeNotifierProvider(
          create: (_) => AnalyticsViewModel(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileEditViewModel(storageService, cameraService),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Financial Roulette Planner',
            theme: context.watch<ThemeViewModel>().getThemeData(),
            debugShowCheckedModeBanner: false,
            home: const PreloaderScreen(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/onboarding':
                  return MaterialPageRoute(
                    builder: (_) => const OnboardingScreen(),
                  );
                case '/home':
                  return MaterialPageRoute(builder: (_) => const HomeScreen());
                case '/roulette':
                  return MaterialPageRoute(
                    builder: (_) => const RouletteScreen(),
                  );
                case '/goals':
                  return MaterialPageRoute(
                    builder: (_) => const GoalsListScreen(),
                  );
                case '/goal-detail':
                  return MaterialPageRoute(
                    builder: (_) =>
                        GoalDetailScreen(goalId: settings.arguments as String),
                  );
                case '/goal-edit':
                  return MaterialPageRoute(
                    builder: (_) =>
                        GoalEditScreen(goalId: settings.arguments as String?),
                  );
                case '/allocation-detail':
                  return MaterialPageRoute(
                    builder: (_) => const AllocationDetailScreen(),
                  );
                case '/analytics':
                  return MaterialPageRoute(
                    builder: (_) => const AnalyticsScreen(),
                  );
                case '/settings':
                  return MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  );
                case '/profile-edit':
                  return MaterialPageRoute(
                    builder: (_) => const ProfileEditScreen(),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const PreloaderScreen(),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
