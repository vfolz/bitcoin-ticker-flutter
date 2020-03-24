import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map exchangeRate = Map();
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    CoinData coinData = CoinData();
    try {
      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        exchangeRate = data;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> getCrypto() {
    List<Widget> crypto = [];

    getData();

    for (String item in cryptoList) {
      crypto.add(CryptoCard(
          cryptoCurrency: item,
          exchangeRate: exchangeRate[item],
          selectedCurrency: selectedCurrency));
    }
    crypto.add(Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? iOSPicker() : androidDropdown(),
    ));
    return crypto;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('🤑 Coin Ticker'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CryptoCard(
                cryptoCurrency: 'BTC',
                exchangeRate: isWaiting ? '?' : exchangeRate['BTC'],
                selectedCurrency: selectedCurrency),
            CryptoCard(
                cryptoCurrency: 'ETH',
                exchangeRate: isWaiting ? '?' : exchangeRate['ETH'],
                selectedCurrency: selectedCurrency),
            CryptoCard(
                cryptoCurrency: 'LTC',
                exchangeRate: isWaiting ? '?' : exchangeRate['LTC'],
                selectedCurrency: selectedCurrency),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            ),
          ],
        ));
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {Key key,
      @required this.exchangeRate,
      @required this.selectedCurrency,
      @required this.cryptoCurrency})
      : super(key: key);

  final String exchangeRate;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            // '1 $cryptoCurrency = ${exchangeRate.toStringAsFixed(2)} $selectedCurrency',
            '1 $cryptoCurrency = $exchangeRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
