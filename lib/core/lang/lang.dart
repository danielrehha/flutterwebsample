enum SystemText {
  PAGE_SETTINGS_HEADER,
  PAGE_SETTINGS_MENU_OTHER,
  PAGE_SETTINGS_MENU_EMAIL,
  PAGE_SETTINGS_MENU_PASSWORD,
  SIDEBAR_ITEM_CALENDAR,
  SIDEBAR_ITEM_SCHEDULER,
  SIDEBAR_ITEM_EMPLOYEES,
  SIDEBAR_ITEM_SERVICES,
  SIDEBAR_ITEM_SETTINGS,
  SIDEBAR_ITEM_PROFILE,
  SIDEBAR_ITEM_APPOINTMENTS,
  SIDEBAR_ITEM_CUSTOMERS,
  SIDEBAR_ITEM_DASHBOARD,
  SIDEBAR_ITEM_BILLING,
  SIDEBAR_ITEM_ADDRESS,
  SIDEBAR_ITEM_RATINGS,
  SIDEBAR_ITEM_INFO,
  EMAIL,
  PASSWORD,
  PASSWORD_CONFIRM,
  CREATE_ACCOUNT,
  LOG_IN,
  LOG_OUT,
  SIGNUP,
  SIGNUP_QUESTION,
  REGISTRATION,
  NEW_ACCOUNT,
  CONFIRM_EMAIL,
  CONFIRM_EMAIL_TEXT_1,
  CONFIRM_EMAIL_TEXT_2,
  REFRESH,
  CONFIRM_EMAIL_DIDNTRECEIVE,
  CONFIRM_EMAIL_RESEND,
  CONFIRM_EMAIL_SENT,
  CONFIRM_EMAIL_FAILED,
  INTRODUCTION,
  INTRODUCTION_HINT,
  BUSINESS_NAME,
  BUSINESS_CATEGORY,
  BUSINESS_CATEGORY_HINT,
  BUSINESS_DESCRIPTION,
  BUSINESS_DESCRIPTION_HINT,
  COUNTRY,
  CITY,
  STREET_NAME,
  STREET_TYPE,
  STREET_NUMBER,
  ZIPCODE,
  NEXT,
  BACK,
  CREATE,
  DELETE,
  SAVE,
  CANNOT_BE_EMPTY,
  IS_NOT_VALID,
  ADDRESS,
  ADDRESS_HINT,
  ADDRESS_DESCRIPTION,
  ADDRESS_DESCRIPTION_HINT,
  SELECT,
  FIRST_NAME,
  LAST_NAME,
  CONTACT_DETAILS,
  CONTACT_DETAILS_HINT,
  PHONE_NUMBER,
  JOB,
  EMPLOYEE_DESCRIPTION_HINT,
  COLOR,
  NEW_EMPLOYEE,
  CANCEL,
  EMPTY_SERVICE_LIST,
  EMPTY_SERVICE_LIST_DESCRIPTION,
  EMPTY_EMPLOYEE_LIST,
  EMPTY_EMPLOYEE_LIST_DESCRIPTION,
  SELECT_AVATAR_IMAGE,
  REMOVE_AVATAR_IMAGE,
  RATINGS,
  SETTINGS,
  INFORMATION,
  CLOSE,
  DATE,
  TIMEOFDAY,
  CREATE_APT_NO_SERVICE_ERROR,
  SELECT_CUSTOMER,
  SELECT_SERVICE,
  NO_ADDED_SERVICE,
  NO_PAST_DATE_ALLOWED,
  APT_DETAILS,
  CREATE_APT,
  LOADING_DOTS,
  OPERATION_FAILED,
  OPERATION_SUCCESS,
  OPERATION_IN_PROGRESS,
  EMPSTGS_CREATION_MIN,
  EMPSTGS_DELETE_MIN,
  EMPSTGS_BOOKING_FREQ,
  EMPSTGS_MIN_INDEX,
  EMPSTGS_APT,
  HOURS,
  MINUTES,
  ANY,
  CREATED_ON,
  ADDED_ON,
  OTHER,
  DELETE_EMPLOYEE,
  SERVICE_NAME,
  SERVICE_COST,
  SERVICE_DURATION,
  CURRENCY,
  ADD,
  CREATE_SERVICE,
  SERVICE_DETAILS,
  PAUSE_SERVICE,
  DELETE_SERVICE,
  UPDATE_SERVICE,
  PAUSE_EMPLOYEE,
  ACTIVATE,
  ACTIVATE_EMPLOYEE,
  ACTIVATE_SERVICE,
  PAUSE,
  DISABLE_EMPLOYEE,
  ENTITY_STATUS_ACTIVE,
  ENTITY_STATUS_INACTIVE,
  DELETED,
  NOT_FOUND,
  EMPLOYEE,
  SERVICE,
  CUSTOMER,
  BUSINESS,
  WORKBLOCK,
  APPOINTMENT,
  CREATE_WORKBLOCK,
  CREATE_WORKBLOCK_MINUTES_ERROR,
  WORKBLOCK_DESCRIPTION_HINT,
  DELETE_APPOINTMENT,
  DELETE_WORKBLOCK,
  WORKBLOCK_DETAILS,
  APPOINTMENT_DETAILS,
  CASH,
  CREDIT_CARD,
  SZEPCARD,
  DEBIT_CARD,
  BAN_CUSTOMER,
  UNBAN_CUSTOMER,
  BAN_CUSTOMER_HINT,
  UNBAN_CUSTOMER_HINT,
  BAN,
  UNBAN,
  STATISTICS,
}

