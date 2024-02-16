import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'change_profile_event.dart';
part 'change_profile_state.dart';

class ChangeProfileBloc extends Bloc<ChangeProfileEvent, ChangeProfileState> {
  ChangeProfileBloc() : super(ChangeProfileInitialState()) {
    on<ChangeProfileInitialEvent>(changeProfileInitialEvent);
    on<ChangeProfile>((event, emit) async {
      emit(ChangeProfileLoadingState());
      ImagePicker picker = ImagePicker();

      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final File storedImage = File(image.path);
        final bytes = storedImage.readAsBytesSync().lengthInBytes;
        final kb = bytes / 1024;
        if (kb > 1024) {
          emit(const ChangeProfileErrorState("Image must be less than 1 Mb"));
        } else {
          emit(ChangeProfileLoadedState(image));
        }
      } else {
        emit(const ChangeProfileErrorState("Error Occurred"));
      }
    });
  }

  FutureOr<void> changeProfileInitialEvent(
      ChangeProfileInitialEvent event, Emitter<ChangeProfileState> emit) {
    emit(ChangeProfileInitialState());
  }
}
