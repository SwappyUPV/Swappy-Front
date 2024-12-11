import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PricingSection extends StatefulWidget {
  final ValueChanged<int?> onPriceChanged;
  final ValueChanged<bool> onExchangeOnlyChanged;

  const PricingSection({
    Key? key,
    required this.onPriceChanged,
    required this.onExchangeOnlyChanged,
  }) : super(key: key);

  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection> {
  bool isPublic = false;
  bool isExchangeOnly = true; // Default to true
  TextEditingController priceController = TextEditingController();
  String? enteredPrice;

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 18, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Público',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'UrbaneMedium',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.28,
                ),
              ),
              CupertinoSwitch(
                value: isPublic,
                onChanged: (value) => setState(() => isPublic = value),
              ),
            ],
          ),
        ),
        if (isPublic) ...[
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 18, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Solo intercambio',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'UrbaneMedium',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.28,
                  ),
                ),
                CupertinoSwitch(
                  value: isExchangeOnly,
                  onChanged: (value) {
                    setState(() => isExchangeOnly = value);
                    widget.onExchangeOnlyChanged(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Swappy no permite la venta exclusiva de prendas sin intercambio asociado. Así, no es posible publicar una prenda solo para su venta',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontSize: 11,
                    fontFamily: 'OpenSans',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Más detalles e información sobre los gastos de envío en nuestras aquí',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 11,
                    fontFamily: 'OpenSans',
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          if (!isExchangeOnly) _buildPriceInput(),
        ],
      ],
    );
  }

  Widget _buildPriceInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 18, bottom: 10),
      child: Row(
        children: [
          const Text(
            'Precio',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'UrbaneMedium',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(width: 16), // Increased spacing
          if (enteredPrice == null)
            Container(
              width: 50,
              height: 30, // Set a fixed width for the TextField
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w500, // Smaller font size
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Smaller padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintStyle: const TextStyle(color: Colors.grey), // Placeholder color
                ),
                onSubmitted: (value) {
                  setState(() {
                    enteredPrice = value;
                    widget.onPriceChanged(int.tryParse(value));
                  });
                },
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    '$enteredPrice €',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        enteredPrice = null;
                        priceController.clear();
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
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