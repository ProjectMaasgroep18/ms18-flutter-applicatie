import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Colors
const Color mainColor = Color.fromARGB(255, 23, 32, 58);
const Color secondColor = Color.fromRGBO(37, 132, 147, 186);
const Color dangerColor = Color(0xffEA5A5A);
const Color successColor = Color(0xff6cc070);
const Color backgroundColor = Color(0xfffafafa);
const Color textColor = Colors.black;
const Color textColorOnSecondColor = Color(0xFFf24300);
const Color textColorOnMainColor = Colors.white;
const Color shadowColor = Colors.blueGrey;
const Color mainButtonColor = mainColor;

// danillo's login
const Color backgroundColor2 = Color.fromARGB(255, 23, 32, 58);
const Color backgroundColorLight = Color(0xFFF2F6FF);
const Color backgroundColorDark = Color.fromRGBO(37, 132, 147, 186);
const Color shadowColorLight = Color(0xFF4A5367);
const Color shadowColorDark = Colors.black;

/*Logo's  -  Hebben we (nog) niet
const String fullLogo = 'images/Obladi logo.png';
const String smallLogo = 'images/Obladi favicon.png';
*/

//Input styles
const OutlineInputBorder inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: mainColor),
  borderRadius: BorderRadius.all(
    Radius.circular(borderRadius),
  ),
);
const UnderlineInputBorder inputUnderlineBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: mainColor),
);
const TextStyle labelTextStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor);
const Icon dropdownIcon = Icon(
  Icons.arrow_downward,
  size: 20,
);
const TextStyle inputTextStyle = TextStyle(fontSize: 15, color: textColor);
const double inputHeight = 13;
const InputDecoration inputFieldStyle = InputDecoration(
    suffixIconConstraints: BoxConstraints.tightForFinite(),
    prefixIconConstraints: BoxConstraints.tightForFinite(),
    hoverColor: backgroundColor,
    filled: true,
    fillColor: backgroundColor,
    isDense: true,
    contentPadding:
        EdgeInsets.only(top: inputHeight, bottom: inputHeight, right: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.red),
    ),
    errorStyle: TextStyle(color: dangerColor),
    prefixText: '   ');
final InputDecoration inputFieldStyleDropdown = inputFieldStyle.copyWith(
  contentPadding: const EdgeInsets.only(
      top: inputHeight - 2.75, bottom: inputHeight - 2.75, right: 10),
);

//error messages
String fieldNotfound = 'This field does not exist';
String? globToken;

//Screen sizes
const int mobileWidth = 600;
const int tabletWidth = 1000;

//Horizontal padding for screen sizes
const double mobilePadding = 15;
const double aboveMobilePadding = 40;

//Button spacing
const double horizontalButtonSpacing = 15;
const double verticalButtonSpacing = 10;

//Button height
const double buttonHeight = 35;
const double desktopButtonWidth = 300;

const double desktopPopupWidth = 500;

//Border Radius
const double borderRadius = 10;

//cosnt itemslist/recordlistitem height
const double itemHeight = 11;

//Navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//Price formatter
var priceFormat = NumberFormat("###.0#", "nl_NL");

//From here down you got stuff for roles

// enum of the roles so you can make a spelling error
enum RolesNames {
  Customer,
  StockUser,
  Admin,
}

//user role values to not type them wrong but to use the variable
const Map<RolesNames, int> roles = {
  RolesNames.Customer: 0,
  RolesNames.StockUser: 1,
  RolesNames.Admin: 2,
};

// Base url and headers for the api
const Set<int> allowedStatusCodes = {200, 204, 201};
const String apiUrl = "https://api.hr.rspn.io/";
const Map<String, String> apiHeaders = {
  "Content-Type": "application/json",
  "Accept": "application/json",
  // 'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTExMDcwODYsImlzcyI6ImxvY2FsaG9zdCIsImF1ZCI6ImxvY2FsaG9zdCJ9.QhZHteVxP5139xZ458IUKNpXOvF0du17dwT1Kq_UgZA"
};

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final res = prefs.getString('token');

  return res;
}

setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.setString('token', token);
}

setPrefString(String value, String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
  await prefs.setString(key, value);
}

Map<String, String> getHeaders() {
  // final prefs = await SharedPreferences.getInstance();
  // final res = prefs.getString('token');
  String bearerToken = "Bearer $globToken";
  return {
    ...apiHeaders,
    ...{"Authorization": bearerToken}
  };
}
