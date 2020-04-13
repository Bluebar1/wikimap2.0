import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/theme_provider.dart';
import '../providers/settings_provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 25.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Dropdown Single Selection'),
                DropdownButton<String>(
                  value: settingsProvider.dropdownSingleSelection,
                  onChanged: (String value) {
                    settingsProvider.setDropdownSingleSelection(value);
                  },
                  items: <String>['Option 1', 'Option 2']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                )
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Multiple Selection'),
                Container(
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: <Widget>[
                      FilterChip(
                        label: Text('Option 1',
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        selected: (settingsProvider.multipleSelection
                                .contains('Option 1'))
                            ? true
                            : false,
                        onSelected: (bool value) {
                          if (value == true) {
                            settingsProvider.addMultipleSelection('Option 1');
                          } else {
                            settingsProvider
                                .removeMultipleSelection('Option 1');
                          }
                        },
                      ),
                      FilterChip(
                        label: Text('Option 2',
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        selected: (settingsProvider.multipleSelection
                                .contains('Option 2'))
                            ? true
                            : false,
                        onSelected: (bool value) {
                          if (value == true) {
                            settingsProvider.addMultipleSelection('Option 2');
                          } else {
                            settingsProvider
                                .removeMultipleSelection('Option 2');
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: List<Widget>.generate(
              3,
              (int index) {
                return ChoiceChip(
                  label: Text('${settingsProvider.speedString[index]}'),
                  selected: settingsProvider.singleSelection == index,
                  onSelected: (bool selected) {
                    selected
                        ? settingsProvider.setSingleSelection(index)
                        : settingsProvider.setSingleSelection(null);
                  },
                );
              },
            ).toList(),
          ),
          RaisedButton(
            elevation: 3.0,
            onPressed: () {
              var themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    content: SingleChildScrollView(
                      child: SlidePicker(
                        pickerColor: settingsProvider.themeColor,
                        onColorChanged: (Color color) {
                          settingsProvider.setThemeColor(color);
                          themeProvider.setPrimaryColor(color);
                        },
                        paletteType: PaletteType.rgb,
                        enableAlpha: false,
                        displayThumbColor: true,
                        showLabel: false,
                        showIndicator: true,
                        indicatorBorderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(25.0),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text('Change Primary Color'),
            color: settingsProvider.themeColor,
            textColor: useWhiteForeground(settingsProvider.themeColor)
                ? const Color(0xffffffff)
                : const Color(0xff000000),
          ),
          RaisedButton(
            elevation: 3.0,
            onPressed: () {
              var themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    content: SingleChildScrollView(
                      child: SlidePicker(
                        pickerColor: settingsProvider.accentColor,
                        onColorChanged: (Color color) {
                          settingsProvider.setAccentColor(color);
                          themeProvider.setBackgroundColor(color);
                        },
                        paletteType: PaletteType.rgb,
                        enableAlpha: false,
                        displayThumbColor: true,
                        showLabel: false,
                        showIndicator: true,
                        indicatorBorderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(25.0),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text('Change Accent Color'),
            color: settingsProvider.accentColor,
            textColor: useWhiteForeground(settingsProvider.accentColor)
                ? const Color(0xffffffff)
                : const Color(0xff000000),
          ),
        ],
      ),
    );
  }
}
