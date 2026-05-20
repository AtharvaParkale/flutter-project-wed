import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/di/injection.dart';
import 'package:flutter_project/features/users/presentation/bloc/users_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UsersBloc>()..add(GetAllUsersEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Users')),
        body: BlocConsumer<UsersBloc, UsersState>(
          listener: (context, state) {
            if (state is UsersErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is UsersLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UsersSuccessState) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<UsersBloc>().add(SortByNameEvent());
                        },
                        child: Text("Sort By Name"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<UsersBloc>().add(SortByIdEvent());
                        },
                        child: Text("Sort By ID"),
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount: state.items.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final user = state.items[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: GestureDetector(
                          onTap: () {},
                          child: Text("Delete"),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            if (state is UsersErrorState) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
