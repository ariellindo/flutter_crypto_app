import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_crypto/models/coins.dart';
import 'package:flutter_crypto/repositories/crypto_repository.dart';
import 'package:meta/meta.dart';

part 'crypto_event.dart';
part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository _cryptoRepository;

  CryptoBloc({@required CryptoRepository cryptoRepository})
      : assert(cryptoRepository != null),
        _cryptoRepository = cryptoRepository;

  @override
  CryptoState get initialState => CryptoEmpty();

  /// maps the events classes to the states class
  @override
  Stream<CryptoState> mapEventToState(CryptoEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCoins) {
      yield* _getCoins(coins: []);
    } else if (event is LoadMoreCoins) {
      yield* _mapLoadMoreCoinsToState(event);
    }
  }

  /// Get coins is called on loading and loading more coins
  /// async generator creates a new stream
  ///
  /// Yield is a keyword that ‘returns’ single value to the sequence, but does not stop the generator function.
  /// Yield* keyword is used for ‘returning’ recursive generator
  Stream<CryptoState> _getCoins({List<Coin> coins, int page: 0}) async* {
    try {
      List<Coin> newCoinsList = coins + await _cryptoRepository.getTopCoins(page: page);
      // this state holds the final state of the coin list
      yield CryptoLoaded(coins: newCoinsList);
    } catch (e) {
      yield CryptoError();
    }
  }

  /// when AppStarted it will fetch getCoins with empty array to append
  Stream<CryptoState> _mapAppStartedToState() async* {
    // yields the loading state to the UI to render the loading icon
    yield CryptoLoading();
    // and calls inmediately to fetch coins and yield it to the UI
    yield* _getCoins(coins: []);
  }

  /// when loading more coins the saved coin list in the repository will be appended to
  /// the new fetched list
  Stream<CryptoState> _mapLoadMoreCoinsToState(LoadMoreCoins event) async* {
    final int nextPage = event.coins.length ~/ CryptoRepository.perPage;
    yield* _getCoins(coins: event.coins, page: nextPage);
  }
}
