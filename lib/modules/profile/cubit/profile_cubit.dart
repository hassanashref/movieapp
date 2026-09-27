import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/profile_local_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final watchlist = await ProfileLocalService.getFavorites();
      final history = await ProfileLocalService.getHistory();
      emit(ProfileLoaded(watchlist: watchlist, history: history));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}