// TODO Implement this library.import '../../domain/entities/pot.dart';

import '../../domain/entities/friend.dart';
import '../../domain/entities/referral.dart';
import '../../domain/repositories/circle_repository.dart';
import 'package:djembe_bank_mobile/features/circle/domain/entities/pot.dart';


class CircleRepositoryMock implements CircleRepository {
  @override
  Future<List<Pot>> getActivePots() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Pot(id: '1', name: 'Anniv Sarah', current: 120, target: 200),
      Pot(id: '2', name: 'Weekend Ski', current: 450, target: 800),
    ];
  }

  @override
  Future<List<Friend>> getRecentFriends() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Friend(id: '1', name: 'Moussa'),
      Friend(id: '2', name: 'Sophie'),
      Friend(id: '3', name: 'Thomas'),
      Friend(id: '4', name: 'Fatou'),
    ];
  }

  @override
  Future<Referral> getReferralInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    return Referral(
      code: 'DJEMBE123',
      message: 'Invitez vos amis à rejoindre la tribu Djembé et gagnez 10€ chacun.',
    );
  }
}