import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class CartSummery extends StatelessWidget {
  const CartSummery({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckOutController>(
      builder: (checkoutController) {
        return GetBuilder<ScheduleController>(
          builder: (scheduleController) {
            return GetBuilder<CartController>(
              builder: (cartController) {
                int scheduleDaysCount = scheduleController.scheduleDaysCount > 0
                    ? scheduleController.scheduleDaysCount
                    : 1;

                ConfigModel configModel =
                    Get.find<SplashController>().configModel;
                List<CartModel> cartList = cartController.cartList;
                bool walletPaymentStatus = cartController.walletPaymentStatus;
                int applicableCouponCount =
                    CheckoutHelper.getNumberOfDaysForApplicableCoupon(
                      pickedScheduleDays: scheduleDaysCount,
                    ) ??
                    1;
                double additionalCharge = CheckoutHelper.getAdditionalCharge();
                bool isPartialPayment = CheckoutHelper.checkPartialPayment(
                  walletBalance: cartController.walletBalance,
                  bookingAmount: cartController.totalPrice,
                );
                double paidAmount = CheckoutHelper.calculatePaidAmount(
                  walletBalance: cartController.walletBalance,
                  bookingAmount: cartController.totalPrice,
                );
                double subTotalPrice = CheckoutHelper.calculateSubTotal(
                  cartList: cartList,
                  daysCount: scheduleDaysCount,
                );
                double disCount = CheckoutHelper.calculateDiscount(
                  cartList: cartList,
                  discountType: DiscountType.general,
                  daysCount: scheduleDaysCount,
                );
                double campaignDisCount = CheckoutHelper.calculateDiscount(
                  cartList: cartList,
                  discountType: DiscountType.campaign,
                  daysCount: scheduleDaysCount,
                );
                double couponDisCount = CheckoutHelper.calculateDiscount(
                  cartList: cartList,
                  discountType: DiscountType.coupon,
                  daysCount: applicableCouponCount,
                );
                double referDisCount = cartController.referralAmount;
                double vat = CheckoutHelper.calculateVat(
                  cartList: cartList,
                  daysCount: scheduleDaysCount,
                );
                double grandTotal = CheckoutHelper.calculateGrandTotal(
                  cartList: cartList,
                  referralDiscount: referDisCount,
                  daysCount: scheduleDaysCount,
                );
                double dueAmount = CheckoutHelper.calculateDueAmount(
                  cartList: cartList,
                  walletPaymentStatus: walletPaymentStatus,
                  walletBalance: cartController.walletBalance,
                  bookingAmount: cartController.totalPrice,
                  referralDiscount: referDisCount,
                  daysCount: scheduleDaysCount,
                );

                Future.delayed(const Duration(milliseconds: 200), () {
                  cartController.updateTotalPrice = grandTotal;
                  cartController.update();
                });

                if (ResponsiveHelper.isMobile(context)) {
                  return _QadhaCartSummary(
                    checkoutController: checkoutController,
                    cartList: cartList,
                    subTotalPrice: subTotalPrice,
                    discount: disCount,
                    campaignDiscount: campaignDisCount,
                    couponDiscount: couponDisCount,
                    referralDiscount: referDisCount,
                    vat: vat,
                    additionalCharge: additionalCharge,
                    grandTotal: grandTotal,
                    paidAmount: paidAmount,
                    dueAmount: dueAmount,
                    isPartialPayment: isPartialPayment,
                    walletPaymentStatus: walletPaymentStatus,
                    configModel: configModel.content,
                    scheduleDaysCount: scheduleDaysCount,
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                        horizontal: Dimensions.paddingSizeDefault,
                      ),
                      child: Text(
                        'cart_summary'.tr,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeDefault,
                      ),
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: cartList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              double totalCost =
                                  (cartList
                                          .elementAt(index)
                                          .serviceCost
                                          .toDouble() *
                                      cartList.elementAt(index).quantity) *
                                  scheduleDaysCount;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowText(
                                    title: cartList
                                        .elementAt(index)
                                        .service!
                                        .name!,
                                    quantity: cartList
                                        .elementAt(index)
                                        .quantity,
                                    price: totalCost,
                                  ),
                                  SizedBox(
                                    width: Get.width / 2.5,
                                    child: Text(
                                      cartList.elementAt(index).variantKey,
                                      style: robotoMedium.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withValues(alpha: .4),
                                        fontSize: Dimensions.fontSizeSmall,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeDefault,
                                  ),
                                ],
                              );
                            },
                          ),

                          Divider(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.color!.withValues(alpha: .6),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall,
                          ),

                          RowText(title: 'sub_total'.tr, price: subTotalPrice),
                          RowText(title: 'discount'.tr, price: disCount),
                          RowText(
                            title: 'campaign_discount'.tr,
                            price: campaignDisCount,
                          ),
                          RowText(
                            title: 'coupon_discount'.tr,
                            price: couponDisCount,
                          ),
                          if (referDisCount > 0)
                            RowText(
                              title: 'referral_discount'.tr,
                              price: referDisCount,
                            ),
                          RowText(title: 'vat'.tr, price: vat),

                          (configModel.content?.additionalChargeLabelName !=
                                      "" &&
                                  configModel.content?.additionalCharge == 1)
                              ? GetBuilder<CheckOutController>(
                                  builder: (controller) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  configModel
                                                          .content
                                                          ?.additionalChargeLabelName ??
                                                      "",
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "(+) ${PriceConverter.convertPrice(additionalCharge, isShowLongPrice: true)}",
                                          style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : const SizedBox(),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeSmall,
                            ),
                            child: Divider(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withValues(alpha: .6),
                            ),
                          ),

                          RowText(title: 'grand_total'.tr, price: grandTotal),
                          (Get.find<CartController>().walletPaymentStatus)
                              ? RowText(
                                  title: 'paid_by_wallet'.tr,
                                  price: paidAmount,
                                )
                              : const SizedBox(),
                          (Get.find<CartController>().walletPaymentStatus &&
                                  isPartialPayment)
                              ? RowText(
                                  title: 'due_amount'.tr,
                                  price: dueAmount,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeSmall,
                      ),
                      child: ConditionCheckBox(
                        checkBoxValue: checkoutController.acceptTerms,
                        onTap: (bool? value) {
                          checkoutController.toggleTerms();
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _QadhaCartSummary extends StatelessWidget {
  final CheckOutController checkoutController;
  final List<CartModel> cartList;
  final double subTotalPrice;
  final double discount;
  final double campaignDiscount;
  final double couponDiscount;
  final double referralDiscount;
  final double vat;
  final double additionalCharge;
  final double grandTotal;
  final double paidAmount;
  final double dueAmount;
  final bool isPartialPayment;
  final bool walletPaymentStatus;
  final ConfigContent? configModel;
  final int scheduleDaysCount;

  const _QadhaCartSummary({
    required this.checkoutController,
    required this.cartList,
    required this.subTotalPrice,
    required this.discount,
    required this.campaignDiscount,
    required this.couponDiscount,
    required this.referralDiscount,
    required this.vat,
    required this.additionalCharge,
    required this.grandTotal,
    required this.paidAmount,
    required this.dueAmount,
    required this.isPartialPayment,
    required this.walletPaymentStatus,
    required this.configModel,
    required this.scheduleDaysCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'مجموع طلباتك',
            textAlign: TextAlign.right,
            style: robotoBold.copyWith(
              color: QadhaPalette.deepNavy,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          QadhaGlassCard(
            radius: 22,
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                ...cartList.map((cart) {
                  final totalCost =
                      (cart.serviceCost.toDouble() * cart.quantity) *
                      scheduleDaysCount;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            cart.service?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: robotoMedium.copyWith(
                              color: QadhaPalette.deepNavy,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          'x ${cart.quantity}',
                          style: robotoMedium.copyWith(
                            color: QadhaPalette.textMuted,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            PriceConverter.convertPrice(
                              totalCost,
                              isShowLongPrice: true,
                            ),
                            style: robotoMedium.copyWith(
                              color: QadhaPalette.deepNavy,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Divider(color: QadhaPalette.line.withValues(alpha: .9)),
                _QadhaSummaryRow(
                  title: 'المجموع الفرعي',
                  amount: subTotalPrice,
                ),
                _QadhaSummaryRow(title: 'خصومات', amount: discount),
                if (campaignDiscount > 0)
                  _QadhaSummaryRow(
                    title: 'خصم الحملة',
                    amount: campaignDiscount,
                  ),
                if (couponDiscount > 0)
                  _QadhaSummaryRow(
                    title: 'خصم القسيمة',
                    amount: couponDiscount,
                  ),
                if (referralDiscount > 0)
                  _QadhaSummaryRow(
                    title: 'خصم الإحالة',
                    amount: referralDiscount,
                  ),
                _QadhaSummaryRow(title: 'الضريبة', amount: vat, positive: true),
                if (configModel?.additionalChargeLabelName != "" &&
                    configModel?.additionalCharge == 1)
                  _QadhaSummaryRow(
                    title: configModel?.additionalChargeLabelName ?? '',
                    amount: additionalCharge,
                    positive: true,
                  ),
                if (walletPaymentStatus)
                  _QadhaSummaryRow(
                    title: 'مدفوع من المحفظة',
                    amount: paidAmount,
                  ),
                if (walletPaymentStatus && isPartialPayment)
                  _QadhaSummaryRow(title: 'المتبقي', amount: dueAmount),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: QadhaPalette.green.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'السعر الإجمالي',
                        style: robotoBold.copyWith(
                          color: QadhaPalette.deepNavy,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          PriceConverter.convertPrice(
                            grandTotal,
                            isShowLongPrice: true,
                          ),
                          style: robotoBold.copyWith(
                            color: QadhaPalette.green,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          QadhaGlassCard(
            radius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: ConditionCheckBox(
              checkBoxValue: checkoutController.acceptTerms,
              onTap: (bool? value) {
                checkoutController.toggleTerms(value: value ?? true);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QadhaSummaryRow extends StatelessWidget {
  final String title;
  final double amount;
  final bool positive;

  const _QadhaSummaryRow({
    required this.title,
    required this.amount,
    this.positive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: robotoRegular.copyWith(
                color: QadhaPalette.textMuted,
                fontSize: 15,
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${positive ? '(+) ' : ''}${PriceConverter.convertPrice(amount, isShowLongPrice: true)}',
              style: robotoMedium.copyWith(
                color: QadhaPalette.deepNavy,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
