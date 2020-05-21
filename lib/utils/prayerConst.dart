import 'package:adhkaar/model/MethordModel.dart';
import 'package:adhkaar/prayercalculator/src/models/calculation_method.dart';
import 'package:adhkaar/prayercalculator/src/models/high_latitude_adjustment.dart';
import 'package:adhkaar/prayercalculator/src/models/juristic_method.dart';

class  prayerConst {
  List<MethordModel> calculationMethord = <MethordModel>[
    MethordModel.forCalcMethrod("University of islamic Sciences, Karachi", 1,
        CalculationMethodPreset.universityOfIslamicSciencesKarachi),
    MethordModel.forCalcMethrod(
        "Malaysia, Malaysian Islamic Development Department",
        2,
        CalculationMethodPreset.departmentOfIslamicAdvancementOfMalaysia),
    MethordModel.forCalcMethrod("Egyptian General Survey Authority", 3,
        CalculationMethodPreset.egyptianGeneralAuthorityOfSurvey),
    MethordModel.forCalcMethrod("Institution of Geophysics University, Tehran",
        4, CalculationMethodPreset.instituteOfGeophysicsUniversityOfTehran),
    MethordModel.forCalcMethrod("Islamic Society of North America (ISNA)", 5,
        CalculationMethodPreset.islamicSocietyOfNorthAmerica),
    MethordModel.forCalcMethrod(
        "Ithna Ashari", 6, CalculationMethodPreset.ithnaAshari),
    MethordModel.forCalcMethrod("Majlis Ugama Islam Singapura", 7,
        CalculationMethodPreset.majlisUgamaIslamSingapura),
    MethordModel.forCalcMethrod(
        "Muslim World League", 8, CalculationMethodPreset.muslimWorldLeague),
    MethordModel.forCalcMethrod("Umm Al-Qura University", 9,
        CalculationMethodPreset.ummAlQuraUniversity),
    MethordModel.forCalcMethrod("Union des organisations islamiques de France",
        10, CalculationMethodPreset.unionDesOrganisationsIslamiquesDeFrance),
  ];

  List<MethordModel> juristicMethord = <MethordModel>[
    MethordModel.forJuristicMethrod(
        "Shafi/Maliki/Hanbali", 1, JuristicMethodPreset.standard),
    MethordModel.forJuristicMethrod("Hanafi", 2, JuristicMethodPreset.hanafi),
  ];

  List<MethordModel> higherLatitude = <MethordModel>[
    MethordModel.forHigherAltitude("None", 1, HighLatitudeAdjustment.none),
    MethordModel.forHigherAltitude(
        "Middle of the Night Methord", 2, HighLatitudeAdjustment.middleOfNight),
    MethordModel.forHigherAltitude("One-Seventh of the Night Methord", 3,
        HighLatitudeAdjustment.oneSeventhOfNight),
    MethordModel.forHigherAltitude(
        "Angle Based Methord", 4, HighLatitudeAdjustment.angleBased),
  ];



}
