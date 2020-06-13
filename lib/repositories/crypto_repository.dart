import 'dart:convert';

import 'package:flutter_crypto/models/coins.dart';
import 'package:flutter_crypto/repositories/base_crypto_repository.dart';
import 'package:http/http.dart' as http;

class CryptoRepository extends BaseCryptoRepository {
  static const String _baseUrl = 'https://min-api.cryptocompare.com';
  static const int perPage = 20;

  final http.Client _httpClient;

  /// the colon after the contructor is called initializer list
  /// https://stackoverflow.com/a/50274735/805938
  /// This is handy to initialize final fields with calculated values.
  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// api call for getting the coins
  @override
  Future<List<Coin>> getTopCoins({int page}) async {
    List<Coin> coins = [];
    String requestUrl =
        '$_baseUrl/data/top/totalvolfull?limit=$perPage&tsym=USD&page=$page';

    try {
      final response = await _httpClient.get(requestUrl);

      /// always check the status code
      /// the response body needs to be decoded so it can be assigned to data list
      /// with String as Key and dynamic as Value
      /// so the parsed json can be used as an object list<dynamic>
      /// finally added to the final model list
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> coinList = data['Data'];
        coinList.forEach(
          (json) => coins.add(Coin.fromJson(json)),
        );
      }

      return coins;

    } catch (e) {
      throw e;
    }
  }

  /// always close the client when finished
  @override
  void dispose() {
    _httpClient.close();
  }
}
