import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../http/webclients/i18n_webclient.dart';
import '../container.dart';
import 'i18n_cubit.dart';
import 'i18n_messages.dart';
import 'i18n_loading_view.dart';

typedef Widget II18NWidgetCreator(I18NMessages messages);

class I18NLoadingContainer extends BlocContainer {
  final II18NWidgetCreator creator;
  final String viewKey;

  I18NLoadingContainer({
    @required this.creator,
    @required this.viewKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (context) {
        final cubit = I18NMessagesCubit(this.viewKey);
        cubit.reload(I18NWebClient(this.viewKey));

        return cubit;
      },
      child: I18NLoadingView(this.creator),
    );
  }
}
