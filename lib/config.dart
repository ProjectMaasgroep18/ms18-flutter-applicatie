import 'package:flutter/material.dart';

//Colors
const Color mainColor = Color(0xFFf24300);
const Color secondColor = Color(0xFF1F8DD6);
const Color dangerColor = Color(0xffEA5A5A);
const Color successColor = Color(0xff6cc070);
const Color backgroundColor = Color(0xfffafafa);
const Color textColor = Colors.black;
const Color textColorOnSecondColor = Color(0xFFf24300);
const Color textColorOnMainColor = Colors.white;
const Color mainButtonColor = mainColor;

/*Logo's  -  Hebben we (nog) niet
const String fullLogo = 'images/Obladi logo.png';
const String smallLogo = 'images/Obladi favicon.png';
*/

//Input styles
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

//cosnt itemslist/recordlistitem height
const double itemHeight = 11;

//Navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
