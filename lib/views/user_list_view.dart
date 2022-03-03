import 'package:arabic_numbers/controllers/api_controller.dart';
import 'package:arabic_numbers/models/user_model.dart';
import 'package:arabic_numbers/views/user_editor_view.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Exercise 2'),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: futureUsers,
          builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
            if (snapshot.connectionState != ConnectionState.done &&
                !snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Fetching users...'),
                    )
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              _showSnackBarError(snapshot.error);
              return Column(
                children: [
                  const Center(
                      child: Text('Maybe try again?😥',
                          style: TextStyle(fontSize: 32))),
                  Center(
                    child: IconButton(
                        icon: const Icon(Icons.refresh),
                        iconSize: 64,
                        onPressed: () {
                          _updateUserList();
                        }),
                  ),
                ],
              );
            }
            usersList = snapshot.data as List<User>;
            if (usersList.isEmpty) {
              return const Text("No users found... Try to add new one!");
            }
            return _buildUserList();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserEditorView(
                      widget.apiController,
                      _updateUserList,
                      _showSnackBarError,
                    )),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildUserList() {
    return ListView.builder(
        itemCount: usersList.isEmpty ? 0 : usersList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: Colors.amber[300],
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserEditorView(
                          widget.apiController,
                          _updateUserList,
                          _showSnackBarError,
                          user: usersList[index],
                        )),
              );
            },
            child: Card(
              color: usersList[index].status == Status.active
                  ? Colors.grey.shade50
                  : Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  IconButton(
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
                      icon: Icon(usersList[index].status == Status.active
                          ? Icons.lock_open
                          : Icons.lock_outline)),
                  Row(children: <Widget>[
                    Text(
                      '${usersList[index].firstName} ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${usersList[index].lastName} ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${usersList[index].createdAt} ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                ],
              ),
            ),
          );
        });
  }

  void _showSnackBarError(dynamic text) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: Text(text.toString()),
        action: SnackBarAction(
          label: 'Ok 😥',
          onPressed: () {},
        ),
      ));
    });
  }
}
