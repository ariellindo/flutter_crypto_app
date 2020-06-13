part of 'crypto_bloc.dart';

abstract class CryptoEvent extends Equatable {
  const CryptoEvent();

  @override
  List<Object> get props => [];
}

/// events are only used to compare the event triggered and carries data to the bloc
class AppStarted extends CryptoEvent {}

class RefreshCoins extends CryptoEvent {}

/// when the scrolled content reaches the bottom then the event passes the class with the loaded list
/// to be used in the bloc and return the new state with the new merged list
class LoadMoreCoins extends CryptoEvent {
  final List<Coin> coins;

  const LoadMoreCoins({this.coins});

  @override
  List<Object> get props => [coins];

  @override
  String toString() => 'LoadMoreCoins {coins: $coins}';
}
