part of 'change_phone_number_bloc.dart';

sealed class ChangePhoneNumberEvent extends Equatable {
  const ChangePhoneNumberEvent();

  @override
  List<Object> get props => [];
}

final class AcquirePhoneNumberEvent extends ChangePhoneNumberEvent {}

final class AcquirePhoneNumberLoadingEvent extends ChangePhoneNumberEvent {}

final class AcquirePhoneNumberErrorEvent extends ChangePhoneNumberEvent {}

final class SaveButtonClickedEvent extends ChangePhoneNumberEvent {
  final BuildContext context;
  final String oldPhoneNumber;
  final String newPhoneNumber;
  final ChangePhoneNumberBloc changePhoneNumberBloc;

  const SaveButtonClickedEvent(this.context, this.oldPhoneNumber,
      this.newPhoneNumber, this.changePhoneNumberBloc);
}

final class ContinueButtonClickedEvent extends ChangePhoneNumberEvent {
  final String phoneNumber;

  const ContinueButtonClickedEvent(this.phoneNumber);
}

final class ContinueButtonClickedErrorEvent extends ChangePhoneNumberEvent {}

final class ButtonReleasedEvent extends ChangePhoneNumberEvent {}
