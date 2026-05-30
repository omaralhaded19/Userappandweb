import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/feature/auth/widgets/social_login_button.dart';
import 'package:seohost/utils/core_export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var referCodeController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late final GlobalKey<FormState> customerSignUpKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().initCountryCode();
    Get.find<AuthController>().toggleTerms(value: false, shouldUpdate: false);
  }

  @override
  void dispose() {
    super.dispose();
    _clearControllerValue();
  }

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveHelper.isDesktop(context)) {
      return _buildMobileSignUp(context);
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          AuthController authController = Get.find();
          authController.acceptTerms == true
              ? authController.toggleTerms()
              : authController.acceptTerms;
          return;
        }
      },
      child: Scaffold(
        endDrawer: ResponsiveHelper.isDesktop(context)
            ? const MenuDrawer()
            : null,
        appBar: const CustomAppBar(title: "", isBackgroundTransparent: true),
        body: SafeArea(
          child: GetBuilder<AuthController>(
            builder: (authController) {
              var config = Get.find<SplashController>().configModel.content;
              var socialLogin =
                  config?.customerLogin?.loginOption?.socialMediaLogin;

              return FooterBaseView(
                child: WebShadowWrap(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                    ),
                    child: Column(
                      children: [
                        Form(
                          key: customerSignUpKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraMoreLarge,
                              ),

                              Hero(
                                tag: Images.logo,
                                child: Image.asset(
                                  Images.logo,
                                  width: Dimensions.logoSize,
                                ),
                              ),

                              const SizedBox(
                                height: Dimensions.paddingSizeExtraMoreLarge,
                              ),
                              if (ResponsiveHelper.isMobile(context))
                                _firstList(authController),
                              if (ResponsiveHelper.isMobile(context))
                                _secondList(authController),
                              if (!ResponsiveHelper.isMobile(context))
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _firstList(authController)),
                                    const SizedBox(
                                      width: Dimensions.paddingSizeLarge,
                                    ),
                                    Expanded(
                                      child: _secondList(authController),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        ConditionCheckBox(
                          checkBoxValue: authController.acceptTerms,
                          onTap: (bool? value) {
                            if (customerSignUpKey.currentState?.validate() ==
                                true) {
                              authController.toggleTerms(value: true);
                            } else {
                              authController.toggleTerms(value: false);
                            }
                          },
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraLarge,
                        ),
                        CustomButton(
                          buttonText: 'sign_up'.tr,
                          isLoading: authController.isLoading,
                          onPressed:
                              authController.acceptTerms &&
                                  customerSignUpKey.currentState?.validate() ==
                                      true
                              ? () => _register(authController)
                              : null,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        socialLogin == 1
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      ResponsiveHelper.isDesktop(context)
                                      ? Dimensions.webMaxWidth / 3.5
                                      : ResponsiveHelper.isTab(context)
                                      ? Dimensions.webMaxWidth / 5.5
                                      : 0,
                                ),
                                child: const SocialLoginWidget(
                                  fromPage: RouteHelper.home,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${'already_have_an_account'.tr} ',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.color,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RouteHelper.getSignInRoute());
                              },
                              child: Text(
                                'sign_in_here'.tr,
                                style: robotoRegular.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        const SizedBox(
                          height: Dimensions.paddingSizeExtraMoreLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileSignUp(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          final AuthController authController = Get.find();
          if (authController.acceptTerms == true) {
            authController.toggleTerms();
          }
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: const Color(0xFFB9F0EA),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: _SignUpAuthBackground(
              child: SafeArea(
                child: GetBuilder<AuthController>(
                  builder: (authController) {
                    final config =
                        Get.find<SplashController>().configModel.content;
                    final socialLogin =
                        config?.customerLogin?.loginOption?.socialMediaLogin;

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
                                      child: _SignUpCircleIconButton(
                                        icon: Icons.arrow_forward_ios_rounded,
                                        onTap: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 132,
                                  height: 132,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: .94),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: .72,
                                      ),
                                      width: 7,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF0F5FD1,
                                        ).withValues(alpha: .24),
                                        blurRadius: 34,
                                        offset: const Offset(0, 16),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: QadhaBrandMark(
                                      iconSize: 54,
                                      textSize: 30,
                                      showTagline: false,
                                      textColor: Color(0xFF2056C7),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    22,
                                    30,
                                    22,
                                    28,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .95),
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
                                    key: customerSignUpKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'إنشاء حساب',
                                          textAlign: TextAlign.center,
                                          style: robotoBold.copyWith(
                                            color: const Color(0xFF10295D),
                                            fontSize: 34,
                                            height: 1.1,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'ابدأ حجز خدماتك المنزلية بسهولة',
                                          textAlign: TextAlign.center,
                                          style: robotoMedium.copyWith(
                                            color: const Color(0xFF8290AA),
                                            fontSize: 16,
                                            height: 1.45,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        const SizedBox(height: 26),
                                        _SignUpAuthField(
                                          controller: firstNameController,
                                          focusNode: _firstNameFocus,
                                          nextFocus: _lastNameFocus,
                                          hintText: 'الاسم الأول',
                                          suffixIcon: Icons.person_outline,
                                          keyboardType: TextInputType.name,
                                          validator: (value) => FormValidation()
                                              .isValidFirstName(value ?? ''),
                                        ),
                                        const SizedBox(height: 14),
                                        _SignUpAuthField(
                                          controller: lastNameController,
                                          focusNode: _lastNameFocus,
                                          nextFocus: _emailFocus,
                                          hintText: 'اسم العائلة',
                                          suffixIcon: Icons.badge_outlined,
                                          keyboardType: TextInputType.name,
                                          validator: (value) => FormValidation()
                                              .isValidLastName(value ?? ''),
                                        ),
                                        const SizedBox(height: 14),
                                        _SignUpAuthField(
                                          controller: emailController,
                                          focusNode: _emailFocus,
                                          nextFocus: _phoneFocus,
                                          hintText: 'البريد الإلكتروني',
                                          suffixIcon:
                                              Icons.mail_outline_rounded,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) => FormValidation()
                                              .isValidEmail(value),
                                        ),
                                        const SizedBox(height: 14),
                                        _SignUpAuthField(
                                          controller: phoneController,
                                          focusNode: _phoneFocus,
                                          nextFocus: _passwordFocus,
                                          hintText: 'رقم الهاتف',
                                          suffixIcon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          prefixWidget: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              authController.countryDialCode,
                                              style: robotoBold.copyWith(
                                                color: const Color(0xFF286BDB),
                                                fontSize: 14,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'enter_phone_number'.tr;
                                            }
                                            return FormValidation()
                                                .isValidPhone(
                                                  authController
                                                          .countryDialCode +
                                                      value,
                                                  fromAuthPage: true,
                                                );
                                          },
                                        ),
                                        const SizedBox(height: 14),
                                        _SignUpAuthField(
                                          controller: passwordController,
                                          focusNode: _passwordFocus,
                                          nextFocus: _confirmPasswordFocus,
                                          hintText: 'كلمة المرور',
                                          suffixIcon:
                                              Icons.lock_outline_rounded,
                                          prefixIcon: _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          obscureText: _obscurePassword,
                                          onPrefixTap: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                          validator: (value) => FormValidation()
                                              .isValidPassword(value ?? ''),
                                        ),
                                        const SizedBox(height: 14),
                                        _SignUpAuthField(
                                          controller: confirmPasswordController,
                                          focusNode: _confirmPasswordFocus,
                                          nextFocus: _referCodeFocus,
                                          hintText: 'تأكيد كلمة المرور',
                                          suffixIcon: Icons.lock_reset_outlined,
                                          prefixIcon: _obscureConfirmPassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          obscureText: _obscureConfirmPassword,
                                          onPrefixTap: () => setState(
                                            () => _obscureConfirmPassword =
                                                !_obscureConfirmPassword,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'this_field_can_not_empty'
                                                  .tr;
                                            }
                                            return FormValidation()
                                                .isValidConfirmPassword(
                                                  passwordController.text,
                                                  confirmPasswordController
                                                      .text,
                                                );
                                          },
                                        ),
                                        const SizedBox(height: 14),
                                        _SignUpAuthField(
                                          controller: referCodeController,
                                          focusNode: _referCodeFocus,
                                          hintText: 'كود الإحالة - اختياري',
                                          suffixIcon: Icons
                                              .confirmation_number_outlined,
                                          textInputAction: TextInputAction.done,
                                        ),
                                        const SizedBox(height: 18),
                                        InkWell(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          onTap: () =>
                                              authController.toggleTerms(
                                                value:
                                                    !authController.acceptTerms,
                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              children: [
                                                _SignUpCheckbox(
                                                  checked: authController
                                                      .acceptTerms,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    'أوافق على الشروط والأحكام',
                                                    style: robotoMedium
                                                        .copyWith(
                                                          color: const Color(
                                                            0xFF20315D,
                                                          ),
                                                          fontSize: 14,
                                                          letterSpacing: 0,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        _SignUpGradientButton(
                                          text: 'إنشاء حساب',
                                          loading: authController.isLoading,
                                          onTap: () {
                                            if (customerSignUpKey.currentState
                                                    ?.validate() !=
                                                true) {
                                              return;
                                            }
                                            if (!authController.acceptTerms) {
                                              customSnackBar(
                                                'please_accept_the_terms_and_conditions'
                                                    .tr,
                                              );
                                              return;
                                            }
                                            _register(authController);
                                          },
                                        ),
                                        if (socialLogin == 1) ...[
                                          const SizedBox(height: 22),
                                          const _SignUpDividerWithLabel(
                                            label: 'OR',
                                          ),
                                          const SizedBox(height: 18),
                                          const _SignUpSocialLoginOptions(
                                            fromPage: RouteHelper.home,
                                          ),
                                        ],
                                        const SizedBox(height: 18),
                                        Center(
                                          child: TextButton.icon(
                                            onPressed: () => Get.toNamed(
                                              RouteHelper.getSignInRoute(),
                                            ),
                                            icon: const Icon(
                                              Icons.chevron_left_rounded,
                                              size: 22,
                                            ),
                                            label: Text(
                                              'لديك حساب؟ تسجيل الدخول',
                                              style: robotoBold.copyWith(
                                                fontSize: 15,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor: const Color(
                                                0xFF2669D8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
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

  Widget _firstList(AuthController authController) {
    return Column(
      children: [
        CustomTextField(
          title: 'first_name'.tr,
          hintText: 'enter_your_first_name'.tr,
          controller: firstNameController,
          isAutoFocus: false,
          focusNode: _firstNameFocus,
          nextFocus: _lastNameFocus,
          inputType: TextInputType.name,
          capitalization: TextCapitalization.words,
          onValidate: (String? value) {
            return FormValidation().isValidFirstName(value!);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

        CustomTextField(
          title: 'last_name'.tr,
          hintText: 'enter_your_last_name'.tr,
          controller: lastNameController,
          focusNode: _lastNameFocus,
          nextFocus: _emailFocus,
          inputType: TextInputType.name,
          capitalization: TextCapitalization.words,
          onValidate: (String? value) {
            return FormValidation().isValidLastName(value!);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

        CustomTextField(
          title: 'email_address'.tr,
          hintText: 'enter_email_address'.tr,
          controller: emailController,
          focusNode: _emailFocus,
          nextFocus: _phoneFocus,
          inputType: TextInputType.emailAddress,
          onValidate: (String? value) {
            return FormValidation().isValidEmail(value);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

        CustomTextField(
          onCountryChanged: (CountryCode countryCode) {
            authController.countryDialCode = countryCode.dialCode!;
          },
          countryDialCode: authController.countryDialCode,
          hintText: 'enter_phone_number'.tr,
          controller: phoneController,
          focusNode: _phoneFocus,
          nextFocus: _passwordFocus,
          inputType: TextInputType.phone,
          isRequired: false,
          onValidate: (String? value) {
            if (value == null || value.isEmpty) {
              return 'enter_phone_number'.tr;
            } else {
              return FormValidation().isValidPhone(
                authController.countryDialCode + (value),
                fromAuthPage: true,
              );
            }
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
      ],
    );
  }

  Widget _secondList(AuthController authController) {
    return Column(
      children: [
        CustomTextField(
          title: 'password'.tr,
          hintText: '****************'.tr,
          controller: passwordController,
          focusNode: _passwordFocus,
          nextFocus: _confirmPasswordFocus,
          inputType: TextInputType.visiblePassword,
          onValidate: (String? value) {
            return FormValidation().isValidPassword(value!);
          },
          isPassword: true,
        ),
        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

        CustomTextField(
          title: 'confirm_password'.tr,
          hintText: '****************'.tr,
          controller: confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          nextFocus: _referCodeFocus,
          inputType: TextInputType.visiblePassword,
          isPassword: true,
          onValidate: (String? value) {
            if (value == null || value.isEmpty) {
              return 'this_field_can_not_empty'.tr;
            } else {
              return FormValidation().isValidConfirmPassword(
                passwordController.text,
                confirmPasswordController.text,
              );
            }
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
        CustomTextField(
          title: 'referral_code'.tr,
          hintText: 'optional'.tr,
          controller: referCodeController,
          focusNode: _referCodeFocus,
          inputType: TextInputType.text,
          inputAction: TextInputAction.done,
          isRequired: false,
        ),
        const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
      ],
    );
  }

  void _register(AuthController authController) async {
    if (customerSignUpKey.currentState!.validate()) {
      SignUpBody signUpBody;
      String numberWithCountryCode =
          PhoneVerificationHelper.getValidPhoneNumber(
            authController.countryDialCode + phoneController.value.text,
            withCountryCode: true,
          );

      if (referCodeController.text != "") {
        signUpBody = SignUpBody(
          fName: firstNameController.value.text.trim(),
          lName: lastNameController.value.text.trim(),
          email: emailController.value.text.trim(),
          phone: numberWithCountryCode.trim(),
          password: passwordController.value.text.trim(),
          confirmPassword: confirmPasswordController.value.text.trim(),
          referCode: referCodeController.text.trim(),
        );
      } else {
        signUpBody = SignUpBody(
          fName: firstNameController.value.text.trim(),
          lName: lastNameController.value.text.trim(),
          email: emailController.value.text.trim(),
          phone: numberWithCountryCode.trim(),
          password: passwordController.value.text.trim(),
          confirmPassword: confirmPasswordController.value.text.trim(),
        );
      }
      authController.registration(signUpBody: signUpBody);
    }
  }

  void _clearControllerValue() {
    firstNameController.text = "";
    lastNameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    referCodeController.text = "";
  }
}

class _SignUpAuthBackground extends StatelessWidget {
  final Widget child;

  const _SignUpAuthBackground({required this.child});

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
          top: 118,
          left: 34,
          child: _SignUpBackgroundIcon(
            icon: Icons.cleaning_services_outlined,
            size: 76,
            angle: -.2,
          ),
        ),
        const Positioned(
          top: 174,
          right: 28,
          child: _SignUpBackgroundIcon(icon: Icons.window_outlined, size: 78),
        ),
        const Positioned(
          top: 292,
          left: 24,
          child: _SignUpBackgroundIcon(icon: Icons.weekend_outlined, size: 84),
        ),
        const Positioned(
          top: 292,
          right: 24,
          child: _SignUpBackgroundIcon(
            icon: Icons.local_laundry_service_outlined,
            size: 80,
            angle: .16,
          ),
        ),
        Positioned(
          bottom: -72,
          left: -46,
          right: -46,
          height: 250,
          child: CustomPaint(painter: const _SignUpWavePainter()),
        ),
        child,
      ],
    );
  }
}

class _SignUpBackgroundIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double angle;

  const _SignUpBackgroundIcon({
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

class _SignUpWavePainter extends CustomPainter {
  const _SignUpWavePainter();

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

class _SignUpAuthField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefixWidget;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onPrefixTap;

  const _SignUpAuthField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.nextFocus,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
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
            prefixIcon:
                prefixWidget ??
                (prefixIcon == null
                    ? null
                    : InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: onPrefixTap,
                        child: Icon(prefixIcon, color: const Color(0xFF8B98AD)),
                      )),
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

class _SignUpGradientButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onTap;

  const _SignUpGradientButton({
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

class _SignUpCheckbox extends StatelessWidget {
  final bool checked;

  const _SignUpCheckbox({required this.checked});

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

class _SignUpDividerWithLabel extends StatelessWidget {
  final String label;

  const _SignUpDividerWithLabel({required this.label});

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

class _SignUpSocialLoginOptions extends StatelessWidget {
  final String? fromPage;

  const _SignUpSocialLoginOptions({this.fromPage});

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

class _SignUpCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SignUpCircleIconButton({required this.icon, required this.onTap});

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
