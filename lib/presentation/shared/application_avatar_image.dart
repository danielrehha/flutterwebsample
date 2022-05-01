import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

enum ImageSourceType {
  url,
  none,
  bytes,
  imageProvider,
}

class ApplicationAvatarImage extends StatefulWidget {
  ApplicationAvatarImage({
    Key key,
    this.image,
    this.color = 1,
    this.size = 50,
    this.isBusiness = false,
    this.icon,
    this.radius = 100,
    this.imageProvider,
  }) : super(key: key);

  final ApplicationImage image;
  final int color;
  final double size;
  final bool isBusiness;
  final Icon icon;
  final double radius;
  final ImageProvider<Object> imageProvider;

  @override
  _ApplicationAvatarImageState createState() => _ApplicationAvatarImageState();
}

class _ApplicationAvatarImageState extends State<ApplicationAvatarImage> {
  double baseIconSize = 30.0;

  double baseAvatarSize = 50.0;

  ImageSourceType source = ImageSourceType.none;

  @override
  void initState() {
    super.initState();
  }

  void checkSource() {
    if (widget.imageProvider != null) {
      source = ImageSourceType.imageProvider;
      return;
    }
    if (widget.image == null) {
      source = ImageSourceType.none;
      return;
    }
    if (widget.image.bytes != null) {
      source = ImageSourceType.bytes;
      return;
    }
    if (widget.image != null && widget.image.pathUrl != null) {
      source = ImageSourceType.url;
      return;
    }
    source = ImageSourceType.none;
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
        borderRadius: BorderRadius.circular(widget.radius),
        border: getBorder(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
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
      case ImageSourceType.imageProvider:
        return Image(
          image: widget.imageProvider,
          fit: BoxFit.fill,
        );
      case ImageSourceType.url:
        return Image.network(
          widget.image.pathUrl,
          fit: BoxFit.fill,
        );
        break;
      case ImageSourceType.bytes:
        return Image.memory(
          widget.image.bytes,
          fit: BoxFit.fill,
        );
        break;
      case ImageSourceType.none:
        return Icon(
          widget.isBusiness
              ? MaterialCommunityIcons.store
              : Ionicons.ios_person,
          color: Colors.grey,
          size: widget.size == null ? null : ratio * widget.size,
        );
        break;
      default:
        return widget.icon == null
            ? Icon(
                Ionicons.ios_person,
                color: Colors.grey,
                size: widget.size == null ? null : ratio * widget.size,
              )
            : widget.icon;
        break;
    }
  }
}
