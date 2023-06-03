import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/providers/providers.dart';
import 'package:gestion_espacios_app/screens/private/bo_add_espacio_dialog.dart';
import 'package:gestion_espacios_app/screens/private/bo_add_usuario_dialog.dart';
import 'package:gestion_espacios_app/screens/private/bo_espacios_screen.dart';
import 'package:gestion_espacios_app/screens/private/bo_reservas_screen.dart';
import 'package:gestion_espacios_app/screens/private/bo_usuarios_screen.dart';
import 'package:gestion_espacios_app/screens/public/reservar_espacios_screen.dart';
import 'package:gestion_espacios_app/screens/screens.dart';
import 'package:gestion_espacios_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('theme') ?? false;
  runApp(MyApp(isDarkMode: isDarkMode));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, UsuariosProvider>(
          create: (context) => UsuariosProvider(null),
          update: (context, authProvider, _) =>
              UsuariosProvider(authProvider.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, EspaciosProvider>(
          create: (context) => EspaciosProvider(null),
          update: (context, authProvider, _) =>
              EspaciosProvider(authProvider.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, StorageProvider>(
          create: (context) => StorageProvider(null),
          update: (context, authProvider, _) =>
              StorageProvider(authProvider.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ReservasProvider>(
          create: (context) => ReservasProvider(null, null),
          update: (context, authProvider, _) =>
              ReservasProvider(authProvider.token, authProvider.userId),
        ),
      ],
      child: MyApp(isDarkMode: isDarkMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'IES Luis Vives',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),

        // Public
        '/login': (context) => LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/espacios': (context) => const EspaciosScreen(),
        '/mis-reservas': (context) => const MisReservasScreen(),
        '/buzon': (context) => const BuzonScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/reservar-espacio': (context) => const ReservaEspacioScreen(),
        // '/editar-reserva': (context) => const EditarReservaScreen(),

        // Private
        '/login-bo': (context) => BOLoginScreen(),
        '/home-bo': (context) => const BOMainScreen(),
        '/espacios-bo': (context) => const EspaciosBOScreen(),
        '/reservas-bo': (context) => const ReservasBOScreen(),
        '/usuarios-bo': (context) => const UsuariosBOScreen(),
        '/nuevo-espacio': (context) => const NuevoEspacioBODialog(),
        '/nuevo-usuario': (context) => const NuevoUsuarioBODialog(),
        // 'nueva-reserva': (context) => const NuevaReservaBODialog(),
        // '/editar-espacio': (context) => const EditarEspacioBODialog(),
        // '/editar-usuario': (context) => const EditarUsuarioBODialog(),
        // '/editar-reserva': (context) => const EditarReservaBODialog(),
      },
    );
  }
}
