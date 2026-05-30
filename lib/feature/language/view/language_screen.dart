import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class LanguageScreen extends StatefulWidget {
  final String? fromPage;

  const LanguageScreen({super.key, this.fromPage});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<LocalizationController>().filterLanguage(
      shouldUpdate: false,
      isChooseLanguage: true,
      fromPage: widget.fromPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSettingsPage = widget.fromPage == "fromSettingsPage";

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: ResponsiveHelper.isDesktop(context)
          ? const MenuDrawer()
          : null,
      appBar: isSettingsPage ? CustomAppBar(title: "language".tr) : null,
      body: GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: [
                const Positioned.fill(child: _LanguageBackground()),
                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        child: Column(
                          children: [
                            if (!isSettingsPage) ...[
                              const QadhaBrandMark(
                                iconSize: 76,
                                textSize: 74,
                                showTagline: false,
                                textColor: Color(0xFF12387D),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _SmallLine(
                                    color: const Color(
                                      0xFF1D65E8,
                                    ).withValues(alpha: .45),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'خدمات المنزل بين يديك',
                                    style: robotoMedium.copyWith(
                                      color: const Color(0xFF667797),
                                      fontSize: 16,
                                      height: 1.2,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  _SmallLine(
                                    color: const Color(
                                      0xFF1DBFC5,
                                    ).withValues(alpha: .45),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 58),
                            ],
                            Text(
                              'اختر اللغة',
                              textAlign: TextAlign.center,
                              style: robotoBold.copyWith(
                                color: const Color(0xFF0D2E65),
                                fontSize: 42,
                                height: 1,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'اختر لغة التطبيق للمتابعة',
                              textAlign: TextAlign.center,
                              style: robotoMedium.copyWith(
                                color: const Color(0xFF71809B),
                                fontSize: 20,
                                height: 1.25,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 52),
                            ...List.generate(
                              localizationController.languages.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 22),
                                child: _LanguageChoiceCard(
                                  language:
                                      localizationController.languages[index],
                                  selected:
                                      localizationController.selectedIndex ==
                                      index,
                                  isArabic:
                                      localizationController
                                          .languages[index]
                                          .languageCode ==
                                      'ar',
                                  onTap: () => localizationController
                                      .setSelectIndex(index),
                                ),
                              ),
                            ),
                            const Spacer(),
                            _ContinueButton(
                              onTap: () => _continue(localizationController),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  color: Color(0xFF1D65E8),
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'نحن نهتم بخصوصيتك وأمان بياناتك',
                                  style: robotoRegular.copyWith(
                                    color: const Color(0xFF71809B),
                                    fontSize: 13,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _continue(LocalizationController localizationController) {
    Get.find<SplashController>().disableShowInitialLanguageScreen();
    localizationController.setLanguage(
      Locale(
        localizationController
            .languages[localizationController.selectedIndex]
            .languageCode!,
        localizationController
            .languages[localizationController.selectedIndex]
            .countryCode,
      ),
      isInitial: true,
    );

    if (Get.find<SplashController>().isShowOnboardingScreen() && !kIsWeb) {
      Get.offNamed(RouteHelper.onBoardScreen);
    } else {
      Get.find<SplashController>().getConfigData();
      HomeScreen.loadData(true);
      Get.offAllNamed(RouteHelper.getMainRoute("home"));
    }
  }
}

class _LanguageChoiceCard extends StatelessWidget {
  final LanguageModel language;
  final bool selected;
  final bool isArabic;
  final VoidCallback onTap;

  const _LanguageChoiceCard({
    required this.language,
    required this.selected,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 112,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .94),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF1DBFC5) : const Color(0xFFE8EEF7),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0x3327BED1)
                  : const Color(0x1A173C78),
              blurRadius: selected ? 24 : 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            _CheckCircle(selected: selected),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isArabic ? 'العربية' : 'English',
                  textAlign: TextAlign.right,
                  style: robotoBold.copyWith(
                    color: const Color(0xFF0D2E65),
                    fontSize: 25,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isArabic ? 'اللغة الافتراضية' : 'English Language',
                  textAlign: TextAlign.right,
                  style: robotoRegular.copyWith(
                    color: selected
                        ? const Color(0xFF1D65E8)
                        : const Color(0xFF71809B),
                    fontSize: 15,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 22),
            _FlagAvatar(imagePath: language.imageUrl),
          ],
        ),
      ),
    );
  }
}

class _FlagAvatar extends StatelessWidget {
  final String? imagePath;

  const _FlagAvatar({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x26173C78),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(imagePath ?? Images.placeholder, fit: BoxFit.cover),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  final bool selected;

  const _CheckCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1D65E8) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.white : const Color(0xFF9AA7BC),
          width: selected ? 3 : 2,
        ),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x331D65E8),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 30)
          : null,
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF1DBFC5), Color(0xFF1C4FE8)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x331C63E8),
                blurRadius: 20,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'متابعة',
                  style: robotoBold.copyWith(
                    color: Colors.white,
                    fontSize: 25,
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

class _SmallLine extends StatelessWidget {
  final Color color;

  const _SmallLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _LanguageBackground extends StatelessWidget {
  const _LanguageBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _LanguageBackgroundPainter());
  }
}

class _LanguageBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blueWash = Paint()..color = const Color(0xFFEAF6FF);
    final mintWash = Paint()..color = const Color(0xFFE7FAF4);
    final line = Paint()
      ..color = const Color(0xFFE6EEF8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final topPath = Path()
      ..moveTo(size.width, 0)
      ..quadraticBezierTo(
        size.width * .92,
        size.height * .06,
        size.width * .82,
        size.height * .08,
      )
      ..quadraticBezierTo(
        size.width * .72,
        size.height * .11,
        size.width * .83,
        size.height * .17,
      )
      ..quadraticBezierTo(
        size.width * .94,
        size.height * .23,
        size.width,
        size.height * .29,
      )
      ..close();
    canvas.drawPath(topPath, blueWash);

    final sofaBlob = Path()
      ..moveTo(0, size.height * .25)
      ..lineTo(size.width * .09, size.height * .25)
      ..quadraticBezierTo(
        size.width * .22,
        size.height * .27,
        size.width * .18,
        size.height * .39,
      )
      ..quadraticBezierTo(
        size.width * .13,
        size.height * .49,
        0,
        size.height * .44,
      )
      ..close();
    canvas.drawPath(sofaBlob, const Color(0xFFEFF7FF).toPaint());
    canvas.drawPath(
      sofaBlob.shift(Offset(size.width * .84, size.height * .28)),
      mintWash,
    );

    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(size.width * .91, size.height * .16),
        72.0 + i * 40,
        line,
      );
    }

    final pale = Paint()
      ..color = const Color(0xFFD8EAFE)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .12, size.height * .35),
      Offset(size.width * .12, size.height * .31),
      pale,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .08,
          size.height * .31,
          size.width * .08,
          size.height * .03,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFE5F2FF),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on Color {
  Paint toPaint() => Paint()..color = this;
}
