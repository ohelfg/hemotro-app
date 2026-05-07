import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/index.dart';
import 'providers/index.dart';
import 'services/index.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  final storageService = StorageService();
  await storageService.init();
  
  // Initialize API service
  final apiService = ApiService();
  
  // Initialize auth
  final authProvider = AuthProvider(
    apiService: apiService,
    storageService: storageService,
  );
  await authProvider.initializeAuth();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => apiService),
        Provider<StorageService>(create: (_) => storageService),
        ChangeNotifierProvider(
          create: (_) => authProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => SeriesProvider(apiService: apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => EpisodeProvider(
            apiService: apiService,
            storageService: storageService,
          ),
        ),
      ],
      child: const HemoTroApp(),
    ),
  );
}

class HemoTroApp extends StatelessWidget {
  const HemoTroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hemo Tro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 12,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          hintStyle: const TextStyle(color: AppColors.textTertiary),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
