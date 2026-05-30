import 'dart:math' as math;

import 'package:seohost/utils/core_export.dart';

class QadhaPalette {
  static const navy = Color(0xFF0A2D64);
  static const deepNavy = Color(0xFF061B3F);
  static const blue = Color(0xFF1D65E8);
  static const cyan = Color(0xFF19C8CF);
  static const green = Color(0xFF2FC86F);
  static const mint = Color(0xFFE9FFF8);
  static const textMuted = Color(0xFF71809B);
  static const line = Color(0xFFE4ECF7);
  static const pageBg = Color(0xFFF7FBFF);

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [cyan, blue],
  );

  static const headerGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [cyan, blue],
  );
}

class QadhaSoftScaffold extends StatelessWidget {
  final Widget child;
  final bool safeArea;
  final Color backgroundColor;

  const QadhaSoftScaffold({
    super.key,
    required this.child,
    this.safeArea = true,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: backgroundColor),
        const Positioned.fill(child: CustomPaint(painter: _SoftPagePainter())),
        child,
      ],
    );
    return safeArea ? SafeArea(child: content) : content;
  }
}

class QadhaGradientHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const QadhaGradientHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.height = 136,
    this.padding = const EdgeInsets.fromLTRB(22, 18, 22, 24),
    this.borderRadius = const BorderRadius.vertical(
      bottom: Radius.circular(30),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: QadhaPalette.headerGradient,
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x302660D8),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: const _HeaderWavePainter()),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: robotoBold.copyWith(
                color: Colors.white,
                fontSize: 30,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ),
          if (leading != null)
            Align(alignment: AlignmentDirectional.centerStart, child: leading),
          if (trailing != null)
            Align(alignment: AlignmentDirectional.centerEnd, child: trailing),
        ],
      ),
    );
  }
}

class QadhaGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double radius;
  final Color? color;
  final Border? border;
  final List<BoxShadow>? shadows;

  const QadhaGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin = EdgeInsets.zero,
    this.radius = 24,
    this.color,
    this.border,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: QadhaPalette.line, width: 1),
        boxShadow:
            shadows ??
            const [
              BoxShadow(
                color: Color(0x141A4384),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
      ),
      child: child,
    );
  }
}

class QadhaGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool iconAfterText;
  final bool loading;
  final double height;

  const QadhaGradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.iconAfterText = false,
    this.loading = false,
    this.height = 58,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TextButton(
        onPressed: loading ? null : onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: onTap == null ? null : QadhaPalette.primaryGradient,
            color: onTap == null ? const Color(0xFFB8C4D6) : null,
            borderRadius: BorderRadius.circular(18),
            boxShadow: onTap == null
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x30245CE8),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: iconAfterText
                        ? [
                            Text(
                              text,
                              style: robotoBold.copyWith(
                                color: Colors.white,
                                fontSize: 21,
                                height: 1,
                                letterSpacing: 0,
                              ),
                            ),
                            if (icon != null) ...[
                              const SizedBox(width: 12),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ]
                        : [
                            if (icon != null) ...[
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              text,
                              style: robotoBold.copyWith(
                                color: Colors.white,
                                fontSize: 21,
                                height: 1,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                  ),
          ),
        ),
      ),
    );
  }
}

class QadhaCircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;
  final bool filled;

  const QadhaCircleIcon({
    super.key,
    required this.icon,
    this.color = QadhaPalette.blue,
    this.size = 52,
    this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool whiteFilled = filled && color == Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled
              ? (whiteFilled ? Colors.white.withValues(alpha: .14) : color)
              : Colors.white.withValues(alpha: .9),
          shape: BoxShape.circle,
          border: Border.all(
            color: filled
                ? Colors.white.withValues(alpha: whiteFilled ? .28 : .2)
                : QadhaPalette.line,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x121A4384),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : color,
          size: size * .42,
        ),
      ),
    );
  }
}

