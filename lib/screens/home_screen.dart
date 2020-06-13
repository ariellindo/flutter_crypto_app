import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crypto/blocs/crypto/crypto_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Top Coins'),
        ),
        /// HomePage is a child of the blocProvider so we can use a BlocBuilder here
        /// with type <Bloc, state> so the events and states can be accessed.
        body: BlocBuilder<CryptoBloc, CryptoState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.grey[850],
                  ],
                ),
              ),
              child: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  /// for the body we need the 3 basic state for consuming the logic when entering, loaded or error
  /// when the events are processed the bloc will return a state
  ///
  /// the states are then used to show specific parts of the UI
  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return _buildCryptoLoading();
    } else if (state is CryptoLoaded) {
      return _buildCryptoLoaded(state);
    } else if (state is CryptoError) {
      return _buildCryptoError();
    }
  }

  Center _buildCryptoError() {
    return Center(
      child: Text(
        'Error Loading coins\nPlease check your connection',
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 18.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// RefreshIndicator will trigger a reload when the list is pulled down
  /// on refresh it will refresh the coins and call get coins with page 0 again
  /// .add(RefreshCoins()); is a bloc function to send the custom event created in crypto_event.dart
  ///
  /// when the list gets to the bottom it will trigger the scroll event `NotificationListener<ScrollNotification>(`
  /// it will call get coins with the new page number
  RefreshIndicator _buildCryptoLoaded(CryptoLoaded state) {
    return RefreshIndicator(
      color: Theme.of(context).accentColor,
      onRefresh: () async {
        context.bloc<CryptoBloc>().add(RefreshCoins());
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) =>
            _onScrollNotification(notification, state),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: state.coins.length,
          itemBuilder: (BuildContext context, int index) {
            final coin = state.coins[index];

            return ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${++index}',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              title: Text(
                coin.fullName,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                coin.name,
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                '\$${coin.price.toStringAsFixed(4)}',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// when initially loading it will call the circular progress animation
  Center _buildCryptoLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).accentColor,
        ),
      ),
    );
  }

  bool _onScrollNotification(ScrollNotification notif, CryptoLoaded state) {
    if (notif is ScrollNotification && _scrollController.position.extentAfter == 0) {
      context.bloc<CryptoBloc>().add(LoadMoreCoins(coins: state.coins));
    }

    return false;
  }
}
