import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sisal_flutter_challenge/gallery_screen/cubits/gallery_cubit.dart';
import 'package:sisal_flutter_challenge/gallery_screen/widgets/show_picker_bottom_sheet.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galleria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<GalleryCubit>().deletePhoto();
            },
          ),
        ],
      ),
      body: BlocBuilder<GalleryCubit, GalleryState>(
        builder: (context, state) {
          final image = state.image;

          /// ho usato una CustomScrollView perché ritengo sia il modo più
          /// pulito di tenere sempre il pulsante a fondo pagina. Usando solo
          /// una singleChildScrollView, avrei dovuto dare un'altezza fissa ai
          /// componenti.
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Questa schermata permette di aprire la galleria del '
                        'dispositivo e selezionare una foto o in alternativa quella'
                        ' di scattarla ed utilizzarla. Una volta selezionata, la '
                        'foto verrà visualizzata sotto. Una volta caricata è '
                        'possibile cancellarla tramite pulsante nell\'AppBar',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),

                      /// LOADING STATE PER CARICARE L'IMMAGINE
                      if (state is GalleryLoading)
                        const Center(
                            child: CircularProgressIndicator.adaptive()),
                      const SizedBox(height: 8),

                      /// EMPTY STATE
                      if (image == null && state is GalleryLoading == false)
                        _buildEmptyState(context)
                      else if (image != null)

                        /// SUCCESS STATE
                        Column(
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                ImageProvider imageProvider =
                                    FileImage(File(image.path));
                                showImageViewer(context, imageProvider,
                                    immersive: false,
                                    closeButtonColor: Colors.grey,
                                    swipeDismissible: true,
                                    useSafeArea: true);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(image.path),
                                  height: 300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Tocca l'immagine per aprirla!",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              /// ERROR STATE
              if (state is GalleryError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildAddPhotoButton(context),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [6, 3],
      color: Colors.grey,
      strokeWidth: 2,
      padding: EdgeInsets.zero,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => showPickerBottomSheet(context),
          child: const SizedBox(
            width: double.infinity,
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                  Text('Aggiungi una foto',
                      style: TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showPickerBottomSheet(context),
      child: const Text('Aggiungi una foto'),
    );
  }
}
