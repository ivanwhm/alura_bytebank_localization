import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import '../../http/webclients/i18n_webclient.dart';
import 'i18n_messages.dart';
import 'i18n_state.dart';

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  final LocalStorage storage = LocalStorage('version.json');
  final String _viewKey;

  I18NMessagesCubit(this._viewKey) : super(InitI18NMessagesState());

  void reload(I18NWebClient client) async {
    emit(LoadingI18NMessagesState());

    await storage.ready;

    final items = storage.getItem(this._viewKey);
    print('Loaded $_viewKey $items');

    if (items != null) {
      emit(LoadedI18NMessagesState(I18NMessages(items)));
      return;
    }

    client.findAll().then(saveAndRefresh);
  }

  void saveAndRefresh(Map<String, dynamic> messages) {
    storage.setItem(_viewKey, messages);
    print('Saving $_viewKey $messages');

    emit(LoadedI18NMessagesState(I18NMessages(messages)));
  }
}
