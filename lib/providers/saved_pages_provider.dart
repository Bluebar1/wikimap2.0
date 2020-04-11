import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Created NB 3/21/2020

This Provider class stores information for the Settings (settings.dart) class
The first 3 widgets on the settings page are just examples and don't change anything else,
but they are able to store if those selections even if the app in closed or turned off
 */
class SavedPagesProvider with ChangeNotifier {
  List<String> _savedPageTitles = List<String>();
  List<String> _savedWikiPageIds = List<String>();

  List<String> get savedPageTitles => _savedPageTitles;
  List<String> get savedWikiPageIds => _savedWikiPageIds;

  SavedPagesProvider() {
    print('saved pages provider called');
    _savedPageTitles.add('example title 1');
    _savedWikiPageIds.add('983298');
    print('saved pages list set to ' + _savedPageTitles.toString());
    loadPreferences();
  }

  deleteSavedPage(int index) {
    _savedPageTitles.removeAt(index);
    _savedWikiPageIds.removeAt(index);
    notifyListeners();
    savePreferences();
  }

  deleteAllPages() {
    _savedPageTitles.clear();
    _savedWikiPageIds.clear();
    _savedPageTitles.add('Apple Park');
    _savedWikiPageIds.add('40780688');
    notifyListeners();
    savePreferences();
  }

  addSavedPage(String title) {
    if (!(_savedPageTitles.contains(title))) {
      _savedPageTitles.add(title);
      notifyListeners();
      savePreferences();
    } else
      print('PAGE ALREADY SAVED ERROR');
  }

  setSavedPages(List<String> titles) {
    _savedPageTitles = titles;
    notifyListeners();
    savePreferences();
  }

  addSavedWikiPageId(String pageId) {
    if (!(_savedWikiPageIds.contains(pageId))) {
      _savedWikiPageIds.add(pageId);
      notifyListeners();
      savePreferences();
    } else
      print('PAGE ID ALREADY SAVED ERROR');
  }

  setSavedWikiPageIds(List<String> pageIds) {
    _savedWikiPageIds = pageIds;
    notifyListeners();
    savePreferences();
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedPageTitles', _savedPageTitles);
    prefs.setStringList('savedWikiPageIds', _savedWikiPageIds);
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedPageTitles = prefs.getStringList('savedPageTitles');
    List<String> savedWikiPageIds = prefs.getStringList('savedWikiPageIds');
    if (savedPageTitles != null) setSavedPages(savedPageTitles);
    if (savedWikiPageIds != null) setSavedWikiPageIds(savedWikiPageIds);
  }
}
