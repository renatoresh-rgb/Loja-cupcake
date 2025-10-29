import 'dart:developer';

import 'package:my_light_app/infra/adapter/http_erro.dart';
import 'package:my_light_app/infra/adapter/request_adapter.dart';
import 'package:my_light_app/infra/client_http/client_http.dart';
import 'package:my_light_app/infra/repositories/casa_repositories/casa_model.dart';
import 'package:my_light_app/infra/repositories/casa_repositories/casa_repository.dart';

final class CasaRepositoryImpl implements CasaRepository {
  final ClientHttp _clientHttp;

  CasaRepositoryImpl({required ClientHttp clientHttp})
      : _clientHttp = clientHttp;

  @override
  Future<ProprietarioResponseModel> getCasa(ProprietarioModel casaModel) async {
    try {
      final request = Request('/casa', body: casaModel.toJson());
      final response = await _clientHttp.get(request);
      log(response.status.toString());
      if (response.data == null) {
        throw HttpError(request: request, response: response);
      }
      return ProprietarioResponseModel.fromJson(response.data!);
    } on HttpError catch (_) {
      log(_.response.status.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProprietarioResponseModel>> getCasas() async {
    try {
      final request = Request("/casas");
      final response = await _clientHttp.get(request);
      if (response.data == null) {
        throw HttpError(request: request, response: response);
      }
      final model = response.data!.map<ProprietarioResponseModel>(
          (e) => ProprietarioResponseModel.fromJson(e));
      return model.toList();
    } on HttpError catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
