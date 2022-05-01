import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_business_details.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_business_details.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessInfoTabV2 extends StatefulWidget {
  BusinessInfoTabV2({Key key}) : super(key: key);

  final SnackBarActions snackBarActions = SnackBarActions();
  final ApiDataSource dataSource = ApiDataSource();

  @override
  _BusinessInfoTabV2State createState() => _BusinessInfoTabV2State();
}

class _BusinessInfoTabV2State extends State<BusinessInfoTabV2> {
  TextEditingController nameController = TextEditingController();

  TextEditingController typeController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  bool nameError = false;

  bool typeError = false;

  bool descriptionError = false;

  BusinessDetails details;

  bool _isLoading;

  bool _isEdited;

  bool _isAvatarImageUploading;

  bool _isAvatarImageDeleting;

  bool _isAvatarImageUploaded;

  ApplicationImage avatarImage;

  @override
  void initState() {
    super.initState();

    _isEdited = false;

    updateInfo();

    _isLoading = false;

    _isAvatarImageUploading = false;

    _isAvatarImageDeleting = false;

    updateAvatarImage();
  }

  void updateInfo() {
    details =
        Provider.of<BusinessProvider>(context, listen: false).business.details;

    nameController.text = details.name;
    typeController.text = details.type;
    descriptionController.text = descriptionController.text;
  }

  void updateAvatarImage() {
    avatarImage =
        Provider.of<BusinessProvider>(context, listen: false).avatarImage;

    if (avatarImage == null || avatarImage.pathUrl == null) {
      _isAvatarImageUploaded = false;
    } else {
      _isAvatarImageUploaded = true;
    }
  }

  bool validateFields() {
    bool showError = false;
    String fieldName = "field";
    String errorMessage = "cannot be empty";
    if (typeController.text.isEmpty) {
      showError = true;
      fieldName = "Business type";
    }
    if (nameController.text.isEmpty) {
      showError = true;
      fieldName = "Business name";
    }
    if (showError) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: "$fieldName $errorMessage");
    }
    return !showError;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 700, minHeight: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ApplicationAvatarImage(
                image: avatarImage,
                size: 100,
              ),
              SizedBox(
                height: 8,
              ),
              ApplicationTextButton(
                fontWeight: FontWeight.bold,
                label: "Profilkép törlése",
                color: Colors.black,
                disabled: !_isAvatarImageUploaded ||
                    _isAvatarImageDeleting ||
                    _isAvatarImageUploading,
                onPress: () async {
                  await deleteAvatarImageAsync();
                },
              ),
              SizedBox(
                height: 8,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: Row(
                  children: [
                    Expanded(
                      child: ApplicationContainerButton(
                        label: "Profilkép feltöltése",
                        color: themeColors[ThemeColor.blue],
                        disabledColor: _isAvatarImageUploading
                            ? themeColors[ThemeColor.blue]
                            : Color.fromRGBO(10, 10, 10, 0.09),
                        disabled:
                            _isAvatarImageUploading || _isAvatarImageUploaded,
                        loadingOnDisabled: _isAvatarImageUploading,
                        onPress: () async {
                          await openAvatarImagePickerAsync();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc. Sed luctus tortor at varius semper. Nunc magna nulla, cursus et enim pharetra, dapibus iaculis nunc. Suspendisse potenti. Fusce eget efficitur ex. Vivamus eleifend elit quis justo tincidunt, eu congue est molestie",
            style: bodyStyle_2_grey,
          ),
          SizedBox(
            height: 30,
          ),
          Text('Üzlet neve *'),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            style: bodyStyle_2_grey,
          ),
          ApplicationTextField(
            textAlign: TextAlign.start,
            controller: nameController,
            error: nameError,
            maxLength: 40,
            showLength: true,
            canBeEmpty: false,
          ),
          Text('Kategória *'),
          ApplicationTextField(
            controller: typeController,
            textAlign: TextAlign.start,
            error: typeError,
            showLength: true,
            maxLength: 40,
            hintText: 'pl. Barber Shop, Pszichológiai magánrendelő, ..',
            canBeEmpty: false,
          ),
          Text('Leírás'),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
            style: bodyStyle_2_grey,
          ),
          Container(
            height: 120,
            child: ApplicationTextField(
              textAlignVertical: TextAlignVertical.top,
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              error: descriptionError,
              maxLength: 120,
              maxLines: null,
              showLength: true,
              canBeEmpty: false,
              expands: true,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ApplicationTextButton(
                label: "Változtatások mentése",
                fontWeight: FontWeight.bold,
                disabled:
                    _isLoading || /* !_isEdited || */ _isAvatarImageUploading ||
                        _isAvatarImageDeleting,
                onPress: () async {
                  if (validateFields()) {
                    await saveInfoAsync();
                  }
                },
                color: Colors.black,
              ),
            ],
          )
        ],
      ),
    );
  }

  void saveInfoAsync() async {
    setState(() {
      _isLoading = true;
    });
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;
    final details = BusinessDetailsModel(
      businessId: businessId,
      name: nameController.text,
      type: typeController.text,
      description: descriptionController.text,
    );
    try {
      await widget.dataSource.updateBusinessDetailsAsync(
        businessId: businessId,
        details: details,
      );
      final oldBusiness =
          Provider.of<BusinessProvider>(context, listen: false).business;
      Provider.of<BusinessProvider>(context, listen: false)
          .update(business: oldBusiness.copyWith(details: details));
      updateInfo();
      widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void openAvatarImagePickerAsync() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['jpg, jpeg, png'],
      allowMultiple: false,
    );

    if (result != null) {
      await uploadAvatarImageAsync(result.files[0]);
    }
  }

  void deleteAvatarImageAsync() async {
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;

    setState(() {
      _isAvatarImageDeleting = true;
    });
    widget.snackBarActions.dispatchLoadingSnackBar(context);
    try {
      await widget.dataSource
          .deleteBusinessAvatarImageAsync(businessId: businessId);
      Provider.of<BusinessProvider>(context, listen: false)
          .setAvatar(avatar: null);
      updateAvatarImage();
      widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isAvatarImageDeleting = false;
    });
  }

  void uploadAvatarImageAsync(PlatformFile file) async {
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;

    setState(() {
      _isAvatarImageUploading = true;
    });
    widget.snackBarActions.dispatchLoadingSnackBar(context);
    try {
      final result = await widget.dataSource
          .uploadBusinessAvatarImageAsync(businessId: businessId, file: file);
      avatarImage = result;
      Provider.of<BusinessProvider>(context, listen: false).update(
        business: Provider.of<BusinessProvider>(context, listen: false)
            .business
            .copyWith(avatar: result),
      );
      updateAvatarImage();
      widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isAvatarImageUploading = false;
    });
  }
}