class QadhaStatusPill extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const QadhaStatusPill({
    super.key,
    required this.text,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? QadhaPalette.green.withValues(alpha: .08)
              : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? QadhaPalette.green : QadhaPalette.line,
            width: selected ? 1.4 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F1A4384),
              blurRadius: 14,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? QadhaPalette.green : QadhaPalette.blue,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: robotoMedium.copyWith(
                color: QadhaPalette.deepNavy,
                fontSize: 14,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QadhaBrandMark extends StatelessWidget {
  final double iconSize;
  final double textSize;
  final bool showTagline;
  final Color textColor;

  const QadhaBrandMark({
    super.key,
    this.iconSize = 86,
    this.textSize = 42,
    this.showTagline = true,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          Images.logo,
          width: (iconSize * 2.9).clamp(92.0, 330.0),
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Text(
          'قدها',
          textAlign: TextAlign.center,
          style: robotoBold.copyWith(
            color: Colors.transparent,
            fontSize: 0,
            height: .9,
            letterSpacing: 0,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 10),
          Text(
            'جميع خدمات المنزلية\nبين يديك',
            textAlign: TextAlign.center,
            style: robotoMedium.copyWith(
              color: textColor.withValues(alpha: .85),
              fontSize: 15,
              height: 1.35,
              letterSpacing: 0,
            ),
          ),
        ],
      ],
    );
  }
}

class QadhaEntranceScaffold extends StatelessWidget {
  final bool showLoader;
  final Widget? child;

  const QadhaEntranceScaffold({super.key, this.showLoader = false, this.child});

  @override
  Widget build(BuildContext context) {
    return QadhaEntranceBackground(
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  child ??
                  Align(
                    alignment: const Alignment(0, -.12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const QadhaBrandMark(textColor: QadhaPalette.navy),
                        if (showLoader) ...[
                          const SizedBox(height: 34),
                          SizedBox(
                            width: 112,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: const LinearProgressIndicator(
                                minHeight: 3,
                                color: Color(0xFF42D34F),
                                backgroundColor: Color(0x331CD6D2),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class QadhaEntranceBackground extends StatelessWidget {
  final Widget child;

  const QadhaEntranceBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, QadhaPalette.pageBg, QadhaPalette.mint],
              stops: [0, .58, 1],
            ),
          ),
        ),
        const Positioned.fill(child: CustomPaint(painter: _SoftPagePainter())),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 210,
          child: CustomPaint(painter: const _LivingRoomPainter()),
        ),
        child,
      ],
    );
  }
}

class QadhaHomeBackground extends StatelessWidget {
  final Widget child;

  const QadhaHomeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF07111D), Color(0xFF0A1B2D), Color(0xFF06111D)],
            ),
          ),
        ),
        CustomPaint(painter: const _HomeGoldAccentPainter()),
        child,
      ],
    );
  }
}

class _SoftPagePainter extends CustomPainter {
  const _SoftPagePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final mintPaint = Paint()..color = const Color(0x2238D5C7);
    final bluePaint = Paint()..color = const Color(0x1A1D65E8);

    canvas.drawCircle(
      Offset(size.width * .02, size.height * .16),
      size.width * .18,
      bluePaint,
    );
    canvas.drawCircle(
      Offset(size.width * .98, size.height * .18),
      size.width * .2,
      bluePaint,
    );
    canvas.drawCircle(
      Offset(size.width * .92, size.height * .78),
      size.width * .22,
      mintPaint,
    );
    canvas.drawCircle(
      Offset(size.width * .07, size.height * .93),
      size.width * .2,
      mintPaint,
    );

