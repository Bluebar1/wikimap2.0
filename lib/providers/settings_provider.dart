import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiki_map/providers/theme_provider.dart';

/*
Created NB 3/21/2020

This Provider class stores information for the Settings (settings.dart) class
The first 3 widgets on the settings page are just examples and don't change anything else,
but they are able to store if those selections even if the app in closed or turned off
 */
class SettingsProvider with ChangeNotifier {
  String _dropdownSingleSelection;
  List<String> _multipleSelection;
  List<String> _singleSelection;
  int _singleSelectionChoice;
  Color _themeColor;
  Color _accentColor;

  SettingsProvider(ThemeProvider themeProvider) {
    _dropdownSingleSelection = 'Option 1';
    _multipleSelection = ['Option 1', 'Option 2'];
    _singleSelectionChoice = 1;
    _singleSelection = ['Option 1', 'Option 2', 'Option 3'];
    _themeColor = Color(themeProvider.hexOfCurrentPrimary);
    _accentColor = Color(themeProvider.hexOfCurrentBackground);
    loadPreferences();
  }

  String get dropdownSingleSelection => _dropdownSingleSelection;
  List<String> get multipleSelection => _multipleSelection;
  int get singleSelection => _singleSelectionChoice;
  List<String> get speedString => _singleSelection;
  Color get themeColor => _themeColor;
  Color get accentColor => _accentColor;

  void setAccentColor(Color accentColor) {
    print('set accent color called');
    _accentColor = accentColor;
    notifyListeners();
    savePreferences();
  }

  void setThemeColor(Color themeColor) {
    print('SET THEME COLOR CALLED');
    _themeColor = themeColor;
    notifyListeners();
    savePreferences();
  }

  void setDropdownSingleSelection(String units) {
    _dropdownSingleSelection = units;
    notifyListeners();
    savePreferences();
  }

  void setSingleSelection(int speedSelect) {
    _singleSelectionChoice = speedSelect;
    notifyListeners();
    savePreferences();
  }

  void _setMultipleSelection(List<String> waxLines) {
    _multipleSelection = waxLines;
    notifyListeners();
  }

  void addMultipleSelection(String waxLine) {
    if (_multipleSelection.contains(waxLine) == false) {
      _multipleSelection.add(waxLine);
      notifyListeners();
      savePreferences();
    }
  }

  void removeMultipleSelection(String waxLine) {
    if (_multipleSelection.contains(waxLine) == true) {
      _multipleSelection.remove(waxLine);
      notifyListeners();
      savePreferences();
    }
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dropdownSingleSelection', _dropdownSingleSelection);
    prefs.setStringList('multipleSelection', _multipleSelection);
    prefs.setInt('singleSelection', _singleSelectionChoice);
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dropdownSingleSelection = prefs.getString('dropdownSingleSelection');
    List<String> multipleSelection = prefs.getStringList('multipleSelection');
    int singleSelection = prefs.getInt('singleSelection');

    if (dropdownSingleSelection != null)
      setDropdownSingleSelection(dropdownSingleSelection);
    if (multipleSelection != null) _setMultipleSelection(multipleSelection);
    if (singleSelection != null) setSingleSelection(singleSelection);
  }
}
