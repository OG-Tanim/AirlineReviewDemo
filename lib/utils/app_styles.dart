import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF1D1929);
  static const Color lightBackground = Color(0xFFF8F8FF);
  static const Color borderColor = Color.fromRGBO(56, 78, 183, 0.3);
  static const Color darkBorder = Color(0xFF141B34);
  static const Color lightGrey = Color(0xFFA5A3A9);
  static const Color veryLightGrey = Color(0xFFE8E8EA);
  static const Color mediumGrey = Color(0xFFD4D7E0);
  static const Color darkGrey = Color(0xFF333333);
  static const Color calendarBackground = Color(0xFFE4E4E4);
  static const Color calendarIcon = Color(0xFF111111);
  static const Color ratingText = Color(0xFF0F0F0F);
  static const Color starYellow = Color(0xFFFFDC24);
  static const Color submitButton = Color(0xFF232323);
}

class AppTextStyles {
  static const TextStyle shareTitle = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w700,
    fontSize: 26,
    height: 1.35, // 1.3500000880314753em
    letterSpacing: 0.01, // 1%
    color: AppColors.primaryText,
  );

  static const TextStyle dropImageText = TextStyle(
    fontFamily: 'Mulish',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5, // 1.5em
    color: AppColors.darkGrey,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.16, // 1.1599999836512975em
    color: AppColors.lightGrey,
  );

  static const TextStyle messagePlaceholder = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.16, // 1.1599999836512975em
    color: AppColors.lightGrey,
  );

  static const TextStyle ratingText = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5, // 1.5em
    color: AppColors.ratingText,
  );

  static const TextStyle submitButtonText = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.12, // 1.1200000217982702em
    letterSpacing: 0.02, // 2%
    color: AppColors.white,
  );
}
