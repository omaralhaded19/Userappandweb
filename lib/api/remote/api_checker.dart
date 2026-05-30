import 'dart:convert';
import 'package:seohost/utils/core_export.dart';
import 'package:get/get.dart';


class ApiChecker {
  static void checkApi(Response response, {bool showDefaultToaster = true}) {
    final int status = response.statusCode ?? 0;
    final dynamic body = response.body;
    final Map<String, dynamic>? bodyMap = _asMap(body);

    // Special case: some providers (e.g. Cloudflare/nginx) return HTML instead of JSON.
    if (bodyMap == null && body is String) {
      final String t = body;
      if (t.contains('Checking your browser') || t.contains('cf-browser-verification')) {
        customSnackBar(
          'تم حظر الطلب بواسطة حماية المتصفح (Cloudflare/WAF). لازم استثناء مسارات API من التحدي.',
          showDefaultSnackBar: showDefaultToaster,
        );
        return;
      }
      if (t.contains('405 Not Allowed')) {
        customSnackBar(
          '405 Method Not Allowed: تأكد من رابط الـ API والـ HTTP Method (GET/POST) لهذا الـ endpoint.',
          showDefaultSnackBar: showDefaultToaster,
        );
        return;
      }
    }

    if (status == 401) {
      Get.find<AuthController>().clearSharedData(response: response);
      if (Get.currentRoute != RouteHelper.getInitialRoute()) {
        Get.offAllNamed(RouteHelper.getInitialRoute());
        customSnackBar("$status".tr, showDefaultSnackBar: showDefaultToaster);
      }
      return;
    }

    if (status == 500) {
      customSnackBar("$status".tr, showDefaultSnackBar: showDefaultToaster);
      return;
    }

    if (status == 429) {
      customSnackBar("too_many_request".tr, showDefaultSnackBar: showDefaultToaster);
      return;
    }

    // Prefer structured error from JSON when available.
    if (status == 400) {
      final errors = bodyMap?['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map && first['message'] != null) {
          customSnackBar(
            first['message'].toString(),
            showDefaultSnackBar: showDefaultToaster,
          );
          return;
        }
      }
    }

    final msg = bodyMap?['message']?.toString()
        ?? (body is String ? body.toString() : null)
        ?? "حدث خطأ غير متوقع";
    customSnackBar(msg, showDefaultSnackBar: showDefaultToaster);
  }

  static Map<String, dynamic>? _asMap(dynamic body) {
    if (body == null) return null;

    if (body is Map<String, dynamic>) return body;

    if (body is Map) {
      return body.map((k, v) => MapEntry(k.toString(), v));
    }

    if (body is String) {
      final s = body.trim();
      // If it looks like JSON, try decode.
      if (s.startsWith('{') || s.startsWith('[')) {
        try {
          final decoded = jsonDecode(s);
          if (decoded is Map) {
            return decoded.map((k, v) => MapEntry(k.toString(), v));
          }
        } catch (_) {
          return null;
        }
      }
    }

    return null;
  }
}