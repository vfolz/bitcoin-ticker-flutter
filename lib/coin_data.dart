import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL =
    'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=';
const apiKey = 'U2Z7AHEJ2U5IKF5C';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map exchangeRate = Map();

    for (String cryptoCurrency in cryptoList) {
      String requestURL =
          '$coinAPIURL$cryptoCurrency&to_currency=$selectedCurrency&apikey=$apiKey';
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
           exchangeRate[cryptoCurrency] = decodedData['Realtime Currency Exchange Rate']['5. Exchange Rate'];

      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
     return exchangeRate;
  }
}
