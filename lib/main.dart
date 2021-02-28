import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/localization/locale.dart';
import 'components/theme.dart';
import 'screens/dashboard/dashboard_container.dart';

void main() => runApp(BytebankApp());

class LogObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} > $change');
    super.onChange(cubit, change);
  }
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc.observer = LogObserver();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: bytebankTheme,
      home: LocalizationContainer(
        child: DashboardContainer(),
      ),
    );
  }
}
