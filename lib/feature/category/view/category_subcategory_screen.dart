import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class CategorySubCategoryScreen extends StatefulWidget {
  final String categoryID;
  final String categoryIndex;

  const CategorySubCategoryScreen({
    super.key,
    required this.categoryID,
    required this.categoryIndex,
  });

  @override
  State<CategorySubCategoryScreen> createState() =>
      _CategorySubCategoryScreenState();
}

class _CategorySubCategoryScreenState extends State<CategorySubCategoryScreen> {
  AutoScrollController? scrollController;
  String? categoryIndex;
  String? selectedCategoryId;
  int availableServiceCount = 0;
  List<Service>? _directServices;

  @override
  void initState() {
    scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
    scrollController!.scrollToIndex(
      int.tryParse(widget.categoryIndex) ?? 0,
      preferPosition: AutoScrollPosition.middle,
    );
    scrollController!.highlight(int.tryParse(widget.categoryIndex) ?? 0);

    if (Get.find<LocationController>().getUserAddress() != null) {
      availableServiceCount = Get.find<LocationController>()
          .getUserAddress()!
          .availableServiceCountInZone!;
    }

    Get.find<CategoryController>().getCategoryList(false);
    categoryIndex = widget.categoryIndex;
    selectedCategoryId = widget.categoryID;
    Get.find<CategoryController>().getSubCategoryList(
      widget.categoryID,
      shouldUpdate: false,
    );
    _loadDirectServices(widget.categoryID);

    super.initState();
  }

  Future<void> _loadDirectServices(String categoryID) async {
    setState(() => _directServices = null);
    final services = await Get.find<ServiceController>()
        .getDirectCategoryServiceList(categoryID);
    if (mounted) {
      setState(() => _directServices = services);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveHelper.isDesktop(context)) {
      return _buildQadhaCategoryView(context);
    }
    return _buildLegacyDesktopView(context);
  }

