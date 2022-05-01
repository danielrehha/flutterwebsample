import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ApplicationShimmerContainer extends StatelessWidget {
  const ApplicationShimmerContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
/*     return Shimmer.fromColors(
      baseColor: lightGrey,
      highlightColor: Colors.white38,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Loading...",
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
    ); */
    return Shimmer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              SystemLang.LANG_MAP[SystemText.LOADING_DOTS][langIso639Code],
            ),
          ),
        ],
      ),
      direction: ShimmerDirection.fromLeftToRight(),
      color: shimmerColor,
    );
  }
}
