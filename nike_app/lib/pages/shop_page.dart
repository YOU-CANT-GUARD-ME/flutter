import 'package:flutter/material.dart';
import 'package:nike_app/models/shoe.dart';

import '../components/shoe_tile.dart';
import '../models/shoe.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search bar
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Search', style: TextStyle(color: Colors.grey),),
              Icon(Icons.search),
            ],
          ),
        ),

        // message
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 25),
          child: Text(
            "Everyone files.. some fly longer than others",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),

        // hot picks
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Hot Picks",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "see all",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),

        SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              // create a shoe
              Shoe shoe = Shoe(name: 'Air Jorden', price: '240', imagePath: 'lib/images/shoe1.png', description: 'cool shoe');
              return ShoeTile(
                shoe: shoe,
              );
            },
          ),
        ),

        Padding(
          padding: EdgeInsetsGeometry.only(
            top: 60,
            left:25,
            right: 25,
          ),
          child: Divider(
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
