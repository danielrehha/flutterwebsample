import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/business_portfolio/bloc/business_portfolio_bloc.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/portfolio_image_picker.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class BusinessImagesTab extends StatefulWidget {
  BusinessImagesTab({Key key}) : super(key: key);

  final ApiDataSource dataSource = ApiDataSource();
  final SnackBarActions snackBarActions = SnackBarActions();

  @override
  _BusinessImagesTabState createState() => _BusinessImagesTabState();
}

class _BusinessImagesTabState extends State<BusinessImagesTab> {
  bool _isUploading;

  bool _isDeleting;

  bool _portfolioUploadDisabled;

  int _subscriptionLimit;

  int _portfolioImageCount;

  @override
  void initState() {
    super.initState();

    _isUploading = false;

    _isDeleting = false;

    _portfolioUploadDisabled = true;

    getSubscriptionLimit();
  }

  void getSubscriptionLimit() {
    _subscriptionLimit = 5;
  }

  void setPortfolioUploadState(int imageCount) {
    bool value = false;
    if (imageCount >= _subscriptionLimit) {
      value = true;
    } else {
      value = false;
    }
    if (value != _portfolioUploadDisabled) {
      _portfolioUploadDisabled = value;
    }
    setState(() {
      _portfolioImageCount = imageCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 700, minHeight: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Portfólió képek",
          ),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            style: bodyStyle_2_grey,
          ),
          SizedBox(
            height: 10,
          ),
          BlocConsumer<BusinessPortfolioBloc, BusinessPortfolioState>(
            listener: (context, state) {
              if (state is BusinessPortfolioLoadedState) {
                setPortfolioUploadState(state.images.length);
              }
              if (state is BusinessPortfolioErrorState) {
                setState(() {
                  _portfolioUploadDisabled = true;
                });
              }
            },
            builder: (context, state) {
              if (state is BusinessPortfolioInitial) {
                final businessId =
                    Provider.of<BusinessProvider>(context, listen: false)
                        .businessId;
                BlocProvider.of<BusinessPortfolioBloc>(context)
                    .add(FetchBusinessPortfolioEvent(businessId));
              }
              if (state is BusinessPortfolioErrorState) {
                return Text(state.failure.errorMessage);
              }
              if (state is BusinessPortfolioLoadedState) {
                //return buildPortfolioImages(state.images);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: PortfolioImagePicker(
                            maxImageCount: 5,
                            images: state.images,
                            onUpload: (file) {},
                            onDelete: (image) async {
                              await deletePortfolioImageAsync(image.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ApplicationLoadingIndicator(),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          ApplicationContainerButton(
            loadingIndicatorColor: Colors.white,
            loadingOnDisabled:
                _portfolioUploadDisabled || _isDeleting ? false : true,
            disabledColor: _portfolioUploadDisabled || _isDeleting
                ? Color.fromRGBO(10, 10, 10, 0.09)
                : themeColors[ThemeColor.blue],
            color: themeColors[ThemeColor.blue],
            disabled: _isUploading || _isDeleting || _portfolioUploadDisabled,
            label:
                "Kép feltöltése ${getPortfolioButtonText(imageCount: _portfolioImageCount)}",
            onPress: () async {
              await openPortfolioImagePicker();
            },
          ),
        ],
      ),
    );
  }

  String getPortfolioButtonText({int imageCount}) {
    if (imageCount == null) {
      return "";
    }
    return "(${imageCount}/$_subscriptionLimit)";
  }

  Widget buildPortfolioImages(List<ApplicationImage> images) {
    return Container(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          if (images.length < 3 && index == images.length - 1) {
            return Row(
              children: [],
            );
          }
          return portfolioImageView(images[index]);
        },
      ),
    );
  }

  Widget emptyPortfolioImageView() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey].withAlpha(70),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Entypo.image,
        size: 75,
      ),
    );
  }

  Widget portfolioImageView(ApplicationImage image) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Image(
        image: NetworkImage(
          image.pathUrl,
        ),
      ),
    );
  }

  void openPortfolioImagePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['jpg, jpeg, png'],
      allowMultiple: false,
    );

    if (result != null) {
      await uploadPortfolioImageAsync(result.files[0]);
    }
  }

  void uploadPortfolioImageAsync(PlatformFile file) async {
    setState(() {
      _isUploading = true;
    });
    widget.snackBarActions.dispatchLoadingSnackBar(context);
    try {
      final businessId =
          Provider.of<BusinessProvider>(context, listen: false).businessId;
      await widget.dataSource.uploadBusinessPortfolioImageAsync(
          businessId: businessId, file: file);
      BlocProvider.of<BusinessPortfolioBloc>(context)
          .add(FetchBusinessPortfolioEvent(businessId));
      widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isUploading = false;
    });
  }

  void deletePortfolioImageAsync(String fileId) async {
    if (!_isDeleting && !_isUploading) {
      setState(() {
        _isDeleting = true;
      });
      widget.snackBarActions.dispatchLoadingSnackBar(context);
      try {
        final businessId =
            Provider.of<BusinessProvider>(context, listen: false).businessId;
        await widget.dataSource.deleteBusinessPortfolioImageAsync(
            businessId: businessId, fileId: fileId);
        BlocProvider.of<BusinessPortfolioBloc>(context)
            .add(FetchBusinessPortfolioEvent(businessId));
        widget.snackBarActions.dispatchSuccessSnackBar(context);
      } on ServerException catch (e) {
        widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
      } on Exception catch (e) {
        widget.snackBarActions
            .dispatchErrorSnackBar(context, err: e.toString());
      }
      setState(() {
        _isDeleting = false;
      });
    }
  }
}
