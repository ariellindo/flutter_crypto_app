import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Coin extends Equatable {
  final String name;
  final String fullName;
  final double price;

  /// added a const contructor to make
  const Coin({
    // requires is like the PropTypes in react throw error on missing
    // with the help of the lib meta.dart
    @required this.name,
    @required this.fullName,
    @required this.price,
  });

  ///
  @override
  List<Object> get props => [
        name,
        fullName,
        price,
      ];

  @override
  String toString() =>
      "Coin { name: $name, fullName: $fullName, price: $price }";

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      name: json['CoinInfo']['Name'] as String,
      fullName: json['CoinInfo']['FullName'] as String,
      price: (json['RAW']['USD']['PRICE']).toDouble(),
    );
  }
}
