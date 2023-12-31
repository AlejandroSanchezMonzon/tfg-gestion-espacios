/// Alejandro Sánchez Monzón
/// Mireya Sánchez Pinzón
/// Rubén García-Redondo Marín

import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/providers/auth_provider.dart';
import 'package:gestion_espacios_app/providers/theme_provider.dart';
import 'package:gestion_espacios_app/widgets/user_image_widget.dart';
import 'package:provider/provider.dart';

/// Widget que muestra el menú lateral de la aplicación.
class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// El provider de autenticación.
    final authProvider = Provider.of<AuthProvider>(context);

    /// El usuario autenticado.
    final usuario = authProvider.usuario;

    /// El provider de temas.
    var themeProvider = context.watch<ThemeProvider>();

    /// Se obtiene el tema actual.
    var theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            accountName: Text(usuario.name,
                style: TextStyle(
                    fontFamily: 'KoHo',
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold)),
            accountEmail: Text('@${usuario.username}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'KoHo',
                  color: theme.colorScheme.onPrimary,
                )),
            currentAccountPicture: Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.onPrimary,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: MyUserImageWidget(image: usuario.avatar),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_rounded),
            iconColor: theme.colorScheme.onPrimary,
            title: Text('Perfil',
                style: TextStyle(
                    fontFamily: 'KoHo', color: theme.colorScheme.onPrimary)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/perfil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_added_rounded),
            iconColor: theme.colorScheme.onPrimary,
            title: Text('Mis reservas',
                style: TextStyle(
                    fontFamily: 'KoHo', color: theme.colorScheme.onPrimary)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/mis-reservas');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            iconColor: theme.colorScheme.onPrimary,
            title: Text('Ajustes',
                style: TextStyle(
                    fontFamily: 'KoHo', color: theme.colorScheme.onPrimary)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Funcionalidad no disponible.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'KoHo',
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      )),
                  duration: const Duration(seconds: 1),
                  backgroundColor: theme.colorScheme.secondary,
                ),
              );
            },
          ),
          ListTile(
            iconColor: theme.colorScheme.onPrimary,
            leading: themeProvider.isDarkMode
                ? const Icon(Icons.wb_sunny_rounded)
                : const Icon(Icons.nightlight_round_rounded),
            title: themeProvider.isDarkMode
                ? Text('Cambiar a tema claro',
                    style: TextStyle(
                        fontFamily: 'KoHo', color: theme.colorScheme.onPrimary))
                : Text('Cambiar a tema oscuro',
                    style: TextStyle(
                        fontFamily: 'KoHo',
                        color: theme.colorScheme.onPrimary)),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
