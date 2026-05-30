import 'package:seohost/utils/core_export.dart';
import 'package:seohost/feature/auth/widgets/social_login_button.dart';
import 'package:get/get.dart';

class SocialLoginWidget extends StatelessWidget {
  final String? fromPage;
  const SocialLoginWidget({super.key, this.fromPage});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var config =
        Get.find<SplashController>().configModel.content?.customerLogin;

    List<SocialLoginType> socialLoginOption = [
      if (config?.socialMediaLoginOptions?.google == 1) SocialLoginType.google,
      if (config?.socialMediaLoginOptions?.facebook == 1)
        SocialLoginType.facebook,
      if (config?.socialMediaLoginOptions?.apple == 1 &&
          !GetPlatform.isAndroid &&
          !GetPlatform.isWeb)
        SocialLoginType.apple,
    ];

    bool isOnlySocialLogin =
        config?.loginOption?.manualLogin == 0 &&
        config?.loginOption?.otpLogin == 0;

    return isOnlySocialLogin
        ? Column(
            children: [
              Text(
                "${'welcome_to'.tr} ${AppConstants.appName}!",
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: size.height * 0.04),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.isMobile(context) ? 20 : 30,
                ),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return SocialLoginButton(
                      title:
                          "Continue with ${_englishName(socialLoginOption[index])}",
                      socialLoginType: socialLoginOption[index],
                      fromPage: fromPage,
                      showPadding: false,
                    );
                  },
                  itemCount: socialLoginOption.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: Dimensions.paddingSizeDefault,
                    );
                  },
                ),
              ),

              SizedBox(height: size.height * 0.05),
            ],
          )
        : Column(
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: socialLoginOption.map((element) {
                  return socialLoginOption.length <= 2
                      ? Expanded(
                          child: SocialLoginButton(
                            title: socialLoginOption.length >= 2
                                ? _englishName(element)
                                : "Continue with ${_englishName(element)}",
                            socialLoginType: element,
                            fromPage: fromPage,
                            showPadding:
                                (socialLoginOption.length - 1) !=
                                socialLoginOption.indexOf(element),
                          ),
                        )
                      : SocialLoginButton(
                          title: socialLoginOption.length >= 2
                              ? _englishName(element)
                              : "Continue with ${_englishName(element)}",
                          socialLoginType: element,
                          fromPage: fromPage,
                          showPadding:
                              (socialLoginOption.length - 1) !=
                              socialLoginOption.indexOf(element),
                        );
                }).toList(),
              ),
            ],
          );
  }

  String _englishName(SocialLoginType type) {
    if (type == SocialLoginType.google) {
      return 'Google';
    }
    if (type == SocialLoginType.facebook) {
      return 'Facebook';
    }
    return 'Apple';
  }
}
