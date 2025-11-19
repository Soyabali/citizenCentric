
import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/request/request.dart';
import '../model/model.dart';

abstract class Repository {
  //  This is a Repository class that here i manage a login or Any Other Repository.
  // Every api repository put here , but you should carefully understand what class put in this syntak

  Future<Either<Failure,Authentication>> login(LoginRequest loginRequest);
  // You should Know : {{Future<Either<Failure,Authentication>> }}
  // Future its a dart class that indicate return any thing in a fututre
  // here {{<Either<Failure,Authentication>>}}, here you should break this concept step by step
   // {{Either}} , this is a concept of Dart programming language, that give a left and right concept.
  // {{<Failure,Authentication>}}, here you shuld clear Failure is a class that give us , code and msg of any api
  // according to http resonse that statically managed.
  // {Authentication} this is a model class here me made a LoginModel
  // login(LoginRequest loginRequest);
  // here login is a function name.hew have a parameter LoginRequest loginRequest
  // LoginRequest is a class that have a parameter to api or api body field mentions.
  //-----------------AAA----------------.
  // --- ChangePassword repository
  Future<Either<Failure,ChangePasswordModel>> changePassword(ChangePassWordRequest changePasswordRequest);


}