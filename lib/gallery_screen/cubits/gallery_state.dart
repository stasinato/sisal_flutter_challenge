part of 'gallery_cubit.dart';

@immutable
sealed class GalleryState {
  final XFile? image;

  const GalleryState({this.image});
}

final class GalleryLoading extends GalleryState {
  const GalleryLoading(XFile? image) : super(image: image);
}

final class GalleryPickerSuccess extends GalleryState {
  const GalleryPickerSuccess(XFile? image) : super(image: image);
}

final class GalleryError extends GalleryState {
  final String error;

  const GalleryError(this.error, XFile? image) : super(image: image);
}
