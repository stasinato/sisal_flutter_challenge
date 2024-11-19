import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenIgScreen extends StatelessWidget {
  const OpenIgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apri Instagram'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Questa schermata permette di aprire l\'app di Instagram tramite il pulsante in fondo. Se l\'app non è installata, verrà chiesto di installarla.',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () => launchInstagram(context),
              child: const Text('Apri Instagram'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> launchInstagram(BuildContext context) async {
  final Uri instagramUrl =
      Uri.parse('instagram://user?username=sisal_corporate');

  // ig urls
  final Uri playStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.instagram.android');
  final Uri appStoreUrl =
      Uri.parse('https://apps.apple.com/app/instagram/id389801252');

  try {
    if (await canLaunchUrl(instagramUrl)) {
      await launchUrl(instagramUrl);
    } else {
      // se non posso lanciare ig, chiedo all'utente se vuole installare l'app
      final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: const Text('App non trovata!'),
              content:
                  const Text('Instagram non è installata. Vuoi installarla?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Sì'),
                ),
              ],
            ),
          ) ??
          false;

      /// se si provo ad aprire lo store
      if (result) {
        final storeUrl = Platform.isAndroid ? playStoreUrl : appStoreUrl;

        if (await canLaunchUrl(storeUrl)) {
          await launchUrl(storeUrl);
        } else {
          throw 'Impossibile aprire il link';
        }
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Errore: $e'),
      ),
    );
  }
}
