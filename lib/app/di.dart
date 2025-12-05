import 'package:citizencentric/app/app_prefs.dart';
import 'package:citizencentric/domain/usecase/staffList_usecase.dart';
import 'package:citizencentric/presentation/main/home/home_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/data_source/local_data_source.dart';
import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';
import '../domain/model/model.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/change_password_usecase.dart';
import '../domain/usecase/login_usecase.dart';
import '../presentation/change_password/change_password_ui_model.dart';
import '../presentation/login/login_viewmodel.dart';


import 'package:citizencentric/app/app_prefs.dart';
import 'package:citizencentric/domain/usecase/staffList_usecase.dart';
// ... other imports

final instance = GetIt.instance;

// CORRECTED initAppModule
Future<void> initAppModule() async {

  // shared prefs instance
  if (!GetIt.I.isRegistered<SharedPreferences>()) {
    final sharedPrefs = await SharedPreferences.getInstance();
    instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  }

  // app prefs instance
  if (!GetIt.I.isRegistered<AppPreferences>()) {
    instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  }

  // network info
  if (!GetIt.I.isRegistered<NetworkInfo>()) {
    instance.registerLazySingleton<NetworkInfo>(
            () => NetworkInfoImpl(InternetConnection()));
  }

  // dio factory
  if (!GetIt.I.isRegistered<DioFactory>()) {
    instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));
  }

  // app service client
  if (!GetIt.I.isRegistered<AppServiceClient>()) {
    final dio = await instance<DioFactory>().getDio();
    instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  }

  // remote data source
  if (!GetIt.I.isRegistered<RemoteDataSource>()) {
    instance.registerLazySingleton<RemoteDataSource>(
            () => RemoteDataSourceImplementer(instance()));
  }

  // local data source
  if (!GetIt.I.isRegistered<LocalDataSource>()) {
    instance.registerLazySingleton<LocalDataSource>(
            () => LocalDataSourceImplementer());
  }

  // repository
  if (!GetIt.I.isRegistered<Repository>()) {
    instance.registerLazySingleton<Repository>(
            () => RepositoryImpl(instance(), instance(), instance()));
  }
}

// login di - THIS IS ALREADY CORRECT
initLoginModule(){
  if(!GetIt.I.isRegistered<LoginUseCase>()){
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

// changePassword di - THIS IS ALREADY CORRECT
initChangePasswordModule(){
  if(!GetIt.I.isRegistered<ChangPasswordUseCase>()){
    instance.registerFactory<ChangPasswordUseCase>(() => ChangPasswordUseCase(instance()));
    instance.registerFactory<ChangePasswordUiModel>(() => ChangePasswordUiModel(instance()));
  }
}

// home di - THIS IS ALREADY CORRECT
initHomeModule() {
  if (!GetIt.I.isRegistered<StaffListUseCase>()) {
    instance.registerFactory<StaffListUseCase>(() => StaffListUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

// resetModules - THIS LOGIC IS NOW SAFE
resetModules() {
  instance.reset(dispose: false);
  initAppModule();
  initLoginModule();
  initChangePasswordModule();
}

// firebaseAuth - THIS IS ALREADY CORRECT
initFirebaseModule() {
  if (!GetIt.I.isRegistered<FirebaseAuth>()) {
    instance.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  if (!GetIt.I.isRegistered<FirebaseFirestore>()) {
    instance.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  }

  if (!GetIt.I.isRegistered<FirebaseStorage>()) {
    instance.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  }
}
