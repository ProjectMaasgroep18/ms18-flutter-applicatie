import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Dashboard/model/products.dart';
import '../../config.dart';

import '../model/course_model.dart';
import '../model/planing_model.dart';
import '../model/statistics_model.dart';

final List<Course> course = [
  Course(
      text: "France",
      lessons: "35 Lessons",
      imageUrl: "images/pic/img1.png",
      percent: 75,
      backImage: "images/box/box1.png",
      color: Colors.white),
];

final List<Planing> planing = [
  Planing(
    heading: "Reading-Begineer Topic 1",
    subHeading: "8:00 AM - 10:00 AM",
    color: mainColor,
    icon: const Icon(
      Icons.menu_book_outlined,
      color: Colors.white,
    ),
  ),
  Planing(
    heading: "Listening - Intermediate Topic 1",
    subHeading: "03:00 PM - 04:00 PM",
    color: const Color(0xffE2EDD2),
    icon: Icon(
      Icons.menu_book_outlined,
      color: Colors.white,
    ),
  ),
];

final List<Statistics> statistics = [
  Statistics(
    link: "ListPictures",
    title: "Nieuwe foto's",
    number: "02",
  ),
  Statistics(
    link: "DeclarationsMenu",
    title: "Declaraties",
    number: "250",
  ),
];

final List<AllProducts> allProducts = [
  AllProducts(
      link: "#FC16A6A", title: "Drinken", number: "02", text: "#A73131"),
  AllProducts(link: "#FFCF87", title: "Eten", number: "250", text: "#A27430"),
  AllProducts(link: "#87F0FF", title: "Snoep", number: "02", text: "#298693"),
  AllProducts(link: "#E09FFF", title: "Coffee", number: "250", text: "#9137BC"),
];
