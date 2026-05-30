import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seohost/feature/auth/controller/auth_controller.dart';
import 'package:seohost/feature/cart/controller/cart_controller.dart';
import 'package:seohost/feature/coupon/controller/coupon_controller.dart';
import 'package:seohost/feature/splash/controller/theme_controller.dart';
import 'package:seohost/utils/dimensions.dart';
import 'package:seohost/utils/images.dart';
import 'package:seohost/utils/styles.dart';

class CouponBottomSheetWidget extends StatefulWidget {
  final double orderAmount;
  const CouponBottomSheetWidget({super.key, required this.orderAmount});

  @override
  State<CouponBottomSheetWidget> createState() =>
      _CouponBottomSheetWidgetState();
}

class _CouponBottomSheetWidgetState extends State<CouponBottomSheetWidget> {
  final TextEditingController couponTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(
      builder: (couponController) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimensions.paddingSizeDefault),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// زر الإغلاق
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).disabledColor,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              /// مربع إدخال القسيمة + زر التأكيد
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(Dimensions.paddingSizeSmall),
                  border: Border.all(
                    color: Get.find<ThemeController>().darkTheme
                        ? Theme.of(context).hintColor.withValues(alpha: .2)
                        : Theme.of(context)
                        .primaryColor
                        .withValues(alpha: .2),
                  ),
                ),
                child: Row(
                  children: [

                    /// input
                    Expanded(
                      child: TextFormField(
                        controller: couponTextController,
                        decoration: InputDecoration(
                          hintText: 'enter_coupon'.tr,
                          hintStyle: robotoRegular.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            child: Image.asset(Images.copyCouponIcon),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    /// زر التأكيد
                    InkWell(
                      onTap: () async {
                        if (couponTextController.text.isEmpty) return;
                        if (!Get.find<AuthController>().isLoggedIn()) return;
                        if (Get.find<CartController>().cartList.isEmpty) return;

                        await couponController
                            .applyCoupon(couponTextController.text);

                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.horizontal(
                            right:
                            Radius.circular(Dimensions.paddingSizeSmall),
                          ),
                        ),
                        child: Center(
                          child: couponController.isLoading
                              ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).cardColor,
                            ),
                          )
                              : Text(
                            'apply'.tr,
                            style: robotoMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
          ),
        );
      },
    );
  }
}
