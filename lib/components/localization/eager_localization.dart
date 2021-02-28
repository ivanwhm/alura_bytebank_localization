import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale.dart';

abstract class ViewI18N {
  String _language;

  ViewI18N(BuildContext context) {
    // precisa fazer o rebuild quando o idioma é trocado.
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String localize(Map<String, String> values) {
    assert(values != null);
    assert(values.containsKey(_language));

    return values[_language];
  }
}
