import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // BlocBuilder uchun
import '../../bloc/recip_bloc.dart';
import '../../bloc/recip_event.dart';
import '../../bloc/recip_state.dart';
import '../../utils/helpers.dart';
import 'add_recip.dart';

class RecipsList extends StatelessWidget {
  final String searchQuery;

  const RecipsList({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipBloc, RecipState>(
      builder: (context, state) {
        if (state is RecipLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is RecipLoadFailure) {
          return Center(
            child: Text("Xato yuz berdi: ${state.error}"),
          );
        }

        if (state is RecipLoadSuccess) {
          final recips = state.recips
              .where((recip) => recip.recepName
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
              .toList();

          if (recips.isEmpty) {
            return const Center(
              child: Text("Ma'lumotlar mavjud emas."),
            );
          }

          return ListView.builder(
            itemCount: recips.length,
            itemBuilder: (ctx, index) {
              final recip = recips[index];
              return Card(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(recip.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recip.recepName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                recip.recepDescription,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                recip.recepProducts.first,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  Helpers.showProgressDialog(context);
                                  try {
                                    context.read<RecipBloc>().add(DeleteRecip(
                                      id: recip.id,
                                      imageUrl: recip.imageUrl,
                                    ));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Xato yuz berdi: $e"),
                                      ),
                                    );
                                  } finally {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ManageRecip(recip: recip);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const Center(
          child: Text("Tanlangan amalni bajarish uchun ma'lumotlar mavjud emas."),
        );
      },
    );
  }
}
