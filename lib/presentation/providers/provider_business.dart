import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/data/models/model_business.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_business.dart';
import 'package:allbert_cms/domain/entities/entity_business_settings.dart';
import 'package:flutter/material.dart';

class BusinessProvider extends ChangeNotifier {
  BusinessModel business;

  ApplicationImageModel avatarImage;

  void setAvatar({@required ApplicationImage avatar}) {
    avatarImage = avatar;
    notifyListeners();
  }

  void update({@required Business business}) {
    this.business = business;
    this.avatarImage = business == null ? null : business.avatar;
    notifyListeners();
  }

  Business get data => business;
  String get businessId => business.id;

  void reset() {
    business = null;
    avatarImage = null;
  }
}
