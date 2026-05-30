import 'package:get/get.dart';
import 'package:seohost/utils/core_export.dart';

class CategoryNavigationHelper {
  static String levelName(int level) {
    switch (level) {
      case 2:
        return 'الفئات الفرعية';
      case 3:
        return 'الفئة رقم 1';
      case 4:
        return 'الفئة رقم 2';
      case 5:
        return 'الفئة رقم 3';
      case 6:
        return 'الفئة رقم 4';
      case 7:
        return 'الفئة رقم 5';
      default:
        return 'الفئات';
    }
  }

  static String footerText(CategoryModel category) {
    final serviceCount = category.serviceCount ?? 0;
    final childrenCount = category.childrenCount;
    final details = <String>[];

    if (childrenCount != null && childrenCount > 0) {
      details.add('$childrenCount ${'sub_categories'.tr}');
    }

    if (serviceCount > 0) {
      details.add('$serviceCount ${'services'.tr}');
    }

    return details.isNotEmpty ? details.join('  |  ') : 'فتح الفئة';
  }

  static Future<void> openCategoryOrServices(
    CategoryModel category, {
    int level = 2,
  }) async {
    final categoryId = category.id;
    if (categoryId == null || categoryId.isEmpty) {
      return;
    }

    final position = category.position ?? level;
    if (position < 7) {
      final children = await Get.find<CategoryController>()
          .getChildCategoryList(categoryId);

      if (children.isNotEmpty) {
        Get.toNamed(
          RouteHelper.getCategoryChildrenRoute(
            categoryId: categoryId,
            title: category.name ?? levelName(level + 1),
            level: level + 1,
          ),
          arguments: children,
        );
        return;
      }
    }

    Get.find<ServiceController>().cleanSubCategory();
    Get.toNamed(RouteHelper.allServiceScreenRoute(categoryId));
  }
}
