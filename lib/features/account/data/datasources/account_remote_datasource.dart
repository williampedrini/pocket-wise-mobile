import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account_model.dart';
import '../models/balance_model.dart';

abstract class AccountRemoteDataSource {
  Future<AccountModel> getAccount(String iban);
  Future<BalanceModel?> getAccountBalance(String iban);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AccountRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<AccountModel> getAccount(String iban) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/accounts/$iban'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return AccountModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load account');
    }
  }

  @override
  Future<BalanceModel?> getAccountBalance(String iban) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/accounts/$iban/balances'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final balances = jsonList
          .map((json) => BalanceModel.fromJson(json))
          .toList();
      
      return BalanceModel.getMostRecent(balances);
    } else {
      throw Exception('Failed to load account balance');
    }
  }
}
