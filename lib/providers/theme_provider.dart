import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Created NB 3/21/2020

This provider class stores the information for theme information for the whole app.
It is created higher than any other provider in the widget tree because the SettingsProvider
needs information from the ThemeProvider to build, so the Theme provider must be created first-
which is why it is initialized in the main.dart file with these lines:
  ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),

This class uses the shared_preferences.dart package to store this information on the device so that-
this information will be saved even if the app closes or the device turns off
 */
class ThemeProvider with ChangeNotifier {
  //Member variables
  ThemeData _themeData;
  int _hexOfCurrentPrimary;
  int _hexOfCurrentBackground;

  //Constructor that sets the default theme settings that can be changed and calls loadPreferences() function
  ThemeProvider() {
    _themeData = ThemeData.dark();
    _hexOfCurrentPrimary = 0xFF42A5F5;
    _hexOfCurrentBackground = 0xFF42A5F5;
    loadPreferences();
  }

  //Member get functions
  ThemeData get themeData => _themeData;
  int get hexOfCurrentPrimary => _hexOfCurrentPrimary;
  int get hexOfCurrentBackground => _hexOfCurrentBackground;

  //Member set Functions
  //if the variable being set is not being listened to from the widget tree or is not being stored in preferences
  //then notifyListeners() and savePreferences() are not needed
  void setHexCurrentBackground(int hexCurrentBackground) {
    _hexOfCurrentBackground = hexCurrentBackground;
  }

  void setHexCurrentPrimary(int hexCurrentPrimary) {
    _hexOfCurrentPrimary = hexCurrentPrimary;
  }

  void setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
    savePreferences();
  }

  //To change variable inside of a ThemeData object,
  //I needed to create a new ThemeData using the information for the classes current-
  //_themeData object, and changing its primary color attribute to Color passed in the parameter
  void setPrimaryColor(Color primaryColor) {
    setHexCurrentPrimary(primaryColor.value);
    ThemeData _tempTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: primaryColor,
      brightness: _themeData.brightness,
      backgroundColor: _themeData.backgroundColor,
      accentColor: _themeData.accentColor,
      accentIconTheme: _themeData.accentIconTheme,
      dividerColor: _themeData.dividerColor,
    );
    setTheme(_tempTheme);
  }

  void setBackgroundColor(Color backgroundColor) {
    print('set background color called');
    setHexCurrentBackground(backgroundColor.value);
    ThemeData _tempTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: _themeData.primaryColor,
      brightness: _themeData.brightness,
      backgroundColor: _themeData.backgroundColor,
      accentColor: backgroundColor,
      accentIconTheme: _themeData.accentIconTheme,
      dividerColor: _themeData.dividerColor,
    );
    setTheme(_tempTheme);
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('primaryHex', _hexOfCurrentPrimary);
    prefs.setInt('backgroundHex', _hexOfCurrentBackground);
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int primaryHex = prefs.getInt('primaryHex');
    int backgroundHex = prefs.getInt('backgroundHex');
    if (primaryHex != null) setPrimaryColor(Color(primaryHex));
    if (backgroundHex != null) setBackgroundColor(Color(backgroundHex));
  }
}
