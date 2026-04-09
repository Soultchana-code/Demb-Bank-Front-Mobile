import '../entities/pot.dart';
import '../entities/friend.dart';
import '../entities/referral.dart';

abstract class CircleRepository {
  Future<List<Pot>> getActivePots();
  Future<List<Friend>> getRecentFriends();
  Future<Referral> getReferralInfo();
}