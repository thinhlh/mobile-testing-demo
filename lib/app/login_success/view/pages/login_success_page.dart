import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tfc/app/login_success/view/providers/login_success_provider.dart';
import 'package:tfc/base/presentation/pages/p_stateless.dart';
import 'package:tfc/config/app_sizes.dart';
import 'package:tfc/generated/locale_keys.g.dart';
import 'package:tfc/utils/extensions/context_extension.dart';

class LoginSuccessPage extends PageStateless<LoginSuccessProvider> {
  const LoginSuccessPage({super.key});

  @override
  Widget buildPage(
    BuildContext context,
    LoginSuccessProvider provider,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                tr(LocaleKeys.logged_in_title),
                style: context.textTheme.titleLarge,
              ),
              AppSizes.mediumHeightDimens.verticalSpace,
              ElevatedButton(
                onPressed: () => apiCallSafety(
                  () => provider.logout(),
                ).then((value) => context.navigator.pop()),
                child: Text(tr(LocaleKeys.logged_in_logout)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
