import 'package:meta/meta.dart';

class Company{
  Company({
    this.compCode,
    this.compName,
  });

  String compCode;
  String compName;
}

final companys = <Company>[
  Company(
    compCode: 'BIO',
    compName: 'Bioscience Animal Health',
  ),
  Company(
    compCode: 'NIC',
    compName: 'Nutrition Improvement',
  ),
  Company(
    compCode: 'SIS',
    compName: 'Special Ingredient Services',
  ),
  Company(
    compCode: 'FAITH',
    compName: 'Feed And Ingredients Technological Hub',
  ),
  Company(
    compCode: 'PEDEX',
    compName: 'PED EX',
  ),
  Company(
    compCode: 'PTK',
    compName: 'PROTEST KIT',
  ),
];