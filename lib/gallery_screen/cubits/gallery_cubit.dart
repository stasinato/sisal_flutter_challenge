import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final GoRouter _router;

  GalleryCubit(this._router) : super(const GalleryLoading(null)) {
    _loadImageFromDevice();
  }

  final _picker = ImagePicker();

  /// funzione utilizzata per recuperare l'immagine persa:
  /// ref: https://pub.dev/packages/image_picker
  /// section Handling MainActivity destruction
  Future<void> retrieveLostData() async {
    if (Platform.isAndroid == false) return;
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _router.go('/gallery');
      await _saveImage(response.file!);
      emit(GalleryPickerSuccess(response.file!));
    }
  }

  /// funzione helper per ottenere il path dell'immagine salvata
  Future<String> _getImagePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/saved_photo.jpg';
  }

  /// funzione usata all'inizio per caricare l'eventuale immagine salvata sul
  /// dispositivo
  Future<void> _loadImageFromDevice() async {
    try {
      await retrieveLostData();

      /// usato solo per simulare un caricamento più lento e mostrare il
      /// CircularProgressIndicator
      await Future.delayed(const Duration(milliseconds: 700));

      final imagePath = await _getImagePath();
      final file = File(imagePath);

      if (await file.exists()) {
        emit(GalleryPickerSuccess(XFile(imagePath)));
      } else {
        emit(const GalleryPickerSuccess(null));
      }
    } catch (e) {
      emit(GalleryError('Error checking photo: $e', state.image));
    }
  }

  Future<void> deletePhoto() async {
    final image = state.image;
    emit(const GalleryPickerSuccess(null));
    try {
      final imagePath = await _getImagePath();
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        _loadImageFromDevice();
      }
    } catch (e) {
      emit(GalleryError('Error deleting photo: $e', image));
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _saveImage(image);
        emit(GalleryPickerSuccess(image));
      } else {
        emit(GalleryPickerSuccess(state.image));
      }
    } catch (e) {
      emit(GalleryError('Error selecting image: $e', state.image));
    }
  }

  Future<void> takePhoto() async {
    try {
      final photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        await _saveImage(photo);
        emit(GalleryPickerSuccess(photo));
      }
    } catch (e) {
      emit(GalleryError('Error taking photo: $e', state.image));
    }
  }

  Future<void> _saveImage(XFile image) async {
    final imagePath = await _getImagePath();
    await File(image.path).copy(imagePath);
  }
}
