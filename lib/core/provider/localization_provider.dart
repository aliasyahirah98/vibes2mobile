import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myveteran/shared/config/constant.dart';

class LocalizationProvider extends ChangeNotifier {
  LocalizationProvider() {
    _loadCurrentLanguage();
  }

  Locale _locale = Locale(languages[0].languageCode!, languages[0].countryCode);
  bool _isLtr = true;
  int? _languageIndex;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get languageIndex => _languageIndex!;

  void setLanguage(Locale locale) {
    _locale = locale;
    _isLtr = _locale.languageCode != 'ar';
    for(int index=0; index<languages.length; index++) {
      if(languages[index].languageCode == locale.languageCode) {
        _languageIndex = index;
        break;
      }
    }
    _saveLanguage(_locale);
    notifyListeners();
  }

  _loadCurrentLanguage() async {
    var _readStorage = const FlutterSecureStorage();
    String? _currentLanguage = await _readStorage.read(key: languageCode);
    String? _currentCountry = await _readStorage.read(key: countryCode);

    _locale = Locale(_currentLanguage ?? languages[0].languageCode!,
        _currentCountry ?? languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    for(int index=0; index<languages.length; index++) {
      if(languages[index].languageCode == locale.languageCode) {
        _languageIndex = index;
        break;
      }
    }
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    var _writeStorage = const FlutterSecureStorage();
    await _writeStorage.write(key: languageCode, value: locale.languageCode);
    await _writeStorage.write(key: countryCode, value: locale.countryCode);
  }
}