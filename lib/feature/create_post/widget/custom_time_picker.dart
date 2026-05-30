import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/common/widgets/time_picker_snipper.dart';
import 'package:seohost/utils/core_export.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'الوقت المطلوب للخدمة',
                textAlign: TextAlign.center,
                style: robotoBold.copyWith(
                  fontSize: 20,
                  color: QadhaPalette.deepNavy,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.access_time_rounded,
                color: QadhaPalette.green,
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: GetBuilder<ScheduleController>(
                builder: (scheduleController) {
                  return TimePickerSpinner(
                    is24HourMode:
                        Get.find<SplashController>()
                            .configModel
                            .content
                            ?.timeFormat ==
                        '24',
                    normalTextStyle: robotoRegular.copyWith(
                      color: QadhaPalette.textMuted,
                      fontSize: 18,
                    ),
                    highlightedTextStyle: robotoBold.copyWith(
                      fontSize: 26,
                      color: QadhaPalette.green,
                      height: 1,
                    ),
                    spacing: 22,
                    itemHeight: 38,
                    itemWidth: 58,
                    alignment: Alignment.center,
                    isForce2Digits: true,
                    onTimeChange: (time) {
                      scheduleController.selectedTime =
                          "${time.hour}:${time.minute}:${time.second}";
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