    final ringPaint = Paint()
      ..color = const Color(0x221D65E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(size.width * .98, size.height * .04),
        size.width * (.18 + i * .06),
        ringPaint,
      );
    }

    final wavePaint = Paint()..color = const Color(0x1435D8B4);
    final path = Path()
      ..moveTo(0, size.height * .78)
      ..cubicTo(
        size.width * .22,
        size.height * .72,
        size.width * .34,
        size.height * .9,
        size.width * .55,
        size.height * .83,
      )
      ..cubicTo(
        size.width * .78,
        size.height * .75,
        size.width * .86,
        size.height * .66,
        size.width,
        size.height * .7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeaderWavePainter extends CustomPainter {
  const _HeaderWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..moveTo(-size.width * .1, size.height * .7)
      ..cubicTo(
        size.width * .18,
        size.height * .42,
        size.width * .4,
        size.height * .92,
        size.width * .68,
        size.height * .55,
      )
      ..cubicTo(
        size.width * .84,
        size.height * .34,
        size.width * .98,
        size.height * .42,
        size.width * 1.08,
        size.height * .22,
      );
    canvas.drawPath(path, paint);

    final star = Paint()..color = Colors.white.withValues(alpha: .22);
    canvas.drawCircle(Offset(size.width * .2, size.height * .22), 1.8, star);
    canvas.drawCircle(Offset(size.width * .76, size.height * .31), 1.5, star);
    canvas.drawCircle(Offset(size.width * .87, size.height * .68), 1.2, star);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LivingRoomPainter extends CustomPainter {
  const _LivingRoomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final floorPaint = Paint()..color = const Color(0x33001635);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .52, size.height * .88),
        width: size.width * .86,
        height: size.height * .24,
      ),
      floorPaint,
    );

    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [const Color(0x6618AFFF), const Color(0x00002861)],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .5, size.height * .7),
              radius: size.width * .42,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .72),
      size.width * .42,
      glowPaint,
    );

    final shadow = Paint()..color = const Color(0x9900071A);
    final furniture = Paint()..color = const Color(0xFF064B9C);
    final furnitureLight = Paint()..color = const Color(0xFF0D6DCA);
    final line = Paint()
      ..color = const Color(0xAA2AAEFF)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .28,
          size.height * .52,
          size.width * .44,
          size.height * .24,
        ),
        const Radius.circular(20),
      ),
      furniture,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .32,
          size.height * .43,
          size.width * .15,
          size.height * .17,
        ),
        const Radius.circular(13),
      ),
      furnitureLight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .53,
          size.height * .43,
          size.width * .15,
          size.height * .17,
        ),
        const Radius.circular(13),
      ),
      furnitureLight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .23,
          size.height * .62,
          size.width * .12,
          size.height * .18,
        ),
        const Radius.circular(13),
      ),
      furniture,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .65,
          size.height * .62,
          size.width * .12,
          size.height * .18,
        ),
        const Radius.circular(13),
      ),
      furniture,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .81),
        width: size.width * .34,
        height: size.height * .055,
      ),
      shadow,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .76),
        width: size.width * .31,
        height: size.height * .055,
      ),
      Paint()..color = const Color(0xFF0C58B0),
    );
    canvas.drawLine(
      Offset(size.width * .4, size.height * .78),
      Offset(size.width * .35, size.height * .91),
      line,
    );
    canvas.drawLine(
      Offset(size.width * .6, size.height * .78),
      Offset(size.width * .65, size.height * .91),
      line,
    );

    canvas.drawLine(
      Offset(size.width * .19, size.height * .32),
      Offset(size.width * .19, size.height * .78),
      line,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .19, size.height * .3),
        width: size.width * .13,
        height: size.height * .04,
      ),
      Paint()..color = const Color(0xFF0D6DCA),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .16,
        size.height * .33,
        size.width * .06,
        size.height * .08,
      ),
      Paint()..color = const Color(0xAA0D6DCA),
    );

    final plantPaint = Paint()
      ..color = const Color(0xFF0AB681)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < 5; i++) {
      final dx = (i - 2) * size.width * .018;
      final path = Path()
        ..moveTo(size.width * .82, size.height * .78)
        ..quadraticBezierTo(
          size.width * (.82 + dx / size.width),
          size.height * (.6 + i * .015),
          size.width * (.78 + i * .02),
          size.height * (.5 + i * .035),
        );
      canvas.drawPath(path, plantPaint);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .79,
          size.height * .77,
          size.width * .07,
          size.height * .08,
        ),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF094079),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HomeGoldAccentPainter extends CustomPainter {
  const _HomeGoldAccentPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x44C49A47)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * .78,
        -size.width * .44,
        size.width * .7,
        size.width * .7,
      ),
      math.pi * .5,
      math.pi * .9,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        -size.width * .42,
        size.height * .04,
        size.width * .58,
        size.width * .58,
      ),
      -math.pi * .55,
      math.pi * .75,
      false,
      paint,
    );
    canvas.drawLine(
      Offset(size.width * .04, size.height * .08),
      Offset(size.width * .15, size.height * .18),
      paint..color = const Color(0x22C49A47),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
