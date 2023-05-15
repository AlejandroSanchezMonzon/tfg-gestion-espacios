import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/providers/theme_provider.dart';
import 'package:gestion_espacios_app/screens/public/reservar_espacios_screen.dart';
import 'package:gestion_espacios_app/screens/screens.dart';
import 'package:gestion_espacios_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final appTheme = AppTheme();
    final theme = appTheme.getTheme(themeNotifier.isDarkMode);

    return MaterialApp(
      title: 'IES Luis Vives App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),

        // Public
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/espacios': (context) => const EspaciosScreen(),
        '/mis-reservas': (context) => const MisReservasScreen(),
        '/buzon': (context) => const BuzonScreen(),
        '/perfil': (context) => const PerfilScreen(),
        'reservar-espacio': (context) => const ReservaEspacioScreen(),
        'editar-reserva': (context) => const EditarReservaScreen(),

        // Private
        '/login-bo': (context) => const BOLoginScreen(),
        '/home-bo': (context) => const BOMainScreen(),
      },
    );
  }
}