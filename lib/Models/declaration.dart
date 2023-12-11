import 'package:flutter/material.dart';

import 'costcentre.dart';

class Declaration {
  final int id;
  final double amount;
  final String location;
  final String note;
  final int status;
  final String statusName;
  final CostCentre costCentre;
  final String approval;

  Declaration({
    required this.id,
    required this.amount,
    required this.location,
    required this.note,
    required this.status,
    required this.statusName,
    required this.costCentre,
    required this.approval,
  });
}