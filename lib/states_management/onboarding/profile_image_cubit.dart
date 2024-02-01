import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_image_state.dart';

class ProfileImageCubit extends Cubit<ImageState> {
  final _picker = ImagePicker();
  ProfileImageCubit() : super(ImageInitialState());

  Future<void> getImage() async {
    try {
      final image = (await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50));

      if (image != null) {
        emit(ImageLoadedState(image.path));
      } else {
        emit(ImageErrorState("No image selected"));
      }
    } catch (e) {
      emit(ImageErrorState(e.toString()));
    }
  }
}
