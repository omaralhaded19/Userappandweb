import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/utils/core_export.dart';

class CustomerBookingNote extends StatefulWidget {
  const CustomerBookingNote({super.key});

  @override
  State<CustomerBookingNote> createState() => _CustomerBookingNoteState();
}

class _CustomerBookingNoteState extends State<CustomerBookingNote> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CheckOutController>().bookingNoteController;
    _controller.addListener(_refreshCounter);
  }

  @override
  void dispose() {
    _controller.removeListener(_refreshCounter);
    super.dispose();
  }

  void _refreshCounter() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = _controller.text.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 18),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: _NoteLine(alignEnd: true)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    gradient: QadhaPalette.primaryGradient,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x241D65E8),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_note_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'ملاحظة العميل',
                        style: robotoBold.copyWith(
                          color: Colors.white,
                          fontSize: 23,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: _NoteLine()),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                gradient: QadhaPalette.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x111A4384),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                height: 248,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: _controller,
                      maxLength: 500,
                      maxLines: null,
                      expands: true,
                      textAlign: TextAlign.right,
                      textAlignVertical: TextAlignVertical.top,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: robotoMedium.copyWith(
                        color: QadhaPalette.deepNavy,
                        fontSize: 17,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'ملاحظات العميل ان وجدت',
                        hintStyle: robotoBold.copyWith(
                          color: QadhaPalette.textMuted.withValues(alpha: .7),
                          fontSize: 19,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(
                          24,
                          32,
                          24,
                          52,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    Positioned(
                      left: 22,
                      bottom: 22,
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: QadhaPalette.blue.withValues(alpha: .08),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: QadhaPalette.blue,
                          size: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 26,
                      bottom: 24,
                      child: Text(
                        '$count/500',
                        style: robotoMedium.copyWith(
                          color: QadhaPalette.textMuted.withValues(alpha: .75),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: CustomPaint(
                        size: const Size(52, 52),
                        painter: _DottedCornerPainter(),
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
}

class _NoteLine extends StatelessWidget {
  final bool alignEnd;

  const _NoteLine({this.alignEnd = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: alignEnd ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  QadhaPalette.blue.withValues(alpha: .05),
                  QadhaPalette.blue.withValues(alpha: .55),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 8,
          width: 8,
          decoration: const BoxDecoration(
            color: QadhaPalette.blue,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _DottedCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = QadhaPalette.cyan.withValues(alpha: .52);
    const spacing = 9.0;
    const radius = 2.4;

    for (int row = 0; row < 6; row++) {
      for (int col = 0; col <= row; col++) {
        canvas.drawCircle(
          Offset(size.width - (col * spacing), size.height - (row * spacing)),
          radius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
