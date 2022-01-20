import 'package:myfit_bmi/model/bmi.dart';

class DataService {
  static DataService instance = DataService();

  final List<Bmi> bmiHistory = [ Bmi(1), Bmi(2)];

  DataService() { }
}