import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final List<String> styles;
  final String size;
  final int price;
  final String quality;
  final String image;
  final String category;
  final bool isExchangeOnly;
  final Color? color;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.styles,
    required this.size,
    required this.price,
    required this.quality,
    required this.image,
    required this.category,
    required this.isExchangeOnly,
    this.color,
  });
}

List<Product> products = [
  Product(
      id: '1',
      title: "Office Code",
      price: 234,
      size: "12",
      description: dummyText,
      image: "assets/images/bag_1.png",
      category: "Bags",
      isExchangeOnly: false,
      styles: ["Office", "Code"],
      quality: "New",
      color: const Color.fromARGB(255, 81, 99, 241)),
  Product(
      id: '2',
      title: "Belt Bag",
      price: 234,
      size: "8",
      description: dummyText,
      image: "assets/images/bag_2.png",
      category: "Bags",
      isExchangeOnly: false,
      styles: ["Office", "Code"],
      quality: "New",
      color: const Color(0xFFD3A984)),
  Product(
      id: '3',
      title: "Hang Top",
      price: 234,
      size: "10",
      description: dummyText,
      image: "assets/images/bag_3.png",
      category: "Bags",
      isExchangeOnly: false,
      styles: ["Office", "Code"],
      quality: "New",
      color: const Color(0xFF989493)),
  Product(
      id: '4',
      title: "Old Fashion",
      price: 234,
      size: "11",
      description: dummyText,
      image: "assets/images/bag_4.png",
      category: "Bags",
      isExchangeOnly: false,
      styles: ["Office", "Code"],
      quality: "New",
      color: const Color(0xFFE6B398)),
  Product(
      id: '5',
      title: "Office Code",
      price: 234,
      size: "12",
      description: dummyText,
      image: "assets/images/bag_5.png",
      category: "Bags",
      isExchangeOnly: false,
      styles: ["Office", "Code"],
      quality: "New",
      color: const Color(0xFFFB7883)),
];
String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
