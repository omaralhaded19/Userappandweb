import 'package:get/get.dart';
import 'package:seohost/utils/core_export.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {

      return categoryController.categoryList != null && categoryController.categoryList!.isEmpty ? const SizedBox() :
      categoryController.categoryList != null ? Center(
        child: SizedBox(width: Dimensions.webMaxWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF07111D), Color(0xFF0F2240)],
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 18,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'all_categories'.tr,
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Colors.white,
                        ),
                      ),
                      if ((categoryController.categoryList!.length > 8 && ResponsiveHelper.isMobile(context))
                          || (categoryController.categoryList!.length > 12 && ResponsiveHelper.isTab(context))
                          || (categoryController.categoryList!.length > 10 && ResponsiveHelper.isDesktop(context)))
                        TextButton(
                          onPressed: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                            categoryController.categoryList![0].id!,
                            categoryController.categoryList![0].name!,
                            0.toString(),
                          )),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'see_all'.tr,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Colors.white.withOpacity(0.7),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 3,
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                      childAspectRatio: 0.96,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ResponsiveHelper.isDesktop(context) && categoryController.categoryList!.length > 10 ? 10
                        : ResponsiveHelper.isTab(context) && categoryController.categoryList!.length > 12 ? 12
                        : ResponsiveHelper.isMobile(context) && categoryController.categoryList!.length > 8 ? 8
                        : categoryController.categoryList!.length,
                    itemBuilder: (context, index) {
                      final category = categoryController.categoryList![index];
                      final subtitleText = category.description?.replaceAll(RegExp(r'<[^>]*>'), '').trim() ?? '';
                      return TextHover(builder: (hovered) {
                        final borderColor = Theme.of(context).colorScheme.primary.withOpacity(0.24);
                        final iconBackground = Theme.of(context).colorScheme.primary.withOpacity(0.18);
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF102441),
                                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                border: Border.all(color: hovered ? borderColor : Colors.transparent),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x22000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeDefault,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 72,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      color: iconBackground,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                        child: CustomImage(
                                          image: category.imageFullPath ?? "",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Text(
                                    category.name!,
                                    textAlign: TextAlign.center,
                                    style: robotoBold.copyWith(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (subtitleText.isNotEmpty) ...[
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      subtitleText,
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Colors.white.withOpacity(0.72),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: RippleButton(
                                onTap: () {
                                  Get.toNamed(RouteHelper.getCategoryProductRoute(
                                    category.id!,
                                    category.name!,
                                    index.toString(),
                                  ));
                                },
                              ),
                            ),
                          ],
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ) : const CategoryShimmer();
    });
  }
}



class CategoryShimmer extends StatelessWidget {
  final bool? fromHomeScreen;

  const CategoryShimmer({super.key, this.fromHomeScreen=true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if(fromHomeScreen!) const SizedBox(height: Dimensions.paddingSizeLarge,),
            if(fromHomeScreen!) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 25, width: 120,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: Get.isDarkMode ? null : cardShadow,
                  ),
                ), Container(
                  height: 25, width: 100,
                  decoration: BoxDecoration(
                    color: Get.find<ThemeController>().darkTheme ?  Theme.of(context).cardColor : Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: Get.isDarkMode ? null : cardShadow,
                  ),
                ),
              ],),
            if(fromHomeScreen!)const SizedBox(height: Dimensions.paddingSizeSmall,),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:  !fromHomeScreen! ? 8 : ResponsiveHelper.isDesktop(context) ? 10 : ResponsiveHelper.isTab(context)? 12 : 8,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                    boxShadow: Get.isDarkMode ? null : cardShadow,
                  ),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeDefault,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Container(
                            height: 12,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: !fromHomeScreen! ? 3 : ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1,
                crossAxisSpacing: Dimensions.paddingSizeSmall + 2,
                mainAxisSpacing: Dimensions.paddingSizeSmall + 2,
                  childAspectRatio: 1
              ),
            ),

            SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge,)
          ],
        ),
      ),
    );
  }
}
