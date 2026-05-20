import 'package:flutter/material.dart';

class AppStyle {
  AppStyle._();

  // ── Screen ────────────────────────────────────────────────

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double heightBanner(BuildContext context, [double? height]) {
    final w = MediaQuery.of(context).size.width;
    final h = height ?? screenHeight(context);

    // ✅ Phone
    if (w < 600) {
      if (h < 700) return h * 0.21;
      if (h < 900) return h * 0.22;
      return h * 0.23;
    }

    // ✅ Tablet
    if (w < 1024) {
      return h * 0.35;
    }

    // ✅ Laptop / PC
    if (w < 1440) {
      return h * 0.45;
    }

    return h * 0.50;
  }

  static bool isCompact(BuildContext context) {
    return screenWidth(context) < 420;
  }

  // ── Common Layout ─────────────────────────────────────────

  static double padding(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.035).clamp(12.0, 36.0);
  }

  static int columns(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w / 220).floor().clamp(1, 6);
  }

  static double maxWidth(BuildContext context) {
    final w = screenWidth(context);

    if (w < 600) return double.infinity;
    if (w < 1024) return 500;

    return 600;
  }

  // ── Typography ────────────────────────────────────────────

  static double titleSize(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.05).clamp(18.0, 30.0);
  }

  static double bodySize(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.032).clamp(12.0, 18.0);
  }

  static double bodySizeSmall(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.028).clamp(10.0, 15.0);
  }

  static double captionSize(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.024).clamp(9.0, 13.0);
  }

  // ── Icons ─────────────────────────────────────────────────

  static double iconSize(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.03).clamp(16.0, 24.0);
  }

  // ── Radius ────────────────────────────────────────────────

  static double cardRadius(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.02).clamp(8.0, 16.0);
  }

  // ── Spacing ───────────────────────────────────────────────

  static double sectionGap(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.012).clamp(6.0, 14.0);
  }

  static double cardGap(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.018).clamp(10.0, 22.0);
  }

  static double topSpace(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.05).clamp(16.0, 40.0);
  }

  static double bottomSpace(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.06).clamp(32.0, 64.0);
  }

  // ── Button ────────────────────────────────────────────────

  static double buttonVerticalPadding(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.025).clamp(10.0, 18.0);
  }

  // ── Profile Screen ────────────────────────────────────────

  static double profileMaxWidth(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    if (w < 600) return double.infinity;
    if (w < 1024) return 520;

    return 640;
  }

  static double profileTopSpace(
      BuildContext context, [
        double? width,
      ]) {
    return topSpace(context, width);
  }

  static double profileAvatarBottomSpace(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    return (w * 0.04).clamp(20.0, 40.0);
  }

  static double profileBottomSpace(
      BuildContext context, [
        double? width,
      ]) {
    return bottomSpace(context, width);
  }

  static double profileSectionGap(
      BuildContext context, [
        double? width,
      ]) {
    return sectionGap(context, width);
  }

  static double profileCardGap(
      BuildContext context, [
        double? width,
      ]) {
    return cardGap(context, width);
  }

  static double profileSectionLabelSize(
      BuildContext context, [
        double? width,
      ]) {
    return captionSize(context, width);
  }

  // ── Product Grid ──────────────────────────────────────────

  static double productCardAspectRatio(
      BuildContext context, [
        double? width,
      ]) {
    final w = width ?? screenWidth(context);

    if (w < 400) return 0.52;
    if (w < 800) return 0.58;
    if (w < 1200) return 0.64;

    return 0.70;
  }
}