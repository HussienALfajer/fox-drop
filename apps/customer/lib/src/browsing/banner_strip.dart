import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../media_image.dart';
import 'browsing.dart';

/// The banners' size (AP §9.11.2, owner decision 2026-11-18): 1200×500.
const bannerAspect = 1200 / 500;

/// «البانرات» on home (CU §8.1, slice 2.27c): the banners in the panel's
/// order, swiped one at a time across the screen's width, each opening its
/// target. Unstyled until the design.
class BannerStrip extends StatelessWidget {
  const BannerStrip({super.key, required this.banners});

  final List<HomeBanner> banners;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width / bannerAspect;
        return Semantics(
          label: l10n.customerBanners,
          container: true,
          child: SizedBox(
            key: const Key('banners'),
            height: height,
            child: PageView(
              children: [
                for (final banner in banners)
                  InkWell(
                    key: Key('banner-${banner.id}'),
                    onTap: () => context.push(bannerPath(banner)),
                    child: MediaImage(
                      imageKey: banner.imageKey,
                      width: width,
                      height: height,
                      label: banner.title,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
