import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sisal_flutter_challenge/gazzetta/cubit/gazzetta_cubit.dart';

class GazzettaScreen extends StatelessWidget {
  const GazzettaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gazzetta'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<GazzettaCubit, GazzettaState>(
              builder: (context, state) {
                if (state is GazzettaLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is GazzettaError) {
                  return Column(
                    children: [
                      const Center(
                        child: Text('Error'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GazzettaCubit>().fetchSoccerFeedData();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  );
                }

                if (state is GazzettaLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      final article = state.articles[index];
                      return ListTile(
                        onTap: () {
                          context.push('/article', extra: article.link);
                        },
                        title: Text(
                          article.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          article.description.length > 50
                              ? '${article.description.substring(0, 50)}…'
                              : article.description,
                        ),
                        leading: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: article.thumbnail,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator.adaptive(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
