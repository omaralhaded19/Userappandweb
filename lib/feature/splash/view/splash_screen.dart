import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  final String? route;
  const SplashScreen({super.key, @required this.body, this.route});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (!firstTime) {
        bool isNotConnected =
            result.first != ConnectivityResult.wifi &&
            result.first != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            backgroundColor: isNotConnected ? Colors.red : Colors.green,
            duration: Duration(seconds: isNotConnected ? 6000 : 3),
            content: Text(
              isNotConnected ? 'no_connection'.tr : 'connected'.tr,
              textAlign: TextAlign.center,
            ),
          ),
        );
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    if (Get.find<SplashController>().getGuestId().isEmpty) {
      var uuid = const Uuid().v1();
      Get.find<SplashController>().setGuestId(uuid);
    }

    Get.find<SplashController>().initSharedData();
    _route();
  }

  @override
  void dispose() {
    _onConnectivityChanged?.cancel();
    super.dispose();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) async {
      if (Get.find<LocationController>().getUserAddress() != null) {
        AddressModel addressModel = Get.find<LocationController>()
            .getUserAddress()!;
        ZoneResponseModel responseModel = await Get.find<LocationController>()
            .getZone(
              addressModel.latitude.toString(),
              addressModel.longitude.toString(),
              false,
            );
        addressModel.availableServiceCountInZone =
            responseModel.totalServiceCount;
        Get.find<LocationController>().saveUserAddress(addressModel);
      }

      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          if (_checkAvailableUpdate()) {
            Get.offNamed(RouteHelper.getUpdateRoute('update'));
          } else if (_checkMaintenanceModeActive() &&
              !AppConstants.avoidMaintenanceMode) {
            Get.offAllNamed(RouteHelper.getMaintenanceRoute());
          } else {
            if (widget.body != null) {
              _notificationRoute();
            } else {
              if (Get.find<SplashController>().isShowInitialLanguageScreen()) {
                Get.offNamed(RouteHelper.getLanguageScreen('fromOthers'));
              } else if (Get.find<SplashController>()
                  .isShowOnboardingScreen()) {
                Get.offAllNamed(RouteHelper.onBoardScreen);
              } else {
                Get.offNamed(RouteHelper.getInitialRoute());
              }
            }
          }
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(
        builder: (splashController) {
          PriceConverter.getCurrency();
          return splashController.hasConnection
              ? const QadhaEntranceScaffold(showLoader: true)
              : NoInternetScreen(
                  child: SplashScreen(body: widget.body, route: widget.route),
                );
        },
      ),
    );
  }

  bool _checkAvailableUpdate() {
    ConfigModel? configModel = Get.find<SplashController>().configModel;
    final localVersion = Version.parse(AppConstants.appVersion);
    final serverVersion = Version.parse(
      GetPlatform.isAndroid
          ? configModel.content?.minimumVersion?.minVersionForAndroid ?? ""
          : configModel.content?.minimumVersion?.minVersionForIos ?? "",
    );
    return localVersion.compareTo(serverVersion) == -1;
  }

  bool _checkMaintenanceModeActive() {
    final ConfigModel configModel = Get.find<SplashController>().configModel;
    return (configModel.content?.maintenanceMode?.maintenanceStatus == 1 &&
        configModel
                .content
                ?.maintenanceMode
                ?.selectedMaintenanceSystem
                ?.mobileApp ==
            1);
  }

  void _notificationRoute() {
    String notificationType = widget.body?.notificationType ?? "";

    switch (notificationType) {
      case "chatting":
        {
          Get.toNamed(
            RouteHelper.getInboxScreenRoute(
              fromNotification: "fromNotification",
            ),
          );
        }
        break;

      case "bidding":
        {
          Get.toNamed(
            RouteHelper.getMyPostScreen(fromNotification: "fromNotification"),
          );
        }
        break;

      case "booking" || 'booking_ignored':
        {
          if (widget.body!.bookingId != null && widget.body!.bookingId != "") {
            if (widget.body?.bookingType == "repeat" &&
                widget.body?.repeatBookingType == "single") {
              Get.toNamed(
                RouteHelper.getBookingDetailsScreen(
                  subBookingId: widget.body!.bookingId!,
                  fromPage: 'fromNotification',
                ),
              );
            } else if (widget.body?.bookingType == "repeat" &&
                widget.body?.repeatBookingType != "single") {
              Get.toNamed(
                RouteHelper.getRepeatBookingDetailsScreen(
                  bookingId: widget.body!.bookingId,
                  fromPage: "fromNotification",
                ),
              );
            } else {
              Get.toNamed(
                RouteHelper.getBookingDetailsScreen(
                  bookingID: widget.body!.bookingId!,
                  fromPage: 'fromNotification',
                ),
              );
            }
          } else {
            Get.toNamed(RouteHelper.getMainRoute(""));
          }
        }
        break;

      case "privacy_policy":
        {
          Get.toNamed(
            RouteHelper.getHtmlRoute(
              HtmlType.privacyPolicy.value,
              title: 'privacy_policy',
            ),
          );
        }
        break;

      case "terms_and_conditions":
        {
          Get.toNamed(
            RouteHelper.getHtmlRoute(
              HtmlType.termsAndCondition.value,
              title: 'terms_and_conditions',
            ),
          );
        }
        break;

      case "wallet":
        {
          Get.toNamed(
            RouteHelper.getMyWalletScreen(fromNotification: "fromNotification"),
          );
        }
        break;

      case "loyalty_point":
        {
          Get.toNamed(
            RouteHelper.getLoyaltyPointScreen(
              fromNotification: "fromNotification",
            ),
          );
        }
        break;

      default:
        {
          Get.toNamed(RouteHelper.getNotificationRoute());
        }
        break;
    }
  }
}

