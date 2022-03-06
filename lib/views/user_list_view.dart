import 'package:arabic_numbers/controllers/api_controller.dart';
import 'package:arabic_numbers/controllers/hero_dialog_controller.dart';
import 'package:arabic_numbers/models/user_model.dart';
import 'package:arabic_numbers/utils/strings.dart';
import 'package:arabic_numbers/views/user_editor_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserListView extends StatefulWidget {
  final ApiController apiController;

  const UserListView(
    this.apiController, {
    Key? key,
  }) : super(key: key);

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<User> usersList = <User>[];
  late Future<List<User>> futureUsers;
  final DateFormat formatterDay = DateFormat('dd/MM/yy');
  final DateFormat formatterHour = DateFormat('HH:mm:ss');

  @override
  void initState() {
    super.initState();
    futureUsers = widget.apiController.fetchUsers();
  }

  Future<void> _updateUserList() async {
    var updatedUserList = await widget.apiController.fetchUsers();
    if (updatedUserList.isEmpty) {
      return;
    }
    futureUsers = Future.value(updatedUserList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[500],
        title: const Text(Strings.adminPanelText),
      ),
      body: Center(
        child: _buildFutureBuilder(),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder<dynamic>(
      future: futureUsers,
      builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(color: Colors.orange[500]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(Strings.fetchingUsersMessage),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          _showSnackBarError(snapshot.error!);
          return Column(
            children: [
              const Center(
                child: Text(
                  Strings.tryAgainMessage,
                  style: TextStyle(fontSize: 32.0),
                ),
              ),
              Center(
                child: IconButton(
                  color: Colors.orange[500],
                  icon: const Icon(Icons.refresh),
                  iconSize: 64.0,
                  onPressed: () {
                    _updateUserList();
                  },
                ),
              ),
            ],
          );
        }
        usersList = snapshot.data as List<User>;
        if (usersList.isEmpty) {
          return const Text(Strings.noUsersFoundMessage);
        }
        return _buildUserList();
      },
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: usersList.isEmpty ? 0 : usersList.length,
      itemBuilder: (BuildContext context, int index) {
        return Hero(
          tag: 'editUser$index',
          child: InkWell(
            focusColor: Colors.orange[300],
            splashColor: Colors.orange[300],
            onLongPress: () {
              Navigator.push(
                context,
                HeroDialogRoute(
                  builder: (context) => UserEditorView(
                    widget.apiController,
                    _updateUserList,
                    _showSnackBarError,
                    user: usersList[index],
                  ),
                ),
              );
            },
            child: Card(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        Status updatedState = Status.active;
                        if (usersList[index].status == Status.active) {
                          updatedState = Status.locked;
                        }
                        widget.apiController
                            .updateStatus(usersList[index].id, updatedState)
                            .then((_) => _updateUserList())
                            .catchError((e) => _showSnackBarError(e));
                        return;
                      },
                      icon: Icon(usersList[index].status == Status.active ? Icons.lock_open : Icons.lock_outline),
                      color: usersList[index].status == Status.active ? Colors.indigo[500] : Colors.orange[700],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      '${usersList[index].firstName} ${usersList[index].lastName}',
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          usersList[index].createdAt.split(' ')[0],
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          usersList[index].createdAt.split(' ')[1],
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          HeroDialogRoute(
            builder: (context) => UserEditorView(
              widget.apiController,
              _updateUserList,
              _showSnackBarError,
            ),
          ),
        );
      },
      backgroundColor: Colors.indigo[500],
      child: const Icon(Icons.add),
    );
  }

  void _showSnackBarError(Object text) async {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 10),
            content: Text(text.toString()),
            action: SnackBarAction(
              label: Strings.okMessage,
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
