/// Alejandro Sánchez Monzón
/// Mireya Sánchez Pinzón
/// Rubén García-Redondo Marín

import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/colors.dart';

/// Clase que gestiona los temas de la aplicación.
class AppTheme {
  /// Tema claro.
  static ThemeData lightThemeData =
      themeData(lightColorScheme, MyColors.blackApp.withOpacity(0.12));

  /// Tema oscuro.
  static ThemeData darkThemeData =
      themeData(darkColorScheme, MyColors.whiteApp.withOpacity(0.12));

  /// Función que devuelve un tema con los colores y el foco indicados.
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.surface),
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
    );
  }

  /// Color scheme para el tema claro.
  static ColorScheme lightColorScheme = ColorScheme(
    primary: MyColors.lightBlueApp,
    inversePrimary: MyColors.lightBlueApp.shade50,
    onPrimary: MyColors.whiteApp,
    primaryContainer: MyColors.lightBlueApp,
    secondary: MyColors.pinkApp,
    onSecondary: MyColors.whiteApp,
    secondaryContainer: MyColors.pinkApp,
    surface: MyColors.blackApp,
    onSurface: MyColors.blackApp,
    background: MyColors.whiteApp,
    onBackground: MyColors.lightBlueApp,
    error: MyColors.pinkApp,
    onError: MyColors.whiteApp,
    brightness: Brightness.light,
  );

  /// Color scheme para el tema oscuro.
  static ColorScheme darkColorScheme = ColorScheme(
    primary: MyColors.darkBlueApp,
    inversePrimary: MyColors.darkBlueApp.shade400,
    onPrimary: MyColors.whiteApp,
    primaryContainer: MyColors.darkBlueApp,
    secondary: MyColors.pinkApp,
    onSecondary: MyColors.whiteApp,
    secondaryContainer: MyColors.pinkApp,
    surface: MyColors.whiteApp,
    onSurface: MyColors.whiteApp,
    background: MyColors.darkBlueApp,
    onBackground: MyColors.lightBlueApp,
    error: MyColors.pinkApp,
    onError: MyColors.whiteApp,
    brightness: Brightness.dark,
  );
}