// -----------------------------------------------------------------------------
// Winter splash animations
// -----------------------------------------------------------------------------

class WinterBackground extends StatelessWidget {
  final Animation<double> animation;
  final List<_Star> stars;
  final List<_RainDrop> rainDrops;
  final List<_SnowFlake> snowFlakes;

  const WinterBackground({
    super.key,
    required this.animation,
    required this.stars,
    required this.rainDrops,
    required this.snowFlakes,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _WinterBackgroundPainter(
            t: animation.value,
            stars: stars,
            rainDrops: rainDrops,
            snowFlakes: snowFlakes,
            isDark: Get.isDarkMode,
          ),
          child: child,
        );
      },
    );
  }
}

class _WinterBackgroundPainter extends CustomPainter {
  final double t;
  final List<_Star> stars;
  final List<_RainDrop> rainDrops;
  final List<_SnowFlake> snowFlakes;
  final bool isDark;

  _WinterBackgroundPainter({
    required this.t,
    required this.stars,
    required this.rainDrops,
    required this.snowFlakes,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Gradient winter sky
    final bgShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? const [Color(0xFF0B1026), Color(0xFF101D3D), Color(0xFF1A2B5E)]
          : const [Color(0xFF0D4D8F), Color(0xFF2A6FB5), Color(0xFF6FB7FF)],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = bgShader);

    // Stars (twinkle)
    final starPaint = Paint()..style = PaintingStyle.fill;
    for (final s in stars) {
      final tw =
          0.5 + 0.5 * math.sin((t * s.twinkleSpeed * 2 * math.pi) + s.phase);
      final opacity = (0.15 + 0.85 * tw).clamp(0.0, 1.0);
      starPaint.color = Colors.white.withValues(alpha: opacity * 0.85);
      final center = Offset(s.x * size.width, s.y * size.height);
      canvas.drawCircle(center, s.radius, starPaint);

      // Soft glow for some stars
      if (s.radius > 1.6) {
        starPaint.color = Colors.white.withValues(alpha: opacity * 0.18);
        canvas.drawCircle(center, s.radius * 2.6, starPaint);
      }
    }

    // Rain
    final rainPaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.30 : 0.22)
      ..strokeCap = StrokeCap.round;

    for (final d in rainDrops) {
      final yN = ((d.y + t * d.speed) % 1.2) - 0.1;
      final xN = (d.x + math.sin(t * 2 * math.pi + d.phase) * d.drift) % 1.0;

      final start = Offset(xN * size.width, yN * size.height);
      final end = start + Offset(size.width * 0.01, size.height * d.length);
      rainPaint.strokeWidth = d.thickness;
      canvas.drawLine(start, end, rainPaint);
    }

    // Snow (slow flakes)
    final snowPaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.22 : 0.17);
    for (final f in snowFlakes) {
      final yN = ((f.y + t * f.speed) % 1.2) - 0.1;
      final xN = (f.x + math.sin(t * 2 * math.pi + f.phase) * f.drift) % 1.0;
      canvas.drawCircle(
        Offset(xN * size.width, yN * size.height),
        f.radius,
        snowPaint,
      );
    }

    // Light haze
    canvas.drawRect(
      rect,
      Paint()..color = Colors.white.withValues(alpha: isDark ? 0.03 : 0.05),
    );
  }

  @override
  bool shouldRepaint(covariant _WinterBackgroundPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.isDark != isDark;
  }
}

class AnimatedLogo extends StatelessWidget {
  final Animation<double> animation;
  final String logoPath;
  final double size;

  const AnimatedLogo({
    super.key,
    required this.animation,
    required this.logoPath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final glowColor = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: 0.35);

    return AnimatedBuilder(
      animation: animation,
      child: Image.asset(logoPath, width: size),
      builder: (context, child) {
        final t = animation.value;
        final dy = math.sin(t * 2 * math.pi) * 10;
        final scale = 0.98 + (0.02 * (0.5 + 0.5 * math.sin(t * 2 * math.pi)));

        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(
            scale: scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: glowColor, blurRadius: 28, spreadRadius: 2),
                ],
              ),
              child: ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) {
                  final slide = (bounds.width * 2 * t) - bounds.width;
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.75),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(
                    Rect.fromLTWH(
                      bounds.left + slide,
                      bounds.top,
                      bounds.width,
                      bounds.height,
                    ),
                  );
                },
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double radius;
  final double phase;
  final double twinkleSpeed;

  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.twinkleSpeed,
  });
}

class _RainDrop {
  final double x;
  final double y;
  final double length;
  final double speed;
  final double thickness;
  final double phase;
  final double drift;

  const _RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.thickness,
    required this.phase,
    required this.drift,
  });
}

class _SnowFlake {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;
  final double drift;

  const _SnowFlake({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.drift,
  });
}
