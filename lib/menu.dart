import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Calendar/calendar.dart';
import 'package:ms18_applicatie/Dashboard/dashboard.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Pictures/listPictures.dart';
import 'package:ms18_applicatie/Profile/profile.dart';
import 'package:ms18_applicatie/Stock/stockReport.dart';
import 'package:ms18_applicatie/Users/userList.dart';
import 'package:ms18_applicatie/roles.dart';
import 'package:ms18_applicatie/team-c/Declarations/declarations.dart';
import 'config.dart';
import 'menuItem.dart' as menuItem;

class MenuIndex {
  static int? index = 0;
}

class Menu extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final List<Widget>? actions;
  final double appBarHeight;
  final bool centerTitle;

  //fil the list of custom InputField classes
  final List<menuItem.MenuItem> menuItems = [
    menuItem.MenuItem(
      text: 'Home',
      icon: Icons.home,
      page: MaterialPageRoute(builder: (context) => Dashboard()),
    ),
    menuItem.MenuItem(
        text: 'Voorraad',
        icon: Icons.add_chart,
        page: MaterialPageRoute(builder: (context) => StockReport()),
        roles: [Roles.Admin, Roles.Subadmin]),
    menuItem.MenuItem(
        text: 'Foto\'s',
        icon: Icons.photo,
        page: MaterialPageRoute(builder: (context) => const ListPictures())),
    menuItem.MenuItem(
        text: 'Declaraties',
        icon: Icons.message,
        page: MaterialPageRoute(builder: (context) => const Declarations()),
        roles: [Roles.Admin, Roles.Subadmin]),
    menuItem.MenuItem(
      text: 'Agenda',
      icon: Icons.calendar_month,
      page: MaterialPageRoute(builder: (context) => const Calendar()),
    ),
    menuItem.MenuItem(
      text: 'Google Maps',
      icon: Icons.map_outlined,
      page: MaterialPageRoute(
          builder: (context) => Menu(
                child: Container(),
              )),
    ),
    menuItem.MenuItem(
      text: 'Gebruikers',
      icon: Icons.account_circle,
      page: MaterialPageRoute(builder: (context) => const UserList()),
    ),
  ];

  Menu({
    required this.child,
    this.title,
    this.actions,
    this.appBarHeight = kToolbarHeight,
    this.centerTitle = true,
  });

  //get and put the menu items from the list to the widgets for non mobile
  List<Widget> getMenuItems(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<Widget> items = [];
    int i = 0;

    if (screenWidth > tabletWidth) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Image.asset(
            "",
            height: 60,
            width: 200,
          ),
        ),
      );
      for (menuItem.MenuItem menuitem in menuItems) {
        if (menuitem.roles.contains(UserData.role)) {
          items.add(
            MenuItemBase(
              page: menuitem.page,
              index: i,
              child: MenuItemDesktop(
                text: menuitem.text,
                icon: menuitem.icon,
                selected: (i == MenuIndex.index),
              ),
            ),
          );
        }
        i++;
      }
    } else if (screenWidth > mobileWidth) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Image.asset(
            "",
            height: 30,
            width: 30,
          ),
        ),
      );
      for (menuItem.MenuItem menuitem in menuItems) {
        if (menuitem.roles.contains(UserData.role)) {
          items.add(
            MenuItemBase(
              page: menuitem.page,
              index: i,
              child: MenuItemtabletWidth(
                text: menuitem.text,
                icon: menuitem.icon,
                selected: (i == MenuIndex.index),
              ),
            ),
          );
        }
        i++;
      }
    }

    return items;
  }

//get and put the menu items from the list to the widgets for mobile
  List<BottomNavigationBarItem> getMenuItemsMobile() {
    List<BottomNavigationBarItem> items = [];
    int i = 0;

    for (menuItem.MenuItem menuitem in menuItems) {
      if (menuitem.roles.contains(UserData.role)) {
        bool selected = MenuIndex.index == i;
        items.add(
          BottomNavigationBarItem(
            label: '',
            icon: Material(
              color: selected ? textColorOnMainColor : mainColor,
              child: MenuItemBase(
                index: i,
                page: menuitem.page,
                child: MobileWidthMenuItem(
                  text: menuitem.text,
                  icon: menuitem.icon,
                  selected: selected,
                ),
              ),
            ),
          ),
        );
      }
      i++;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width > mobileWidth
          ? AppBar(
              toolbarHeight: 0,
            )
          : (title != null
              ? AppBar(
                  centerTitle: centerTitle,
                  shadowColor: mainColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(borderRadius * 2),
                    ),
                  ),
                  backgroundColor: mainColor,
                  title: title,
                  elevation: 2,
                  actions: actions,
                  toolbarHeight: appBarHeight,
                )
              : null),
      bottomNavigationBar: MediaQuery.of(context).size.width > mobileWidth
          ? null
          : SizedBox(
              height: 48,
              child: BottomNavigationBar(
                currentIndex: MenuIndex.index!,
                items: getMenuItemsMobile(),
                selectedFontSize: 0,
                iconSize: 20,
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MediaQuery.of(context).size.width > mobileWidth
              ? Container(
                  width: MediaQuery.of(context).size.width > tabletWidth
                      ? 250
                      : 60,
                  color: secondColor,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: getMenuItems(context),
                    ),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: child!,
          ),
        ],
      ),
    );
  }
}

class UserData {
  static Roles? role = Roles.Admin;
}

class MenuItemDesktop extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final bool? selected;

  MenuItemDesktop({this.text, this.icon, this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: selected! ? secondColor : textColorOnMainColor,
          ),
          SizedBox(width: 20),
          Text(
            text!,
            style: TextStyle(
                color: selected! ? secondColor : textColorOnMainColor,
                fontSize: 12,
                height: 1.5),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class MenuItemtabletWidth extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;

  MenuItemtabletWidth(
      {required this.text, required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: selected ? secondColor : textColorOnMainColor,
          ),
          SizedBox(width: 25),
          Text(
            text,
            style: TextStyle(
              color: selected ? secondColor : textColorOnMainColor,
              fontSize: 8,
              height: 1.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class MenuItemBase extends StatelessWidget {
  final int? index;
  final Widget? child;
  final Route? page;

  MenuItemBase({required this.index, required this.child, required this.page});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        alignment: Alignment.center,
        backgroundColor:
            index == MenuIndex.index! ? mainColor : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      onPressed: () {
        MenuIndex.index = index;
        navigatorKey.currentState?.pushAndRemoveUntil(page!, (r) => false);
      },
      child: child,
    );
  }
}

class MobileWidthMenuItem extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final bool? selected;

  MobileWidthMenuItem({this.text, this.icon, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: selected! ? secondColor : textColorOnMainColor),
          Text(
            text!,
            style: TextStyle(
                fontSize: 8,
                color: selected! ? secondColor : textColorOnMainColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
