import 'package:seohost/feature/home/widget/qadha_home_content.dart';
import 'package:get/get.dart';
import 'package:seohost/utils/core_export.dart';

class HomeScreen extends StatefulWidget {
  static Future<void> loadData(
    bool reload, {
    int availableServiceCount = 1,
  }) async {
    if (availableServiceCount == 0) {
      Get.find<BannerController>().getBannerList(reload);
    } else {
      await Future.wait([
        Get.find<ServiceController>().getRecommendedSearchList(),
        Get.find<ServiceController>().getAllServiceList(1, reload),
        Get.find<BannerController>().getBannerList(reload),
        Get.find<AdvertisementController>().getAdvertisementList(reload),
        Get.find<CategoryController>().getCategoryList(reload),
        Get.find<ServiceController>().getPopularServiceList(1, reload),
        Get.find<ServiceController>().getTrendingServiceList(1, reload),
        Get.find<ProviderBookingController>().getProviderList(1, reload),
        Get.find<NearbyProviderController>().getProviderList(1, reload),
        Get.find<CampaignController>().getCampaignList(reload),
        Get.find<ServiceController>().getRecommendedServiceList(1, reload),
        Get.find<CheckOutController>().getOfflinePaymentMethod(
          false,
          shouldUpdate: false,
        ),
        Get.find<ServiceController>().getFeatherCategoryList(reload),
        if (Get.find<AuthController>().isLoggedIn())
          Get.find<AuthController>().updateToken(),
        if (Get.find<AuthController>().isLoggedIn())
          Get.find<ServiceController>().getRecentlyViewedServiceList(1, reload),
      ]);

      Get.find<BookingDetailsController>().manageDialog();
    }
  }

  final AddressModel? addressModel;
  final bool showServiceNotAvailableDialog;
  const HomeScreen({
    super.key,
    this.addressModel,
    required this.showServiceNotAvailableDialog,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AddressModel? _previousAddress;
  int availableServiceCount = 0;

  final ScrollController scrollController = ScrollController();
  final signInShakeKey = GlobalKey<CustomShakingWidgetState>();

  @override
  void initState() {
    super.initState();

    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);

    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }

    if (Get.find<LocationController>().getUserAddress() != null) {
      availableServiceCount = Get.find<LocationController>()
          .getUserAddress()!
          .availableServiceCountInZone!;
    }

    HomeScreen.loadData(false, availableServiceCount: availableServiceCount);

    _previousAddress = widget.addressModel;

    if (_previousAddress != null &&
        availableServiceCount == 0 &&
        widget.showServiceNotAvailableDialog) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.dialog(
          ServiceNotAvailableDialog(
            address: _previousAddress,
            forCard: false,
            showButton: true,
            onBackPressed: () {
              Get.back();
              Get.find<LocationController>().setZoneContinue('false');
            },
          ),
        );
      });
    }
  }

  /// ✔ إصلاح دائم لمشكلة PreferredSizeWidget
  PreferredSizeWidget homeAppBar({
    GlobalKey<CustomShakingWidgetState>? signInShakeKey,
  }) {
    if (ResponsiveHelper.isDesktop(context)) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: WebMenuBar(signInShakeKey: signInShakeKey),
      );
    } else {
      return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const AddressAppBar(backButton: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveHelper.isDesktop(context)) {
      return const QadhaHomeContent();
    }

    return Scaffold(
      appBar: homeAppBar(signInShakeKey: signInShakeKey),
      endDrawer: const MenuDrawer(),
      body: WebHomeScreen(
        scrollController: scrollController,
        availableServiceCount: availableServiceCount,
        signInShakeKey: signInShakeKey,
      ),
    );
  }
}

class QadhaHomeIntroSection extends StatelessWidget {
  const QadhaHomeIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF07101F), Color(0xFF0C2438)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF1B4E6C).withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2035),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF09212F),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFF6BCB3D),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الموقع الحالي',
                                  style: robotoRegular.copyWith(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  Get.find<LocationController>()
                                          .getUserAddress()
                                          ?.address ??
                                      'حدد موقعك',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF6BCB3D),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'قدها',
                    textAlign: TextAlign.center,
                    style: robotoBold.copyWith(
                      color: Colors.white,
                      fontSize: 46,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'كيف يمكننا مساعدتك اليوم؟',
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _QadhaServiceCard(
                    icon: Icons.layers_outlined,
                    title: 'السجاد',
                    subtitle: 'تنظيف عميق للسجاد والمفروشات',
                  ),
                  _QadhaServiceCard(
                    icon: Icons.ac_unit_outlined,
                    title: 'تنظيف مكيفات',
                    subtitle: 'غسيل وتعقيم وفحص للمكيفات',
                  ),
                  _QadhaServiceCard(
                    icon: Icons.cleaning_services_outlined,
                    title: 'التنظيف الشامل',
                    subtitle: 'تنظيف كامل للمنزل بأدق التفاصيل',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                height: 0,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(
                    RouteHelper.getSearchResultRoute(
                      fromPage: RouteHelper.home,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6BCB3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'احجز الآن',
                    style: robotoMedium.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _QadhaFeatureChip(
                    label: 'جودة عالية',
                    icon: Icons.workspace_premium_outlined,
                  ),
                  _QadhaFeatureChip(
                    label: 'ثقة وأمان',
                    icon: Icons.verified_user_outlined,
                  ),
                  _QadhaFeatureChip(
                    label: 'سرعة استجابة',
                    icon: Icons.timer_outlined,
                  ),
                  _QadhaFeatureChip(
                    label: 'متابعة مستمرة',
                    icon: Icons.support_agent_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _QadhaServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _QadhaServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1B2D),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF1888A2).withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF122E45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF6BCB3D), size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: robotoBold.copyWith(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QadhaFeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _QadhaFeatureChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0E2337),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF185776).withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF6BCB3D), size: 18),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
