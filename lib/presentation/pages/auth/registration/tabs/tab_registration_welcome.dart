import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/contracts/i_datasource_local.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_local.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/util_registration.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationWelcomeTab extends StatefulWidget {
  RegistrationWelcomeTab({Key key}) : super(key: key);

  final IApiDataSource dataSource = ApiDataSource();
  final ILocalDataSource localDataSource = LocalDataSource();
  final RegistrationUtil registrationUtil = RegistrationUtil();
  final SnackBarActions snackBarActions = SnackBarActions();

  @override
  _RegistrationWelcomeTabState createState() => _RegistrationWelcomeTabState();
}

class _RegistrationWelcomeTabState extends State<RegistrationWelcomeTab> {
  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: CachedNetworkImage(
              imageUrl:
                  "https://allbert-vector-images.s3.eu-central-1.amazonaws.com/sprite_registration_welcome.jpg",
              placeholder: (context, url) => SizedBox(),
              errorWidget: (context, url, error) {
                print(error);
                return Icon(Icons.error);
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ApplicationContainerButton(
              loadingOnDisabled: true,
              disabled: _isLoading,
              label: SystemLang.LANG_MAP[SystemText.NEXT]
                  [langIso639Code],
              onPress: () async {
                await createBusinessAsync();
              },
            ),
          ),
        ],
      ),
    );
  }

  void createBusinessAsync() async {
    setState(() {
      _isLoading = true;
    });

    final firebaseUid =
        Provider.of<FirebaseUserProvider>(context, listen: false).firebaseUid;
    final langIso639Code =
        await widget.localDataSource.loadLangIso639CodeAsync();
    try {
      final result = await widget.dataSource.createBusinessAsyncV2(
          firebaseUid: firebaseUid, langIso639Code: langIso639Code);
      Provider.of<BusinessProvider>(context, listen: false)
          .update(business: result);
      widget.registrationUtil.pushRegistrationPageByBusiness(context, result);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }
}
