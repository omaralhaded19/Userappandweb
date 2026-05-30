import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<ServiceController>().getOffersList(1, true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveHelper.isDesktop(context)) {
      return _buildQadhaOffers(context);
    }

    return Scaffold(
      endDrawer: const MenuDrawer(),
      appBar: CustomAppBar(isBackButtonExist: false, title: 'offers'.tr),
      body: GetBuilder<ServiceController>(
        builder: (serviceController) {
          return FooterBaseView(
            scrollController: _scrollController,
            bottomPadding: false,
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: PaginatedListView(
                scrollController: _scrollController,
                totalSize: serviceController.offerBasedServiceContent?.total,
                offset: serviceController.offerBasedServiceContent?.currentPage,
                onPaginate: (int offset) async {
                  return serviceController.getOffersList(offset, false);
                },
                itemView: ServiceViewVertical(
                  service: serviceController.offerBasedServiceList,
                  type: 'others',
                  noDataType: NoDataType.offers,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQadhaOffers(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: QadhaSoftScaffold(
          safeArea: false,
          child: SafeArea(
            bottom: false,
            child: GetBuilder<ServiceController>(
              builder: (serviceController) {
                final offers = serviceController.offerBasedServiceList;
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 126),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QadhaGradientHeader(
                            title: 'العروض',
                            height: 150,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(34),
                            ),
                            trailing: Container(
                              height: 56,
                              width: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: .24),
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _OffersHeroCard(total: offers?.length),
                          const SizedBox(height: 28),
                          if (offers == null)
                            const SizedBox(
                              height: 280,
                              child: Center(child: CustomLoader()),
                            )
                          else if (offers.isEmpty)
                            const _EmptyOffersView()
                          else
                            PaginatedListView(
                              scrollController: _scrollController,
                              totalSize: serviceController
                                  .offerBasedServiceContent
                                  ?.total,
                              offset: serviceController
                                  .offerBasedServiceContent
                                  ?.currentPage,
                              bottomPadding: 20,
                              onPaginate: (int offset) async {
                                return serviceController.getOffersList(
                                  offset,
                                  false,
                                );
                              },
                              itemView: ServiceViewVertical(
                                service: offers,
                                type: 'others',
                                noDataType: NoDataType.offers,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                        ],
                      ),
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
}

class _OffersHeroCard extends StatelessWidget {
  final int? total;

  const _OffersHeroCard({this.total});

  @override
  Widget build(BuildContext context) {
    return QadhaGlassCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      color: const Color(0xFFEAF6FF).withValues(alpha: .86),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العروض الحالية',
                  style: robotoBold.copyWith(
                    color: QadhaPalette.deepNavy,
                    fontSize: 24,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  total == null || total == 0
                      ? 'أفضل العروض والخدمات بأسعار مميزة'
                      : '$total عروض متاحة الآن',
                  style: robotoRegular.copyWith(
                    color: QadhaPalette.textMuted,
                    fontSize: 15,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 112,
            width: 112,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .78),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: QadhaPalette.blue,
              size: 62,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOffersView extends StatelessWidget {
  const _EmptyOffersView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Container(
            height: 190,
            width: 190,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6FF),
              shape: BoxShape.circle,
              border: Border.all(color: QadhaPalette.line),
            ),
            child: Image.asset(
              Images.emptyOffer,
              height: 136,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.percent_rounded,
                color: QadhaPalette.cyan,
                size: 96,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'لم يتم العثور على أي عرض',
            textAlign: TextAlign.center,
            style: robotoBold.copyWith(
              color: QadhaPalette.deepNavy,
              fontSize: 24,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد عروض متاحة حالياً، تفضل بزيارة هذه الصفحة لاحقاً للاطلاع على أحدث العروض.',
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(
              color: QadhaPalette.textMuted,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
