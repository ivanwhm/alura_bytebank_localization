import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../error_view.dart';
import '../progress/progress_view.dart';
import 'i18n_container.dart';
import 'i18n_cubit.dart';
import 'i18n_state.dart';

class I18NLoadingView extends StatelessWidget {
  final II18NWidgetCreator _creator;

  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
      builder: (context, state) {
        if (state is InitI18NMessagesState || state is LoadingI18NMessagesState) {
          return ProgressView(
            message: 'Loading...',
          );
        }

        if (state is LoadedI18NMessagesState) {
          final messages = state.messages;
          return _creator.call(messages);
        }

        return ErrorView('Unknown Error');
      },
    );
  }
}
