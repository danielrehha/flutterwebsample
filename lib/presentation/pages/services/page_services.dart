import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/pages/error/container_error.dart';
import 'package:allbert_cms/presentation/pages/services/page_create_service.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/pages/services/widget_service.dart';
import 'package:allbert_cms/presentation/shared/application_page_header_text.dart';
import 'package:allbert_cms/presentation/themes/theme_animation.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_size.dart';

class ServicesPage extends StatefulWidget {
  ServicesPage({Key key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    final provider = Provider.of<BusinessProvider>(context);
    return Padding(
      padding: defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ApplicationPageHeaderText(
                  label: SystemText.SIDEBAR_ITEM_SERVICES),
              Spacer(),
              Container(
                width: 150,
                child: ApplicationContainerButton(
                  label: SystemLang.LANG_MAP[SystemText.CREATE][langIso639Code],
                  onPress: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: CreateServicePage(),
                          duration: globalPageTransitionDuration,
                        ));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: paddingBelowHeader,
          ),
          Expanded(
            child: BlocConsumer<ServicesBloc, ServicesState>(
              listener: (context, state) {
                if (state is ServicesLoadedState) {
                 
                }
              },
              builder: (context, state) {
                if (state is ServicesInitial) {
                  BlocProvider.of<ServicesBloc>(context).add(
                      FetchServicesEvent(businessId: provider.business.id));
                }
                if (state is ServicesLoadedState) {
                  if (state.services.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Nincs hozzáadott szolgáltatás',
                          style: headerStyle_3_bold,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                            "Adjon hozzá szolgáltatást, majd rendelje hozzá szakembereihez")
                      ],
                    );
                  }
                  return SingleChildScrollView(
                    child: buildServices(services: state.services),
                  );
                }
                if (state is ServicesErrorState) {
                  return Center(
                    child: ErrorContainer(
                      failure: state.failure,
                      errorHandlerCallback: () {
                        BlocProvider.of<ServicesBloc>(context).add(
                          FetchServicesEvent(
                              businessId: Provider.of<BusinessProvider>(context,
                                      listen: false)
                                  .businessId),
                        );
                      },
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ApplicationLoadingIndicator(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildServices({@required List<ServiceModel> services}) {
    return ListView.builder(
      itemCount: services.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: applicationListWidgetPadding,
          child: ServiceWidget(
            service: services[index],
          ),
        );
      },
    );
  }
}
