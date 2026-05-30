import 'package:seohost/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';

class CheckoutHeaderWidget extends StatelessWidget {
  final String pageState;
  const CheckoutHeaderWidget({super.key, required this.pageState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 426,
      child: GetBuilder<CheckOutController>(
        builder: (controller) {
          final orderActive =
              controller.currentPageState == PageState.orderDetails &&
              PageState.orderDetails.name == pageState;
          final paymentActive =
              controller.currentPageState == PageState.payment ||
              PageState.payment.name == pageState;
          final completeActive =
              controller.currentPageState == PageState.complete ||
              pageState == 'complete';

          return QadhaGlassCard(
            radius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(
              children: [
                _CheckoutStep(
                  title: 'booking_details'.tr,
                  icon: Icons.description_rounded,
                  active: orderActive,
                  done: paymentActive || completeActive,
                ),
                _CheckoutLine(done: completeActive),
                _CheckoutStep(
                  title: 'payment'.tr,
                  icon: Icons.credit_card_rounded,
                  active: paymentActive,
                  done: completeActive,
                ),
                _CheckoutLine(done: paymentActive || completeActive),
                _CheckoutStep(
                  title: 'complete'.tr,
                  icon: Icons.check_rounded,
                  active: completeActive,
                  done: completeActive,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CheckoutStep extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool active;
  final bool done;

  const _CheckoutStep({
    required this.title,
    required this.icon,
    required this.active,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? QadhaPalette.green
        : active
        ? QadhaPalette.blue
        : const Color(0xFF9AA7BC);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 58,
            width: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: done || active ? .15 : .08),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: .35)),
            ),
            child: Icon(
              done ? Icons.check_rounded : icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(color: color, fontSize: 13, height: 1),
          ),
        ],
      ),
    );
  }
}

class _CheckoutLine extends StatelessWidget {
  final bool done;

  const _CheckoutLine({required this.done});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          color: done ? QadhaPalette.green : const Color(0xFFE4ECF7),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
