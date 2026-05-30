import 'package:get/get.dart';
import 'package:seohost/utils/core_export.dart';

class CategoryChildrenScreen extends StatefulWidget {
  final String parentId;
  final String title;
  final int level;

  const CategoryChildrenScreen({
    super.key,
    required this.parentId,
    required this.title,
    required this.level,
  });

  @override
  State<CategoryChildrenScreen> createState() => _CategoryChildrenScreenState();
}

class _CategoryChildrenScreenState extends State<CategoryChildrenScreen> {
  List<CategoryModel>? _categories;
  List<Service>? _services;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    if (arguments is List<CategoryModel>) {
      _categories = arguments;
    } else {
      _loadCategories();
    }
    _loadServices();
  }

  Future<void> _loadCategories() async {
    final categories = await Get.find<CategoryController>()
        .getChildCategoryList(widget.parentId);
    if (mounted) {
      setState(() => _categories = categories);
    }
  }

  Future<void> _loadServices() async {
    final services = await Get.find<ServiceController>()
        .getDirectCategoryServiceList(widget.parentId);
    if (mounted) {
      setState(() => _services = services);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ResponsiveHelper.isDesktop(context)
          ? const MenuDrawer()
          : null,
      appBar: CustomAppBar(title: widget.title, showCart: true),
      body: FooterBaseView(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Text(
                  CategoryNavigationHelper.levelName(widget.level),
                  textAlign: TextAlign.center,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              if (_categories == null)
                const Center(child: CustomLoader())
              else if (_categories!.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: ResponsiveHelper.isTab(context)
                        ? 0.0
                        : Dimensions.paddingSizeSmall,
                    mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.paddingSizeDefault
                        : Dimensions.paddingSizeSmall,
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 3,
                    mainAxisExtent: 120,
                  ),
                  itemCount: _categories!.length,
                  itemBuilder: (context, index) {
                    return _CategoryChildItem(
                      category: _categories![index],
                      level: widget.level,
                    );
                  },
                ),
              if (_services == null)
                const Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Center(child: CustomLoader()),
                )
              else if (_services!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeSmall,
                    Dimensions.paddingSizeDefault,
                    0,
                  ),
                  child: Text(
                    'الخدمات المتاحة',
                    textAlign: TextAlign.center,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ServiceViewVertical(
                  service: _services,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  fromPage: widget.parentId,
                ),
              ] else if (_categories != null && _categories!.isEmpty)
                NoDataScreen(
                  text: 'no_services_found'.tr,
                  type: NoDataType.service,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChildItem extends StatelessWidget {
  final CategoryModel category;
  final int level;

  const _CategoryChildItem({required this.category, required this.level});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CategoryNavigationHelper.openCategoryOrServices(
        category,
        level: level,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context)
              ? 0
              : Dimensions.paddingSizeDefault,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImage(
                image: category.imageFullPath ?? "",
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name ?? "",
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      category.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      _footerText,
                      style: robotoRegular.copyWith(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w400,
                        color: Get.isDarkMode
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _footerText {
    return CategoryNavigationHelper.footerText(category);
  }
}