  Widget _buildQadhaCategoryView(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: QadhaSoftScaffold(
              safeArea: false,
              child: SafeArea(
                bottom: false,
                child: availableServiceCount > 0
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _QadhaCategoryTopBar(onBack: () => Get.back()),
                                const SizedBox(height: 26),
                                const _QadhaSectionHeading(
                                  title: 'الخدمات المتاحة',
                                ),
                                const SizedBox(height: 16),
                                _QadhaCategoryTabs(
                                  categories: categoryController.categoryList,
                                  selectedIndex:
                                      int.tryParse(categoryIndex ?? '0') ?? 0,
                                  scrollController: scrollController,
                                  onSelected: (index, category) async {
                                    categoryIndex = index.toString();
                                    selectedCategoryId = category.id;
                                    Get.find<CategoryController>()
                                        .getSubCategoryList(category.id!);
                                    _loadDirectServices(category.id!);
                                    await scrollController!.scrollToIndex(
                                      index,
                                      preferPosition: AutoScrollPosition.middle,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                    await scrollController!.highlight(index);
                                  },
                                ),
                                const SizedBox(height: 26),
                                const _QadhaSectionHeading(
                                  title: 'الفئات الفرعية',
                                  compact: true,
                                ),
                                const SizedBox(height: 18),
                                _QadhaSubCategoryList(
                                  subCategories:
                                      categoryController.subCategoryList,
                                ),
                                _QadhaDirectServiceList(
                                  services: _directServices,
                                  categoryId:
                                      selectedCategoryId ?? widget.categoryID,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * .6,
                        child: const ServiceNotAvailableScreen(),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegacyDesktopView(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        return Scaffold(
          endDrawer: const MenuDrawer(),
          appBar: CustomAppBar(title: 'available_service'.tr),
          body: FooterBaseView(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: availableServiceCount > 0
                  ? CustomScrollView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child:
                              (categoryController.categoryList != null &&
                                  !categoryController.isSearching!)
                              ? Center(
                                  child: Container(
                                    height: 140,
                                    width: Dimensions.webMaxWidth,
                                    padding: const EdgeInsets.only(
                                      bottom: Dimensions.paddingSizeExtraSmall,
                                      top: Dimensions.paddingSizeDefault,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: scrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categoryController
                                          .categoryList!
                                          .length,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final categoryModel = categoryController
                                            .categoryList!
                                            .elementAt(index);
                                        return AutoScrollTag(
                                          controller: scrollController!,
                                          key: ValueKey(index),
                                          index: index,
                                          child: InkWell(
                                            onTap: () async {
                                              categoryIndex = index.toString();
                                              Get.find<CategoryController>()
                                                  .getSubCategoryList(
                                                    categoryModel.id!,
                                                  );
                                              await scrollController!
                                                  .scrollToIndex(
                                                    index,
                                                    preferPosition:
                                                        AutoScrollPosition
                                                            .middle,
                                                    duration: const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                              await scrollController!.highlight(
                                                index,
                                              );
                                            },
                                            child: Container(
                                              width: 140,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    index !=
                                                        int.parse(
                                                          categoryIndex!,
                                                        )
                                                    ? Theme.of(
                                                        context,
                                                      ).primaryColorLight
                                                    : Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(
                                                        Dimensions
                                                            .radiusDefault,
                                                      ),
                                                    ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault,
                                                        ),
                                                    child: CustomImage(
                                                      fit: BoxFit.cover,
                                                      height: 50,
                                                      width: 50,
                                                      image:
                                                          '${categoryController.categoryList![index].imageFullPath}',
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeDefault,
                                                        ),
                                                    child: Text(
                                                      categoryController
                                                          .categoryList![index]
                                                          .name!,
                                                      style: robotoRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall,
                                                        color:
                                                            index ==
                                                                int.parse(
                                                                  categoryIndex!,
                                                                )
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                )
                              : const CategoryShimmer(fromHomeScreen: false),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeLarge,
                              ),
                              child: Center(
                                child: Text(
                                  'sub_categories'.tr,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SubCategoryView(
                          noDataText: "no_subcategory_found".tr,
                          isScrollable: true,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * .6,
                      child: const ServiceNotAvailableScreen(),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _QadhaCategoryTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _QadhaCategoryTopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        QadhaCircleIcon(
          icon: Icons.arrow_back_ios_new_rounded,
          color: QadhaPalette.deepNavy,
          onTap: onBack,
        ),
        const Spacer(),
        const QadhaBrandMark(
          iconSize: 34,
          textSize: 28,
          showTagline: false,
          textColor: QadhaPalette.cyan,
        ),
        const Spacer(),
        QadhaCircleIcon(
          icon: Icons.notifications_none_rounded,
          color: QadhaPalette.deepNavy,
          onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
        ),
      ],
    );
  }
}

class _QadhaSectionHeading extends StatelessWidget {
  final String title;
  final bool compact;

  const _QadhaSectionHeading({required this.title, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(color: QadhaPalette.line.withValues(alpha: .8)),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.auto_awesome_rounded,
          color: QadhaPalette.cyan,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: robotoBold.copyWith(
            color: QadhaPalette.deepNavy,
            fontSize: compact ? 18 : 20,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.auto_awesome_rounded,
          color: QadhaPalette.cyan,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(color: QadhaPalette.line.withValues(alpha: .8)),
        ),
      ],
    );
  }
}

class _QadhaCategoryTabs extends StatelessWidget {
  final List<CategoryModel>? categories;
  final int selectedIndex;
  final AutoScrollController? scrollController;
  final void Function(int index, CategoryModel category) onSelected;

  const _QadhaCategoryTabs({
    required this.categories,
    required this.selectedIndex,
    required this.scrollController,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      return const SizedBox(height: 118, child: Center(child: CustomLoader()));
    }
    if (categories!.isEmpty) {
      return NoDataScreen(
        type: NoDataType.categorySubcategory,
        text: 'no_category_found'.tr,
      );
    }

    return SizedBox(
      height: 126,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories!.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories![index];
          final selected = index == selectedIndex;
          return AutoScrollTag(
            controller: scrollController!,
            index: index,
            key: ValueKey(category.id ?? index.toString()),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onSelected(index, category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 92,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: selected ? QadhaPalette.primaryGradient : null,
                  color: selected ? null : Colors.white.withValues(alpha: .95),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected ? Colors.transparent : QadhaPalette.line,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x121A4384),
                      blurRadius: 16,
                      offset: Offset(0, 9),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 54,
                      width: 54,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: selected ? .95 : .9,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: CustomImage(
                          image: category.imageFullPath ?? '',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      category.name ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: robotoMedium.copyWith(
                        color: selected ? Colors.white : QadhaPalette.deepNavy,
                        fontSize: 12,
                        height: 1.15,
                      ),
                    ),
                    if (selected)
                      Container(
                        width: 28,
                        height: 3,
                        margin: const EdgeInsets.only(top: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QadhaSubCategoryList extends StatelessWidget {
  final List<CategoryModel>? subCategories;

  const _QadhaSubCategoryList({required this.subCategories});

  @override
  Widget build(BuildContext context) {
    if (subCategories == null) {
      return const SizedBox(height: 220, child: Center(child: CustomLoader()));
    }
    if (subCategories!.isEmpty) {
      return SizedBox(
        height: 300,
        child: NoDataScreen(
          text: 'no_subcategory_found'.tr,
          type: NoDataType.categorySubcategory,
        ),
      );
    }

    return Column(
      children: subCategories!
          .map((subcategory) => _QadhaSubCategoryCard(subcategory: subcategory))
          .toList(),
    );
  }
}

class _QadhaDirectServiceList extends StatelessWidget {
  final List<Service>? services;
  final String categoryId;

  const _QadhaDirectServiceList({
    required this.services,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    if (services == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(child: CustomLoader()),
      );
    }

    if (services!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 22),
        const _QadhaSectionHeading(
          title: 'Ø§Ù„Ø®Ø¯Ù…Ø§Øª Ø§Ù„Ù…ØªØ§Ø­Ø©',
          compact: true,
        ),
        const SizedBox(height: 12),
        ServiceViewVertical(
          service: services,
          padding: EdgeInsets.zero,
          fromPage: categoryId,
        ),
      ],
    );
  }
}

class _QadhaSubCategoryCard extends StatelessWidget {
  final CategoryModel subcategory;

  const _QadhaSubCategoryCard({required this.subcategory});

  @override
  Widget build(BuildContext context) {
    final description = (subcategory.description ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () =>
            CategoryNavigationHelper.openCategoryOrServices(subcategory),
        child: QadhaGlassCard(
          radius: 24,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          child: Row(
            children: [
              Container(
                height: 68,
                width: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFFFF8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: QadhaPalette.green.withValues(alpha: .22),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: CustomImage(
                      image: subcategory.imageFullPath ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subcategory.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: robotoBold.copyWith(
                        color: QadhaPalette.deepNavy,
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(
                          color: QadhaPalette.textMuted,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          CategoryNavigationHelper.footerText(subcategory),
                          style: robotoMedium.copyWith(
                            color: QadhaPalette.blue,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: QadhaPalette.blue,
                          size: 13,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