class SystemLang {
  static const Map<SystemText, Map<String, String>> LANG_MAP = {
    SystemText.PAGE_SETTINGS_HEADER: {
      "hu": "Be??ll??t??sok",
      "en": "Settings",
    },
    SystemText.PAGE_SETTINGS_MENU_OTHER: {
      "hu": "Egy??b",
      "en": "Other",
    },
    SystemText.PAGE_SETTINGS_MENU_EMAIL: {
      "hu": "E-mail c??m megv??ltoztat??sa",
      "en": "Change email address",
    },
    SystemText.PAGE_SETTINGS_MENU_PASSWORD: {
      "hu": "Jelsz?? megv??ltoztat??sa",
      "en": "Change password",
    },
    SystemText.SIDEBAR_ITEM_CALENDAR: {
      "hu": "Napt??r",
      "en": "Calendar",
    },
    SystemText.SIDEBAR_ITEM_SCHEDULER: {
      "hu": "Beoszt??s",
      "en": "Scheduler",
    },
    SystemText.SIDEBAR_ITEM_EMPLOYEES: {
      "hu": "Alkalmazottak",
      "en": "Employees",
    },
    SystemText.SIDEBAR_ITEM_SERVICES: {
      "hu": "Szolg??ltat??sok",
      "en": "Services",
    },
    SystemText.SIDEBAR_ITEM_SETTINGS: {
      "hu": "Be??ll??t??sok",
      "en": "Settings",
    },
    SystemText.SIDEBAR_ITEM_PROFILE: {
      "hu": "Profil",
      "en": "Profile",
    },
    SystemText.SIDEBAR_ITEM_ADDRESS: {
      "hu": "C??m adatok",
      "en": "Address",
    },
    SystemText.SIDEBAR_ITEM_RATINGS: {
      "hu": "??rt??kel??sek",
      "en": "Ratings",
    },
    SystemText.SIDEBAR_ITEM_INFO: {
      "hu": "Bemutatkoz??s",
      "en": "Details",
    },
    SystemText.SIDEBAR_ITEM_APPOINTMENTS: {
      "hu": "Foglal??sok",
      "en": "Appointments",
    },
    SystemText.SIDEBAR_ITEM_CUSTOMERS: {
      "hu": "Vend??gek",
      "en": "Customers",
    },
    SystemText.SIDEBAR_ITEM_DASHBOARD: {
      "hu": "??ttekint??s",
      "en": "Dashboard",
    },
    SystemText.SIDEBAR_ITEM_BILLING: {
      "hu": "El??fizet??s",
      "en": "Subscription",
    },
    SystemText.EMAIL: {
      "hu": "E-mail c??m",
      "en": "Email address",
    },
    SystemText.PASSWORD: {
      "hu": "Jelsz??",
      "en": "Password",
    },
    SystemText.LOG_IN: {
      "hu": "Bel??p??s",
      "en": "Sign in",
    },
    SystemText.LOG_OUT: {
      "hu": "Kil??p??s",
      "en": "Sign out",
    },
    SystemText.SIGNUP: {
      "hu": "V??llalkoz??i fi??k l??trehoz??sa",
      "en": "Create business account",
    },
    SystemText.SIGNUP_QUESTION: {
      "hu": "M??g nem regisztr??lt??l?",
      "en": "Didn't sign up yet?",
    },
    SystemText.PASSWORD_CONFIRM: {
      "hu": "Jelsz?? megism??tl??se",
      "en": "Confirm password",
    },
    SystemText.CREATE_ACCOUNT: {
      "hu": "Fi??k l??trehoz??sa",
      "en": "Create account",
    },
    SystemText.REGISTRATION: {
      "hu": "Regisztr??ci??",
      "en": "Registration",
    },
    SystemText.NEW_ACCOUNT: {
      "hu": "??j fi??k",
      "en": "New account",
    },
    SystemText.CONFIRM_EMAIL: {
      "hu": "Er??s??tsd meg az e-mail c??med!",
      "en": "Confirm your email address!",
    },
    SystemText.CONFIRM_EMAIL_TEXT_1: {
      "hu": "Meger??s??t?? levelet k??ldt??nk a(z) ",
      "en": "We sent an email to ",
    },
    SystemText.CONFIRM_EMAIL_TEXT_2: {
      "hu":
          " c??mre. Amint meger??s??tetted az e-mail c??medet ez az oldal automatikusan elt??nik. Amennyiben nem friss??l az oldal, kattints a friss??t??s gombra.",
      "en":
          ". After confirming your email address this page will disappear. In case the page doesn't refresh, manually hit refresh",
    },
    SystemText.REFRESH: {
      "hu": "Friss??t??s",
      "en": "Refresh",
    },
    SystemText.CONFIRM_EMAIL_DIDNTRECEIVE: {
      "hu": "Nem kapt??l levelet?",
      "en": "Didn't receive the email?",
    },
    SystemText.CONFIRM_EMAIL_RESEND: {
      "hu": "Meger??s??t?? lev??l ??jrak??ld??se",
      "en": "Resend confirmation email",
    },
    SystemText.CONFIRM_EMAIL_SENT: {
      "hu": "??j meger??s??t?? level??nket elk??ldt??k ??nnek!",
      "en": "New confirmation email has been sent!",
    },
    SystemText.CONFIRM_EMAIL_FAILED: {
      "hu": "E-mail c??me nincs meger??s??tve.",
      "en": "Email address has not been verified.",
    },
    SystemText.INTRODUCTION: {
      "hu": "Bemutatkoz??s",
      "en": "Introduction",
    },
    SystemText.INTRODUCTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.BUSINESS_NAME: {
      "hu": "??zlet neve",
      "en": "Business name",
    },
    SystemText.BUSINESS_CATEGORY: {
      "hu": "Kateg??ria",
      "en": "Category",
    },
    SystemText.BUSINESS_CATEGORY_HINT: {
      "hu": "pl. Barber Shop, ??gyv??di Iroda, ..",
      "en": "ex. Barber Shop, Law Office, ..",
    },
    SystemText.BUSINESS_DESCRIPTION: {
      "hu": "Le??r??s",
      "en": "Description",
    },
    SystemText.BUSINESS_DESCRIPTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.COUNTRY: {
      "hu": "Orsz??g",
      "en": "Country",
    },
    SystemText.CITY: {
      "hu": "V??ros",
      "en": "City",
    },
    SystemText.STREET_NAME: {
      "hu": "K??zter??let neve",
      "en": "Street",
    },
    SystemText.STREET_TYPE: {
      "hu": "K??zter??let jellege",
      "en": "Address type",
    },
    SystemText.STREET_NUMBER: {
      "hu": "H??zsz??m",
      "en": "Street number",
    },
    SystemText.ZIPCODE: {
      "hu": "Ir??ny??t??sz??m",
      "en": "Zip code",
    },
    SystemText.NEXT: {
      "hu": "Tov??bb",
      "en": "Next",
    },
    SystemText.BACK: {
      "hu": "Vissza",
      "en": "Back",
    },
    SystemText.CREATE: {
      "hu": "L??trehoz??s",
      "en": "Create",
    },
    SystemText.DELETE: {
      "hu": "T??rl??s",
      "en": "Delete",
    },
    SystemText.SAVE: {
      "hu": "Ment??s",
      "en": "Save",
    },
    SystemText.CANNOT_BE_EMPTY: {
      "hu": "nem lehet ??res.",
      "en": "cannot be empty.",
    },
    SystemText.IS_NOT_VALID: {
      "hu": "nem helyes.",
      "en": "is not valid.",
    },
    SystemText.ADDRESS: {
      "hu": "??zlet c??me",
      "en": "Business address",
    },
    SystemText.ADDRESS_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.ADDRESS_DESCRIPTION: {
      "hu": "C??m le??r??s",
      "en": "Address description",
    },
    SystemText.ADDRESS_DESCRIPTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.SELECT: {
      "hu": "K??rj??k v??lasszon",
      "en": "Please select",
    },
    SystemText.FIRST_NAME: {
      "hu": "Keresztn??v",
      "en": "First name",
    },
    SystemText.LAST_NAME: {
      "hu": "Keresztn??v",
      "en": "Last name",
    },
    SystemText.CONTACT_DETAILS: {
      "hu": "Kapcsolattart??i adatok",
      "en": "Contact details",
    },
    SystemText.PHONE_NUMBER: {
      "hu": "Telefonsz??m",
      "en": "Phone number",
    },
    SystemText.CONTACT_DETAILS_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc. Sed luctus tortor at varius semper. Nunc magna nulla, cursus et enim pharetra, dapibus iaculis nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc. Sed luctus tortor at varius semper. Nunc magna nulla, cursus et enim pharetra, dapibus iaculis nunc.",
    },
    SystemText.JOB: {
      "hu": "Foglalkoz??s",
      "en": "Job",
    },
    SystemText.COLOR: {
      "hu": "Sz??n",
      "en": "Color",
    },
    SystemText.EMPLOYEE_DESCRIPTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.NEW_EMPLOYEE: {
      "hu": "??j alkalmazott",
      "en": "New employee",
    },
    SystemText.CANCEL: {
      "hu": "M??gse",
      "en": "Cancel",
    },
    SystemText.EMPTY_SERVICE_LIST: {
      "hu": "Nincs hozz??adott szolg??ltat??s.",
      "en": "You don't have any services.",
    },
    SystemText.EMPTY_EMPLOYEE_LIST: {
      "hu": "Nincs hozz??adott szakember.",
      "en": "You don't have any employees.",
    },
    SystemText.SELECT_AVATAR_IMAGE: {
      "hu": "Profilk??p kiv??laszt??sa",
      "en": "Upload avatar",
    },
    SystemText.REMOVE_AVATAR_IMAGE: {
      "hu": "Profilk??p elt??vol??t??sa",
      "en": "Remove avatar",
    },
    SystemText.RATINGS: {
      "hu": "??rt??kel??sek",
      "en": "Ratings",
    },
    SystemText.INFORMATION: {
      "hu": "Adatok",
      "en": "Information",
    },
    SystemText.SETTINGS: {
      "hu": "Be??ll??t??sok",
      "en": "Settings",
    },
    SystemText.CLOSE: {
      "hu": "Bez??r??s",
      "en": "Close",
    },
    SystemText.DATE: {
      "hu": "D??tum",
      "en": "Date",
    },
    SystemText.TIMEOFDAY: {
      "hu": "Id??pont",
      "en": "Time",
    },
    SystemText.CREATE_APT_NO_SERVICE_ERROR: {
      "hu":
          "Foglal??s l??trehoz??s??hoz rendeljen hozz?? szolg??ltat??st a kiv??lasztott alkalmazotthoz.",
      "en":
          "In order to create an appointment please assign at least one service to the selected employee.",
    },
    SystemText.SELECT_CUSTOMER: {
      "hu": "V??lassza ki a vend??get",
      "en": "Please select a customer",
    },
    SystemText.SELECT_SERVICE: {
      "hu": "V??lassza ki a szolg??ltat??st",
      "en": "Please select a service",
    },
    SystemText.NO_ADDED_SERVICE: {
      "hu": "Nincs hozz??adott szolg??ltat??s",
      "en": "No services assigned",
    },
    SystemText.NO_PAST_DATE_ALLOWED: {
      "hu": "Nem v??laszthat?? m??ltbeli id??pont.",
      "en": "Past dates are not allowed.",
    },
    SystemText.APT_DETAILS: {
      "hu": "Foglal??s adatai",
      "en": "Appointment details",
    },
    SystemText.CREATE_APT: {
      "hu": "Foglal??s l??trehoz??sa",
      "en": "Create appointment",
    },
    SystemText.LOADING_DOTS: {
      "hu": "Bet??lt??s...",
      "en": "Loading...",
    },
    SystemText.OPERATION_FAILED: {
      "hu": "Hiba a m??velet sor??n",
      "en": "There was a problem"
    },
    SystemText.OPERATION_IN_PROGRESS: {
      "hu": "M??velet folyamatban...",
      "en": "Just a second..."
    },
    SystemText.OPERATION_SUCCESS: {
      "hu": "Sikeres m??velet!",
      "en": "Done!",
    },
    SystemText.EMPSTGS_CREATION_MIN: {
      "hu": "Minimum id??pontfoglal??s l??trehoz??s intervallum",
      "en": "Minimum appointment creation timespan",
    },
    SystemText.EMPSTGS_DELETE_MIN: {
      "hu": "Minimum id??pontfoglal??s t??rl??s intervallum",
      "en": "Minimum appointment deletion timespan",
    },
    SystemText.EMPSTGS_BOOKING_FREQ: {
      "hu": "Foglal??si frekvencia",
      "en": "Booking frequency",
    },
    SystemText.EMPSTGS_MIN_INDEX: {
      "hu": "Minimum l??togat??si index",
      "en": "Minimum customer index",
    },
    SystemText.EMPSTGS_APT: {
      "hu": "Id??pontfoglal??si be??ll??t??sok",
      "en": "Appointment settings",
    },
    SystemText.HOURS: {
      "hu": "??ra",
      "en": "hours",
    },
    SystemText.MINUTES: {
      "hu": "perc",
      "en": "minutes",
    },
    SystemText.ANY: {
      "hu": "mindegy",
      "en": "any",
    },
    SystemText.CREATED_ON: {
      "hu": "L??trehoz??s d??tuma",
      "en": "Created on",
    },
    SystemText.ADDED_ON: {
      "hu": "Hozz??adva",
      "en": "Added on",
    },
    SystemText.DELETE_EMPLOYEE: {
      "hu": "Alkalmazott t??rl??se",
      "en": "Delete employee",
    },
    SystemText.OTHER: {
      "hu": "Egy??b",
      "en": "Other",
    },
    SystemText.SERVICE_NAME: {
      "hu": "N??v",
      "en": "Name",
    },
    SystemText.SERVICE_COST: {
      "hu": "??r",
      "en": "Cost",
    },
    SystemText.SERVICE_DURATION: {
      "hu": "Id??tartam",
      "en": "Duration",
    },
    SystemText.CURRENCY: {
      "hu": "P??nznem",
      "en": "Currency",
    },
    SystemText.ADD: {
      "hu": "Hozz??ad??s",
      "en": "Add",
    },
    SystemText.CREATE_SERVICE: {
      "hu": "??j szolg??ltat??s",
      "en": "New service",
    },
    SystemText.SERVICE_DETAILS: {
      "hu": "Szolg??ltat??s adatai",
      "en": "Service details",
    },
    SystemText.PAUSE_SERVICE: {
      "hu": "Szolg??ltat??s sz??neteltet??se",
      "en": "Pause service",
    },
    SystemText.PAUSE_EMPLOYEE: {
      "hu": "Szakember sz??neteltet??se",
      "en": "Pause employee",
    },
    SystemText.ACTIVATE_SERVICE: {
      "hu": "Szolg??ltat??s aktiv??l??sa",
      "en": "Activate service",
    },
    SystemText.ACTIVATE_EMPLOYEE: {
      "hu": "Szakember aktiv??l??sa",
      "en": "Activate employee",
    },
    SystemText.DELETE_SERVICE: {
      "hu": "Szolg??ltat??s t??rl??se",
      "en": "Delete service",
    },
    SystemText.UPDATE_SERVICE: {
      "hu": "Szolg??ltat??s szerkeszt??se",
      "en": "Update service",
    },
    SystemText.ACTIVATE: {
      "hu": "Aktiv??l??s",
      "en": "Activate",
    },
    SystemText.PAUSE: {
      "hu": "Sz??neteltet??s",
      "en": "Pause",
    },
    SystemText.ENTITY_STATUS_ACTIVE: {
      "hu": "Akt??v",
      "en": "Active",
    },
    SystemText.ENTITY_STATUS_INACTIVE: {
      "hu": "Sz??neteltetve",
      "en": "Paused",
    },
    SystemText.DELETED: {
      "hu": "t??r??lve",
      "en": "deleted",
    },
    SystemText.NOT_FOUND: {
      "hu": "nem tal??lhat??",
      "en": "not found",
    },
    SystemText.EMPLOYEE: {
      "hu": "Alkalmazott",
      "en": "Employee",
    },
    SystemText.SERVICE: {
      "hu": "Szolg??ltat??s",
      "en": "Service",
    },
    SystemText.CUSTOMER: {
      "hu": "Vend??g",
      "en": "Customer",
    },
    SystemText.BUSINESS: {
      "hu": "??zlet",
      "en": "Business",
    },
    SystemText.WORKBLOCK: {
      "hu": "Id??blokk",
      "en": "Timeblock",
    },
    SystemText.APPOINTMENT: {
      "hu": "Id??pontfoglal??s",
      "en": "Appointment",
    },
    SystemText.CREATE_WORKBLOCK: {
      "hu": "Id??blokk l??trehoz??sa",
      "en": "Create time block",
    },
    SystemText.CREATE_WORKBLOCK_MINUTES_ERROR: {
      "hu": "Egy id??blokk minimum 15 perc, maximum 120 perc lehet.",
      "en":
          "A time block can't be less than 15 minutes, and no more than 120 minutes.",
    },
    SystemText.WORKBLOCK_DESCRIPTION_HINT: {
      "hu": 'pl. "eb??dsz??net"',
      "en": 'for ex. "lunch break"',
    },
    SystemText.DELETE_APPOINTMENT: {
      "hu": 'Foglal??s t??rl??se',
      "en": 'Delete appointment',
    },
    SystemText.DELETE_WORKBLOCK: {
      "hu": 'Id??blokk t??rl??se',
      "en": 'Delete time block',
    },
    SystemText.WORKBLOCK_DETAILS: {
      "hu": 'Id??blokk adatai',
      "en": 'Time block details',
    },
    SystemText.APPOINTMENT_DETAILS: {
      "hu": 'Foglal??s adatai',
      "en": 'Appointment details',
    },
    SystemText.CASH: {
      "hu": 'K??szp??nz',
      "en": 'Cash',
    },
    SystemText.CREDIT_CARD: {
      "hu": 'Hitelk??rtya',
      "en": 'Credit card',
    },
    SystemText.DEBIT_CARD: {
      "hu": 'Bankk??rtya',
      "en": 'Debit card',
    },
    SystemText.SZEPCARD: {
      "hu": 'SZ??P k??rtya',
      "en": 'SZ??P card',
    },
    SystemText.BAN_CUSTOMER: {
      "hu": 'Vend??g letilt??sa',
      "en": 'Ban customer',
    },
    SystemText.UNBAN_CUSTOMER: {
      "hu": 'Vend??g felold??sa',
      "en": 'Unban customer',
    },
    SystemText.BAN_CUSTOMER_HINT: {
      "hu":
          'Letilt??s ut??n a vend??g nem tud id??pontfoglal??st l??trehozni az ??zletedben.',
      "en":
          "After banning the customer won't be able to make appointments in your shop.",
    },
    SystemText.UNBAN_CUSTOMER_HINT: {
      "hu": 'Felold??s ut??n a vend??g ??jra foglalhat id??pontot az ??zletedben.',
      "en":
          'After unbanning the customer will be able to make appointments in your shop.',
    },
    SystemText.BAN: {
      "hu": 'Letilt??s',
      "en": 'Ban',
    },
    SystemText.UNBAN: {
      "hu": 'Felold??s',
      "en": 'Unban',
    },
     SystemText.STATISTICS: {
      "hu": 'Statisztika',
      "en": 'Statistics',
    },
  };
}
