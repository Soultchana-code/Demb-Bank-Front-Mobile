import 'package:djembe_bank_mobile/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await repository.getUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(UserProfile user) async {
    try {
      await repository.updateProfile(user);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await repository.logout();
      // Ici, on pourrait émettre un état spécifique pour rediriger vers login
      // Mais la déconnexion sera gérée dans l'UI via AuthCubit
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}