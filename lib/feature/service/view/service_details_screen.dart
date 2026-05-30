import 'package:get/get.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String? serviceID;
  final String? fromPage;
  const ServiceDetailsScreen({
    super.key,
    this.serviceID,
    this.fromPage = "others",
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.serviceID != null) {
      Get.find<ServiceDetailsController>().getServiceDetails(
        widget.serviceID!,
        fromPage: widget.fromPage == "search_page" ? "search_page" : "",
      );
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<ServiceController>().getRecentlyViewedServiceList(1, true);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      endDrawer: ResponsiveHelper.isDesktop(context)
          ? const MenuDrawer()
          : null,
      appBar: CustomAppBar(
        centerTitle: false,
        title: 'service_details'.tr,
        showCart: true,
      ),
      body: GetBuilder<ServiceDetailsController>(
        builder: (serviceController) {
          if (serviceController.service != null || widget.serviceID == null) {
            if (serviceController.service != null &&
                serviceController.service!.id != null &&
                widget.serviceID != null) {
              Service? service = serviceController.service;
              Discount discount = PriceConverter.discountCalculation(service!);
              double lowestPrice = 0.0;
              if (service.variationsAppFormat!.zoneWiseVariations != null) {
                lowestPrice = service
                    .variationsAppFormat!
                    .zoneWiseVariations![0]
                    .price!
                    .toDouble();
                for (
                  var i = 0;
                  i < service.variationsAppFormat!.zoneWiseVariations!.length;
                  i++
                ) {
                  if (service
                          .variationsAppFormat!
                          .zoneWiseVariations![i]
                          .price! <
                      lowestPrice) {
                    lowestPrice = service
                        .variationsAppFormat!
                        .zoneWiseVariations![i]
                        .price!
                        .toDouble();
                  }
                }
              }
              if (ResponsiveHelper.isMobile(context)) {
                return _QadhaServiceDetails(
                  service: service,
                  discount: discount,
                  lowestPrice: lowestPrice,
                );
              }
              return FooterBaseView(
                isScrollView: ResponsiveHelper.isMobile(context) ? false : true,
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: DefaultTabController(
                    length:
                        Get.find<ServiceDetailsController>()
                            .service!
                            .faqs!
                            .isNotEmpty
                        ? 3
                        : 2,
                    child: Column(
                      children: [
                        if (!ResponsiveHelper.isMobile(context) &&
                            !ResponsiveHelper.isTab(context))
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                        Stack(
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    (!ResponsiveHelper.isMobile(context) &&
                                            !ResponsiveHelper.isTab(context))
                                        ? const Radius.circular(8)
                                        : const Radius.circular(0.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          width: Dimensions.webMaxWidth,
                                          height:
                                              ResponsiveHelper.isDesktop(
                                                context,
                                              )
                                              ? 280
                                              : 150,
                                          child: CustomImage(
                                            image:
                                                service.coverImageFullPath ??
                                                "",
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: Dimensions.webMaxWidth,
                                          height:
                                              ResponsiveHelper.isDesktop(
                                                context,
                                              )
                                              ? 280
                                              : 150,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Dimensions.webMaxWidth,
                                        height:
                                            ResponsiveHelper.isDesktop(context)
                                            ? 280
                                            : 150,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeLarge,
                                        ),
                                        child: Center(
                                          child: Text(
                                            service.name ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraLarge,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 120),
                              ],
                            ),
                            Positioned(
                              bottom: -2,
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              child: ServiceInformationCard(
                                discount: discount,
                                service: service,
                                lowestPrice: lowestPrice,
                              ),
                            ),
                          ],
                        ),

                        //Tab Bar
                        GetBuilder<ServiceTabController>(
                          init: Get.find<ServiceTabController>(),
                          builder: (serviceTabController) {
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Center(
                                child: Container(
                                  width: ResponsiveHelper.isMobile(context)
                                      ? null
                                      : Get.width / 3,
                                  color: Get.isDarkMode
                                      ? Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor
                                      : Theme.of(context).cardColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault,
                                  ),
                                  child: DecoratedTabBar(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: .3),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    tabBar: TabBar(
                                      padding: const EdgeInsets.only(
                                        top: Dimensions.paddingSizeMini,
                                      ),
                                      unselectedLabelColor: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withValues(alpha: 0.4),
                                      controller:
                                          serviceTabController.controller!,
                                      labelColor: Get.isDarkMode
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      labelStyle: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                      ),
                                      indicatorColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      indicatorPadding: const EdgeInsets.only(
                                        top: Dimensions.paddingSizeSmall,
                                      ),
                                      labelPadding: const EdgeInsets.only(
                                        bottom:
                                            Dimensions.paddingSizeExtraSmall,
                                      ),
                                      indicatorWeight: 2,
                                      onTap: (int? index) {
                                        switch (index) {
                                          case 0:
                                            serviceTabController
                                                .updateServicePageCurrentState(
                                                  ServiceTabControllerState
                                                      .serviceOverview,
                                                );
                                            break;
                                          case 1:
                                            serviceTabController
                                                        .serviceDetailsTabs(
                                                          serviceController
                                                              .service,
                                                        )
                                                        .length >
                                                    2
                                                ? serviceTabController
                                                      .updateServicePageCurrentState(
                                                        ServiceTabControllerState
                                                            .faq,
                                                      )
                                                : serviceTabController
                                                      .updateServicePageCurrentState(
                                                        ServiceTabControllerState
                                                            .review,
                                                      );
                                            break;
                                          case 2:
                                            serviceTabController
                                                .updateServicePageCurrentState(
                                                  ServiceTabControllerState
                                                      .review,
                                                );
                                            break;
                                        }
                                      },
                                      tabs: serviceTabController
                                          .serviceDetailsTabs(
                                            serviceController.service,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        //Tab Bar View
                        GetBuilder<ServiceTabController>(
                          initState: (state) {
                            Get.find<ServiceTabController>().getServiceReview(
                              serviceController.service!.id!,
                              1,
                            );
                          },
                          builder: (controller) {
                            Widget tabBarView = TabBarView(
                              controller: controller.controller,
                              children: [
                                SingleChildScrollView(
                                  child: ServiceOverview(
                                    description: service.description!,
                                  ),
                                ),
                                if (Get.find<ServiceDetailsController>()
                                    .service!
                                    .faqs!
                                    .isNotEmpty)
                                  const SingleChildScrollView(
                                    child: ServiceDetailsFaqSection(),
                                  ),
                                if (controller.reviewList != null)
                                  SingleChildScrollView(
                                    child: ServiceDetailsReview(
                                      serviceID: serviceController.service!.id!,
                                    ),
                                  )
                                else
                                  const EmptyReviewWidget(),
                              ],
                            );

                            if (ResponsiveHelper.isMobile(context)) {
                              return Expanded(child: tabBarView);
                            } else {
                              return SizedBox(height: 500, child: tabBarView);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return NoDataScreen(
                text: 'no_service_available'.tr,
                type: NoDataType.service,
              );
            }
          } else {
            return const ServiceDetailsShimmerWidget();
          }
        },
      ),
    );
  }
}

class _QadhaServiceDetails extends StatelessWidget {
  final Service service;
  final Discount discount;
  final double lowestPrice;

  const _QadhaServiceDetails({
    required this.service,
    required this.discount,
    required this.lowestPrice,
  });

  String get _price => PriceConverter.convertPrice(
    lowestPrice,
    discount: discount.discountAmount?.toDouble(),
    discountType: discount.discountAmountType,
    isShowLongPrice: true,
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: QadhaSoftScaffold(
        safeArea: false,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: Row(
                  children: [
                    QadhaCircleIcon(
                      icon: Icons.arrow_back_rounded,
                      onTap: Get.back,
                    ),
                    const Spacer(),
                    Text(
                      'تفاصيل الخدمة',
                      style: robotoBold.copyWith(
                        color: QadhaPalette.deepNavy,
                        fontSize: 24,
                        height: 1,
                      ),
                    ),
                    const Spacer(),
                    QadhaCircleIcon(
                      icon: Icons.shopping_cart_outlined,
                      onTap: () => Get.toNamed(RouteHelper.getCartRoute()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                  child: Column(
                    children: [
                      _QadhaServiceHero(
                        service: service,
                        price: _price,
                        onOrder: () => _openCartSheet(context),
                      ),
                      const SizedBox(height: 18),
                      _QadhaServiceOverview(service: service),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ServiceCenterDialog(service: service, isFromDetails: true),
    );
  }
}

class _QadhaServiceHero extends StatefulWidget {
  final Service service;
  final String price;
  final VoidCallback onOrder;

  const _QadhaServiceHero({
    required this.service,
    required this.price,
    required this.onOrder,
  });

  @override
  State<_QadhaServiceHero> createState() => _QadhaServiceHeroState();
}

class _QadhaServiceHeroState extends State<_QadhaServiceHero> {
  bool _imageExpanded = false;

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFE9FBFF), Color(0xFFF6FFFB)],
        ),
        border: Border.all(color: const Color(0xFFD8F3F5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x181A4384),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_imageExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => setState(() => _imageExpanded = false),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CustomImage(
                    image: service.thumbnailFullPath ?? '',
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: robotoBold.copyWith(
                          color: QadhaPalette.deepNavy,
                          fontSize: 28,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        service.shortDescription ??
                            'تنظيف شامل للمنازل بلمسة احترافية',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(
                          color: QadhaPalette.textMuted,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .86),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFA000),
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                (service.avgRating ?? 0).toStringAsFixed(2),
                                style: robotoBold.copyWith(
                                  color: const Color(0xFFFF9700),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${service.ratingCount ?? 0})',
                                style: robotoMedium.copyWith(
                                  color: QadhaPalette.textMuted,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_imageExpanded) ...[
                  const SizedBox(width: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => setState(() => _imageExpanded = true),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomImage(
                        image: service.thumbnailFullPath ?? '',
                        height: 178,
                        width: 146,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .96),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x121A4384),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: robotoBold.copyWith(
                        color: QadhaPalette.blue,
                        fontSize: 23,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 148,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: QadhaGradientButton(
                        text: 'اطلب',
                        icon: Icons.shopping_cart_outlined,
                        height: 58,
                        onTap: widget.onOrder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QadhaServiceOverview extends StatelessWidget {
  final Service service;

  const _QadhaServiceOverview({required this.service});

  @override
  Widget build(BuildContext context) {
    final description = (service.description?.trim().isNotEmpty ?? false)
        ? service.description!.trim()
        : (service.shortDescription ?? '').trim();

    return QadhaGlassCard(
      radius: 26,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: _QadhaDetailsTab(
              title: 'نظرة عامة على الخدمة',
              icon: Icons.article_outlined,
              selected: true,
            ),
          ),
          Divider(height: 1, color: QadhaPalette.line.withValues(alpha: .9)),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
            child: description.isEmpty
                ? Text(
                    'لا يوجد وصف لهذه الخدمة حالياً',
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      color: QadhaPalette.textMuted,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  )
                : HtmlWidget(
                    description,
                    textStyle: robotoRegular.copyWith(
                      color: QadhaPalette.deepNavy,
                      fontSize: 16,
                      height: 1.7,
                    ),
                    customStylesBuilder: (element) {
                      if (element.localName == 'p') {
                        return {'text-align': 'right', 'line-height': '1.8'};
                      }
                      if (element.localName == 'li') {
                        return {'line-height': '1.8'};
                      }
                      return null;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QadhaDetailsTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;

  const _QadhaDetailsTab({
    required this.title,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? QadhaPalette.blue : QadhaPalette.textMuted,
              size: 22,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: robotoBold.copyWith(
                  color: selected ? QadhaPalette.blue : QadhaPalette.textMuted,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 3,
          width: selected ? 110 : 0,
          decoration: BoxDecoration(
            color: QadhaPalette.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
