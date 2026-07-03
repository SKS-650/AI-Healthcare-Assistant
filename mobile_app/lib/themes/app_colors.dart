import 'package:flutter/material.dart';

/// Premium dark healthcare color palette
class AppColors {
  const AppColors._();

  // ── Core Background ──────────────────────────────────────────────────────
  static const background = Color(0xFF0D1117);
  static const surface = Color(0xFF1B263B);
  static const surfaceVariant = Color(0xFF243447);
  static const border = Color(0xFF2C3A4D);

  // ── Brand ─────────────────────────────────────────────────────────────────
  static const primary = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFF93C5FD);

  // ── Accent ────────────────────────────────────────────────────────────────
  static const accent = Color(0xFF22C55E);
  static const accentDark = Color(0xFF16A34A);
  static const accentLight = Color(0xFF86EFAC);

  // ── Status Colors ─────────────────────────────────────────────────────────
  static const emergency = Color(0xFFEF4444);
  static const emergencyDark = Color(0xFFB91C1C);
  static const emergencyLight = Color(0xFFFCA5A5);
  static const warning = Color(0xFFF59E0B);
  static const warningDark = Color(0xFFB45309);
  static const warningLight = Color(0xFFFCD34D);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textTertiary = Color(0xFF6B7280);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientAccent = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientEmergency = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientWarm = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientCool = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientPurple = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Glassmorphism ─────────────────────────────────────────────────────────
  static final glassWhite = Colors.white.withValues(alpha: 0.08);
  static final glassBorder = Colors.white.withValues(alpha: 0.12);

  // ── Shadows ───────────────────────────────────────────────────────────────
  static final shadowPrimary = [
    BoxShadow(
      color: primary.withValues(alpha: 0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static final shadowCard = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static final shadowEmergency = [
    BoxShadow(
      color: emergency.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
