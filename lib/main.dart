import 'package:allbert_cms/data/implementations/datasource_auth.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/repositories/repository_auth.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/domain/repositories/repository_employee.dart';
import 'package:allbert_cms/domain/repositories/repository_service.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/sub_blocs/employee_query/appointment_employee_query_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_city_list/city_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_country_list/country_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_notification_list/notification_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_schedule/schedule_bloc.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/bloc/firebase_bloc/firebase_bloc.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/pages/auth/login/page_login.dart';
import 'package:allbert_cms/presentation/pages/auth/page_auth_router.dart';
import 'package:allbert_cms/presentation/pages/auth/page_lang_state_handler.dart';
import 'package:allbert_cms/presentation/pages/auth/page_user_state_handler.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/page_registration.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/page_verify_email.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/tabs/tab_registration_details.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/tabs/tab_registration_welcome.dart';
import 'package:allbert_cms/presentation/pages/dev_auth/page_dev_auth.dart';
import 'package:allbert_cms/presentation/providers/provider_application.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/providers/provider_notification.dart';
import 'package:allbert_cms/presentation/providers/provider_payment_method_selector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'presentation/bloc/bloc_appointment_list/sub_blocs/service_query/appointment_service_query_bloc.dart';
import 'presentation/bloc/bloc_customer_list/customer_list_bloc.dart';
import 'presentation/bloc/business_portfolio/bloc/business_portfolio_bloc.dart';
import 'presentation/bloc/employee_bloc/employee_bloc.dart';
import 'presentation/pages/auth/login/page_login.dart';
import 'presentation/pages/auth/registration/tabs/tab_registration_address.dart';
import 'presentation/pages/auth/registration/tabs/tab_registration_contact.dart';
import 'presentation/pages/auth/page_language_selection.dart';
import 'presentation/pages/content_holder.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
/*   final prefs = await SharedPreferences.getInstance();
  prefs.clear(); */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BusinessProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentMethodSelectorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ApplicationProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FirebaseBloc(
              repository: FirebaseAuthRepository(
                authSource: FirebaseAuthSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => EmployeeBloc(
              repository: EmployeeRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CalendarBloc(
              repository: EmployeeRepository(
                dataSource: ApiDataSource(),
              ),
              businessRepository: BusinessRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ServicesBloc(
              repository: ServiceRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => BusinessPortfolioBloc(
              repository: BusinessRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AppointmentListBloc(
              repository: BusinessRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CustomerListBloc(
              repository: BusinessRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AppointmentEmployeeQueryBloc(
              repository: EmployeeRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AppointmentServiceQueryBloc(
              repository: ServiceRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ScheduleBloc(
              repository: BusinessRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => NotificationListBloc(
              repository: BusinessRepository(
                dataSource: ApiDataSource(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CountryListBloc(),
          ),
          BlocProvider(
            create: (context) => CityListBloc(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('hu'),
          ],
          locale: const Locale('hu'),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (context) => ContentHolder());
                break;
              case '/auth/login':
                return MaterialPageRoute(builder: (context) => LoginPage());
                break;
              case '/auth/registration':
                return MaterialPageRoute(
                    builder: (context) => RegistrationPage());
                break;
              case '/auth/registration/welcome':
                return MaterialPageRoute(
                    builder: (context) => RegistrationWelcomeTab());
              case '/auth/registration/details':
                return MaterialPageRoute(
                    builder: (context) => RegistrationDetailsTab());
              case '/auth/registration/address':
                return MaterialPageRoute(
                    builder: (context) => RegistrationAddressTab());
              case '/auth/registration/contact':
                return MaterialPageRoute(
                    builder: (context) => RegistrationContactTab());
              case '/auth/language':
                return MaterialPageRoute(
                    builder: (context) => LanguageSelectionPage());
              case '/auth/router':
                return MaterialPageRoute(
                    builder: (context) => AuthRouterPage());
                break;
              case '/devauth':
                return MaterialPageRoute(builder: (context) => DevAuthPage());
              case '/auth/verify':
                return MaterialPageRoute(
                    builder: (context) => VerifyEmailPage());
              case '/auth/state/user':
                return MaterialPageRoute(
                    builder: (context) => UserStateHandlerPage());
              case '/auth/state/language':
                return MaterialPageRoute(
                    builder: (context) => LanguageStateHandlerPage());
              default:
                return null;
                break;
            }
          },
          initialRoute: '/auth/state/language',
          theme: ThemeData(
            textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
