import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../components/container.dart';
import '../components/error_view.dart';
import '../components/progress/progress_view.dart';
import '../components/transaction_auth_dialog.dart';
import '../http/webclients/transaction_webclient.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class ErrorState extends TransactionFormState {
  final String message;

  const ErrorState(this.message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  final TransactionWebClient _webClient = TransactionWebClient();

  TransactionFormCubit() : super(ShowFormState());

  void save(Transaction transactionCreated, String password, BuildContext context) async {
    emit(SendingState());
    await _send(transactionCreated, password, context);
  }

  Future<void> _send(Transaction transactionCreated, String password, BuildContext context) async {
    await _webClient.save(transactionCreated, password).then((transaction) {
      emit(SentState());
    }).catchError((e) {
      emit(ErrorState(e.message));
    }, test: (e) => e is HttpException).catchError((e) {
      emit(ErrorState('timeout submitting the transaction'));
    }, test: (e) => e is TimeoutException).catchError((e) {
      emit(ErrorState('Unknown Error'));
    });
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
      create: (context) => TransactionFormCubit(),
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
        listener: (context, state) {
          if (state is SentState) {
            Navigator.of(context).pop();
          }
        },
        child: TransactionForm(_contact),
      ),
    );
  }
}

class TransactionForm extends StatelessWidget {
  final Contact _contact;

  TransactionForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
      builder: (context, state) {
        if (state is ShowFormState) {
          return _BasicForm(_contact);
        }
        if (state is SendingState || state is SentState) {
          return ProgressView();
        }
        if (state is ErrorState) {
          return ErrorView(state.message);
        }

        return ErrorView('Unknown Error');
      },
    );
  }
}

class _BasicForm extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();
  final Contact _contact;

  _BasicForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value = double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(
                        transactionId,
                        value,
                        _contact,
                      );
                      showDialog(
                        context: context,
                        builder: (contextDialog) {
                          return TransactionAuthDialog(
                            onConfirm: (String password) {
                              BlocProvider.of<TransactionFormCubit>(context)
                                  .save(transactionCreated, password, context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
