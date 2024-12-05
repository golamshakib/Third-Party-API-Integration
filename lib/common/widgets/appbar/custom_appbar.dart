import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:third_party_api_integrations/utils/constants/colors.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';


class YCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const YCustomAppbar({
    super.key,
    this.title,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.backgroundColor,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Iconsax.arrow_left, color: YColors.dark))
          : leadingIcon != null
              ? IconButton(
                  onPressed: leadingOnPressed, icon: Icon(leadingIcon))
              : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(YDeviceUtils.appBarHeight());
}
