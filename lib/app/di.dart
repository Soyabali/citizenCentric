import 'package:citizencentric/app/app_prefs.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

final instance = GetIt.instance;

 initAppModule() async {

final sharedPrefs = await SharedPreferences.getInstance();
// shared prefs instance
 instance.registerLazySingleton<SharedPreferences>(()=> sharedPrefs);

   // app prefs instance
   instance.registerLazySingleton<AppPreferences>(()=>AppPreferences(instance()));

   // network info
   instance.registerLazySingleton<NetworkInfo>(
           () => NetworkInfoImpl(InternetConnection()));

   // dio factory
   instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

   // app  service client
   final dio = await instance<DioFactory>().getDio();
   instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

   // remote data source
   instance.registerLazySingleton<RemoteDataSource>(
           () => RemoteDataSourceImplementer(instance()));

   // repository
   instance.registerLazySingleton<Repository>(
           () => RepositoryImpl(instance(), instance()));

 }
 // login di
initLoginModule(){
  if(!GetIt.I.isRegistered<LoginUseCase>()){
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}
// changePassword di
initChangePasswordModule(){
  if(!GetIt.I.isRegistered<ChangPasswordUseCase>()){
    instance.registerFactory<ChangPasswordUseCase>(() => ChangPasswordUseCase(instance()));
    instance.registerFactory<ChangePasswordUiModel>(() => ChangePasswordUiModel(instance()));
  }
}

resetModules() {
  instance.reset(dispose: false);
  initAppModule();
  initLoginModule();
  initChangePasswordModule();

 }