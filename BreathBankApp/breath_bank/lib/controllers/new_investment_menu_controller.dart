import 'package:breath_bank/models/new_investment_menu_model.dart';

class NewInvestmentMenuController {
  final NewInvestmentMenuModel _model = NewInvestmentMenuModel();

  Future<Map<String, dynamic>> loadUserStats() async {
    return await _model.fetchUserStats();
  }

  final Map<String, int> durations = {
    'Express (1 minuto)': 1,
    'Breve (2 minutos)': 2,
    'Normal (5 minutos)': 5,
    'Extensa (10 minutos)': 10,
  };
}
