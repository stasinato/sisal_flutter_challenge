import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit/gazzetta_cubit.dart';

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
                /// LOADING STATE PER FETCHARE ARTICOLI
                if (state is GazzettaLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                /// ERROR STATE - L'UTENTE PUÒ PROVARE A RICARICARE I DATI
                if (state is GazzettaError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Errore: \n${state.error}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<GazzettaCubit>().fetchSoccerFeedData();
                          },
                          child: const Text('Riprova'),
                        ),
                      ],
                    ),
                  );
                }

                /// SUCCESS STATE - MOSTRO GLI ARTICOLI
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
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: article.thumbnail.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: article.thumbnail,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child:
                                          CircularProgressIndicator.adaptive()),
                                  errorWidget: (context, url, error) {
                                    print('Error loading image: $error');
                                    print('Error url  : $url');
                                    return const Icon(Icons.error);
                                  })
                              : const Icon(Icons.error),
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
