import 'dart:convert';

import 'package:daily_tarot_app/controller/app_controller.dart';
import 'package:daily_tarot_app/modal/tarot_card.dart';
import 'package:daily_tarot_app/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  AppController.soulCards = jsonDecode(await rootBundle.loadString("assets/data/soul_cards_data.json")).map<TarotCard>((e) => TarotCard.fromJson(e as Map<String, dynamic>)).toList();
  AppController.loveCards = jsonDecode(await rootBundle.loadString("assets/data/loves_tarot_cards_data.json")).map<TarotCard>((e) => TarotCard.fromJson(e as Map<String, dynamic>)).toList();
  AppController.fruitCards = jsonDecode(await rootBundle.loadString("assets/data/fruit_tarot_cards_data.json")).map<TarotCard>((e) => TarotCard.fromJson(e as Map<String, dynamic>)).toList();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}


