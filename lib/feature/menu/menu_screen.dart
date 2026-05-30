import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<BottomNavController>().updateMenuPageIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    ConfigModel configModel = Get.find<SplashController>().configModel;
    final List<MenuModel> menuList = [
      MenuModel(
        icon: Images.profileIcon,
        title: 'profile'.tr,
        route: RouteHelper.getProfileRoute(),
      ),
      MenuModel(
        icon: Images.chatImage,
        title: 'inbox'.tr,
        route: isLoggedIn
            ? RouteHelper.getInboxScreenRoute()
            : RouteHelper.getNotLoggedScreen(RouteHelper.chatInbox, "inbox"),
      ),
      MenuModel(
        icon: Images.translate,
        title: 'language'.tr,
        route: RouteHelper.getLanguageScreen('fromSettingsPage'),
      ),
      MenuModel(
        icon: Images.settings,
        title: 'settings'.tr,
        route: RouteHelper.getSettingRoute(),
      ),
      MenuModel(
        icon: Images.myFavorite,
        title: 'my_favorite'.tr,
        route: !isLoggedIn
            ? RouteHelper.getNotLoggedScreen(
                RouteHelper.favorite,
                "my_favorite",
              )
            : RouteHelper.getMyFavoriteScreen(),
      ),
      if (configModel.content?.biddingStatus == 1)
        MenuModel(
          icon: Images.customPostIcon,
          title: 'my_posts'.tr,
          route: isLoggedIn
              ? RouteHelper.getMyPostScreen()
              : RouteHelper.getNotLoggedScreen(RouteHelper.myPost, "my_posts"),
        ),
      if (configModel.content!.walletStatus != 0 && isLoggedIn)
        MenuModel(
          icon: Images.walletMenu,
          title: 'my_wallet'.tr,
          route: RouteHelper.getMyWalletScreen(),
        ),
      if (configModel.content!.loyaltyPointStatus != 0 && isLoggedIn)
        MenuModel(
          icon: Images.myPoint,
          title: 'loyalty_point'.tr,
          route: RouteHelper.getLoyaltyPointScreen(),
        ),

      if (Get.find<SplashController>().configModel.content?.referEarnStatus ==
          1)
        MenuModel(
          title: 'refer_and_earn'.tr,
          icon: Images.shareIcon,
          route: isLoggedIn
              ? RouteHelper.getReferAndEarnScreen()
              : RouteHelper.getNotLoggedScreen(
                  RouteHelper.referAndEarn,
                  "refer_and_earn",
                ),
        ),
      MenuModel(
        icon: Images.areaMenuIcon,
        title: 'service_area'.tr,
        route: RouteHelper.getServiceArea(),
      ),

      MenuModel(
        icon: Images.helpIcon,
        title: 'help_&_support'.tr,
        route: RouteHelper.getSupportRoute(),
      ),

      if (configModel.content?.providerSelfRegistration == 1)
        MenuModel(
          icon: Images.providerImage,
          title: 'become_a_provider'.tr,
          route: GetPlatform.isWeb
              ? '${AppConstants.baseUrl}/provider/auth/sign-up'
              : RouteHelper.getProviderWebView(),
        ),

      ...(configModel.content!.businessPages ?? []).map(
        (page) => MenuModel(
          icon: page.pageKey == HtmlType.aboutUs.value
              ? Images.aboutUs
              : page.pageKey == HtmlType.termsAndCondition.value
              ? Images.termsIcon
              : page.pageKey == HtmlType.privacyPolicy.value
              ? Images.privacyPolicyIcon
              : page.pageKey == HtmlType.cancellationPolicy.value
              ? Images.cancellationPolicy
              : page.pageKey == HtmlType.refundPolicy.value
              ? Images.refundPolicy
              : Images.othersPageIcon, // Or choose icon based on page
          title: _getPageTitle(page),
          route: RouteHelper.getHtmlRoute(
            page.pageKey!,
            title: _getPageTitle(page),
          ),
        ),
      ),
    ];
    int menuCountInSinglePage =
        ResponsiveHelper.isTab(context) && menuList.length > 17
        ? 18
        : ResponsiveHelper.isTab(context) && menuList.length < 18
        ? menuList.length
        : ResponsiveHelper.isMobile(context) && menuList.length > 11
        ? 12
        : menuList.length;

    int totalPageSize = (menuList.length / menuCountInSinglePage).ceil();

    return PointerInterceptor(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: QadhaSoftScaffold(
            child: GetBuilder<BottomNavController>(
              builder: (bottomNavController) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        QadhaGradientHeader(
                          title: 'المزيد',
                          height: 132,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32),
                          ),
                          trailing: Container(
                            height: 54,
                            width: 54,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .24),
                              ),
                            ),
                            child: const Icon(
                              Icons.more_horiz_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: QadhaPalette.green,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'كل ما تحتاجه وأكثر',
                              style: robotoBold.copyWith(
                                color: QadhaPalette.deepNavy,
                                fontSize: 22,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: QadhaPalette.green,
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'خيارات إضافية لتجربة أفضل',
                          style: robotoRegular.copyWith(
                            color: QadhaPalette.textMuted,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: PageView.builder(
                            onPageChanged: (value) {
                              bottomNavController.updateMenuPageIndex(
                                value,
                                shouldUpdate: true,
                              );
                            },
                            itemCount: totalPageSize,
                            itemBuilder: (context, pageIndex) {
                              final start = pageIndex * menuCountInSinglePage;
                              final end = math.min(
                                start + menuCountInSinglePage,
                                menuList.length,
                              );
                              final pageItems = menuList.sublist(start, end);
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final int rows = (pageItems.length / 4)
                                      .ceil()
                                      .clamp(1, 3);
                                  final double extent =
                                      ((constraints.maxHeight -
                                                  ((rows - 1) * 10)) /
                                              rows)
                                          .clamp(82.0, 112.0)
                                          .toDouble();

                                  return GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          mainAxisExtent: extent,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                    itemCount: pageItems.length,
                                    itemBuilder: (context, index) {
                                      return _QadhaMenuTile(
                                        menu: pageItems[index],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        if (totalPageSize > 1) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              totalPageSize,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: 10,
                                width:
                                    bottomNavController.currentMenuPageIndex ==
                                        index
                                    ? 24
                                    : 10,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      bottomNavController
                                              .currentMenuPageIndex ==
                                          index
                                      ? QadhaPalette.green
                                      : const Color(0xFFD7E0EC),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: Text(
                              '${bottomNavController.currentMenuPageIndex + 1} من $totalPageSize',
                              style: robotoMedium.copyWith(
                                color: QadhaPalette.textMuted,
                                fontSize: 0,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          '${'app_version'.tr} ${AppConstants.appVersion}',
                          style: robotoMedium.copyWith(
                            color: QadhaPalette.textMuted,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getPageTitle(BusinessPage page) {
    return page.pageKey == HtmlType.aboutUs.value
        ? 'about_us'.tr
        : page.pageKey == HtmlType.termsAndCondition.value
        ? 'terms_and_conditions'.tr
        : page.pageKey == HtmlType.privacyPolicy.value
        ? 'privacy_policy'.tr
        : page.pageKey == HtmlType.cancellationPolicy.value
        ? 'cancellation_policy'.tr
        : page.pageKey == HtmlType.refundPolicy.value
        ? 'refund_policy'.tr
        : page.title ?? '';
  }
}

class _QadhaMenuTile extends StatelessWidget {
  final MenuModel menu;

  const _QadhaMenuTile({required this.menu});

  @override
  Widget build(BuildContext context) {
    final bool danger =
        menu.isLogout && Get.find<AuthController>().isLoggedIn();
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: _handleTap,
      child: QadhaGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        radius: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 38,
              width: 38,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: danger
                    ? const Color(0xFFFFEEF2)
                    : const Color(0xFFEFFFF8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x101A4384),
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                menu.icon ?? Images.placeholder,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  danger ? Icons.logout_rounded : Icons.grid_view_rounded,
                  color: danger ? const Color(0xFFEF4E62) : QadhaPalette.green,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              menu.title ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(
                color: QadhaPalette.deepNavy,
                fontSize: 10,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    if (menu.isLogout) {
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.dialog(
          ConfirmationDialog(
            icon: Images.logoutIcon,
            title: 'are_you_sure_to_logout'.tr,
            description: 'if_you_logged_out_your_cart_will_be_removed'.tr,
            onYesPressed: () {
              Get.find<AuthController>().clearSharedData();
              Get.find<AuthController>().logOut();
              Get.find<AuthController>().googleLogout();
              Get.find<AuthController>().signOutWithFacebook();
              Get.find<LocationController>().updateSelectedAddress(null);
              Get.offAllNamed(RouteHelper.getInitialRoute());
            },
          ),
          useSafeArea: false,
        );
      } else {
        Get.toNamed(RouteHelper.getSignInRoute());
      }
      return;
    }

    final route = menu.route ?? '';
    if (route.startsWith('http')) {
      if (await canLaunchUrlString(route)) {
        launchUrlString(route, mode: LaunchMode.externalApplication);
      }
      return;
    }
    if (route.isNotEmpty) {
      Get.toNamed(route);
    }
  }
}
