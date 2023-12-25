import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/statusIndicator.dart';
import '../config.dart';

const Map<String, IconData> productIcons = {
  "Lunch Dining": Icons.lunch_dining,
  "Cake": Icons.cake,
  "Local Bar": Icons.local_bar,
  "Local Cafe": Icons.local_cafe,
  "Liquor": Icons.liquor,
  "Local Pizza": Icons.local_pizza,
  "Icecream": Icons.icecream,
  "Bakery Dinding": Icons.bakery_dining,
  "Soup Kitchen": Icons.soup_kitchen,
  "Set Meal": Icons.set_meal,
  "Rice Bowl": Icons.rice_bowl,
  "Dinner Dining": Icons.dinner_dining,
  "Egg Alt": Icons.egg_alt,
  "Emoji Food Beverage": Icons.emoji_food_beverage,
  "Ramen Dining": Icons.ramen_dining,
  "Breakfast Dining": Icons.breakfast_dining,
  "Tapas": Icons.tapas,
  "Sports Bar": Icons.sports_bar,
  "Local Drink": Icons.local_drink,
  "Wine Bar": Icons.wine_bar,
  "Coffee": Icons.coffee,
};

Future<void> addItemsDialog(
    BuildContext context, Function(StockProduct stockProduct) onSave,
    [Function()? onDelete, StockProduct? stockProduct]) async {
  //Checking if the product is being changed
  bool isChange = stockProduct != null;
  //Adding default product information
  stockProduct ??= StockProduct(
      product:
          Product(color: Colors.black, name: '', price: 0, icon: '', id: 0),
      quantity: 0);

  //Initializing the input controllers
  TextEditingController nameController =
      TextEditingController(text: stockProduct.product.name);
  TextEditingController priceController =
      TextEditingController(text: stockProduct.product.price.toString());
  TextEditingController countController =
      TextEditingController(text: stockProduct.quantity.toString());
  String icon = stockProduct.product.icon;

  final GlobalKey<FormState> formKey = GlobalKey();

  await showInputPopup(context,
      title: "Item ${isChange ? 'wijzigen' : 'toevoegen'}",
      height: 300 + (isChange ? 48 : 0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            InputField(
              controller: nameController,
              labelText: 'Product naam',
            ),
            const PaddingSpacing(),
            InputField(
              controller: priceController,
              labelText: 'Prijs',
              isDouble: true,
            ),
            const PaddingSpacing(),
            InputDropDown(
              labelText: "Icon",
              value: productIcons.keys.contains(icon) ? icon : null,
              items: [
                for (String item in productIcons.keys)
                  DropdownMenuItem(
                    value: item,
                    child: InputDropdownItem(
                      iconName: item,
                    ),
                  )
              ],
              onChange: (newValue) {
                icon = newValue ?? '';
              },
            ),
            const PaddingSpacing(),
            InputField(
              controller: countController,
              labelText: 'Aantal stuks',
              isInt: true,
            ),
            if (onDelete != null) ...[
              const PaddingSpacing(),
              Button(
                onTap: onDelete,
                color: dangerColor,
                text: "Verwijderen",
                icon: Icons.delete,
              )
            ]
          ],
        ),
      ), onSave: () {
    if (formKey.currentState!.validate()) {
      // Updating the product object information
      stockProduct!.product
        ..name = nameController.text
        ..price = double.parse(priceController.text)
        ..icon = icon;
      onSave(stockProduct);
    }
  });
}

class StockElement extends StatelessWidget {
  final StockProduct stockProduct;
  final Function(String?)? onChange;
  late TextEditingController stockController;
  final Function(StockProduct)? onSave;
  final Function() onDelete;

  StockElement(
      {super.key,
      required this.stockProduct,
      this.onChange,
      this.onSave,
      required this.onDelete}) {
    stockController =
        TextEditingController(text: stockProduct.quantity.toString());
  }

  //Increasing or decresing the input by the given amount
  void changeNumber(int change) {
    int currentValue = int.tryParse(stockController.text) ?? 0;
    currentValue += change;

    stockController.text = currentValue.toString();
    updateInput();
  }

  void updateInput() {
    if (onChange != null) {
      onChange!(stockController.text);
    }
    stockProduct.quantity = int.tryParse(stockController.text) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        addItemsDialog(context, (stockProduct) {
          if (onSave != null) {
            onSave!(stockProduct);
          }
        }, onDelete, stockProduct);
      },
      leading: SizedBox(
        width: 45,
        height: 45,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: stockProduct.product.color,
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(2, 2), // changes position of shadow
                ),
              ],
            ),
            child: Icon(
              productIcons[stockProduct.product.icon],
              color: Colors.white,
            ),
          ),
          const Positioned(
              bottom: 0,
              right: -3,
              child: StatusIndicator(color: successColor)),
        ]),
      ),
      title: Text(stockProduct.product.name),
      subtitle: Text('€${stockProduct.product.price}'),
      contentPadding: EdgeInsets.zero,
      trailing: SizedBox(
        width: 160,
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Button(
                onTap: () {
                  changeNumber(-1);
                },
                icon: Icons.remove,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: InputField(
                isUnderlineBorder: false,
                isInt: true,
                controller: stockController,
                textAlign: TextAlign.center,
                onChange: (value) {
                  updateInput();
                },
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 44,
              height: 44,
              child: Button(
                onTap: () {
                  changeNumber(1);
                },
                icon: Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputDropdownItem extends StatelessWidget {
  const InputDropdownItem({super.key, required this.iconName});
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(productIcons[iconName]),
          const PaddingSpacing(),
          Text(iconName)
        ],
      ),
    );
  }
}
