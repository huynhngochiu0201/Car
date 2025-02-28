import 'package:flutter/material.dart';
import '../../models/address_map_model.dart';

class CoffeeShopItem extends StatelessWidget {
  const CoffeeShopItem(
    this.shop, {
    super.key,
    this.onPressed,
  });

  final Function()? onPressed;
  final AddressMapModel shop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        color: Colors.white,
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 2.6,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                shop.name ?? '-:-',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
