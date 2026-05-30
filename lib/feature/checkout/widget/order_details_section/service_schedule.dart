import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/feature/create_post/widget/custom_date_time_picker.dart';
import 'package:seohost/utils/core_export.dart';

class ServiceSchedule extends StatefulWidget {
  const ServiceSchedule({super.key});

  @override
  State<ServiceSchedule> createState() => _ServiceScheduleState();
}

class _ServiceScheduleState extends State<ServiceSchedule> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return GetBuilder<ScheduleController>(
          builder: (scheduleController) {
            final scheduleText =
                scheduleController.selectedScheduleType ==
                        ScheduleType.schedule &&
                    scheduleController.scheduleTime != null
                ? DateConverter.dateMonthYearTimeTwentyFourFormat(
                    DateConverter.dateTimeStringToDate(
                      scheduleController.scheduleTime!,
                    ),
                  )
                : 'اضغط هنا لتحديد الوقت';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الوقت المطلوب للخدمة',
                        textAlign: TextAlign.center,
                        style: robotoBold.copyWith(
                          fontSize: 22,
                          color: QadhaPalette.deepNavy,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.access_time_rounded,
                        color: QadhaPalette.green,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      final errorText = cartController
                          .checkScheduleBookingAvailability();
                      if (errorText != null) {
                        customSnackBar(errorText.tr);
                        return;
                      }
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomDateTimePicker();
                        },
                      );
                    },
                    child: Container(
                      height: 116,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFFFF8).withValues(alpha: .66),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: QadhaPalette.green.withValues(alpha: .16),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x101A4384),
                            blurRadius: 18,
                            offset: Offset(0, 9),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              scheduleText,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: robotoBold.copyWith(
                                color: QadhaPalette.deepNavy,
                                fontSize: 19,
                                height: 1.25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const _ScheduleCalendarArt(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],
            );
          },
        );
      },
    );
  }
}

class _ScheduleCalendarArt extends StatelessWidget {
  const _ScheduleCalendarArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: 102,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 4,
            top: 6,
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: QadhaPalette.green.withValues(alpha: .55),
                  width: 5,
                ),
              ),
              child: const Icon(
                Icons.access_time_rounded,
                color: QadhaPalette.green,
                size: 31,
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 7,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                gradient: QadhaPalette.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2419C8CF),
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
