import 'package:flutter/widgets.dart';
import 'package:ismart_crm/models/discount.dart';

Widget setDiscountType(Discount discount) {
  if (discount.type == 'THB') {
    return Text('THB');
  } else {
    return Text('%');
  }
}

