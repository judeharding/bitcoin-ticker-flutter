//1. Import the required packages.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker/pvt.dart';

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

//2.  create part of the url and Move API key to a private file
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  //3. Create the Asynchronous method called getCoinData() that returns
  // a Future (the price data).
  Future getCoinData() async {
    //4. Create a url combining the coinAPIURL with your apik key and
    // with the currencies we're interested, BTC to USD.
    String requestURL = '$coinAPIURL/BTC/USD?apikey=$apiKey';
    print(requestURL);

    //5. Make a GET request to the URL and wait for the response.
    http.Response response = await http.get(requestURL);

    //6. Check that the request was successful.
    if (response.statusCode == 200) {
      //7. Use the 'dart:convert' package to decode the JSON data that comes back from coinapi.io.
      var decodedData = jsonDecode(response.body);
      print('JSON DECODED DATA ... ${decodedData}');

      //8. Get the last price of bitcoin with the key 'last'.
      var lastPrice = decodedData['rate'];
      print(lastPrice);

      //9. Output the lastPrice from the method.
      return lastPrice;
    } else {
      //10. Handle any errors that occur during the request.
      print(response.statusCode);

      //Optional: throw an error if our request fails.
      throw 'Problem with the get request';
    }
  }
}
