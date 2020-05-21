
import 'package:adhkaar/prayercalculator/src/models/calculation_method.dart';
import 'package:adhkaar/prayercalculator/src/models/high_latitude_adjustment.dart';
import 'package:adhkaar/prayercalculator/src/models/juristic_method.dart';


class MethordModel {

  String name;
  int id;

  CalculationMethodPreset calculationMethodPreset;
  JuristicMethodPreset juristicMethodPreset;
  HighLatitudeAdjustment higherAltitudePresent;
  MethordModel.forCalcMethrod(this.name, this.id, this. calculationMethodPreset);
  MethordModel.forJuristicMethrod(this.name, this.id, this. juristicMethodPreset);
  MethordModel.forHigherAltitude(this.name, this.id, this. higherAltitudePresent);

}
