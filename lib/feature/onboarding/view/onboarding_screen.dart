import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/feature/onboarding/controller/on_board_pager_controller.dart';
import 'package:seohost/utils/core_export.dart';

class OnBoardingScreen extends GetView<OnBoardController> {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<OnBoardController>(
        builder: (onBoardingController) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: PageView.builder(
              controller: onBoardingController.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: 3,
              itemBuilder: (context, index) {
                final controls = _OnboardingControls(
                  index: onBoardingController.pageIndex,
                  total: 3,
                  onPrevious: onBoardingController.pageIndex == 0
                      ? null
                      : () => onBoardingController.pageController.previousPage(
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeOutCubic,
                        ),
                  onNext: () {
                    if (onBoardingController.pageIndex == 2) {
                      _finishOnboarding();
                    } else {
                      onBoardingController.pageController.nextPage(
                        duration: const Duration(milliseconds: 420),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                );

                if (index == 0) {
                  return _WelcomeOnboardingPage(controls: controls);
                }
                if (index == 1) {
                  return _CleaningOnboardingPage(controls: controls);
                }
                return _TrustOnboardingPage(controls: controls);
              },
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeOnboardingPage extends StatelessWidget {
  final _OnboardingControls controls;

  const _WelcomeOnboardingPage({required this.controls});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _SoftWhiteBackground()),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 210,
          child: CustomPaint(painter: _MintWavePainter()),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const QadhaBrandMark(
                  iconSize: 156,
                  textSize: 96,
                  showTagline: false,
                  textColor: Color(0xFF123A8F),
                ),
                const SizedBox(height: 84),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: robotoBold.copyWith(
                      color: const Color(0xFF0E2F69),
                      fontSize: 42,
                      height: 1.25,
                      letterSpacing: 0,
                    ),
                    children: const [
                      TextSpan(text: 'مرحبا بك في '),
                      TextSpan(
                        text: 'قدها',
                        style: TextStyle(color: Color(0xFF27BC89)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'تطبيقك الموثوق لجميع\nالخدمات المنزلية',
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(
                    color: const Color(0xFF7B89A4),
                    fontSize: 25,
                    height: 1.55,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(flex: 3),
                _PrimaryPillButton(text: 'ابدأ', onTap: controls.onNext),
                const SizedBox(height: 28),
                _PageDots(index: controls.index, total: controls.total),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CleaningOnboardingPage extends StatelessWidget {
  final _OnboardingControls controls;

  const _CleaningOnboardingPage({required this.controls});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _SoftWhiteBackground()),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 210,
          child: CustomPaint(painter: _MintWavePainter()),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 26, 28, 0),
            child: Column(
              children: [
                const Spacer(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: robotoBold.copyWith(
                      color: const Color(0xFF123A8F),
                      fontSize: 40,
                      height: 1.32,
                      letterSpacing: 0,
                    ),
                    children: const [
                      TextSpan(text: 'خدمات منزلية\nبجودة '),
                      TextSpan(
                        text: 'عالية',
                        style: TextStyle(color: Color(0xFF28D284)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'نقدم لك أفضل الخدمات المنزلية\nباحترافية وثقة تامة',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: const Color(0xFF7B89A4),
                    fontSize: 22,
                    height: 1.45,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 26),
                Expanded(
                  flex: 5,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _CleaningIllustrationPainter(),
                      );
                    },
                  ),
                ),
                _BottomInfoPanel(
                  title: 'تجربة سهلة وسريعة',
                  subtitle: 'احجز خدمتك في دقائق\nواستمتع براحة البال',
                  controls: controls,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrustOnboardingPage extends StatelessWidget {
  final _OnboardingControls controls;

  const _TrustOnboardingPage({required this.controls});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _SoftWhiteBackground()),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
            child: Column(
              children: [
                const Spacer(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: robotoBold.copyWith(
                      color: const Color(0xFF123A8F),
                      fontSize: 40,
                      height: 1.28,
                      letterSpacing: 0,
                    ),
                    children: const [
                      TextSpan(text: 'جودة وثقة\n'),
                      TextSpan(text: 'نهتم براحتك'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'فريق مدرب ومحترف لخدمتك\nفي أي وقت وأي مكان',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: const Color(0xFF7B89A4),
                    fontSize: 23,
                    height: 1.45,
                    letterSpacing: 0,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _LivingRoomIllustrationPainter(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _FeatureMini(
                      icon: Icons.headset_mic_outlined,
                      text: 'دعم\n24/7',
                    ),
                    _FeatureMini(
                      icon: Icons.local_offer_outlined,
                      text: 'أسعار\nتنافسية',
                    ),
                    _FeatureMini(
                      icon: Icons.verified_user_outlined,
                      text: 'ضمان\nالجودة',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                controls,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomInfoPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final _OnboardingControls controls;

  const _BottomInfoPanel({
    required this.title,
    required this.subtitle,
    required this.controls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x3301204C),
            blurRadius: 24,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentDots(index: controls.index),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: robotoBold.copyWith(
              color: const Color(0xFF123A8F),
              fontSize: 25,
              height: 1.15,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(
              color: const Color(0xFF7B89A4),
              fontSize: 19,
              height: 1.38,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 18),
          controls,
        ],
      ),
    );
  }
}

class _OnboardingControls extends StatelessWidget {
  final int index;
  final int total;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;

  const _OnboardingControls({
    required this.index,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundNavButton(
          icon: Icons.arrow_forward_rounded,
          onTap: onPrevious,
          filled: false,
        ),
        const Spacer(),
        _PageDots(index: index, total: total),
        const Spacer(),
        _RoundNavButton(
          icon: Icons.arrow_back_rounded,
          onTap: onNext,
          filled: true,
        ),
      ],
    );
  }
}

class _PrimaryPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PrimaryPillButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF174FDD),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(38),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              style: robotoBold.copyWith(
                color: Colors.white,
                fontSize: 28,
                height: 1,
                letterSpacing: 0,
              ),
            ),
            const Positioned(
              left: 30,
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _RoundNavButton({
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? .35 : 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: filled ? const Color(0xFF174FDD) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F102D66),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: filled ? Colors.white : const Color(0xFF0D2E65),
            size: 30,
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int index;
  final int total;

  const _PageDots({required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 7),
          height: 13,
          width: 13,
          decoration: BoxDecoration(
            color: i == index
                ? const Color(0xFF1C4FE8)
                : const Color(0xFFD5DDEB),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _SegmentDots extends StatelessWidget {
  final int index;

  const _SegmentDots({required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 8,
          width: i == index ? 34 : 26,
          decoration: BoxDecoration(
            color: i == index
                ? const Color(0xFF27BC89)
                : const Color(0xFFE1E6EF),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _FeatureMini extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureMini({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x14102D66),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF123A8F), size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: robotoMedium.copyWith(
            color: const Color(0xFF071734),
            fontSize: 18,
            height: 1.25,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _SoftWhiteBackground extends StatelessWidget {
  const _SoftWhiteBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _SoftWhiteBackgroundPainter());
  }
}

class _SoftWhiteBackgroundPainter extends CustomPainter {
  const _SoftWhiteBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final ringPaint = Paint()
      ..color = const Color(0xFFE8EEF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(size.width * .92, size.height * .08),
        54.0 + i * 34,
        ringPaint,
      );
    }
    canvas.drawCircle(
      Offset(size.width * .12, size.height * .22),
      7,
      Paint()..color = const Color(0xFFDDF7F1),
    );
    canvas.drawCircle(
      Offset(size.width * .88, size.height * .36),
      9,
      Paint()..color = const Color(0xFFDDF2FF),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MintWavePainter extends CustomPainter {
  const _MintWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final back = Paint()..color = const Color(0xFFE1F8F0);
    final front = Paint()..color = const Color(0xFFCFF5EB);

    final p1 = Path()
      ..moveTo(0, size.height * .38)
      ..cubicTo(
        size.width * .22,
        size.height * .05,
        size.width * .35,
        size.height * .78,
        size.width * .55,
        size.height * .56,
      )
      ..cubicTo(
        size.width * .76,
        size.height * .34,
        size.width * .82,
        size.height * .16,
        size.width,
        size.height * .28,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p1, back);

    final p2 = Path()
      ..moveTo(0, size.height * .58)
      ..cubicTo(
        size.width * .2,
        size.height * .32,
        size.width * .32,
        size.height * .92,
        size.width * .55,
        size.height * .78,
      )
      ..cubicTo(
        size.width * .76,
        size.height * .65,
        size.width * .82,
        size.height * .36,
        size.width,
        size.height * .52,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p2, front);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CleaningIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .58);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0x3319C8CF), const Color(0x001D65E8)],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * .45));
    canvas.drawCircle(center, size.width * .45, glow);

    final orbit = Paint()
      ..color = const Color(0x331D65E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: size.width * .72,
        height: size.height * .62,
      ),
      math.pi * .08,
      math.pi * 1.84,
      false,
      orbit,
    );

    _drawServiceBubble(
      canvas,
      Offset(size.width * .24, size.height * .34),
      Icons.cleaning_services_outlined,
    );
    _drawServiceBubble(
      canvas,
      Offset(size.width * .50, size.height * .18),
      Icons.local_laundry_service_outlined,
    );
    _drawServiceBubble(
      canvas,
      Offset(size.width * .76, size.height * .34),
      Icons.cleaning_services,
    );

    final plate = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .86),
        width: size.width * .72,
        height: size.height * .13,
      ),
      plate,
    );

    final bucket = Paint()..color = const Color(0xFF1D7FEA);
    final bucketPath = Path()
      ..moveTo(size.width * .30, size.height * .55)
      ..quadraticBezierTo(
        size.width * .50,
        size.height * .63,
        size.width * .70,
        size.height * .55,
      )
      ..lineTo(size.width * .64, size.height * .83)
      ..quadraticBezierTo(
        size.width * .50,
        size.height * .91,
        size.width * .36,
        size.height * .83,
      )
      ..close();
    canvas.drawPath(bucketPath, bucket);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .55),
        width: size.width * .43,
        height: size.height * .08,
      ),
      Paint()..color = const Color(0xFF58B8FF),
    );

    final bottle = Paint()..color = const Color(0xFF44D675);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .51,
          size.height * .36,
          size.width * .14,
          size.height * .28,
        ),
        const Radius.circular(22),
      ),
      bottle,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .535,
          size.height * .31,
          size.width * .09,
          size.height * .07,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF91ED77),
    );

    final sprayer = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .36,
          size.height * .37,
          size.width * .12,
          size.height * .28,
        ),
        const Radius.circular(14),
      ),
      sprayer,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .32,
          size.height * .32,
          size.width * .17,
          size.height * .08,
        ),
        const Radius.circular(10),
      ),
      sprayer,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .37,
        size.height * .40,
        size.width * .08,
        size.height * .035,
      ),
      Paint()..color = const Color(0xFF7BB7FF),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .60,
          size.height * .77,
          size.width * .22,
          size.height * .08,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFFFD24A),
    );
    canvas.drawCircle(
      Offset(size.width * .18, size.height * .78),
      26,
      Paint()..color = const Color(0xFF4DCD61),
    );
  }

  void _drawServiceBubble(Canvas canvas, Offset center, IconData icon) {
    canvas.drawCircle(center, 48, Paint()..color = const Color(0xFFEAF6FF));
    canvas.drawCircle(
      center,
      48,
      Paint()
        ..color = const Color(0x6619C8CF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          fontSize: 36,
          color: const Color(0xFF1D65E8),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LivingRoomIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = const Color(0xFFF1F5FB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * .5, size.height * .73),
          width: size.width * .82,
          height: size.height * .26,
        ),
        const Radius.circular(38),
      ),
      base,
    );

    final sofa = Paint()..color = const Color(0xFF9DD4FF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .15,
          size.height * .42,
          size.width * .37,
          size.height * .27,
        ),
        const Radius.circular(24),
      ),
      sofa,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .20,
          size.height * .34,
          size.width * .28,
          size.height * .2,
        ),
        const Radius.circular(22),
      ),
      Paint()..color = const Color(0xFF86C4F4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .29,
          size.height * .46,
          size.width * .13,
          size.height * .09,
        ),
        const Radius.circular(12),
      ),
      Paint()..color = const Color(0xFF55D8A0),
    );

    final cabinet = Paint()..color = const Color(0xFF2F77D5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .59,
          size.height * .48,
          size.width * .26,
          size.height * .18,
        ),
        const Radius.circular(12),
      ),
      cabinet,
    );
    canvas.drawLine(
      Offset(size.width * .59, size.height * .56),
      Offset(size.width * .85, size.height * .56),
      Paint()..color = const Color(0xFF1854A8),
    );
    canvas.drawLine(
      Offset(size.width * .72, size.height * .56),
      Offset(size.width * .72, size.height * .66),
      Paint()..color = const Color(0xFF1854A8),
    );

    final lamp = Paint()
      ..color = const Color(0xFFC99D69)
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(size.width * .54, size.height * .42),
      Offset(size.width * .54, size.height * .66),
      lamp,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .54, size.height * .66),
        width: 58,
        height: 10,
      ),
      lamp,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .49,
          size.height * .35,
          size.width * .11,
          size.height * .08,
        ),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFFF3DEC8),
    );

    canvas.drawCircle(
      Offset(size.width * .52, size.height * .70),
      54,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(size.width * .52, size.height * .68),
      13,
      Paint()..color = const Color(0xFF63D481),
    );

    final shieldRect = Rect.fromLTWH(
      size.width * .72,
      size.height * .25,
      size.width * .14,
      size.height * .14,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(shieldRect, const Radius.circular(18)),
      Paint()..color = const Color(0xFF89C9FF),
    );
    final check = Path()
      ..moveTo(size.width * .76, size.height * .32)
      ..lineTo(size.width * .79, size.height * .35)
      ..lineTo(size.width * .84, size.height * .28);
    canvas.drawPath(
      check,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> _finishOnboarding() async {
  Get.find<SplashController>().disableShowOnboardingScreen();

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    Get.offAllNamed(RouteHelper.getPickMapRoute("", false, "", null, null));
  } else {
    Get.dialog(const CustomLoader(), barrierDismissible: false);
    AddressModel address = await Get.find<LocationController>()
        .getCurrentLocation(true);
    ZoneResponseModel response = await Get.find<LocationController>().getZone(
      address.latitude!,
      address.longitude!,
      false,
    );

    if (response.isSuccess) {
      Get.find<LocationController>().saveAddressAndNavigate(
        address,
        false,
        '',
        false,
        true,
      );
    } else {
      Get.back();
      Get.offAllNamed(RouteHelper.getPickMapRoute("", false, "", null, null));
    }
  }
}
