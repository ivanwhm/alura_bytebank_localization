import 'dart:convert';

import 'package:http/http.dart';

import '../webclient.dart';

const String MESSAGES_URI =
    'https://gist.githubusercontent.com/ivanwhm/c5d0164360bb96dbfe36e78fc120e471/raw/69ef353424bdbe97b8ebabde56c863df54ad1ee9/';

class I18NWebClient {
  final String _viewKey;

  I18NWebClient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    final Response response = await client.get('$MESSAGES_URI$_viewKey.json');
    return jsonDecode(response.body);
  }
}
