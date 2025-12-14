import 'package:seohost/api/remote/client_api.dart';
import 'package:seohost/utils/app_constants.dart';
import 'package:get/get.dart';

class LoyaltyPointRepo{
  final ApiClient apiClient;
  LoyaltyPointRepo({required this.apiClient});

  Future<Response> convertLoyaltyPoint(String point) async {
    return await apiClient.postData(AppConstants.convertLoyaltyPointUri,{"point":point});
  }

  Future<Response> getLoyaltyPointData(int offset) async {
    return await apiClient.getData("${AppConstants.loyaltyPointTransactionData}?limit=10&offset=$offset");
  }
}