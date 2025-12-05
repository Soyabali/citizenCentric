import 'package:flutter/material.dart';

import '../../data/data_source/local_data_hive.dart';
import '../../domain/model/hive_model/login_model.dart';
import '../../domain/model/hive_model/registration_model.dart';
import '../../domain/model/hive_model/server_form_model.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Hive Example")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                print("-----21--save --");
                final model = LoginModel(
                  mobile: "9871950881",
                  password: "123456789",
                );
                LocalStorage.saveLogin(model.toJson());
              },
              child: const Text("Save Login"),
            ),
            ElevatedButton(
              onPressed: () {

                final model = RegistrationModel(
                  name: "Anil",
                  email: "abc@gmial.com",
                  city: "Noida",
                );
                LocalStorage.saveRegistration(model.toJson());
              },
              child: const Text("Save Registration"),
            ),
            ElevatedButton(
              onPressed: () {
                final model = ServerFormModel(
                  userId: "2",
                  description: "ITT",
                  address: "Noida",
                  date: "5/12/2025",
                  status: "Sucesss",
                );
                LocalStorage.saveServerForm(model.toJson());
              },
              child: const Text("Save Server Form"),
            ),
            ElevatedButton(
              onPressed: () {
                print(LocalStorage.getLoginItems());
                print(LocalStorage.getRegistrationItems());
                print(LocalStorage.getServerItems());
              },
              child: const Text("Print All Data"),
            ),
            ElevatedButton(
              onPressed: () {
                LocalStorage.clearLogin();
                LocalStorage.clearRegistration();
                LocalStorage.clearServer();
              },
              child: const Text("Clear All Data"),
            )
          ],
        ),
      ),
    );
  }
}
