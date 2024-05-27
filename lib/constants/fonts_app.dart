enum FontsApp {
  interThin,
  interExtraLight,
  interLight,
  interRegular,
  interMedium,
  interSemiBold,
  interBold,
  interExtraBold,
  interBlack
}

extension FontsAppExtension on FontsApp {
  String get font {
    switch (this) {
      case FontsApp.interThin:
        return "Inter_Thin";
      case FontsApp.interExtraLight:
        return "Inter_ExtraLight";
      case FontsApp.interLight:
        return "Inter_Light";
      case FontsApp.interRegular:
        return "Inter_Regular";
      case FontsApp.interMedium:
        return "Inter_Medium";
      case FontsApp.interSemiBold:
        return "Inter_SemiBold";
      case FontsApp.interBold:
        return "Inter_Bold";
      case FontsApp.interExtraBold:
        return "Inter_ExtraBold";
      case FontsApp.interBlack:
        return "Inter_Black";
      default:
        return "Inter_Thin";
    }
  }
}
