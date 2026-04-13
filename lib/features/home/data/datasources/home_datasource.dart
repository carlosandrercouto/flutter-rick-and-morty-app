import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/enums/api_response_status_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/helpers/database_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/apis/api_endpoints.dart';
import '../../../../core/entities/api_response.dart';

import '../../domain/entities/entities_export.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/models_export.dart';
import '../../../../core/enums/cache_source_enum.dart';

/// Datasource da feature Home com suporte a cache local via SQLite.
///
/// Estratégia de cache (TTL = 1 minuto):
/// - Se existir uma entrada válida no SQLite, retorna os dados locais.
/// - Caso contrário, realiza a request à API, atualiza o cache e retorna.
///
/// A origem dos dados (local ou remota) é exposta via [lastEpsodeSource] e
/// [lastCharactersSource] para exibição na UI.
class HomeDatasource extends HomeRepository {
  final ApiService _apiService;
  final DatabaseHelper _db;

  HomeDatasource({
    ApiService? apiService,
    DatabaseHelper? databaseHelper,
  }) : _apiService = apiService ?? ApiService(),
       _db = databaseHelper ?? DatabaseHelper.instance;

  static const Duration _cacheTtl = Duration(minutes: 1);

  // Chaves de cache
  String _epsodeKey(int id) => 'episode_$id';
  String _charactersKey(List<int> ids) => 'characters_${ids.join(",")}';

  /// Origem do último carregamento do episódio.
  CacheSource lastEpsodeSource = CacheSource.remote;

  /// Origem do último carregamento dos personagens.
  CacheSource lastCharactersSource = CacheSource.remote;

  // ── getEpsode ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure?, Epsode>> getEpsode({required int id}) async {
    final String cacheKey = _epsodeKey(id);

    // 1. Verificar cache
    final CacheEntry? cached = await _db.get(key: cacheKey);
    if (cached != null && cached.isValid(ttl: _cacheTtl)) {
      log('Cache HIT: $cacheKey', name: 'HomeDatasource');
      lastEpsodeSource = CacheSource.local;

      try {
        final Map<String, dynamic> map =
            jsonDecode(cached.jsonData) as Map<String, dynamic>;
        return Right(EpsodeModel.fromCacheMap(map: map));
      } catch (e) {
        log(
          'Cache parse error: $e — falling through to API',
          name: 'HomeDatasource',
        );
      }
    }

    // 2. Request à API
    log('Cache MISS: $cacheKey', name: 'HomeDatasource');
    lastEpsodeSource = CacheSource.remote;

    final ApiEndpoints endpoint = ApiEndpoints.getEpsodios;
    final ApiResponse apiResponse = await _apiService(
      endpoint: '${endpoint.url}/$id',
      request: ApiRequest(requestType: endpoint.requestType, body: {}),
      devLog: 'HomeDatasource: getEpsode',
      currentStackTrace: StackTrace.current,
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final EpsodeModel resultData = EpsodeModel.fromMap(
          map: apiResponse.result!,
        );

        // 3. Persistir no cache
        await _db.upsert(
          key: cacheKey,
          jsonData: jsonEncode(resultData.toMap()),
        );

        return Right(resultData);
      } catch (error) {
        log('Error: ${error.toString()}', name: 'HomeDatasource: getEpsode');

        /// TODO: Implementar gravação de logs de erro tal como Firebase Analytics ou similar aqui

        return const Left(null);
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Left(TimeoutFailure());
    } else if (apiResponse.status == ApiResponseStatus.errorSessionExpired) {
      return Left(SessionExpiredFailure());
    }

    return const Left(null);
  }

  // ── getCharacters ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure?, List<CharacterEntity>>> getCharacters({
    required List<int> ids,
  }) async {
    final List<int> sortedIds = List.from(ids)..sort();
    final String cacheKey = _charactersKey(sortedIds);

    // 1. Verificar cache
    final CacheEntry? cached = await _db.get(key: cacheKey);
    if (cached != null && cached.isValid(ttl: _cacheTtl)) {
      log('Cache HIT: $cacheKey', name: 'HomeDatasource');
      lastCharactersSource = CacheSource.local;

      try {
        final List<dynamic> list = jsonDecode(cached.jsonData) as List<dynamic>;
        final List<CharacterEntity> characters = list
            .map(
              (e) => CharacterModel.fromCacheMap(
                map: e as Map<String, dynamic>,
              ),
            )
            .toList();
        return Right(characters);
      } catch (e) {
        log(
          'Cache parse error: $e — falling through to API',
          name: 'HomeDatasource',
        );
      }
    }

    // 2. Request à API
    log('Cache MISS: $cacheKey', name: 'HomeDatasource');
    lastCharactersSource = CacheSource.remote;

    final ApiEndpoints endpoint = ApiEndpoints.getCharacters;
    final String idsParam = sortedIds.join(',');

    final ApiResponse apiResponse = await _apiService(
      endpoint: '${endpoint.url}/$idsParam',
      request: ApiRequest(requestType: endpoint.requestType, body: {}),
      devLog: 'HomeDatasource: getCharacters',
      currentStackTrace: StackTrace.current,
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final result = apiResponse.result!;

        final List<dynamic> rawList = result.containsKey('data')
            ? result['data'] as List<dynamic>
            : [result];

        final List<CharacterEntity> characters =
            rawList
                .map(
                  (item) => CharacterModel.fromMap(
                    map: item as Map<String, dynamic>,
                  ),
                )
                .toList()
              ..sort((a, b) => a.name.compareTo(b.name));

        // 3. Persistir no cache
        await _db.upsert(
          key: cacheKey,
          jsonData: jsonEncode(
            characters.cast<CharacterModel>().map((c) => c.toMap()).toList(),
          ),
        );

        return Right(characters);
      } catch (error) {
        log(
          'Error: ${error.toString()}',
          name: 'HomeDatasource: getCharacters',
        );

        /// TODO: Implementar gravação de logs de erro tal como Firebase Analytics ou similar aqui

        return const Left(null);
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Left(TimeoutFailure());
    } else if (apiResponse.status == ApiResponseStatus.errorSessionExpired) {
      return Left(SessionExpiredFailure());
    }

    return const Left(null);
  }
}
