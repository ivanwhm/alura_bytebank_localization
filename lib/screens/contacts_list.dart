import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/container.dart';
import '../components/progress/progress.dart';
import '../database/dao/contact_dao.dart';
import '../models/contact.dart';
import '../screens/contact_form.dart';
import '../screens/transaction_form.dart';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contact> _contacts;

  const LoadedContactsListState(this._contacts);
}

@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(InitContactsListState());

  void reload(ContactDao dao) async {
    emit(LoadingContactsListState());
    dao.findAll().then((contacts) => emit(LoadedContactsListState(contacts)));
  }
}

class ContactsListContainer extends BlocContainer {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsListCubit>(
      create: (context) {
        final cubit = ContactsListCubit();
        cubit.reload(_dao);
        return cubit;
      },
      child: ContactsList(_dao),
    );
  }
}

class ContactsList extends StatelessWidget {
  final ContactDao _dao;

  ContactsList(this._dao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {
          if (state is InitContactsListState || state is LoadingContactsListState) {
            return Progress();
          }

          if (state is LoadedContactsListState) {
            final contacts = state._contacts;
            return ListView.builder(
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _ContactItem(
                  contact,
                  onClick: () => push(context, TransactionFormContainer(contact)),
                );
              },
              itemCount: contacts.length,
            );
          }

          return const Text('Unknown error');
        },
      ),
      floatingActionButton: _addContactButton(context),
    );
  }

  FloatingActionButton _addContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ContactForm(),
              ),
            )
            .then((value) => context.read<ContactsListCubit>().reload(_dao));
      },
      child: Icon(
        Icons.add,
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
