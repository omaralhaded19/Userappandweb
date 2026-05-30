import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/feature/auth/widgets/social_login_button.dart';
import 'package:seohost/utils/core_export.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final String? fromPage;
  const SignInScreen({super.key, required this.exitFromApp, this.fromPage});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var signInPhoneController = TextEditingController();
  var signInPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _canExit = GetPlatform.isWeb ? true : false;
  bool _obscurePassword = true;
  final GlobalKey<FormState> customerSignInKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initializeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveHelper.isDesktop(context)) {
      return _buildMobileSignIn(context);
    }

    return CustomPopScopeWidget(
      onPopInvoked: () => _existFromApp(),
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const WebMenuBar()
            : !widget.exitFromApp
            ? AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  hoverColor: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  onPressed: () => Navigator.pop(context),
                ),
              )
            : null,

        endDrawer: ResponsiveHelper.isDesktop(context)
            ? const MenuDrawer()
            : null,

        body: SafeArea(
          child: FooterBaseView(
            isCenter: true,
            child: WebShadowWrap(
              child: Center(
                child: GetBuilder<SplashController>(
                  builder: (splashController) {
                    return GetBuilder<AuthController>(
                      builder: (authController) {
                        var config = splashController.configModel.content;
                        var otpLogin =
                            config?.customerLogin?.loginOption?.otpLogin;
                        var manualLogin =
                            config?.customerLogin?.loginOption?.manualLogin ??
                            1;
                        var socialLogin = config
                            ?.customerLogin
                            ?.loginOption
                            ?.socialMediaLogin;

                        return Form(
                          autovalidateMode: ResponsiveHelper.isDesktop(context)
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          key: customerSignInKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.webMaxWidth / 3.5
                                  : ResponsiveHelper.isTab(context)
                                  ? Dimensions.webMaxWidth / 5.5
                                  : Dimensions.paddingSizeLarge,
                            ),
                            child: Column(
                              children: [
                                Hero(
                                  tag: Images.logo,
                                  child: Image.asset(
                                    Images.logo,
                                    width: Dimensions.logoSize,
                                  ),
                                ),
                                SizedBox(
                                  height: manualLogin == 1 || otpLogin == 1
                                      ? Dimensions.paddingSizeExtraMoreLarge
                                      : Dimensions.paddingSizeDefault,
                                ),

                                manualLogin == 1 || otpLogin == 1
                                    ? CustomTextField(
                                        onCountryChanged: (countryCode) =>
                                            authController.countryDialCode =
                                                countryCode.dialCode!,
                                        countryDialCode:
                                            authController.isNumberLogin ||
                                                (manualLogin == 0 &&
                                                    otpLogin == 1)
                                            ? authController.countryDialCode
                                            : null,
                                        title: 'email_phone'.tr,
                                        hintText:
                                            authController
                                                        .selectedLoginMedium ==
                                                    LoginMedium.otp ||
                                                (manualLogin == 0 &&
                                                    otpLogin == 1)
                                            ? "please_enter_phone_number".tr
                                            : 'enter_email_or_phone'.tr,
                                        controller: signInPhoneController,
                                        focusNode: _phoneFocus,
                                        nextFocus: _passwordFocus,
                                        capitalization:
                                            TextCapitalization.words,
                                        onChanged: (String text) {
                                          if (authController
                                                  .selectedLoginMedium !=
                                              LoginMedium.otp) {
                                            final numberRegExp = RegExp(
                                              r'^[+]?[0-9]+$',
                                            );

                                            if (text.isEmpty &&
                                                authController.isNumberLogin) {
                                              authController
                                                  .toggleIsNumberLogin();
                                            }
                                            if (text.startsWith(numberRegExp) &&
                                                !authController.isNumberLogin &&
                                                manualLogin == 1) {
                                              authController
                                                  .toggleIsNumberLogin();
                                              final cursorPosition =
                                                  signInPhoneController
                                                      .selection
                                                      .baseOffset;
                                              signInPhoneController.text = text
                                                  .replaceAll("+", "");
                                              signInPhoneController.selection =
                                                  TextSelection.fromPosition(
                                                    TextPosition(
                                                      offset: cursorPosition,
                                                    ),
                                                  );
                                            }
                                            final emailRegExp = RegExp(r'@');
                                            if (text.contains(emailRegExp) &&
                                                authController.isNumberLogin &&
                                                manualLogin == 1) {
                                              authController
                                                  .toggleIsNumberLogin();
                                            }

                                            _phoneFocus.requestFocus();
                                          }
                                        },
                                        onValidate: (String? value) {
                                          if (otpLogin == 1 &&
                                              manualLogin == 0 &&
                                              PhoneVerificationHelper.getValidPhoneNumber(
                                                    authController
                                                            .countryDialCode +
                                                        signInPhoneController
                                                            .text
                                                            .trim(),
                                                    withCountryCode: true,
                                                  ) ==
                                                  "") {
                                            return "enter_valid_phone_number"
                                                .tr;
                                          }
                                          if (authController.isNumberLogin &&
                                              PhoneVerificationHelper.getValidPhoneNumber(
                                                    authController
                                                            .countryDialCode +
                                                        signInPhoneController
                                                            .text
                                                            .trim(),
                                                    withCountryCode: true,
                                                  ) ==
                                                  "") {
                                            return "enter_valid_phone_number"
                                                .tr;
                                          }
                                          return (PhoneVerificationHelper.getValidPhoneNumber(
                                                        authController
                                                                .countryDialCode +
                                                            signInPhoneController
                                                                .text
                                                                .trim(),
                                                        withCountryCode: true,
                                                      ) !=
                                                      "" ||
                                                  GetUtils.isEmail(value ?? ""))
                                              ? null
                                              : 'enter_email_or_phone'.tr;
                                        },
                                      )
                                    : const SizedBox.shrink(),

                                SizedBox(
                                  height:
                                      manualLogin == 1 &&
                                          authController.selectedLoginMedium ==
                                              LoginMedium.manual
                                      ? Dimensions.paddingSizeTextFieldGap
                                      : 0,
                                ),

                                manualLogin == 1 &&
                                        authController.selectedLoginMedium ==
                                            LoginMedium.manual
                                    ? CustomTextField(
                                        title: 'password'.tr,
                                        hintText: '************'.tr,
                                        controller: signInPasswordController,
                                        focusNode: _passwordFocus,
                                        inputType:
                                            TextInputType.visiblePassword,
                                        isPassword: true,
                                        inputAction: TextInputAction.done,
                                        onValidate: (String? value) {
                                          return FormValidation()
                                              .isValidPassword(value!.tr);
                                        },
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(
                                  height:
                                      authController.selectedLoginMedium ==
                                          LoginMedium.manual
                                      ? Dimensions.paddingSizeDefault
                                      : 0,
                                ),

                                manualLogin == 1 || otpLogin == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () => authController
                                                .toggleRememberMe(),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 20.0,
                                                  child: Checkbox(
                                                    activeColor: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    value: authController
                                                        .isActiveRememberMe,
                                                    onChanged:
                                                        (
                                                          bool? isChecked,
                                                        ) => authController
                                                            .toggleRememberMe(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall,
                                                ),
                                                Text(
                                                  'remember_me'.tr,
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          manualLogin == 1 &&
                                                  authController
                                                          .selectedLoginMedium ==
                                                      LoginMedium.manual
                                              ? TextButton(
                                                  onPressed: () => Get.toNamed(
                                                    RouteHelper.getSendOtpScreen(),
                                                  ),
                                                  child: Text(
                                                    'forgot_password'.tr,
                                                    style: robotoRegular
                                                        .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                        ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      )
                                    : const SizedBox.shrink(),

                                SizedBox(
                                  height: manualLogin == 1 || otpLogin == 1
                                      ? Dimensions.paddingSizeLarge
                                      : 0,
                                ),

                                manualLogin == 1 || otpLogin == 1
                                    ? CustomButton(
                                        buttonText:
                                            (authController
                                                        .selectedLoginMedium ==
                                                    LoginMedium.otp) ||
                                                (manualLogin == 0 &&
                                                    otpLogin == 1)
                                            ? "get_otp".tr
                                            : 'sign_in'.tr,
                                        onPressed: () {
                                          if (customerSignInKey.currentState!
                                              .validate()) {
                                            _login(
                                              authController,
                                              manualLogin,
                                              otpLogin,
                                            );
                                          }
                                        },
                                        isLoading: authController.isLoading,
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(
                                  height: manualLogin == 1 || otpLogin == 1
                                      ? Dimensions.paddingSizeDefault
                                      : 0,
                                ),

                                (manualLogin == 1 || otpLogin == 1) &&
                                        socialLogin == 1
                                    ? Center(
                                        child: Text(
                                          'or'.tr,
                                          style: robotoRegular.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                                .withValues(alpha: 0.6),
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),

                                manualLogin == 1 &&
                                        (otpLogin == 1 || socialLogin == 1)
                                    ? Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'sign_in_with'.tr,
                                              style: robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color!
                                                    .withValues(alpha: 0.6),
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                              ),
                                            ),
                                            otpLogin == 1 && manualLogin == 1
                                                ? TextButton(
                                                    onPressed: () {
                                                      String
                                                      phoneWithoutCountryCode =
                                                          PhoneVerificationHelper.getValidPhoneNumber(
                                                            Get.find<
                                                                  AuthController
                                                                >()
                                                                .getUserNumber(),
                                                          );
                                                      String countryCode =
                                                          PhoneVerificationHelper.getCountryCode(
                                                            Get.find<
                                                                  AuthController
                                                                >()
                                                                .getUserNumber(),
                                                          );

                                                      if (authController
                                                              .selectedLoginMedium ==
                                                          LoginMedium.otp) {
                                                        authController
                                                            .toggleSelectedLoginMedium(
                                                              loginMedium:
                                                                  LoginMedium
                                                                      .manual,
                                                            );
                                                        signInPhoneController
                                                                .text =
                                                            phoneWithoutCountryCode !=
                                                                ""
                                                            ? phoneWithoutCountryCode
                                                            : authController
                                                                  .getUserNumber();
                                                        if (countryCode != "") {
                                                          authController
                                                              .toggleIsNumberLogin(
                                                                value: true,
                                                              );
                                                        } else {
                                                          authController
                                                              .toggleIsNumberLogin(
                                                                value: false,
                                                              );
                                                        }
                                                        authController
                                                            .initCountryCode(
                                                              countryCode:
                                                                  countryCode !=
                                                                      ""
                                                                  ? countryCode
                                                                  : null,
                                                            );
                                                        signInPasswordController
                                                            .text = authController
                                                            .getUserPassword();

                                                        if (signInPasswordController
                                                            .text
                                                            .isEmpty) {
                                                          signInPhoneController
                                                                  .text =
                                                              "";
                                                          authController
                                                              .toggleIsNumberLogin(
                                                                value: false,
                                                              );
                                                        }
                                                      } else {
                                                        authController
                                                            .toggleSelectedLoginMedium(
                                                              loginMedium:
                                                                  LoginMedium
                                                                      .otp,
                                                            );
                                                        authController
                                                            .toggleIsNumberLogin(
                                                              value: true,
                                                            );
                                                        signInPasswordController
                                                            .clear();

                                                        signInPhoneController
                                                                .text =
                                                            phoneWithoutCountryCode;
                                                        authController
                                                            .initCountryCode(
                                                              countryCode:
                                                                  countryCode !=
                                                                      ""
                                                                  ? countryCode
                                                                  : null,
                                                            );
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      minimumSize: const Size(
                                                        30,
                                                        30,
                                                      ),
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                          ),
                                                      child: Text(
                                                        authController
                                                                    .selectedLoginMedium ==
                                                                LoginMedium
                                                                    .manual
                                                            ? 'OTP'.tr
                                                            : "email_phone".tr,
                                                        style: robotoRegular.copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),

                                socialLogin == 1
                                    ? SocialLoginWidget(
                                        fromPage: widget.fromPage,
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),

                                manualLogin == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${'do_not_have_an_account'.tr} ',
                                            style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge!.color,
                                            ),
                                          ),

                                          TextButton(
                                            onPressed: () {
                                              signInPhoneController.clear();
                                              signInPasswordController.clear();

                                              Get.toNamed(
                                                RouteHelper.getSignUpRoute(),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(50, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Text(
                                              'sign_up_here'.tr,
                                              style: robotoRegular.copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileSignIn(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: () => _existFromApp(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: const Color(0xFFB9F0EA),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: _QadhaSignInBackground(
              child: SafeArea(
                child: GetBuilder<SplashController>(
                  builder: (splashController) {
                    return GetBuilder<AuthController>(
                      builder: (authController) {
                        final config = splashController.configModel.content;
                        final otpLogin =
                            config?.customerLogin?.loginOption?.otpLogin;
                        final manualLogin =
                            config?.customerLogin?.loginOption?.manualLogin ??
                            1;
                        final socialLogin = config
                            ?.customerLogin
                            ?.loginOption
                            ?.socialMediaLogin;
                        final isOtpMode =
                            authController.selectedLoginMedium ==
                                LoginMedium.otp ||
                            (manualLogin == 0 && otpLogin == 1);
                        final showIdentity = manualLogin == 1 || otpLogin == 1;
                        final showPassword =
                            manualLogin == 1 &&
                            authController.selectedLoginMedium ==
                                LoginMedium.manual;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 18),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        18,
                                        8,
                                        18,
                                        0,
                                      ),
                                      child: SizedBox(
                                        height: 42,
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: !widget.exitFromApp
                                              ? _CircleIconButton(
                                                  icon: Icons
                                                      .arrow_forward_ios_rounded,
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: 156,
                                      height: 156,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: .94,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: .72,
                                          ),
                                          width: 8,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF0F5FD1,
                                            ).withValues(alpha: .26),
                                            blurRadius: 38,
                                            offset: const Offset(0, 18),
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withValues(
                                              alpha: .46,
                                            ),
                                            blurRadius: 18,
                                            offset: const Offset(0, -6),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: QadhaBrandMark(
                                          iconSize: 64,
                                          textSize: 34,
                                          showTagline: false,
                                          textColor: Color(0xFF2056C7),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 34),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        34,
                                        24,
                                        30,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: .95,
                                        ),
                                        borderRadius: BorderRadius.circular(42),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF113E7A,
                                            ).withValues(alpha: .18),
                                            blurRadius: 34,
                                            offset: const Offset(0, 18),
                                          ),
                                        ],
                                      ),
                                      child: Form(
                                        key: customerSignInKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'تسجيل الدخول',
                                              textAlign: TextAlign.center,
                                              style: robotoBold.copyWith(
                                                color: const Color(0xFF10295D),
                                                fontSize: 36,
                                                height: 1.1,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'مرحباً بكم في قدها للخدمات المنزلية',
                                              textAlign: TextAlign.center,
                                              style: robotoMedium.copyWith(
                                                color: const Color(0xFF8290AA),
                                                fontSize: 17,
                                                height: 1.45,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            const SizedBox(height: 28),
                                            if (showIdentity)
                                              _ModernAuthField(
                                                controller:
                                                    signInPhoneController,
                                                focusNode: _phoneFocus,
                                                nextFocus: showPassword
                                                    ? _passwordFocus
                                                    : null,
                                                hintText: isOtpMode
                                                    ? 'رقم الهاتف'
                                                    : 'البريد الإلكتروني / الهاتف',
                                                suffixIcon:
                                                    Icons.mail_outline_rounded,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction: showPassword
                                                    ? TextInputAction.next
                                                    : TextInputAction.done,
                                                onChanged: (text) =>
                                                    _handleIdentityChanged(
                                                      authController,
                                                      manualLogin,
                                                      text,
                                                    ),
                                                validator: (value) =>
                                                    _validateIdentity(
                                                      authController,
                                                      manualLogin,
                                                      otpLogin,
                                                      value,
                                                    ),
                                              ),
                                            if (showPassword) ...[
                                              const SizedBox(height: 16),
                                              _ModernAuthField(
                                                controller:
                                                    signInPasswordController,
                                                focusNode: _passwordFocus,
                                                hintText: 'كلمة المرور',
                                                prefixIcon: _obscurePassword
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                          .visibility_off_outlined,
                                                suffixIcon:
                                                    Icons.lock_outline_rounded,
                                                obscureText: _obscurePassword,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onPrefixTap: () => setState(
                                                  () => _obscurePassword =
                                                      !_obscurePassword,
                                                ),
                                                validator: (value) =>
                                                    FormValidation()
                                                        .isValidPassword(
                                                          (value ?? '').tr,
                                                        ),
                                              ),
                                            ],
                                            if (showIdentity) ...[
                                              const SizedBox(height: 18),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: showPassword
                                                        ? Align(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .centerStart,
                                                            child: TextButton(
                                                              onPressed: () =>
                                                                  Get.toNamed(
                                                                    RouteHelper.getSendOtpScreen(),
                                                                  ),
                                                              style: TextButton.styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                minimumSize:
                                                                    const Size(
                                                                      10,
                                                                      32,
                                                                    ),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                              ),
                                                              child: Text(
                                                                'هل نسيت كلمة السر؟',
                                                                style: robotoMedium.copyWith(
                                                                  color: const Color(
                                                                    0xFF2768D8,
                                                                  ),
                                                                  fontSize: 14,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationColor:
                                                                      const Color(
                                                                        0xFF2768D8,
                                                                      ),
                                                                  letterSpacing:
                                                                      0,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox.shrink(),
                                                  ),
                                                  InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    onTap: () => authController
                                                        .toggleRememberMe(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 4,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'تذكرني',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                  color: const Color(
                                                                    0xFF20315D,
                                                                  ),
                                                                  fontSize: 15,
                                                                  letterSpacing:
                                                                      0,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          _ModernCheckbox(
                                                            checked: authController
                                                                .isActiveRememberMe,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            if (showIdentity) ...[
                                              const SizedBox(height: 24),
                                              _GradientLoginButton(
                                                text: isOtpMode
                                                    ? 'الحصول على رمز التحقق'
                                                    : 'تسجيل الدخول',
                                                loading:
                                                    authController.isLoading,
                                                onTap: () => _login(
                                                  authController,
                                                  manualLogin,
                                                  otpLogin,
                                                ),
                                              ),
                                            ],
                                            if (manualLogin == 1) ...[
                                              const SizedBox(height: 18),
                                              Center(
                                                child: TextButton.icon(
                                                  onPressed: () {
                                                    signInPhoneController
                                                        .clear();
                                                    signInPasswordController
                                                        .clear();
                                                    Get.toNamed(
                                                      RouteHelper.getSignUpRoute(),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.chevron_left_rounded,
                                                    size: 22,
                                                  ),
                                                  label: Text(
                                                    'إنشاء حساب جديد',
                                                    style: robotoBold.copyWith(
                                                      fontSize: 16,
                                                      letterSpacing: 0,
                                                    ),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF2669D8),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            if (manualLogin == 1 &&
                                                otpLogin == 1) ...[
                                              const SizedBox(height: 2),
                                              Center(
                                                child: TextButton(
                                                  onPressed: () =>
                                                      _toggleLoginMedium(
                                                        authController,
                                                      ),
                                                  child: Text(
                                                    isOtpMode
                                                        ? 'تسجيل الدخول بكلمة المرور'
                                                        : 'الدخول برمز تحقق',
                                                    style: robotoMedium
                                                        .copyWith(
                                                          color: const Color(
                                                            0xFF8290AA,
                                                          ),
                                                          fontSize: 14,
                                                          letterSpacing: 0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            if (socialLogin == 1) ...[
                                              const SizedBox(height: 10),
                                              const _DividerWithLabel(
                                                label: 'أو',
                                              ),
                                              const SizedBox(height: 18),
                                              _ModernSocialLoginOptions(
                                                fromPage: widget.fromPage,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 18,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 42,
                                            width: 42,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withValues(
                                                alpha: .58,
                                              ),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: .78,
                                                ),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.verified_user_outlined,
                                              color: Color(0xFF15B9C9),
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'بياناتك آمنة لدينا',
                                                style: robotoBold.copyWith(
                                                  color: const Color(
                                                    0xFF536885,
                                                  ),
                                                  fontSize: 16,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                'نحمي خصوصيتك ونضمن أمان معلوماتك',
                                                style: robotoRegular.copyWith(
                                                  color: const Color(
                                                    0xFF70809B,
                                                  ),
                                                  fontSize: 12,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
            ),
          ),
        ),
      ),
    );
  }

  void _handleIdentityChanged(
    AuthController authController,
    int manualLogin,
    String text,
  ) {
    if (authController.selectedLoginMedium == LoginMedium.otp) {
      return;
    }

    final numberRegExp = RegExp(r'^[+]?[0-9]+$');
    if (text.isEmpty && authController.isNumberLogin) {
      authController.toggleIsNumberLogin();
    }

    if (text.startsWith(numberRegExp) &&
        !authController.isNumberLogin &&
        manualLogin == 1) {
      authController.toggleIsNumberLogin();
      final cursorPosition = signInPhoneController.selection.baseOffset;
      signInPhoneController.text = text.replaceAll("+", "");
      signInPhoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition),
      );
    }

    if (text.contains(RegExp(r'@')) &&
        authController.isNumberLogin &&
        manualLogin == 1) {
      authController.toggleIsNumberLogin();
    }

    _phoneFocus.requestFocus();
  }

  String? _validateIdentity(
    AuthController authController,
    int manualLogin,
    int? otpLogin,
    String? value,
  ) {
    final identity = value?.trim() ?? '';
    final phone = PhoneVerificationHelper.getValidPhoneNumber(
      authController.countryDialCode + identity,
      withCountryCode: true,
    );

    if (otpLogin == 1 && manualLogin == 0 && phone == "") {
      return "enter_valid_phone_number".tr;
    }
    if (authController.isNumberLogin && phone == "") {
      return "enter_valid_phone_number".tr;
    }

    return phone != "" || GetUtils.isEmail(identity)
        ? null
        : 'enter_email_or_phone'.tr;
  }

  void _toggleLoginMedium(AuthController authController) {
    final phoneWithoutCountryCode = PhoneVerificationHelper.getValidPhoneNumber(
      authController.getUserNumber(),
    );
    final countryCode = PhoneVerificationHelper.getCountryCode(
      authController.getUserNumber(),
    );

    if (authController.selectedLoginMedium == LoginMedium.otp) {
      authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.manual);
      signInPhoneController.text = phoneWithoutCountryCode != ""
          ? phoneWithoutCountryCode
          : authController.getUserNumber();
      authController.toggleIsNumberLogin(value: countryCode != "");
      authController.initCountryCode(
        countryCode: countryCode != "" ? countryCode : null,
      );
      signInPasswordController.text = authController.getUserPassword();

      if (signInPasswordController.text.isEmpty) {
        signInPhoneController.text = "";
        authController.toggleIsNumberLogin(value: false);
      }
    } else {
      authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.otp);
      authController.toggleIsNumberLogin(value: true);
      signInPasswordController.clear();
      signInPhoneController.text = phoneWithoutCountryCode;
      authController.initCountryCode(
        countryCode: countryCode != "" ? countryCode : null,
      );
    }
  }

  void _initializeController() {
    var authController = Get.find<AuthController>();
    String phoneWithoutCountryCode =
        PhoneVerificationHelper.getValidPhoneNumber(
          Get.find<AuthController>().getUserNumber(),
        );
    String countryCode = PhoneVerificationHelper.getCountryCode(
      Get.find<AuthController>().getUserNumber(),
    );

    var config = Get.find<SplashController>().configModel.content;
    var manualLogin = config?.customerLogin?.loginOption?.manualLogin ?? 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (countryCode != "" && phoneWithoutCountryCode != "") {
        authController.toggleIsNumberLogin(value: true);
      } else {
        authController.toggleIsNumberLogin(value: false);
      }
      authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.manual);
      authController.initCountryCode(
        countryCode: countryCode != "" ? countryCode : null,
      );

      signInPhoneController.text = phoneWithoutCountryCode != ""
          ? phoneWithoutCountryCode
          : authController.isNumberLogin
          ? ""
          : Get.find<AuthController>().getUserNumber();
      signInPasswordController.text = Get.find<AuthController>()
          .getUserPassword();

      if (manualLogin == 1 && signInPasswordController.text.isEmpty) {
        signInPhoneController.text = "";
        authController.initCountryCode();
        authController.toggleIsNumberLogin(value: false);
      }
    });
    authController.toggleRememberMe(value: false, shouldUpdate: false);
  }

  Future<bool> _existFromApp() async {
    if (widget.exitFromApp) {
      if (_canExit) {
        if (GetPlatform.isAndroid) {
          SystemNavigator.pop();
        } else if (GetPlatform.isIOS) {
          exit(0);
        } else {
          Navigator.pushNamed(context, RouteHelper.getInitialRoute());
        }
        return Future.value(false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'back_press_again_to_exit'.tr,
              style: const TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ),
        );
        _canExit = true;
        Timer(const Duration(seconds: 2), () {
          _canExit = false;
        });
        return Future.value(false);
      }
    } else {
      return true;
    }
  }

  void _login(
    AuthController authController,
    var manualLogin,
    var otpLogin,
  ) async {
    if (customerSignInKey.currentState!.validate()) {
      var config = Get.find<SplashController>().configModel.content;

      SendOtpType type = config?.firebaseOtpVerification == 1
          ? SendOtpType.firebase
          : SendOtpType.verification;

      String phone = PhoneVerificationHelper.getValidPhoneNumber(
        authController.countryDialCode + signInPhoneController.text.trim(),
        withCountryCode: true,
      );

      if ((authController.selectedLoginMedium == LoginMedium.otp) ||
          (manualLogin == 0 && otpLogin == 1)) {
        authController
            .sendVerificationCode(
              identity: phone,
              identityType: "phone",
              type: type,
              checkUser: 0,
            )
            .then((status) {
              if (status != null) {
                if (status.isSuccess!) {
                  Get.toNamed(
                    RouteHelper.getVerificationRoute(
                      identity: phone,
                      identityType: "phone",
                      fromPage: config?.firebaseOtpVerification == 1
                          ? "firebase-otp"
                          : "otp-login",
                      firebaseSession: type == SendOtpType.firebase
                          ? status.message
                          : null,
                    ),
                  );
                } else {
                  customSnackBar(status.message.toString().capitalizeFirst);
                }
              }
            });
      } else {
        authController.login(
          fromPage: widget.fromPage,
          emailPhone: phone != "" ? phone : signInPhoneController.text.trim(),
          password: signInPasswordController.text.trim(),
          type: phone != "" ? "phone" : "email",
        );
      }
    }
  }
}

class _QadhaSignInBackground extends StatelessWidget {
  final Widget child;

  const _QadhaSignInBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF275BD7), Color(0xFF4CA7E6), Color(0xFFB9F0EA)],
              stops: [0, .48, 1],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00FFFFFF), Color(0x33FFFFFF), Color(0x99FFFFFF)],
              stops: [0, .56, 1],
            ),
          ),
        ),
        const Positioned(
          top: 96,
          left: 38,
          child: _SoftBackgroundIcon(
            icon: Icons.cleaning_services_outlined,
            size: 74,
            angle: -.2,
          ),
        ),
        const Positioned(
          top: 164,
          right: 26,
          child: _SoftBackgroundIcon(icon: Icons.window_outlined, size: 84),
        ),
        const Positioned(
          top: 268,
          left: 26,
          child: _SoftBackgroundIcon(icon: Icons.weekend_outlined, size: 88),
        ),
        const Positioned(
          top: 256,
          right: 28,
          child: _SoftBackgroundIcon(
            icon: Icons.local_laundry_service_outlined,
            size: 82,
            angle: .16,
          ),
        ),
        const Positioned(
          top: 382,
          right: 62,
          child: _SoftBackgroundIcon(icon: Icons.yard_outlined, size: 58),
        ),
        Positioned(
          bottom: -72,
          left: -46,
          right: -46,
          height: 250,
          child: CustomPaint(painter: const _SignInWavePainter()),
        ),
        child,
      ],
    );
  }
}

class _SoftBackgroundIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double angle;

  const _SoftBackgroundIcon({
    required this.icon,
    required this.size,
    this.angle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Icon(icon, size: size, color: Colors.white.withValues(alpha: .2)),
    );
  }
}

class _SignInWavePainter extends CustomPainter {
  const _SignInWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backWave = Path()
      ..moveTo(0, size.height * .34)
      ..cubicTo(
        size.width * .18,
        size.height * .14,
        size.width * .34,
        size.height * .66,
        size.width * .52,
        size.height * .46,
      )
      ..cubicTo(
        size.width * .72,
        size.height * .24,
        size.width * .83,
        size.height * .18,
        size.width,
        size.height * .34,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(backWave, Paint()..color = const Color(0x5546E2CF));

    final frontWave = Path()
      ..moveTo(0, size.height * .5)
      ..cubicTo(
        size.width * .2,
        size.height * .28,
        size.width * .38,
        size.height * .72,
        size.width * .58,
        size.height * .55,
      )
      ..cubicTo(
        size.width * .76,
        size.height * .39,
        size.width * .87,
        size.height * .35,
        size.width,
        size.height * .48,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(frontWave, Paint()..color = const Color(0x774FE8D5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModernAuthField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onPrefixTap;

  const _ModernAuthField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.nextFocus,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.validator,
    this.onPrefixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4EBF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B668B).withValues(alpha: .1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textAlign: TextAlign.right,
          autocorrect: false,
          cursorColor: const Color(0xFF286BDB),
          style: robotoMedium.copyWith(
            color: const Color(0xFF122B5D),
            fontSize: 16,
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: robotoMedium.copyWith(
              color: const Color(0xFF909BB0),
              fontSize: 16,
              letterSpacing: 0,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: onPrefixTap,
                    child: Icon(prefixIcon, color: const Color(0xFF8B98AD)),
                  ),
            suffixIcon: suffixIcon == null
                ? null
                : Icon(suffixIcon, color: const Color(0xFF2865CE)),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 52,
              minWidth: 54,
            ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 52,
              minWidth: 54,
            ),
          ),
          onChanged: onChanged,
          validator: validator,
          onFieldSubmitted: (_) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ),
    );
  }
}

class _GradientLoginButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onTap;

  const _GradientLoginButton({
    required this.text,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: loading ? null : onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFF4DA6F2), Color(0xFF2856D8)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF286BDB).withValues(alpha: .25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 22,
              child: Icon(
                Icons.chevron_left_rounded,
                color: Colors.white.withValues(alpha: loading ? .45 : .9),
                size: 30,
              ),
            ),
            loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    style: robotoBold.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _ModernCheckbox extends StatelessWidget {
  final bool checked;

  const _ModernCheckbox({required this.checked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: checked ? const Color(0xFF286BDB) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: checked ? const Color(0xFF286BDB) : const Color(0xFFD5DCE8),
          width: 2,
        ),
      ),
      child: checked
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
          : null,
    );
  }
}

class _DividerWithLabel extends StatelessWidget {
  final String label;

  const _DividerWithLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFDDE4EE))),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            label,
            style: robotoBold.copyWith(
              color: const Color(0xFF2A3763),
              fontSize: 15,
              letterSpacing: 0,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFDDE4EE))),
      ],
    );
  }
}

class _ModernSocialLoginOptions extends StatelessWidget {
  final String? fromPage;

  const _ModernSocialLoginOptions({this.fromPage});

  @override
  Widget build(BuildContext context) {
    final config =
        Get.find<SplashController>().configModel.content?.customerLogin;
    final options = <SocialLoginType>[
      if (config?.socialMediaLoginOptions?.google == 1) SocialLoginType.google,
      if (config?.socialMediaLoginOptions?.facebook == 1)
        SocialLoginType.facebook,
      if (config?.socialMediaLoginOptions?.apple == 1 &&
          !GetPlatform.isAndroid &&
          !GetPlatform.isWeb)
        SocialLoginType.apple,
    ];

    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    if (options.length == 1) {
      return SocialLoginButton(
        title: _titleFor(options.first),
        socialLoginType: options.first,
        fromPage: fromPage,
        showPadding: false,
      );
    }

    return Row(
      children: options.take(2).map((type) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: type == options.take(2).last ? 0 : 10,
            ),
            child: SocialLoginButton(
              title: _titleFor(type),
              socialLoginType: type,
              fromPage: fromPage,
              showPadding: false,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _titleFor(SocialLoginType type) {
    if (type == SocialLoginType.google) {
      return 'Sign in with Google';
    }
    if (type == SocialLoginType.apple) {
      return 'Sign in with Apple';
    }
    return 'Sign in with Facebook';
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .86),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2457B8).withValues(alpha: .16),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF13346D), size: 20),
      ),
    );
  }
}
