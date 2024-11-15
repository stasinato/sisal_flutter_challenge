import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/gallery_cubit.dart';

void showPickerBottomSheet(BuildContext context) {
  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Seleziona dalla galleria'),
              onTap: () {
                context.pop();
                context.read<GalleryCubit>().pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Scatta una foto'),
              onTap: () {
                context.pop();
                context.read<GalleryCubit>().takePhoto();
              },
            ),
          ],
        ),
      );
    },
  );
}
