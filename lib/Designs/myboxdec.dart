import 'dart:ui';
import 'package:flutter/material.dart';

/// =======================
/// MyBoxShadow
/// =======================
class MyBoxShadow {
  final Color color;
  final Offset offset;
  final double blurRadius;
  final double spreadRadius;
  final bool inset;

  const MyBoxShadow({
    required this.color,
    this.offset = Offset.zero,
    this.blurRadius = 0.0,
    this.spreadRadius = 0.0,
    this.inset = false,
  });

  /// 🔥 Animation Support
  static MyBoxShadow? lerp(MyBoxShadow? a, MyBoxShadow? b, double t) {
    if (a == null && b == null) return null;

    return MyBoxShadow(
      color: Color.lerp(a?.color, b?.color, t) ?? Colors.transparent,
      offset: Offset.lerp(a?.offset, b?.offset, t) ?? Offset.zero,
      blurRadius: lerpDouble(a?.blurRadius, b?.blurRadius, t) ?? 0.0,
      spreadRadius: lerpDouble(a?.spreadRadius, b?.spreadRadius, t) ?? 0.0,
      inset: t < 0.5 ? (a?.inset ?? false) : (b?.inset ?? false),
    );
  }
}

/// =======================
/// MyBoxDecoration
/// =======================
class MyBoxDecoration extends Decoration {
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final List<MyBoxShadow> boxShadow;

  const MyBoxDecoration({
    this.color = Colors.white,
    this.borderRadius = BorderRadius.zero,
    this.boxShadow = const [],
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyBoxPainter(this);
  }

  /// 🔥 Animation Support
  static MyBoxDecoration? lerp(
      MyBoxDecoration? a, MyBoxDecoration? b, double t) {
    if (a == null && b == null) return null;

    return MyBoxDecoration(
      color: Color.lerp(a?.color, b?.color, t) ?? Colors.white,
      borderRadius:
      BorderRadiusGeometry.lerp(a?.borderRadius, b?.borderRadius, t) ??
          BorderRadius.zero,
      boxShadow: List.generate(
        a?.boxShadow.length ?? 0,
            (index) => MyBoxShadow.lerp(
          a?.boxShadow[index],
          b?.boxShadow[index],
          t,
        )!,
      ),
    );
  }

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is MyBoxDecoration) {
      return MyBoxDecoration.lerp(a, this, t);
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is MyBoxDecoration) {
      return MyBoxDecoration.lerp(this, b, t);
    }
    return super.lerpTo(b, t);
  }
}

/// =======================
/// Painter
/// =======================
class _MyBoxPainter extends BoxPainter {
  final MyBoxDecoration decoration;

  _MyBoxPainter(this.decoration);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size size = configuration.size!;
    final Rect rect = offset & size;

    final BorderRadius resolved =
    decoration.borderRadius.resolve(TextDirection.ltr);

    final RRect rrect = resolved.toRRect(rect);

    // Draw outer shadows
    for (final shadow in decoration.boxShadow) {
      if (!shadow.inset) {
        _drawOuterShadow(canvas, rrect, shadow);
      }
    }

    // Fill color
    final Paint fillPaint = Paint()..color = decoration.color;
    canvas.drawRRect(rrect, fillPaint);

    // Draw inset shadows
    for (final shadow in decoration.boxShadow) {
      if (shadow.inset) {
        _drawInsetShadow(canvas, rect, rrect, shadow);
      }
    }
  }

  void _drawOuterShadow(Canvas canvas, RRect rrect, MyBoxShadow shadow) {
    final Paint paint = Paint()
      ..color = shadow.color
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        _convertRadiusToSigma(shadow.blurRadius),
      );

    final RRect spreadRRect = rrect.inflate(shadow.spreadRadius);

    canvas.drawRRect(
      spreadRRect.shift(shadow.offset),
      paint,
    );
  }

  void _drawInsetShadow(
      Canvas canvas,
      Rect rect,
      RRect rrect,
      MyBoxShadow shadow,
      ) {
    final double blurSigma = _convertRadiusToSigma(shadow.blurRadius);

    final RRect outer =
    rrect.inflate(shadow.spreadRadius).shift(shadow.offset);

    final Path outerPath = Path()..addRRect(outer);
    final Path innerPath = Path()..addRRect(rrect);

    final Path shadowRing =
    Path.combine(PathOperation.difference, outerPath, innerPath);

    final Paint paint = Paint()
      ..color = shadow.color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawPath(shadowRing, paint);
    canvas.restore();
  }

  double _convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}