import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FuelCalculator extends StatefulWidget {
  const FuelCalculator({super.key});

  @override
  State<FuelCalculator> createState() => _FuelCalculatorState();
}

TextEditingController MilageController = TextEditingController();
TextEditingController DistanceController = TextEditingController();
TextEditingController FuelPriceController = TextEditingController();
double? fuelExpenxe;

class _FuelCalculatorState extends State<FuelCalculator> {
  @override
  void initState() {
    fuelExpenxe = 0.0;
    MilageController.clear();
    DistanceController.clear();
    FuelPriceController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹$fuelExpenxe',
                        style: GoogleFonts.tenorSans(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            fuelPriceChecking(
                                MilageController.text,
                                DistanceController.text,
                                FuelPriceController.text);
                          },
                          child: Text("Check",
                              style: GoogleFonts.tenorSans(fontSize: 20)),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  style: GoogleFonts.tenorSans(),
                  keyboardType: TextInputType.number,
                  controller: DistanceController,
                  decoration: InputDecoration(
                    hintText: 'Distance',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: GoogleFonts.tenorSans(),
                  keyboardType: TextInputType.number,
                  controller: MilageController,
                  decoration: InputDecoration(
                    hintText: 'Vehicle Mileage',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: GoogleFonts.tenorSans(),
                  keyboardType: TextInputType.number,
                  controller: FuelPriceController,
                  decoration: InputDecoration(
                    hintText: 'Fuel Price',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fuelPriceChecking(String milage, String distance, String fuelPrice) {
    double Milage = double.tryParse(milage)!;
    double Distance = double.tryParse(distance)!;
    double FuelPrice = double.tryParse(fuelPrice)!;
    double consuming = Distance / Milage;
    double expenxe = consuming * FuelPrice;
    setState(() {
      fuelExpenxe = expenxe.roundToDouble();
    });
  }
}
