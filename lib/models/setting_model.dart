class SettingsModel {
  final bool isLoggedIn;
  final int selectedLanguageIndex;
  final List<LanguageOption> languageOptions;

  SettingsModel({
    required this.isLoggedIn,
    this.selectedLanguageIndex = 0,
    required this.languageOptions,
  });

  factory SettingsModel.initial() {
    return SettingsModel(
      isLoggedIn: false,
      selectedLanguageIndex: 0,
      languageOptions: LanguageOption.getDefaultOptions(),
    );
  }

  SettingsModel copyWith({
    bool? isLoggedIn,
    int? selectedLanguageIndex,
    List<LanguageOption>? languageOptions,
  }) {
    return SettingsModel(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      selectedLanguageIndex:
          selectedLanguageIndex ?? this.selectedLanguageIndex,
      languageOptions: languageOptions ?? this.languageOptions,
    );
  }
}

class LanguageOption {
  final String name;
  final bool isAvailable;
  final String? comingSoonText;

  LanguageOption({
    required this.name,
    this.isAvailable = true,
    this.comingSoonText,
  });

  static List<LanguageOption> getDefaultOptions() {
    return [
      LanguageOption(name: 'Indonesia', isAvailable: true),
      LanguageOption(
        name: 'English',
        isAvailable: false,
        comingSoonText: 'Segera hadir',
      ),
    ];
  }
}
