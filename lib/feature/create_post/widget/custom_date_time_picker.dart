import 'package:seohost/utils/core_export.dart';
import 'package:seohost/feature/create_post/widget/custom_date_picker.dart';
import 'package:seohost/feature/create_post/widget/custom_time_picker.dart';
import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateTimePicker extends StatelessWidget {
  const CustomDateTimePicker({super.key});

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
    Get.find<ScheduleController>().setInitialScheduleValue();
    ConfigModel configModel = Get.find<SplashController>().configModel;
    var dateRangePickerController = DateRangePickerController();

    return Container(
      width: ResponsiveHelper.isDesktop(Get.context!)
          ? Dimensions.webMaxWidth / 2
          : Dimensions.webMaxWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: GetBuilder<ScheduleController>(
        builder: (scheduleController) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7DCE8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 4,
                  width: 80,
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                  decoration: BoxDecoration(
                    gradient: QadhaPalette.headerGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x302660D8),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .3),
                          ),
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'اختر تاريخ ووقت الخدمة',
                        textAlign: TextAlign.center,
                        style: robotoBold.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'حدد الموعد الأنسب لك',
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                          color: Colors.white.withValues(alpha: .8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                QadhaGlassCard(
                  radius: 24,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomDatePicker(
                    dateRangePickerController: dateRangePickerController,
                  ),
                ),
                const SizedBox(height: 12),

                QadhaGlassCard(
                  radius: 24,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isDesktop(Get.context!)
                        ? Dimensions.paddingSizeLarge * 2
                        : 0,
                  ),
                  child: const CustomTimePicker(),
                ),

                if (configModel.content?.instantBooking == 1)
                  Padding(
                    padding: EdgeInsets.only(
                      top: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            scheduleController.updateScheduleType(
                              scheduleType: ScheduleType.asap,
                            );
                            dateRangePickerController.selectedDate = null;
                          },
                          child: QadhaGlassCard(
                            radius: 18,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            border: Border.all(
                              color: QadhaPalette.green.withValues(alpha: .4),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flash_on_rounded,
                                  color: QadhaPalette.green,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'ASAP',
                                  style: robotoBold.copyWith(
                                    color: QadhaPalette.green,
                                    fontSize: 20,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'أقرب وقت متاح',
                                  style: robotoMedium.copyWith(
                                    color: QadhaPalette.deepNavy,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isDesktop(Get.context!)
                        ? Dimensions.paddingSizeLarge * 3
                        : 0,
                  ),
                  child: actionButtonWidget(Get.context!, scheduleController),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Row actionButtonWidget(
    BuildContext context,
    ScheduleController scheduleController,
  ) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: QadhaPalette.textMuted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: QadhaPalette.line),
                ),
              ),
              child: Text(
                'cancel'.tr,
                style: robotoBold.copyWith(
                  color: QadhaPalette.textMuted,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),
        Expanded(
          child: QadhaGradientButton(
            text: 'نعم',
            icon: Icons.check_rounded,
            onTap: () {
              ConfigModel config = Get.find<SplashController>().configModel;

              if (scheduleController.initialSelectedScheduleType == null) {
                customSnackBar(
                  'select_your_preferable_booking_time'.tr,
                  showDefaultSnackBar: false,
                );
              } else if (config.content!.advanceBooking != null &&
                  config.content?.scheduleBookingTimeRestriction == 1 &&
                  scheduleController.initialSelectedScheduleType !=
                      ScheduleType.asap) {
                if (scheduleController.checkValidityOfTimeRestriction(
                      config.content!.advanceBooking!,
                    ) !=
                    null) {
                  customSnackBar(
                    scheduleController.checkValidityOfTimeRestriction(
                      config.content!.advanceBooking!,
                    ),
                    showDefaultSnackBar: false,
                  );
                } else {
                  scheduleController.buildSchedule(
                    scheduleType: ScheduleType.schedule,
                  );
                  Get.back();
                }
              } else {
                scheduleController.buildSchedule(
                  scheduleType: scheduleController.selectedScheduleType,
                );
                Get.back();
              }
            },
          ),
        ),
      ],
    );
  }
}
