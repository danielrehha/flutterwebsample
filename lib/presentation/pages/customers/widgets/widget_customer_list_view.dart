import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_list_view.dart';
import 'package:allbert_cms/domain/helpers/customer_query_parameters.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/bloc_customer_list/customer_list_bloc.dart';
import 'package:allbert_cms/presentation/popups/action_confirmation_popup.dart';
import 'package:allbert_cms/presentation/popups/popup_customer_details.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class CustomerListViewWidget extends StatelessWidget {
  CustomerListViewWidget({Key key, this.customerListView}) : super(key: key);

  final CustomerListView customerListView;
  final PersonNameResolver nameResolver = PersonNameResolver();
  final SnackBarActions snackBarActions = SnackBarActions();
  final ApiDataSource dataSource = ApiDataSource();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return CustomerDetailsPopup(
              customerId: customerListView.customer.id,
            );
          },
        );
      },
      child: ApplicationWidgetContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              child: Text(
                nameResolver.cultureBasedResolve(
                  firstName: customerListView.customer.info.firstName,
                  lastName: customerListView.customer.info.lastName,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: 150,
              child: Text(
                customerListView.appointmentCount.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 150,
              child: Text(
                getBannedText(),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 50,
              child: PopupMenuButton(
                  icon: Icon(
                    Entypo.dots_three_vertical,
                  ),
                  onSelected: (value) {
                    final action = getPopupMenuItemAction(context, value);
                    action();
                  },
                  itemBuilder: (context) {
                    return getPopupMenuItems();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> banCustomerAsync(BuildContext context) async {
    try {
      final businessId =
          Provider.of<BusinessProvider>(context, listen: false).businessId;
      snackBarActions.dispatchLoadingSnackBar(context);
      await dataSource.banCustomerAsync(
          businessId: businessId, customerId: customerListView.customer.id);
      snackBarActions.dispatchSuccessSnackBar(context);
      BlocProvider.of<CustomerListBloc>(context).add(
        FetchCustomerListEvent(
          businessId,
          parameters: CustomerQueryParameters(),
        ),
      );
    } on ServerException catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
  }

  Future<void> unBanCustomerAsync(BuildContext context) async {
    try {
      final businessId =
          Provider.of<BusinessProvider>(context, listen: false).businessId;
      snackBarActions.dispatchLoadingSnackBar(context);
      await dataSource.unBanCustomerAsync(
          businessId: businessId, customerId: customerListView.customer.id);
      snackBarActions.dispatchSuccessSnackBar(context);
      BlocProvider.of<CustomerListBloc>(context).add(
        FetchCustomerListEvent(
          businessId,
          parameters: CustomerQueryParameters(),
        ),
      );
    } on ServerException catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
  }

  Function getPopupMenuItemAction(
      BuildContext context2, CustomerPopupMenuItemAction action) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context2, listen: false).langIso639Code;
    if (action == CustomerPopupMenuItemAction.Ban) {
      return () {
        showDialog(
          context: context2,
          builder: (context) {
            return ActionConfirmationPopup(
              popPageCount: 1,
              asyncOperation: () async {
                await banCustomerAsync(context);
              },
              headerText: SystemLang.LANG_MAP[SystemText.BAN_CUSTOMER]
                  [langIso639Code],
              descriptionText: SystemLang.LANG_MAP[SystemText.BAN_CUSTOMER_HINT]
                  [langIso639Code],
              continueButtonLabel: SystemLang.LANG_MAP[SystemText.BAN]
                  [langIso639Code],
              cancelButtonLabel: SystemLang.LANG_MAP[SystemText.CANCEL]
                  [langIso639Code],
            );
          },
        );
      };
    }
    if (action == CustomerPopupMenuItemAction.Unban) {
      return () {
        showDialog(
          context: context2,
          builder: (context) {
            return ActionConfirmationPopup(
              popPageCount: 1,
              asyncOperation: () async {
                await unBanCustomerAsync(context);
              },
              headerText: SystemLang.LANG_MAP[SystemText.UNBAN_CUSTOMER]
                  [langIso639Code],
              descriptionText: SystemLang
                  .LANG_MAP[SystemText.UNBAN_CUSTOMER_HINT][langIso639Code],
              continueButtonLabel: SystemLang.LANG_MAP[SystemText.UNBAN]
                  [langIso639Code],
              cancelButtonLabel: SystemLang.LANG_MAP[SystemText.CANCEL]
                  [langIso639Code],
            );
          },
        );
      };
    }
    return () {
      showDialog(
          context: context2,
          builder: (context) {
            return CustomerDetailsPopup(
              customerId: customerListView.customer.id ?? null,
            );
          });
    };
  }

  List<Widget> getPopupMenuItems() {
    List<PopupMenuItem> items = [
      PopupMenuItem(
        value: CustomerPopupMenuItemAction.Details,
        child: Text("Vendég adatai"),
      ),
    ];
    if (customerListView.banned) {
      items.insert(
        0,
        PopupMenuItem(
          value: CustomerPopupMenuItemAction.Unban,
          child: Text("Tiltás feloldása"),
        ),
      );
    }
    if (!customerListView.banned) {
      items.insert(
        0,
        PopupMenuItem(
          value: CustomerPopupMenuItemAction.Ban,
          child: Text("Letiltás"),
        ),
      );
    }
    return items;
  }

  String getBannedText() {
    if (customerListView.banned) {
      return "Letiltott";
    }
    return "Aktív";
  }

  Widget header() {
    return null;
  }
}

enum CustomerPopupMenuItemAction {
  Ban,
  Unban,
  Details,
}
