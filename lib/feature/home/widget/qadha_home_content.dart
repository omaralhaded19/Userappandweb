import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class QadhaHomeContent extends StatelessWidget {
  const QadhaHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: QadhaSoftScaffold(
          safeArea: false,
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 22, 18, 116),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 430),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _LocationTopBar(),
                              const SizedBox(height: 26),
                              const _QadhaHeader(),
                              const SizedBox(height: 30),
                              const BannerView(),
                              const SizedBox(height: 18),
                              _SectionTitle(title: 'خدماتنا'),
                              const SizedBox(height: 10),
                              const _ServicesGrid(),
                              const SizedBox(height: 24),
                              _SectionTitle(title: 'لماذا قدها؟'),
                              const SizedBox(height: 12),
                              const _WhyQadhaRow(),
                            ],
                          ),
                        ),
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

class _QadhaHeader extends StatelessWidget {
  const _QadhaHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const QadhaBrandMark(
          iconSize: 92,
          textSize: 64,
          showTagline: false,
          textColor: QadhaPalette.navy,
        ),
        const SizedBox(height: 14),
        Text(
          'كيف يمكننا مساعدتك اليوم؟',
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(
            color: QadhaPalette.textMuted,
            fontSize: 17,
            height: 1.3,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: robotoMedium.copyWith(
        color: QadhaPalette.deepNavy,
        fontSize: 18,
        height: 1.2,
        letterSpacing: 0,
      ),
    );
  }
}

class _LocationTopBar extends StatelessWidget {
  const _LocationTopBar();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('address')),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .96),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: QadhaPalette.line, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x141A4384),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFFFF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: QadhaPalette.green,
                size: 22,
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
                      color: QadhaPalette.textMuted,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GetBuilder<LocationController>(
                    builder: (locationController) {
                      final address =
                          locationController.getUserAddress()?.address ??
                          'حدد موقعك';
                      return Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: robotoBold.copyWith(
                          color: QadhaPalette.deepNavy,
                          fontSize: 14,
                          height: 1.2,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: QadhaPalette.green,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        final categories = categoryController.categoryList;
        if (categories == null) {
          return const SizedBox(
            height: 190,
            child: Center(child: CustomLoader()),
          );
        }
        if (categories.isEmpty) {
          return const SizedBox();
        }

        return GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            mainAxisExtent: ResponsiveHelper.isMobile(context) ? 176 : 188,
          ),
          itemBuilder: (context, index) {
            return _CategoryServiceTile(
              category: categories[index],
              index: index,
            );
          },
        );
      },
    );
  }
}

class _CategoryServiceTile extends StatelessWidget {
  final CategoryModel category;
  final int index;

  const _CategoryServiceTile({required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Get.toNamed(
        RouteHelper.getCategoryProductRoute(
          category.id ?? '',
          category.name ?? '',
          index.toString(),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .96),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: QadhaPalette.line, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x141A4384),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 96,
              width: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEFFFF8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: QadhaPalette.green.withValues(alpha: .25),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ClipOval(
                  child: CustomImage(
                    image: category.imageFullPath ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              category.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(
                color: QadhaPalette.deepNavy,
                fontSize: 14,
                height: 1.2,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhyQadhaRow extends StatelessWidget {
  const _WhyQadhaRow();

  @override
  Widget build(BuildContext context) {
    final items = [
      _FeatureItem(Icons.workspace_premium_outlined, 'جودة\nعالية'),
      _FeatureItem(Icons.verified_user_outlined, 'ثقة\nوأمان'),
      _FeatureItem(Icons.timer_outlined, 'سرعة\nاستجابة'),
      _FeatureItem(Icons.support_agent_outlined, 'متابعة\nمستمرة'),
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _FeaturePill(item: item),
          ),
        );
      }).toList(),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final _FeatureItem item;

  const _FeaturePill({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: QadhaPalette.line, width: .8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1A4384),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: QadhaPalette.green, size: 22),
          const SizedBox(height: 5),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: robotoRegular.copyWith(
              color: QadhaPalette.deepNavy,
              fontSize: 10,
              height: 1.15,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String label;

  const _FeatureItem(this.icon, this.label);
}
