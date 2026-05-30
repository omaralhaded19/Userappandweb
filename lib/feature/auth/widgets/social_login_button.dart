import 'package:seohost/feature/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:seohost/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginButton extends StatelessWidget {
  final String? title;
  final String? fromPage;
  final SocialLoginType socialLoginType;
  final bool showPadding;
  const SocialLoginButton({
    super.key,
    this.title,
    required this.socialLoginType,
    required this.fromPage,
    required this.showPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: showPadding && Get.find<LocalizationController>().isLtr
            ? Dimensions.paddingSizeDefault
            : 2,
        left: showPadding && !Get.find<LocalizationController>().isLtr
            ? Dimensions.paddingSizeDefault
            : 2,
      ),
      child: InkWell(
        onTap: () =>
            _onTap(socialLoginType: socialLoginType, fromPage: fromPage),
        child: TextHover(
          builder: (hovered) {
            return Container(
              height: title != null ? 52 : 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: hovered ? .88 : .98),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: const Color(0xFFE2E9F3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF385071).withValues(alpha: .1),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: title?.trim() == ""
                          ? Dimensions.paddingSizeDefault
                          : Dimensions.paddingSizeEight,
                    ),
                    child: Image.asset(
                      socialLoginType == SocialLoginType.google
                          ? Images.google
                          : socialLoginType == SocialLoginType.facebook
                          ? Images.facebook
                          : Images.apple,
                      height: ResponsiveHelper.isDesktop(context)
                          ? 25
                          : ResponsiveHelper.isTab(context)
                          ? 25
                          : 20,
                      width: ResponsiveHelper.isDesktop(context)
                          ? 25
                          : ResponsiveHelper.isTab(context)
                          ? 25
                          : 20,
                    ),
                  ),
                  title != null && title!.trim() != ""
                      ? Flexible(
                          child: Text(
                            title!.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: const Color(0xFF1E315C),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void route(
    bool isRoute,
    String? token,
    String errorMessage,
    String? tempToken,
    UserInfoModel? userInfoModel,
    String? socialLoginMedium,
    String? userName,
    String? email,
  ) async {
    if (isRoute) {
      if (token != null) {
        if (Get.find<LocationController>().getUserAddress() != null) {
          Get.offAllNamed(RouteHelper.getMainRoute("home"));
        } else {
          Get.offAllNamed(RouteHelper.pickMap);
        }
      } else if (tempToken != null) {
        Get.toNamed(
          RouteHelper.getUpdateProfileRoute(
            email: email ?? "",
            tempToken: tempToken,
            userName: userName ?? "",
          ),
        );
      } else if (userInfoModel != null) {
        showModalBottomSheet(
          context: Get.context!,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) => ExistingAccountBottomSheet(
            userInfoModel: userInfoModel,
            socialLoginMedium: socialLoginMedium!,
          ),
          backgroundColor: Colors.transparent,
        );
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _onTap({
    required SocialLoginType socialLoginType,
    String? fromPage,
  }) async {
    if (socialLoginType == SocialLoginType.google) {
      final bool isSignedIn = await Get.find<AuthController>().socialLogin();
      if (!isSignedIn) {
        return;
      }
      String? id = '', token = '', email = '', medium = '', userName = '';
      if (Get.find<AuthController>().googleAccount != null) {
        id = Get.find<AuthController>().googleAccount?.id;
        email = Get.find<AuthController>().googleAccount?.email;
        userName = Get.find<AuthController>().googleAccount?.displayName;
        token =
            Get.find<AuthController>().auth?.idToken ??
            Get.find<AuthController>().auth?.accessToken;
        medium = 'google';

        if (token == null || token.isEmpty) {
          customSnackBar('Google sign-in token is missing');
          return;
        }

        Get.find<AuthController>().loginWithSocialMedia(
          SocialLogInBody(
            email: email,
            userName: userName,
            token: token,
            uniqueId: id,
            medium: medium,
            guestId: Get.find<SplashController>().getGuestId(),
          ),
          route,
          fromPage: fromPage,
        );
      }
    } else if (socialLoginType == SocialLoginType.facebook) {
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        Map userData = await FacebookAuth.instance.getUserData();
        Get.find<AuthController>().loginWithSocialMedia(
          SocialLogInBody(
            email: userData['email'],
            userName: userData['name'],
            token: result.accessToken!.token,
            uniqueId: result.accessToken!.userId,
            medium: 'facebook',
            guestId: Get.find<SplashController>().getGuestId(),
          ),
          route,
          fromPage: fromPage,
        );
      }
    } else if (socialLoginType == SocialLoginType.apple) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      Get.find<AuthController>().loginWithSocialMedia(
        SocialLogInBody(
          email: credential.email,
          token: credential.authorizationCode,
          uniqueId: credential.authorizationCode,
          medium: "apple",
          guestId: Get.find<SplashController>().getGuestId(),
          userName: credential.givenName ?? credential.familyName,
        ),
        route,
        fromPage: fromPage,
      );
    }
  }
}
