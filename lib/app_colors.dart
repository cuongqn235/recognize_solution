class AppColors {
  static List<AppColors> get values => [
        AppColors(value: 0.01, red: 141, green: 145, blue: 135),
        AppColors(value: 0.025, red: 146, green: 150, blue: 138),
        AppColors(value: 0.05, red: 129, green: 139, blue: 127),
        AppColors(value: 0.1, red: 125, green: 147, blue: 135),
        AppColors(value: 0.25, red: 85, green: 137, blue: 131),
        AppColors(value: 0.5, red: 0, green: 111, blue: 118),
        AppColors(value: 0.75, red: 32, green: 122, blue: 125),
        AppColors(value: 1, red: 0, green: 105, blue: 122),
        AppColors(value: 0.015, red: 141, green: 143, blue: 130),
        AppColors(value: 0.035, red: 149, green: 153, blue: 143),
        AppColors(value: 0.045, red: 139, green: 146, blue: 135),
        AppColors(value: 0.075, red: 144, green: 148, blue: 255),
        AppColors(value: 0.15, red: 135, green: 147, blue: 135),
        AppColors(value: 0.35, red: 142, green: 162, blue: 156),
        AppColors(value: 0.45, red: 133, green: 158, blue: 151),
        AppColors(value: 0.65, red: 129, green: 156, blue: 150),
        AppColors(value: 0.85, red: 89, green: 125, blue: 119),
      ];
  final double value;

  final int red, green, blue;

  AppColors({
    required this.value,
    required this.red,
    required this.green,
    required this.blue,
  });
}
