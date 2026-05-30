import 'package:seohost/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';

class BottomNavScreen extends StatefulWidget {
  final AddressModel? previousAddress;
  final bool showServiceNotAvailableDialog;
  final int pageIndex;
  const BottomNavScreen({
    super.key,
    required this.pageIndex,
    this.previousAddress,
    required this.showServiceNotAvailableDialog,
  });

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _pageIndex = 0;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;

    if (_pageIndex == 1) {
      Get.find<BottomNavController>().changePage(
        BnbItem.bookings,
        shouldUpdate: false,
      );
    } else if (_pageIndex == 2) {
      Get.find<BottomNavController>().changePage(
        BnbItem.cart,
        shouldUpdate: false,
      );
    } else if (_pageIndex == 3) {
      Get.find<BottomNavController>().changePage(
        BnbItem.offers,
        shouldUpdate: false,
      );
    } else {
      Get.find<BottomNavController>().changePage(
        BnbItem.homePage,
        shouldUpdate: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    bool isUserLoggedIn = Get.find<AuthController>().isLoggedIn();

    return CustomPopScopeWidget(
      canPop: ResponsiveHelper.isWeb() ? true : false,
      onPopInvoked: () {
        if (Get.find<BottomNavController>().currentPage != BnbItem.homePage) {
          Get.find<BottomNavController>().changePage(BnbItem.homePage);
        } else {
          if (_canExit) {
            if (!GetPlatform.isWeb) {
              exit(0);
            }
          } else {
            customSnackBar(
              'back_press_again_to_exit'.tr,
              type: ToasterMessageType.info,
            );
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
          }
        }
      },

      child: Scaffold(
        backgroundColor: QadhaPalette.pageBg,
        bottomNavigationBar:
            ResponsiveHelper.isDesktop(context) ||
                MediaQuery.of(context).viewInsets.bottom != 0
            ? const SizedBox()
            : SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    0,
                    12,
                    padding.bottom > 15 ? 8 : 12,
                  ),
                  child: Container(
                    height: 96,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .96),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE4ECF7)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A1A4384),
                          blurRadius: 24,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        children: [
                          _bnbItem(
                            iconData: Icons.person_outline,
                            label: 'قائمة المزيد',
                            bnbItem: BnbItem.more,
                            onTap: () => Get.find<BottomNavController>()
                                .changePage(BnbItem.more),
                          ),
                          _bnbItem(
                            iconData: Icons.calendar_month_outlined,
                            label: 'حجوزاتي',
                            bnbItem: BnbItem.bookings,
                            onTap: () {
                              if (!isUserLoggedIn) {
                                Get.toNamed(
                                  RouteHelper.getNotLoggedScreen(
                                    "booking",
                                    "my_bookings",
                                  ),
                                );
                              } else {
                                Get.find<BottomNavController>().changePage(
                                  BnbItem.bookings,
                                );
                              }
                            },
                          ),
                          GetBuilder<CartController>(
                            builder: (cartController) {
                              final selectedItemCount = cartController.cartList
                                  .fold<int>(
                                    0,
                                    (count, cart) => count + cart.quantity,
                                  );
                              return _bnbItem(
                                iconData: Icons.check_circle_outline,
                                label: 'قائمة طلباتي',
                                bnbItem: BnbItem.cart,
                                badgeCount: selectedItemCount,
                                onTap: () {
                                  if (!isUserLoggedIn) {
                                    Get.toNamed(
                                      RouteHelper.getSignInRoute(
                                        fromPage: RouteHelper.home,
                                      ),
                                    );
                                  } else {
                                    Get.find<BottomNavController>().changePage(
                                      BnbItem.cart,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          _bnbItem(
                            iconData: Icons.apps_rounded,
                            label: 'العروض',
                            bnbItem: BnbItem.offers,
                            onTap: () => Get.find<BottomNavController>()
                                .changePage(BnbItem.offers),
                          ),
                          _bnbItem(
                            iconData: Icons.home_outlined,
                            label: 'الرئيسية',
                            bnbItem: BnbItem.homePage,
                            onTap: () => Get.find<BottomNavController>()
                                .changePage(BnbItem.homePage),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

        body: GetBuilder<BottomNavController>(
          builder: (navController) {
            return _bottomNavigationView(
              widget.previousAddress,
              widget.showServiceNotAvailableDialog,
            );
          },
        ),
      ),
    );
  }

  Widget _bnbItem({
    required IconData iconData,
    required String label,
    required BnbItem bnbItem,
    required GestureTapCallback onTap,
    int badgeCount = 0,
  }) {
    return GetBuilder<BottomNavController>(
      builder: (bottomNavController) {
        final bool selected =
            Get.find<BottomNavController>().currentPage == bnbItem;
        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: selected ? const Color(0x112FC86F) : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
                border: selected
                    ? Border.all(color: const Color(0x552FC86F), width: 1)
                    : null,
                boxShadow: selected
                    ? const [
                        BoxShadow(
                          color: Color(0x222FC86F),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: selected ? 34 : 26,
                        width: selected ? 34 : 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? Colors.white : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconData,
                          size: selected ? 20 : 19,
                          color: selected
                              ? const Color(0xFF21B96A)
                              : const Color(0xFF71809B),
                        ),
                      ),
                      if (badgeCount > 0)
                        PositionedDirectional(
                          top: -7,
                          end: -7,
                          child: Container(
                            height: 19,
                            constraints: const BoxConstraints(minWidth: 19),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: QadhaPalette.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badgeCount > 99 ? '99+' : badgeCount.toString(),
                              style: robotoBold.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoMedium.copyWith(
                      fontSize: 11,
                      color: selected
                          ? const Color(0xFF21B96A)
                          : const Color(0xFF71809B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationView(
    AddressModel? previousAddress,
    bool showServiceNotAvailableDialog,
  ) {
    PriceConverter.getCurrency();

    switch (Get.find<BottomNavController>().currentPage) {
      case BnbItem.homePage:
        return HomeScreen(
          addressModel: previousAddress,
          showServiceNotAvailableDialog: showServiceNotAvailableDialog,
        );

      case BnbItem.bookings:
        if (!Get.find<AuthController>().isLoggedIn()) {
          return const SizedBox();
        } else {
          return const BookingListScreen();
        }

      case BnbItem.cart:
        if (!Get.find<AuthController>().isLoggedIn()) {
          return const SizedBox();
        } else {
          return const CartScreen(fromNav: true);
        }

      case BnbItem.offers:
        return const OfferScreen();

      case BnbItem.more:
        return const MenuScreen();
    }
  }
}
