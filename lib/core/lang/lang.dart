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
      "hu": "Beállítások",
      "en": "Settings",
    },
    SystemText.PAGE_SETTINGS_MENU_OTHER: {
      "hu": "Egyéb",
      "en": "Other",
    },
    SystemText.PAGE_SETTINGS_MENU_EMAIL: {
      "hu": "E-mail cím megváltoztatása",
      "en": "Change email address",
    },
    SystemText.PAGE_SETTINGS_MENU_PASSWORD: {
      "hu": "Jelszó megváltoztatása",
      "en": "Change password",
    },
    SystemText.SIDEBAR_ITEM_CALENDAR: {
      "hu": "Naptár",
      "en": "Calendar",
    },
    SystemText.SIDEBAR_ITEM_SCHEDULER: {
      "hu": "Beosztás",
      "en": "Scheduler",
    },
    SystemText.SIDEBAR_ITEM_EMPLOYEES: {
      "hu": "Alkalmazottak",
      "en": "Employees",
    },
    SystemText.SIDEBAR_ITEM_SERVICES: {
      "hu": "Szolgáltatások",
      "en": "Services",
    },
    SystemText.SIDEBAR_ITEM_SETTINGS: {
      "hu": "Beállítások",
      "en": "Settings",
    },
    SystemText.SIDEBAR_ITEM_PROFILE: {
      "hu": "Profil",
      "en": "Profile",
    },
    SystemText.SIDEBAR_ITEM_ADDRESS: {
      "hu": "Cím adatok",
      "en": "Address",
    },
    SystemText.SIDEBAR_ITEM_RATINGS: {
      "hu": "Értékelések",
      "en": "Ratings",
    },
    SystemText.SIDEBAR_ITEM_INFO: {
      "hu": "Bemutatkozás",
      "en": "Details",
    },
    SystemText.SIDEBAR_ITEM_APPOINTMENTS: {
      "hu": "Foglalások",
      "en": "Appointments",
    },
    SystemText.SIDEBAR_ITEM_CUSTOMERS: {
      "hu": "Vendégek",
      "en": "Customers",
    },
    SystemText.SIDEBAR_ITEM_DASHBOARD: {
      "hu": "Áttekintés",
      "en": "Dashboard",
    },
    SystemText.SIDEBAR_ITEM_BILLING: {
      "hu": "Előfizetés",
      "en": "Subscription",
    },
    SystemText.EMAIL: {
      "hu": "E-mail cím",
      "en": "Email address",
    },
    SystemText.PASSWORD: {
      "hu": "Jelszó",
      "en": "Password",
    },
    SystemText.LOG_IN: {
      "hu": "Belépés",
      "en": "Sign in",
    },
    SystemText.LOG_OUT: {
      "hu": "Kilépés",
      "en": "Sign out",
    },
    SystemText.SIGNUP: {
      "hu": "Vállalkozói fiók létrehozása",
      "en": "Create business account",
    },
    SystemText.SIGNUP_QUESTION: {
      "hu": "Még nem regisztráltál?",
      "en": "Didn't sign up yet?",
    },
    SystemText.PASSWORD_CONFIRM: {
      "hu": "Jelszó megismétlése",
      "en": "Confirm password",
    },
    SystemText.CREATE_ACCOUNT: {
      "hu": "Fiók létrehozása",
      "en": "Create account",
    },
    SystemText.REGISTRATION: {
      "hu": "Regisztráció",
      "en": "Registration",
    },
    SystemText.NEW_ACCOUNT: {
      "hu": "Új fiók",
      "en": "New account",
    },
    SystemText.CONFIRM_EMAIL: {
      "hu": "Erősítsd meg az e-mail címed!",
      "en": "Confirm your email address!",
    },
    SystemText.CONFIRM_EMAIL_TEXT_1: {
      "hu": "Megerősítő levelet küldtünk a(z) ",
      "en": "We sent an email to ",
    },
    SystemText.CONFIRM_EMAIL_TEXT_2: {
      "hu":
          " címre. Amint megerősítetted az e-mail címedet ez az oldal automatikusan eltűnik. Amennyiben nem frissül az oldal, kattints a frissítés gombra.",
      "en":
          ". After confirming your email address this page will disappear. In case the page doesn't refresh, manually hit refresh",
    },
    SystemText.REFRESH: {
      "hu": "Frissítés",
      "en": "Refresh",
    },
    SystemText.CONFIRM_EMAIL_DIDNTRECEIVE: {
      "hu": "Nem kaptál levelet?",
      "en": "Didn't receive the email?",
    },
    SystemText.CONFIRM_EMAIL_RESEND: {
      "hu": "Megerősítő levél újraküldése",
      "en": "Resend confirmation email",
    },
    SystemText.CONFIRM_EMAIL_SENT: {
      "hu": "Új megerősítő levelünket elküldtük önnek!",
      "en": "New confirmation email has been sent!",
    },
    SystemText.CONFIRM_EMAIL_FAILED: {
      "hu": "E-mail címe nincs megerősítve.",
      "en": "Email address has not been verified.",
    },
    SystemText.INTRODUCTION: {
      "hu": "Bemutatkozás",
      "en": "Introduction",
    },
    SystemText.INTRODUCTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.BUSINESS_NAME: {
      "hu": "Üzlet neve",
      "en": "Business name",
    },
    SystemText.BUSINESS_CATEGORY: {
      "hu": "Kategória",
      "en": "Category",
    },
    SystemText.BUSINESS_CATEGORY_HINT: {
      "hu": "pl. Barber Shop, Ügyvédi Iroda, ..",
      "en": "ex. Barber Shop, Law Office, ..",
    },
    SystemText.BUSINESS_DESCRIPTION: {
      "hu": "Leírás",
      "en": "Description",
    },
    SystemText.BUSINESS_DESCRIPTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.COUNTRY: {
      "hu": "Ország",
      "en": "Country",
    },
    SystemText.CITY: {
      "hu": "Város",
      "en": "City",
    },
    SystemText.STREET_NAME: {
      "hu": "Közterület neve",
      "en": "Street",
    },
    SystemText.STREET_TYPE: {
      "hu": "Közterület jellege",
      "en": "Address type",
    },
    SystemText.STREET_NUMBER: {
      "hu": "Házszám",
      "en": "Street number",
    },
    SystemText.ZIPCODE: {
      "hu": "Irányítószám",
      "en": "Zip code",
    },
    SystemText.NEXT: {
      "hu": "Tovább",
      "en": "Next",
    },
    SystemText.BACK: {
      "hu": "Vissza",
      "en": "Back",
    },
    SystemText.CREATE: {
      "hu": "Létrehozás",
      "en": "Create",
    },
    SystemText.DELETE: {
      "hu": "Törlés",
      "en": "Delete",
    },
    SystemText.SAVE: {
      "hu": "Mentés",
      "en": "Save",
    },
    SystemText.CANNOT_BE_EMPTY: {
      "hu": "nem lehet üres.",
      "en": "cannot be empty.",
    },
    SystemText.IS_NOT_VALID: {
      "hu": "nem helyes.",
      "en": "is not valid.",
    },
    SystemText.ADDRESS: {
      "hu": "Üzlet címe",
      "en": "Business address",
    },
    SystemText.ADDRESS_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.ADDRESS_DESCRIPTION: {
      "hu": "Cím leírás",
      "en": "Address description",
    },
    SystemText.ADDRESS_DESCRIPTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.SELECT: {
      "hu": "Kérjük válasszon",
      "en": "Please select",
    },
    SystemText.FIRST_NAME: {
      "hu": "Keresztnév",
      "en": "First name",
    },
    SystemText.LAST_NAME: {
      "hu": "Keresztnév",
      "en": "Last name",
    },
    SystemText.CONTACT_DETAILS: {
      "hu": "Kapcsolattartói adatok",
      "en": "Contact details",
    },
    SystemText.PHONE_NUMBER: {
      "hu": "Telefonszám",
      "en": "Phone number",
    },
    SystemText.CONTACT_DETAILS_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc. Sed luctus tortor at varius semper. Nunc magna nulla, cursus et enim pharetra, dapibus iaculis nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc. Sed luctus tortor at varius semper. Nunc magna nulla, cursus et enim pharetra, dapibus iaculis nunc.",
    },
    SystemText.JOB: {
      "hu": "Foglalkozás",
      "en": "Job",
    },
    SystemText.COLOR: {
      "hu": "Szín",
      "en": "Color",
    },
    SystemText.EMPLOYEE_DESCRIPTION_HINT: {
      "hu":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
      "en":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
    },
    SystemText.NEW_EMPLOYEE: {
      "hu": "Új alkalmazott",
      "en": "New employee",
    },
    SystemText.CANCEL: {
      "hu": "Mégse",
      "en": "Cancel",
    },
    SystemText.EMPTY_SERVICE_LIST: {
      "hu": "Nincs hozzáadott szolgáltatás.",
      "en": "You don't have any services.",
    },
    SystemText.EMPTY_EMPLOYEE_LIST: {
      "hu": "Nincs hozzáadott szakember.",
      "en": "You don't have any employees.",
    },
    SystemText.SELECT_AVATAR_IMAGE: {
      "hu": "Profilkép kiválasztása",
      "en": "Upload avatar",
    },
    SystemText.REMOVE_AVATAR_IMAGE: {
      "hu": "Profilkép eltávolítása",
      "en": "Remove avatar",
    },
    SystemText.RATINGS: {
      "hu": "Értékelések",
      "en": "Ratings",
    },
    SystemText.INFORMATION: {
      "hu": "Adatok",
      "en": "Information",
    },
    SystemText.SETTINGS: {
      "hu": "Beállítások",
      "en": "Settings",
    },
    SystemText.CLOSE: {
      "hu": "Bezárás",
      "en": "Close",
    },
    SystemText.DATE: {
      "hu": "Dátum",
      "en": "Date",
    },
    SystemText.TIMEOFDAY: {
      "hu": "Időpont",
      "en": "Time",
    },
    SystemText.CREATE_APT_NO_SERVICE_ERROR: {
      "hu":
          "Foglalás létrehozásához rendeljen hozzá szolgáltatást a kiválasztott alkalmazotthoz.",
      "en":
          "In order to create an appointment please assign at least one service to the selected employee.",
    },
    SystemText.SELECT_CUSTOMER: {
      "hu": "Válassza ki a vendéget",
      "en": "Please select a customer",
    },
    SystemText.SELECT_SERVICE: {
      "hu": "Válassza ki a szolgáltatást",
      "en": "Please select a service",
    },
    SystemText.NO_ADDED_SERVICE: {
      "hu": "Nincs hozzáadott szolgáltatás",
      "en": "No services assigned",
    },
    SystemText.NO_PAST_DATE_ALLOWED: {
      "hu": "Nem választható múltbeli időpont.",
      "en": "Past dates are not allowed.",
    },
    SystemText.APT_DETAILS: {
      "hu": "Foglalás adatai",
      "en": "Appointment details",
    },
    SystemText.CREATE_APT: {
      "hu": "Foglalás létrehozása",
      "en": "Create appointment",
    },
    SystemText.LOADING_DOTS: {
      "hu": "Betöltés...",
      "en": "Loading...",
    },
    SystemText.OPERATION_FAILED: {
      "hu": "Hiba a művelet során",
      "en": "There was a problem"
    },
    SystemText.OPERATION_IN_PROGRESS: {
      "hu": "Művelet folyamatban...",
      "en": "Just a second..."
    },
    SystemText.OPERATION_SUCCESS: {
      "hu": "Sikeres művelet!",
      "en": "Done!",
    },
    SystemText.EMPSTGS_CREATION_MIN: {
      "hu": "Minimum időpontfoglalás létrehozás intervallum",
      "en": "Minimum appointment creation timespan",
    },
    SystemText.EMPSTGS_DELETE_MIN: {
      "hu": "Minimum időpontfoglalás törlés intervallum",
      "en": "Minimum appointment deletion timespan",
    },
    SystemText.EMPSTGS_BOOKING_FREQ: {
      "hu": "Foglalási frekvencia",
      "en": "Booking frequency",
    },
    SystemText.EMPSTGS_MIN_INDEX: {
      "hu": "Minimum látogatási index",
      "en": "Minimum customer index",
    },
    SystemText.EMPSTGS_APT: {
      "hu": "Időpontfoglalási beállítások",
      "en": "Appointment settings",
    },
    SystemText.HOURS: {
      "hu": "óra",
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
      "hu": "Létrehozás dátuma",
      "en": "Created on",
    },
    SystemText.ADDED_ON: {
      "hu": "Hozzáadva",
      "en": "Added on",
    },
    SystemText.DELETE_EMPLOYEE: {
      "hu": "Alkalmazott törlése",
      "en": "Delete employee",
    },
    SystemText.OTHER: {
      "hu": "Egyéb",
      "en": "Other",
    },
    SystemText.SERVICE_NAME: {
      "hu": "Név",
      "en": "Name",
    },
    SystemText.SERVICE_COST: {
      "hu": "Ár",
      "en": "Cost",
    },
    SystemText.SERVICE_DURATION: {
      "hu": "Időtartam",
      "en": "Duration",
    },
    SystemText.CURRENCY: {
      "hu": "Pénznem",
      "en": "Currency",
    },
    SystemText.ADD: {
      "hu": "Hozzáadás",
      "en": "Add",
    },
    SystemText.CREATE_SERVICE: {
      "hu": "Új szolgáltatás",
      "en": "New service",
    },
    SystemText.SERVICE_DETAILS: {
      "hu": "Szolgáltatás adatai",
      "en": "Service details",
    },
    SystemText.PAUSE_SERVICE: {
      "hu": "Szolgáltatás szüneteltetése",
      "en": "Pause service",
    },
    SystemText.PAUSE_EMPLOYEE: {
      "hu": "Szakember szüneteltetése",
      "en": "Pause employee",
    },
    SystemText.ACTIVATE_SERVICE: {
      "hu": "Szolgáltatás aktiválása",
      "en": "Activate service",
    },
    SystemText.ACTIVATE_EMPLOYEE: {
      "hu": "Szakember aktiválása",
      "en": "Activate employee",
    },
    SystemText.DELETE_SERVICE: {
      "hu": "Szolgáltatás törlése",
      "en": "Delete service",
    },
    SystemText.UPDATE_SERVICE: {
      "hu": "Szolgáltatás szerkesztése",
      "en": "Update service",
    },
    SystemText.ACTIVATE: {
      "hu": "Aktiválás",
      "en": "Activate",
    },
    SystemText.PAUSE: {
      "hu": "Szüneteltetés",
      "en": "Pause",
    },
    SystemText.ENTITY_STATUS_ACTIVE: {
      "hu": "Aktív",
      "en": "Active",
    },
    SystemText.ENTITY_STATUS_INACTIVE: {
      "hu": "Szüneteltetve",
      "en": "Paused",
    },
    SystemText.DELETED: {
      "hu": "törölve",
      "en": "deleted",
    },
    SystemText.NOT_FOUND: {
      "hu": "nem található",
      "en": "not found",
    },
    SystemText.EMPLOYEE: {
      "hu": "Alkalmazott",
      "en": "Employee",
    },
    SystemText.SERVICE: {
      "hu": "Szolgáltatás",
      "en": "Service",
    },
    SystemText.CUSTOMER: {
      "hu": "Vendég",
      "en": "Customer",
    },
    SystemText.BUSINESS: {
      "hu": "Üzlet",
      "en": "Business",
    },
    SystemText.WORKBLOCK: {
      "hu": "Időblokk",
      "en": "Timeblock",
    },
    SystemText.APPOINTMENT: {
      "hu": "Időpontfoglalás",
      "en": "Appointment",
    },
    SystemText.CREATE_WORKBLOCK: {
      "hu": "Időblokk létrehozása",
      "en": "Create time block",
    },
    SystemText.CREATE_WORKBLOCK_MINUTES_ERROR: {
      "hu": "Egy időblokk minimum 15 perc, maximum 120 perc lehet.",
      "en":
          "A time block can't be less than 15 minutes, and no more than 120 minutes.",
    },
    SystemText.WORKBLOCK_DESCRIPTION_HINT: {
      "hu": 'pl. "ebédszünet"',
      "en": 'for ex. "lunch break"',
    },
    SystemText.DELETE_APPOINTMENT: {
      "hu": 'Foglalás törlése',
      "en": 'Delete appointment',
    },
    SystemText.DELETE_WORKBLOCK: {
      "hu": 'Időblokk törlése',
      "en": 'Delete time block',
    },
    SystemText.WORKBLOCK_DETAILS: {
      "hu": 'Időblokk adatai',
      "en": 'Time block details',
    },
    SystemText.APPOINTMENT_DETAILS: {
      "hu": 'Foglalás adatai',
      "en": 'Appointment details',
    },
    SystemText.CASH: {
      "hu": 'Készpénz',
      "en": 'Cash',
    },
    SystemText.CREDIT_CARD: {
      "hu": 'Hitelkártya',
      "en": 'Credit card',
    },
    SystemText.DEBIT_CARD: {
      "hu": 'Bankkártya',
      "en": 'Debit card',
    },
    SystemText.SZEPCARD: {
      "hu": 'SZÉP kártya',
      "en": 'SZÉP card',
    },
    SystemText.BAN_CUSTOMER: {
      "hu": 'Vendég letiltása',
      "en": 'Ban customer',
    },
    SystemText.UNBAN_CUSTOMER: {
      "hu": 'Vendég feloldása',
      "en": 'Unban customer',
    },
    SystemText.BAN_CUSTOMER_HINT: {
      "hu":
          'Letiltás után a vendég nem tud időpontfoglalást létrehozni az üzletedben.',
      "en":
          "After banning the customer won't be able to make appointments in your shop.",
    },
    SystemText.UNBAN_CUSTOMER_HINT: {
      "hu": 'Feloldás után a vendég újra foglalhat időpontot az üzletedben.',
      "en":
          'After unbanning the customer will be able to make appointments in your shop.',
    },
    SystemText.BAN: {
      "hu": 'Letiltás',
      "en": 'Ban',
    },
    SystemText.UNBAN: {
      "hu": 'Feloldás',
      "en": 'Unban',
    },
     SystemText.STATISTICS: {
      "hu": 'Statisztika',
      "en": 'Statistics',
    },
  };
}
