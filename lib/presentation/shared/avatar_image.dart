import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:allbert_cms/presentation/themes/theme_color.dart';

enum ImageSourceType {
  url,
  none,
}

class AvatarImageWidget extends StatefulWidget {
  AvatarImageWidget({
    Key key,
    this.image,
    this.color = 1,
    this.size = 50,
    this.isBusiness = false,
    this.icon,
  }) : super(key: key);

  final ApplicationImage image;
  final int color;
  final double size;
  final bool isBusiness;
  final Icon icon;

  @override
  _AvatarImageWidgetState createState() => _AvatarImageWidgetState();
}

class _AvatarImageWidgetState extends State<AvatarImageWidget> {
  double baseIconSize = 30.0;

  double baseAvatarSize = 50.0;

  ImageSourceType source = ImageSourceType.none;

  @override
  void initState() {
    super.initState();
  }

  void checkSource() {
    source = ImageSourceType.none;
    if (widget.image != null && widget.image.pathUrl != null) {
      source = ImageSourceType.url;
    }
  }

  Border getBorder() {
    if (widget.color == 1) {
      return null;
    } else if (widget.color == null) {
      return Border.all(color: Colors.grey, width: 2);
    } else {
      return Border.all(color: Color(widget.color), width: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconAvatarRatio = baseIconSize / baseAvatarSize;
    checkSource();
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(50),
        border: getBorder(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        clipBehavior: Clip.antiAlias,
        child: new OverflowBox(
          minWidth: 0.0,
          minHeight: 0.0,
          maxWidth: double.infinity,
          child: getImageFromSource(ratio: iconAvatarRatio),
        ),
      ),
    );
  }

  Widget getImageFromSource({double ratio}) {
    switch (source) {
      case ImageSourceType.url:
        return Image.network(
          widget.image.pathUrl,
          fit: BoxFit.cover,
        );
        break;
      case ImageSourceType.none:
        return Icon(
          widget.isBusiness
              ? MaterialCommunityIcons.store
              : Ionicons.ios_person,
          color: Colors.grey,
          size: ratio * widget.size,
        );
        break;
      default:
        return widget.icon == null
            ? Icon(
                Ionicons.ios_person,
                color: Colors.grey,
                size: ratio * widget.size,
              )
            : widget.icon;
        break;
    }
  }
}
