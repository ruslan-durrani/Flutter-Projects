import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileStates> {
  EditProfileBloc() : super(EditProfileStates.Initial) {
    on<EditProfileButtonPressedEvent>(_editProfileButtonPressedState);
    on<CancelEditProfileButtonPressedEvent>(_cancelEditProfileButtonPressedState);
  }
  FutureOr<void> _editProfileButtonPressedState(EditProfileButtonPressedEvent event, Emitter<EditProfileStates> emit) {
    emit(EditProfileStates.Edit);
  }
  FutureOr<void> _cancelEditProfileButtonPressedState(CancelEditProfileButtonPressedEvent event, Emitter<EditProfileStates> emit) {
    emit(EditProfileStates.Initial);
  }
}
