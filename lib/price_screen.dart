import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
//  "my pages"
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  // configuring for android dropdowns and is determined by dart:io PLATFORM
  // use this ternary to activate
  // child: Platform.isIOS ? iOSPicker() : androidDropdown(),
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
          //b1: Call getData() when the picker/dropdown changes.
          getData();
        });
      },
    );
  }

  // configuring for ios  and is determined by dart:io PLATFORM
  // use this ternary to activate
  // child: Platform.isIOS ? iOSPicker() : androidDropdown(),
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
        setState(() {
          //a: Save the selected currency to the property selectedCurrency
          selectedCurrency = currenciesList[selectedIndex];
          //b2: Call getData() when the picker/dropdown changes.
          getData();
        });
      },
      children: pickerItems,
    );
  }

  //12. Create a variable to hold the value and use in our Text Widget.  Give
  // the variable a starting value of '?' before the data comes back from the async methods.
  double bitcoinValue;

  //11. Create an async method here await the coin data from coin_data.dart
  void getData() async {
    try {
      //We're now passing the selectedCurrency when we call getCoinData().
      var data = await CoinData().getCoinData(selectedCurrency);

      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
//        putting coin_data into bitcoinvalue
        bitcoinValue = data;
      });
      //catching any errors from the api call in coin_data.dart
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //14. Call getData() when the screen loads up. We can't call
    // CoinData().getCoinData() directly here because we can't make initState() async.
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
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  //15: Update the currency name depending on the selectedCurrency.
                  '1 BTC = $bitcoinValue $selectedCurrency ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            //   is determined by dart:io PLATFORM
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
//            child: androidDropdown(),
          ),
        ],
      ),
    );
  }
}
