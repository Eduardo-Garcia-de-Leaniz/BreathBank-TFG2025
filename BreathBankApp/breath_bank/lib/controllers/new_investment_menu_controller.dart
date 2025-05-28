import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/models/new_investment_menu_model.dart';

class NewInvestmentMenuController {
  final NewInvestmentMenuModel model = NewInvestmentMenuModel();

  Future<Map<String, dynamic>> loadUserStats() async {
    return await model.fetchUserStats();
  }

  final Map<String, int> durations = {
    Strings.expressInvestment: 1,
    Strings.briefInvestment: 2,
    Strings.normalInvestment: 5,
    Strings.extensiveInvestment: 10,
  };
}
