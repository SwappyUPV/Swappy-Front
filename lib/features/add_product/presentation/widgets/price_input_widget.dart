import 'package:flutter/material.dart';

class PriceInputWidget extends StatelessWidget {
  final bool isExchangeOnly;
  final Function(int?) onPriceChanged;
  final Function(bool) onExchangeOnlyChanged;

  const PriceInputWidget({
    Key? key,
    required this.isExchangeOnly,
    required this.onPriceChanged,
    required this.onExchangeOnlyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Precio',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            enabled: !isExchangeOnly,
            validator: (value) {
              if (!isExchangeOnly && (value == null || value.isEmpty)) {
                return 'Este campo es obligatorio si no es solo intercambio';
              }
              if (!isExchangeOnly && int.tryParse(value!) == null) {
                return 'Ingrese solo números';
              }
              return null;
            },
            onSaved: (value) => onPriceChanged(int.tryParse(value ?? '')),
          ),
        ),
        SizedBox(width: 10),
        Column(
          children: [
            Text('Solo intercambio'),
            Checkbox(
              value: isExchangeOnly,
              onChanged: (value) => onExchangeOnlyChanged(value!),
            ),
          ],
        ),
      ],
    );
  }
}
