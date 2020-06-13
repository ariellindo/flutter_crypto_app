part of 'crypto_bloc.dart';

abstract class CryptoState extends Equatable {
  const CryptoState();

  @override
  List<Object> get props => [];
}

// Initial State
class CryptoEmpty extends CryptoState {}

// Fetching Coins
class CryptoLoading extends CryptoState {}

/// Retrieved coins holds the new list of loaded coins
/// when the repository finishes fetching the api, the crypto loaded state is passed to the UI
class CryptoLoaded extends CryptoState {
  final List<Coin> coins;

  const CryptoLoaded({this.coins});

  @override
  List<Object> get props => [coins];

  @override
  String toString() => 'CryptpLoaded {coins: $coins}';
}

// API Request Error
class CryptoError extends CryptoState {}
