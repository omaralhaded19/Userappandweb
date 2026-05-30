import 'package:get/get.dart';
import 'package:seohost/common/widgets/qadha_branding.dart';
import 'package:seohost/feature/profile/model/profile_cart_item_model.dart';
import 'package:seohost/utils/core_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo(reload: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool pickedAddress =
        Get.find<LocationController>().getUserAddress() != null;

    final profileCartModelList = [
      ProfileCardItemModel(
        'my_address'.tr,
        Images.address,
        Get.find<AuthController>().isLoggedIn()
            ? RouteHelper.getAddressRoute('fromProfileScreen')
            : RouteHelper.getNotLoggedScreen(RouteHelper.profile, "profile"),
      ),
      ProfileCardItemModel(
        'notifications'.tr,
        Images.notification,
        pickedAddress
            ? RouteHelper.getNotificationRoute()
            : RouteHelper.getPickMapRoute(
                RouteHelper.notification,
                true,
                'false',
                null,
                null,
              ),
      ),
      if (!Get.find<AuthController>().isLoggedIn())
        ProfileCardItemModel(
          'sign_in'.tr,
          Images.logout,
          RouteHelper.getSignInRoute(fromPage: RouteHelper.profile),
        ),

      if (Get.find<AuthController>().isLoggedIn())
        ProfileCardItemModel(
          'suggest_new_service'.tr,
          Images.suggestServiceIcon,
          pickedAddress
              ? RouteHelper.getNewSuggestedServiceScreen()
              : RouteHelper.getPickMapRoute(
                  RouteHelper.suggestService,
                  true,
                  'false',
                  null,
                  null,
                ),
        ),

      if (Get.find<AuthController>().isLoggedIn())
        ProfileCardItemModel(
          'delete_account'.tr,
          Images.accountDelete,
          'delete_account',
        ),

      if (Get.find<AuthController>().isLoggedIn())
        ProfileCardItemModel('logout'.tr, Images.logout, 'sign_out'),
    ];

    if (!ResponsiveHelper.isDesktop(context)) {
      return _buildQadhaProfile(context, profileCartModelList);
    }

    return CustomPopScopeWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        endDrawer: ResponsiveHelper.isDesktop(context)
            ? const MenuDrawer()
            : null,
        appBar: CustomAppBar(
          title: 'profile'.tr,
          centerTitle: true,
          bgColor: Theme.of(context).primaryColor,
          isBackButtonExist: true,
          onBackPressed: () {
            if (Navigator.canPop(context)) {
              Get.back();
            } else {
              Get.offAllNamed(RouteHelper.getMainRoute("home"));
            }
          },
        ),

        body: GetBuilder<UserController>(
          builder: (userController) {
            return userController.userInfoModel == null &&
                    Get.find<AuthController>().isLoggedIn()
                ? const Center(child: CircularProgressIndicator())
                : FooterBaseView(
                    child: WebShadowWrap(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileHeader(
                            userInfoModel: userController.userInfoModel,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      ResponsiveHelper.isMobile(context)
                                      ? 1
                                      : 2,
                                  childAspectRatio: 6,
                                  crossAxisSpacing:
                                      Dimensions.paddingSizeExtraLarge,
                                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                                ),
                            itemCount: profileCartModelList.length,
                            itemBuilder: (context, index) {
                              return ProfileCardItem(
                                title: profileCartModelList[index].title,
                                leadingIcon:
                                    profileCartModelList[index].loadingIcon,
                                onTap: () {
                                  if (profileCartModelList[index].routeName ==
                                      'sign_out') {
                                    if (Get.find<AuthController>()
                                        .isLoggedIn()) {
                                      Get.dialog(
                                        ConfirmationDialog(
                                          icon: Images.logoutIcon,
                                          title: 'are_you_sure_to_logout'.tr,
                                          description:
                                              "if_you_logged_out_your_cart_will_be_removed"
                                                  .tr,
                                          yesButtonColor: Theme.of(
                                            Get.context!,
                                          ).colorScheme.primary,
                                          onYesPressed: () async {
                                            Get.find<AuthController>()
                                                .clearSharedData();
                                            Get.find<AuthController>()
                                                .googleLogout();
                                            Get.find<AuthController>()
                                                .signOutWithFacebook();
                                            Get.find<AuthController>()
                                                .signOutWithFacebook();
                                            Get.offAllNamed(
                                              RouteHelper.getInitialRoute(),
                                            );
                                          },
                                        ),
                                        useSafeArea: false,
                                      );
                                    } else {
                                      Get.toNamed(RouteHelper.getSignInRoute());
                                    }
                                  } else if (profileCartModelList[index]
                                          .routeName ==
                                      'delete_account') {
                                    Get.dialog(
                                      ConfirmationDialog(
                                        icon: Images.deleteProfile,
                                        title:
                                            'are_you_sure_to_delete_your_account'
                                                .tr,
                                        description:
                                            'it_will_remove_your_all_information'
                                                .tr,
                                        yesButtonText: 'delete',
                                        noButtonText: 'cancel',
                                        onYesPressed: () =>
                                            userController.removeUser(),
                                      ),
                                      useSafeArea: false,
                                    );
                                  } else {
                                    Get.toNamed(
                                      profileCartModelList[index].routeName,
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: Dimensions.paddingSizeDefault),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildQadhaProfile(
    BuildContext context,
    List<ProfileCardItemModel> items,
  ) {
    return CustomPopScopeWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: QadhaSoftScaffold(
            child: GetBuilder<UserController>(
              builder: (userController) {
                if (userController.userInfoModel == null &&
                    Get.find<AuthController>().isLoggedIn()) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = userController.userInfoModel;
                final name = Get.find<AuthController>().isLoggedIn()
                    ? '${user?.fName ?? ''} ${user?.lName ?? ''}'.trim()
                    : 'ضيف قدها';
                final bookings = user?.bookingsCount ?? 0;
                final joinedDays = _joinedDays(user?.createdAt);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    children: [
                      QadhaGradientHeader(
                        title: 'الحساب الشخصي',
                        height: 142,
                        leading: QadhaCircleIcon(
                          icon: Icons.arrow_back_ios_new_rounded,
                          size: 48,
                          color: Colors.white,
                          filled: true,
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              Get.back();
                            } else {
                              Get.find<BottomNavController>().changePage(
                                BnbItem.more,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 34),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(26, 160, 26, 0),
                            child: Column(
                              children: [
                                Text(
                                  name.isEmpty ? 'ضيف قدها' : name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoBold.copyWith(
                                    color: QadhaPalette.deepNavy,
                                    fontSize: 24,
                                    height: 1.22,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                QadhaGlassCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 20,
                                  ),
                                  radius: 22,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _ProfileMetric(
                                          icon: Icons.event_note_rounded,
                                          title: 'الحجوزات',
                                          value: bookings.toString(),
                                          subtitle: 'إجمالي حجوزاتك',
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 70,
                                        color: QadhaPalette.line,
                                      ),
                                      Expanded(
                                        child: _ProfileMetric(
                                          icon: Icons.calendar_month_rounded,
                                          title: 'منذ أيام',
                                          value: joinedDays.toString(),
                                          subtitle: 'منذ انضمامك',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ...items.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _ProfileActionTile(
                                      item: item,
                                      onTap: () => _handleProfileAction(
                                        item,
                                        userController,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _ProfileAvatar(image: user?.imageFullPath),
                          PositionedDirectional(
                            top: 116,
                            start: 26,
                            child: InkWell(
                              onTap: () => Get.toNamed(
                                RouteHelper.getEditProfileRoute(),
                              ),
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .95),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: QadhaPalette.green.withValues(
                                      alpha: .45,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.edit_rounded,
                                      color: QadhaPalette.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'التعديل',
                                      style: robotoBold.copyWith(
                                        color: QadhaPalette.green,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  int _joinedDays(String? createdAt) {
    final created = DateTime.tryParse(createdAt ?? '');
    if (created == null) return 0;
    return DateTime.now().difference(created).inDays.clamp(0, 9999).toInt();
  }

  void _handleProfileAction(
    ProfileCardItemModel item,
    UserController userController,
  ) {
    if (item.routeName == 'sign_out') {
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.dialog(
          ConfirmationDialog(
            icon: Images.logoutIcon,
            title: 'are_you_sure_to_logout'.tr,
            description: 'if_you_logged_out_your_cart_will_be_removed'.tr,
            yesButtonColor: Theme.of(Get.context!).colorScheme.primary,
            onYesPressed: () async {
              Get.find<AuthController>().clearSharedData();
              Get.find<AuthController>().googleLogout();
              Get.find<AuthController>().signOutWithFacebook();
              Get.find<AuthController>().signOutWithFacebook();
              Get.offAllNamed(RouteHelper.getInitialRoute());
            },
          ),
          useSafeArea: false,
        );
      } else {
        Get.toNamed(RouteHelper.getSignInRoute());
      }
    } else if (item.routeName == 'delete_account') {
      Get.dialog(
        ConfirmationDialog(
          icon: Images.deleteProfile,
          title: 'are_you_sure_to_delete_your_account'.tr,
          description: 'it_will_remove_your_all_information'.tr,
          yesButtonText: 'delete',
          noButtonText: 'cancel',
          onYesPressed: () => userController.removeUser(),
        ),
        useSafeArea: false,
      );
    } else {
      Get.toNamed(item.routeName);
    }
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? image;

  const _ProfileAvatar({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      width: 138,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            QadhaPalette.green.withValues(alpha: .35),
            QadhaPalette.cyan.withValues(alpha: .25),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x252FC86F),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: image != null && image!.isNotEmpty
            ? CustomImage(image: image!, fit: BoxFit.cover)
            : Container(
                color: const Color(0xFFDFFAF4),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 92,
                ),
              ),
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _ProfileMetric({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFEFFFF8),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: QadhaPalette.green, size: 26),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: robotoMedium.copyWith(
                color: QadhaPalette.textMuted,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: robotoBold.copyWith(
                color: QadhaPalette.green,
                fontSize: 28,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: robotoRegular.copyWith(
                color: QadhaPalette.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final ProfileCardItemModel item;
  final VoidCallback onTap;

  const _ProfileActionTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final danger =
        item.routeName == 'delete_account' || item.routeName == 'sign_out';
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: QadhaGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        radius: 20,
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: danger
                    ? const Color(0xFFFFEEF2)
                    : const Color(0xFFEFFFF8),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                item.loadingIcon,
                color: danger ? const Color(0xFFEF4E62) : QadhaPalette.green,
                errorBuilder: (context, error, stackTrace) => Icon(
                  danger ? Icons.logout_rounded : Icons.chevron_left_rounded,
                  color: danger ? const Color(0xFFEF4E62) : QadhaPalette.green,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                textAlign: TextAlign.right,
                style: robotoMedium.copyWith(
                  color: QadhaPalette.deepNavy,
                  fontSize: 17,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: QadhaPalette.green,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
