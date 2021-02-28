import '../../components/localization/eager_localization.dart';
import '../../components/localization/i18n_messages.dart';
import 'package:flutter/material.dart';

class DashboardViewI18N extends ViewI18N {
  DashboardViewI18N(BuildContext context) : super(context);

  String get transfer => localize({
        "pt-br": "Transferir",
        'en-us': 'Transfer',
      });

  // ignore: non_constant_identifier_names
  String get transaction_feed => localize({
        "pt-br": "Transações",
        'en-us': 'Transaction Feed',
      });

  // ignore: non_constant_identifier_names
  String get change_name => localize({
        "pt-br": "Mudar Nome",
        'en-us': 'Change Name',
      });

  String welcome(String name) => localize({
        "pt-br": "Bem-vindo(a) $name",
        'en-us': 'Welcome $name',
      });
}

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String get transfer => _messages.get("transfer");

  // ignore: non_constant_identifier_names
  String get transaction_feed => _messages.get('transaction_feed');

  // ignore: non_constant_identifier_names
  String get change_name => _messages.get('change_name');
}
