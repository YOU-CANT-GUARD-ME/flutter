import 'package:flutter/material.dart';
import 'package:nike_app/models/shoe.dart';

class ShoeTile extends StatelessWidget {
  Shoe shoe;
  ShoeTile({
    super.key,
    required this.shoe
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25),
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // shoe pic
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: Image.asset(shoe.imagePath),
          ),

          // description
          Text(
            shoe.description,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),

          //price + details
          Padding(
            padding: EdgeInsetsGeometry.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // shoe name
                    Text(
                      shoe.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),


                    // price
                    Text(
                      '\$' + shoe.price,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // plus button
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
