
import 'package:citizencentric/data/data_source/remote_data_source.dart';
import 'package:citizencentric/data/mapper/mappper.dart';
import 'package:citizencentric/data/network/failure.dart';
import 'package:citizencentric/data/network/network_info.dart';
import 'package:citizencentric/data/request/request.dart';
import 'package:citizencentric/domain/model/model.dart';
import 'package:citizencentric/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import '../data_source/cache_keys.dart';
import '../data_source/local_data_source.dart';
import '../network/error_handler.dart';
import '../responses/response.dart';

class RepositoryImpl implements Repository {

  final RemoteDataSource _remote;
  final LocalDataSource _local;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remote, this._local, this._networkInfo);

  // ========================= LOGIN =========================

  @override
  Future<Either<Failure, Authentication>> login(LoginRequest request) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await _remote.login(request);

      if (response.result == "1" &&
          response.data != null &&
          response.data!.isNotEmpty) {
        return Right(response.data!.first.toDomain());
      }

      return Left(
        Failure(
          int.tryParse(response.result ?? '') ?? ApiInternalStatus.FAILURE,
          response.msg ?? ResponseMessage.DEFAULT,
        ),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  // ========================= CHANGE PASSWORD =========================

  @override
  Future<Either<Failure, ChangePasswordModel>> changePassword(
      ChangePassWordRequest request) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      final responses = await _remote.changePassword(request);
      final successItem = responses.firstWhere(
            (e) => e.Result == "1",
        orElse: () => responses.first,
      );
      if (successItem.Result == "1") {
        return Right(successItem.toDomain());
      }

      return Left(
        Failure(
          int.tryParse(successItem.Result ?? '') ?? ApiInternalStatus.FAILURE,
          successItem.Msg ?? ResponseMessage.DEFAULT,
        ),
      );
    } catch (e) {
      return Left(ErrorHandler
          .handle(e)
          .failure);
    }
  }

  // ========================= STAFF LIST =========================

  @override
  Future<Either<Failure, List<StaffListModel>>> staffList(
      StaffListRequest request,) async {
    try {
      // 🔹 Try cache first
      final cached = await _local.getListFromCache(
        CacheKeys.staffList,
        CacheInterval.oneMinute,
      );

      return Right(
        cached.map((e) => (e as StafListResponse).toDomain()).toList(),
      );
    } catch (_) {
      // 🔹 Cache miss → API
      if (!await _networkInfo.isConnected) {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }

      try {
        final response = await _remote.stafflist(request);

        await _local.saveListToCache(CacheKeys.staffList, response);

        return Right(response.map((e) => e.toDomain()).toList());
      } catch (e) {
        return Left(ErrorHandler
            .handle(e)
            .failure);
      }
    }
  }

  // ========================= INSPECTION LIST =========================

  @override
  Future<Either<Failure, List<InspectionStatusModel>>> inspectionList(
      InspectionListRequest request,) async {
    // 🔹 STEP 1: Try CACHE first
    try {
      final cached = await _local.getListFromCache(
        CacheKeys.inspectionList,
        CacheInterval.oneMinute,
      );

      // Cache is List<InspectionStatusItemResponse>
      final cachedList = cached
          .map((e) => (e as InspectionStatusItemResponse).toDomain())
          .toList();

      if (cachedList.isNotEmpty) {
        return Right(cachedList);
      }
    } catch (_) {
      // Ignore cache error → go to API
    }

    // 🔹 STEP 2: Check INTERNET
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    // 🔹 STEP 3: API CALL

    try {
      final response = await _remote.inspectionList(request);
      // response = InspectionStatusListResponse

      // ❌ API FAILURE
      if (response.result != "1" || response.data == null) {
        return Left(
          Failure(
            ApiInternalStatus.FAILURE,
            response.msg ?? "Something went wrong",
          ),
        );
      }

      // 🔹 STEP 4: MAP TO DOMAIN
      final list = response.data!.map((item) => item.toDomain()).toList();

      // 🔹 STEP 5: SAVE TO CACHE (save ITEM list, not wrapper)
      await _local.saveListToCache(CacheKeys.inspectionList, response.data!);
      return Right(list);
    } catch (e) {
      return Left(ErrorHandler
          .handle(e)
          .failure);
    }
  }

