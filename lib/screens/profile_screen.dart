// ------------------ Profile Controller ------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = 'John Doe'.obs;
  var email = 'johndoe@example.com'.obs;
  var phone = '123-456-7890'.obs;

  void updateProfile(String newName, String newEmail, String newPhone) {
    name.value = newName;
    email.value = newEmail;
    phone.value = newPhone;
  }
}

// ------------------ Profile Screen ------------------
class ProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => TextField(
              controller: nameController..text = profileController.name.value,
              decoration: InputDecoration(labelText: 'Name'),
            )),
            Obx(() => TextField(
              controller: emailController..text = profileController.email.value,
              decoration: InputDecoration(labelText: 'Email'),
            )),
            Obx(() => TextField(
              controller: phoneController..text = profileController.phone.value,
              decoration: InputDecoration(labelText: 'Phone'),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                profileController.updateProfile(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                );
                Get.snackbar('Profile Updated', 'Your profile information has been updated.', snackPosition: SnackPosition.BOTTOM);
              },
              child: Text('Save Changes'),
            )
          ],
        ),
      ),
    );
  }
}
