import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'portfolio_image.dart';

class PortfolioImagePicker extends StatefulWidget {
  PortfolioImagePicker(
      {@required this.images,
      @required this.onUpload,
      @required this.onDelete,
      @required this.maxImageCount,
      Key key})
      : super(key: key);

  final List<ApplicationImage> images;
  final Function(PlatformFile) onUpload;
  final Function(ApplicationImage) onDelete;

  final int maxImageCount;

  @override
  _PortfolioImagePickerState createState() => _PortfolioImagePickerState();
}

class _PortfolioImagePickerState extends State<PortfolioImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildPortfolioImages(),
        buildPortfolioImagePlaceholders(),
      ],
    );
  }

  void openPortfolioImagePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['jpg, jpeg, png'],
      allowMultiple: false,
    );

    if (result != null) {
      widget.onUpload(result.files[0]);
    }
  }

  Widget buildPortfolioImages() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return PortfolioImage(
            image: widget.images[index],
            onDeleteCallback: (image) {
              widget.onDelete(image);
            },
          );
        },
      ),
    );
  }

  Widget buildPortfolioImagePlaceholders() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.maxImageCount - widget.images.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: portfolioImagePickerContainer(),
          );
        },
      ),
    );
  }

  Widget portfolioImagePickerContainer() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: InkWell(
            child: Icon(Entypo.image, size: 40),
            onTap: () {
              openPortfolioImagePicker();
            }),
      ),
    );
  }
}