// CounterDashBoard
//   ----count Dashboard----.

  @override
  Future<Either<Failure, CountDashboardModel>> countDashboard(CountDashboardRequest request) async {
    // 🔹 STEP 1: Try CACHE first
    try {
      final cached = await _local.getObjectFromCache(
        CacheKeys.countDashboard,
        CacheInterval.oneMinute,
      );

      // Cache is CountDashboardItemResponse
      final cachedModel =
      (cached as CountDashboardItemResponse).toDomain();

      return Right(cachedModel);
    } catch (_) {
      // Ignore cache error → go to API
    }

    // 🔹 STEP 2: Check INTERNET
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    // 🔹 STEP 3: API CALL
    try {
      final response = await _remote.countDashboard(request);
      // response = CountDashboardListResponse

      // ❌ API FAILURE
      if (response.result != "1" || response.data == null ||
          response.data!.isEmpty) {
        return Left(
          Failure(
            ApiInternalStatus.FAILURE,
            response.msg ?? "Something went wrong",
          ),
        );
      }

      // 🔹 STEP 4: TAKE FIRST ITEM (Dashboard is single object)
      final itemResponse = response.data!.first;
      // 🔹 STEP 5: MAP TO DOMAIN
      final model = itemResponse.toDomain();

      // 🔹 STEP 6: SAVE TO CACHE (save ITEM, not wrapper)
      await _local.saveObjectToCache(
        CacheKeys.countDashboard,
        itemResponse,
      );
      return Right(model);
    } catch (e) {
      return Left(ErrorHandler
          .handle(e)
          .failure);
    }
  }

  @override
  Future<Either<Failure, List<ParkListByAgencyModel>>> parkListByAgency(
      ParkListByAgencyRequest request) async {

    /// 🔹 STEP 1: TRY CACHE FIRST
    try {
      final cached = await _local.getListFromCache(
        CacheKeys.parkListByAgency,
        CacheInterval.oneMinute,
      );

      final cachedList = cached
          .map((e) => (e as ParkListByAgencyItemResponse).toDomain())
          .toList();

      if (cachedList.isNotEmpty) {
        return Right(cachedList);
      }
    } catch (_) {
      // ignore cache error → go API
    }

    /// 🔹 STEP 2: CHECK INTERNET
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    /// 🔹 STEP 3: API CALL
    try {
      final response = await _remote.parklistByAgency(request);

      /// ❌ API FAILURE
      if (response.result != "1" ||
          response.data == null ||
          response.data!.isEmpty) {
        return Left(
          Failure(
            ApiInternalStatus.FAILURE,
            response.msg ?? "Something went wrong",
          ),
        );
      }

      /// 🔹 STEP 4: MAP TO DOMAIN
      final list =
      response.data!.map((item) => item.toDomain()).toList();

      /// 🔹 STEP 5: SAVE TO CACHE
      await _local.saveListToCache(
        CacheKeys.parkListByAgency,
        response.data!,
      );

      return Right(list);

    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

// Future<Either<Failure, List<ParkListByAgencyModel>>> parkListByAgency(ParkListByAgencyRequest request) async {
  //
  //   try {
  //     final cached = await _local.getObjectFromCache(
  //       CacheKeys.parkListByAgency,
  //       CacheInterval.oneMinute,
  //     );
  //
  //     // Cache is CountDashboardItemResponse
  //     final cachedModel =
  //     (cached as ParkListByAgencyItemResponse).toDomain();
  //
  //     return Right(cachedModel);
  //   } catch (_) {
  //     // Ignore cache error → go to API
  //   }
  //
  //   // 🔹 STEP 2: Check INTERNET
  //   if (!await _networkInfo.isConnected) {
  //     return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
  //   }
  //
  //   // 🔹 STEP 3: API CALL
  //   try {
  //     final response = await _remote.parklistByAgency(request);
  //     // response = CountDashboardListResponse
  //
  //     // ❌ API FAILURE
  //     if (response.result != "1" || response.data == null ||
  //         response.data!.isEmpty) {
  //       return Left(
  //         Failure(
  //           ApiInternalStatus.FAILURE,
  //           response.msg ?? "Something went wrong",
  //         ),
  //       );
  //     }
  //     // 🔹 STEP 4: TAKE FIRST ITEM (Dashboard is single object)
  //     final itemResponse = response.data!.first;
  //     // 🔹 STEP 5: MAP TO DOMAIN
  //     final model = itemResponse.toDomain();
  //
  //     // 🔹 STEP 6: SAVE TO CACHE (save ITEM, not wrapper)
  //     await _local.saveObjectToCache(
  //       CacheKeys.countDashboard,
  //       itemResponse,
  //     );
  //     return Right(model);
  //   } catch (e) {
  //     return Left(ErrorHandler
  //         .handle(e)
  //         .failure);
  //   }
  // }

}
