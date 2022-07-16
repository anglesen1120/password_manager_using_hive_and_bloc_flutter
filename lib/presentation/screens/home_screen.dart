import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:password_manager/data/models/pass_model.dart';
import 'package:password_manager/logic/bloc/pass/pass_bloc.dart';
import 'package:password_manager/presentation/screens/passview_screen.dart';
import 'package:password_manager/presentation/screens/usersview_screen.dart';
import 'package:password_manager/presentation/widgets/sidemenu.dart';
import 'package:password_manager/presentation/widgets/startingtutorial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    launchTutorial(context, key);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _bodyView(),
      drawer: const SideMenu(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Home"),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget _bodyView() {
    return BlocBuilder<PassBloc, PassState>(
      builder: (context, state) {
        if (state is PassInitial) {
          return _loadingView();
        } else if (state is PassLoadedState) {
          return state.passList.isEmpty
              ? _emptyPassView()
              : _passListView(state.passList);
        }
        return _loadingView();
      },
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.of(context).pushNamed('/addPass'),
    );
  }

  Widget _loadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _emptyPassView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/empty.png"),
          const SizedBox(height: 25),
          const Text(
            "No entries found",
            style: TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }

  Widget _passListView(List<SuperPassModel> passList) {
    return ListView.builder(
      itemCount: passList.length,
      itemBuilder: (context, index) {
        SuperPassModel superPassModel = passList[index];
        return Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  context
                      .read<PassBloc>()
                      .add(PassDeleteEvent(title: superPassModel.title));
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
              )
            ],
          ),
          child: ListTile(
            title: Text(superPassModel.title),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UsersViewScreen(superPassModel: superPassModel),
                  ));
            },
          ),
        );
      },
    );
  }
}
