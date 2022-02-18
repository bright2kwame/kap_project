import 'package:flutter/material.dart';

class AppDecoration {
  static get appBackgroundDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.4, 0.7, 0.9],
          colors: [
            Color(0xFF5CC5E8),
            Color(0xFF5CC5E8),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
          ],
        ),
      );

  static get appBoardBackgroundDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.4, 0.7],
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black54,
          ],
        ),
      );

  static get topAppBackgroundDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.3, 0.1, 0.1],
          colors: [
            Color(0xFF5CC5E8),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
          ],
        ),
      );

  static cardBackgroundDecoration(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.1, 0.4, 0.7, 0.9],
        colors: [
          color,
          color,
          const Color(0xFFFFFFFF),
          const Color(0xFFFFFFFF),
        ],
      ),
    );
  }

  static overlayBackgroundDecoration(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.1, 0.4, 0.9],
        colors: [
          Colors.transparent,
          Colors.transparent,
          color,
        ],
      ),
    );
  }
}
