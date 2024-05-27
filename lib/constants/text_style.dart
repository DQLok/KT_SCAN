// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:techable/constants/colors_app.dart';
import 'package:techable/constants/dimension_app.dart';
import 'package:techable/constants/fonts_app.dart';

enum TextStyleApp {
  inter_s10_t_black,
  inter_s10_el_black,
  inter_s10_l_black,
  inter_s10_r_black,
  inter_s10_m_black,
  inter_s10_sb_black,
  inter_s10_b_black,
  inter_s10_eb_black,
  inter_s10_bl_black,
  inter_s25_b_b_primary, //weight = bold,
}

extension TextStyleExtension on TextStyleApp {
  TextStyle textStyle(
      {required Color color,
      required String familyFont,
      required double size,
      FontWeight? weight,
      TextDecoration? decoration}) {
    return TextStyle(
        color: color,
        fontFamily: familyFont,
        fontSize: size,
        fontWeight: weight,
        decoration: decoration);
  }

  TextStyle get style {
    final interT = FontsApp.interThin.font;
    final interEL = FontsApp.interExtraLight.font;
    final interL = FontsApp.interLight.font;
    final interR = FontsApp.interRegular.font;
    final interM = FontsApp.interMedium.font;
    final interSB = FontsApp.interSemiBold.font;
    final interB = FontsApp.interBlack.font;
    final interEB = FontsApp.interExtraBold.font;
    final interBl = FontsApp.interBlack.font;

    final weightB = FontWeight.bold;

    switch (this) {
      case TextStyleApp.inter_s10_t_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interT,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_el_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interEL,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_l_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interL,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_r_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interR,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_m_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interM,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_sb_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interSB,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_b_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interB,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_eb_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interEB,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s10_bl_black:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interBl,
            size: DimensionApp.size10);
      case TextStyleApp.inter_s25_b_b_primary:
        return textStyle(
            color: ColorsApp.primary,
            familyFont: interBl,
            weight: weightB,
            size: DimensionApp.size25);
      default:
        return textStyle(
            color: ColorsApp.black,
            familyFont: interT,
            size: DimensionApp.size10);
    }
  }
}
