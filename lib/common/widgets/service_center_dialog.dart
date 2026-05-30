import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class ServiceCenterDialog extends StatefulWidget {
  final Service? service;
  final CartModel? cart;
  final int? cartIndex;
  final bool? isFromDetails;
  final ProviderData? providerData;

  const ServiceCenterDialog({
    super.key,
    required this.service,
    this.cart,
    this.cartIndex,
    this.isFromDetails = false,
    this.providerData,
  });

  @override
  State<ServiceCenterDialog> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ServiceCenterDialog> {
  @override
  void initState() {
    Get.find<CartController>().setInitialCartList(widget.service!);
    Get.find<CartController>().updatePreselectedProvider(
      null,
      shouldUpdate: false,
    );
    Get.find<AllSearchController>().searchFocus.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  Widget pointerInterceptor() {
    if (!ResponsiveHelper.isDesktop(context)) {
      return _qadhaPointerInterceptor();
    }

    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveHelper.isWeb() ? 0 : Dimensions.cartDialogPadding,
      ),
      child: PointerInterceptor(
        child: Container(
          width: ResponsiveHelper.isDesktop(context)
              ? Dimensions.webMaxWidth / 2
              : Dimensions.webMaxWidth,
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimensions.radiusExtraLarge),
            ),
          ),
          child: GetBuilder<CartController>(
            builder: (cartControllerInit) {
              return GetBuilder<ServiceController>(
                builder: (serviceController) {
                  if (widget.service!.variationsAppFormat!.zoneWiseVariations !=
                      null) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Dimensions.paddingSizeDefault),
                              ),
                              child: CustomImage(
                                image: '${widget.service!.thumbnailFullPath}',
                                height: Dimensions.imageSizeButton,
                                width: Dimensions.imageSizeButton,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white70.withValues(alpha: 0.6),
                                boxShadow: Get.isDarkMode
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: Colors.grey[300]!,
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                        ),
                                      ],
                              ),
                              child: InkWell(
                                onTap: () => Get.back(),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeEight),
                        Text(
                          widget.service!.name!,
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeMini),
                        Text(
                          widget
                                      .service!
                                      .variationsAppFormat!
                                      .zoneWiseVariations!
                                      .length >
                                  1
                              ? "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variations_available'.tr}"
                              : "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variation_available'.tr}",

                          style: robotoRegular.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.color!.withValues(alpha: .5),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: Get.height * 0.1,
                                maxHeight: Get.height * 0.4,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    cartControllerInit.initialCartList.length,
                                itemBuilder: (context, index) {
                                  //variation item
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeSmall,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).hoverColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                            Dimensions.paddingSizeDefault,
                                          ),
                                        ),
                                      ),
                                      child: GetBuilder<CartController>(
                                        builder: (cartController) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        cartControllerInit
                                                            .initialCartList[index]
                                                            .variantKey
                                                            .replaceAll(
                                                              '-',
                                                              ' ',
                                                            ),
                                                        style: robotoMedium
                                                            .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                            ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall,
                                                      ),
                                                      Directionality(
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        child: Text(
                                                          PriceConverter.convertPrice(
                                                            double.parse(
                                                              cartControllerInit
                                                                  .initialCartList[index]
                                                                  .price
                                                                  .toString(),
                                                            ),
                                                            isShowLongPrice:
                                                                true,
                                                          ),
                                                          style: robotoMedium.copyWith(
                                                            color:
                                                                Get.isDarkMode
                                                                ? Theme.of(
                                                                    context,
                                                                  ).primaryColorLight
                                                                : Theme.of(
                                                                    context,
                                                                  ).primaryColor,
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Expanded(child: SizedBox()),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      cartControllerInit
                                                                  .initialCartList[index]
                                                                  .quantity >
                                                              0
                                                          ? InkWell(
                                                              onTap: () {
                                                                cartController
                                                                    .updateQuantity(
                                                                      index,
                                                                      false,
                                                                    );
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                margin: const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeSmall,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Theme.of(
                                                                    context,
                                                                  ).colorScheme.secondary,
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  size: 15,
                                                                  color: Theme.of(
                                                                    context,
                                                                  ).cardColor,
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),

                                                      cartControllerInit
                                                                  .initialCartList[index]
                                                                  .quantity >
                                                              0
                                                          ? Text(
                                                              cartControllerInit
                                                                  .initialCartList[index]
                                                                  .quantity
                                                                  .toString(),
                                                            )
                                                          : const SizedBox(),

                                                      GestureDetector(
                                                        onTap: () {
                                                          cartController
                                                              .updateQuantity(
                                                                index,
                                                                true,
                                                              );
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          margin: const EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeSmall,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .secondary,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 15,
                                                            color: Theme.of(
                                                              context,
                                                            ).cardColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                          ],
                        ),

                        GetBuilder<CartController>(
                          builder: (cartController) {
                            bool addToCart = true;
                            return cartController.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Row(
                                    spacing: Dimensions.paddingSizeSmall,
                                    children: [
                                      if (Get.find<SplashController>()
                                                  .configModel
                                                  .content
                                                  ?.directProviderBooking ==
                                              1 &&
                                          (widget.providerData != null ||
                                              cartController.selectedProvider !=
                                                  null))
                                        GestureDetector(
                                          onTap: () {
                                            // showModalBottomSheet(
                                            //   useRootNavigator: true,
                                            //   isScrollControlled: true,
                                            //   backgroundColor: Colors.transparent,
                                            //   context: context, builder: (context) =>  AvailableProviderWidget(
                                            //   subcategoryId: widget.service?.subCategoryId ??"",
                                            // ));
                                          },
                                          child: SelectedProductWidget(
                                            providerData:
                                                widget.providerData ??
                                                cartController.selectedProvider,
                                          ),
                                        ),

                                      if (Get.find<SplashController>()
                                              .configModel
                                              .content
                                              ?.biddingStatus ==
                                          1)
                                        GestureDetector(
                                          onTap: () {
                                            Get.back();
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              context: Get.context!,
                                              builder: (BuildContext context) {
                                                return const BottomCreatePostDialog();
                                              },
                                            );
                                            if (widget.service != null) {
                                              Get.find<CreatePostController>()
                                                  .resetCreatePostValue(
                                                    removeService: false,
                                                  );
                                              Get.find<CreatePostController>()
                                                  .updateSelectedService(
                                                    widget.service!,
                                                  );
                                            }
                                          },
                                          child: Container(
                                            height:
                                                ResponsiveHelper.isDesktop(
                                                  context,
                                                )
                                                ? 50
                                                : 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    Dimensions.radiusSmall,
                                                  ),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.5),
                                                width: 0.7,
                                              ),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.1),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                            child: Center(
                                              child: Hero(
                                                tag: 'provide_image',
                                                child: Image.asset(
                                                  Images.customPostIcon,
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      Expanded(
                                        child: CustomButton(
                                          height:
                                              ResponsiveHelper.isDesktop(
                                                context,
                                              )
                                              ? 55
                                              : 45,
                                          onPressed: cartControllerInit.isButton
                                              ? () async {
                                                  if (addToCart) {
                                                    addToCart = false;
                                                    await cartController
                                                        .addMultipleCartToServer(
                                                          providerId:
                                                              cartController
                                                                  .selectedProvider
                                                                  ?.id ??
                                                              widget
                                                                  .providerData
                                                                  ?.id ??
                                                              "",
                                                        );
                                                    await cartController
                                                        .getCartListFromServer(
                                                          shouldUpdate: true,
                                                        );
                                                  }
                                                }
                                              : null,
                                          buttonText:
                                              (cartController
                                                      .cartList
                                                      .isNotEmpty &&
                                                  cartController.cartList
                                                          .elementAt(0)
                                                          .serviceId ==
                                                      widget.service!.id)
                                              ? 'update_cart'.tr
                                              : 'add_to_cart'.tr,
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 20,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white70.withValues(alpha: 0.6),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.grey[Get.find<ThemeController>()
                                            .darkTheme
                                        ? 700
                                        : 300]!,
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 7,
                        child: Center(
                          child: Text(
                            'no_variation_is_available'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _qadhaPointerInterceptor() {
    return PointerInterceptor(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GetBuilder<CartController>(
          builder: (cartControllerInit) {
            return GetBuilder<ServiceController>(
              builder: (serviceController) {
                if (widget.service!.variationsAppFormat!.zoneWiseVariations ==
                    null) {
                  return _QadhaNoVariationSheet();
                }

                return DraggableScrollableSheet(
                  initialChildSize: 0.78,
                  minChildSize: 0.55,
                  maxChildSize: 0.92,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(34),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x2A061B3F),
                            blurRadius: 28,
                            offset: Offset(0, -10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 7,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9DEEA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: QadhaCircleIcon(
                                icon: Icons.close_rounded,
                                size: 56,
                                onTap: () => Get.back(),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CustomImage(
                                image: widget.service!.thumbnailFullPath ?? '',
                                height: 156,
                                width: 156,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              widget.service!.name ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: robotoBold.copyWith(
                                color: QadhaPalette.deepNavy,
                                fontSize: 26,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} الخدمة المطلوبة',
                              style: robotoRegular.copyWith(
                                color: QadhaPalette.textMuted,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 26),
                            ...List.generate(
                              cartControllerInit.initialCartList.length,
                              (index) => _QadhaVariationRow(index: index),
                            ),
                            const SizedBox(height: 20),
                            _QadhaDialogTotalCard(
                              total: _currentTotal(cartControllerInit),
                            ),
                            const SizedBox(height: 22),
                            GetBuilder<CartController>(
                              builder: (cartController) {
                                bool addToCart = true;
                                return QadhaGradientButton(
                                  text:
                                      (cartController.cartList.isNotEmpty &&
                                          cartController.cartList
                                                  .elementAt(0)
                                                  .serviceId ==
                                              widget.service!.id)
                                      ? 'تحديث الطلب'
                                      : 'إضافة الطلب',
                                  icon: Icons.shopping_cart_outlined,
                                  loading: cartController.isLoading,
                                  onTap: cartControllerInit.isButton
                                      ? () async {
                                          if (addToCart) {
                                            addToCart = false;
                                            await cartController
                                                .addMultipleCartToServer(
                                                  providerId:
                                                      cartController
                                                          .selectedProvider
                                                          ?.id ??
                                                      widget.providerData?.id ??
                                                      '',
                                                );
                                            await cartController
                                                .getCartListFromServer(
                                                  shouldUpdate: true,
                                                );
                                            if (mounted) {
                                              Get.back();
                                            }
                                          }
                                        }
                                      : null,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 58,
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  if (widget.cart != null) {
                                    await Get.find<CartController>()
                                        .removeCartFromServer(widget.cart!);
                                  }
                                  Get.back();
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFFF4D62),
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFFFF4D62),
                                ),
                                label: Text(
                                  'حذف الطلب',
                                  style: robotoBold.copyWith(
                                    color: const Color(0xFFFF4D62),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  double _currentTotal(CartController cartController) {
    double total = 0;
    for (final item in cartController.initialCartList) {
      final price = double.tryParse('${item.price}') ?? 0;
      total += price * item.quantity;
    }
    return total;
  }
}

class _QadhaVariationRow extends StatelessWidget {
  final int index;

  const _QadhaVariationRow({required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        final item = cartController.initialCartList[index];
        final price = double.tryParse('${item.price}') ?? 0;
        return QadhaGlassCard(
          margin: const EdgeInsets.only(bottom: 14),
          radius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              _QuantityCircle(
                icon: Icons.remove_rounded,
                enabled: item.quantity > 0,
                onTap: () => cartController.updateQuantity(index, false),
              ),
              const SizedBox(width: 12),
              Text(
                item.quantity.toString(),
                style: robotoBold.copyWith(
                  color: QadhaPalette.deepNavy,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 12),
              _QuantityCircle(
                icon: Icons.add_rounded,
                onTap: () => cartController.updateQuantity(index, true),
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 42, color: QadhaPalette.line),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.variantKey.replaceAll('-', ' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: robotoMedium.copyWith(
                        color: QadhaPalette.deepNavy,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.convertPrice(
                          price,
                          isShowLongPrice: true,
                        ),
                        style: robotoBold.copyWith(
                          color: QadhaPalette.blue,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuantityCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QuantityCircle({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 46,
        width: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: enabled ? QadhaPalette.primaryGradient : null,
          color: enabled ? null : const Color(0xFFE8EEF7),
          shape: BoxShape.circle,
          boxShadow: enabled
              ? const [
                  BoxShadow(
                    color: Color(0x3025BFCB),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _QadhaDialogTotalCard extends StatelessWidget {
  final double total;

  const _QadhaDialogTotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return QadhaGlassCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: QadhaPalette.mint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: QadhaPalette.cyan,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'الإجمالي',
            style: robotoBold.copyWith(
              color: QadhaPalette.deepNavy,
              fontSize: 19,
            ),
          ),
          const Spacer(),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              PriceConverter.convertPrice(total, isShowLongPrice: true),
              style: robotoBold.copyWith(
                color: QadhaPalette.blue,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QadhaNoVariationSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QadhaCircleIcon(icon: Icons.close_rounded, onTap: () => Get.back()),
            const SizedBox(height: 24),
            Text(
              'no_variation_is_available'.tr,
              style: robotoBold.copyWith(
                color: QadhaPalette.deepNavy,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
