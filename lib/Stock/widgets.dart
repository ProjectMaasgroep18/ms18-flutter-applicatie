import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import '../config.dart';

const Map<String, IconData> productIcons = {
  "Hamburger": Icons.lunch_dining,
  "Taart": Icons.cake,
  "Koffie": Icons.local_bar,
  "Cocktail": Icons.local_cafe,
  "Liquor": Icons.liquor,
  "Pizza": Icons.local_pizza,
  "Ijs": Icons.icecream,
  "Croissant": Icons.bakery_dining,
  "Soep": Icons.soup_kitchen,
  "Vis": Icons.set_meal,
  "Schaaltje": Icons.rice_bowl,
  "Dinner": Icons.dinner_dining,
  "Spiegelei": Icons.egg_alt,
  "Thee": Icons.emoji_food_beverage,
  "Noodels": Icons.ramen_dining,
  "Brood": Icons.breakfast_dining,
  "Tapas": Icons.tapas,
  "Bier": Icons.sports_bar,
  "Drank": Icons.local_drink,
  "Wijn": Icons.wine_bar,
  "Koffie ": Icons.coffee,
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
      title: "Product ${isChange ? 'wijzigen' : 'toevoegen'}",
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
              labelText: "Icoon",
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

      stockProduct.quantity = int.tryParse(countController.text) ?? 0;
      onSave(stockProduct);
    }
  });
}

class StockElement extends StatelessWidget {
  final StockProduct stockProduct;
  final Function(String?)? onChange;
  late TextEditingController stockController;
  final Function(StockProduct)? onSave;
  final Function()? onDelete;
  final bool isReadOnly;

  StockElement({
    super.key,
    required this.stockProduct,
    this.onChange,
    this.onSave,
    this.onDelete,
    this.isReadOnly = false,
  }) {
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
      onTap: isReadOnly
          ? null
          : () {
              addItemsDialog(context, (stockProduct) {
                if (onSave != null) {
                  onSave!(stockProduct);
                }
              }, onDelete, stockProduct);
            },
      leading: isReadOnly
          ? null
          : Container(
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
      title: Text(stockProduct.product.name),
      subtitle: Text('€${priceFormat.format(stockProduct.product.price)}'),
      contentPadding: EdgeInsets.zero,
      trailing: isReadOnly
          ? Text(stockProduct.quantity.toString(), style: const TextStyle(fontSize: 15),)
          : SizedBox(
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
