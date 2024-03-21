import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/screens/add_admin/controller/addAdmin_Controller.dart';
import '../../../constants/constants.dart';
import '../../my_profile/widgets/widgets.dart';
import '../controller/passwordProvider.dart';

class AddAdmin extends StatefulWidget {
  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  SingleValueDropDownController controllerGender =
  SingleValueDropDownController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKeyAddAdmin = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final passProvider = Provider.of<PasswordProvider>(context);
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: MediaQuery.of(context).size.height ,
      padding: EdgeInsets.symmetric(
        horizontal: appPadding,
        vertical: appPadding * 2,
      ),
      decoration: BoxDecoration(
          color: primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Container(
        alignment: Alignment.center,
        width: 400,
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(10)),
        child: Form(
          key: _formKeyAddAdmin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Padding(
              padding: const EdgeInsets.all(appPadding),
              child: Text("Register an Admin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),),
            ),
            Container(
            padding: const EdgeInsets.all(appPadding),
              child: TextFormField(
                controller: nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value!.length < 3){
                    return "please enter name full name";
                  }
                },
                decoration: setInputDecoration(hintText: 'Admin Name', labelText: 'Admin name'),
              ),
            ),
            Container(
            padding: const EdgeInsets.all(appPadding),

              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value){
                  if(value!.isEmpty){
                    return "Please enter email address for admin";
                  }
                  else if(!(value.contains("@") || value.contains(".com"))){
                    return "Email format: string@example.com";
                  }
                },
                decoration: setInputDecoration(hintText: 'Email', labelText: 'Admin Email'),
              ),
            ),
            Container(
            padding: const EdgeInsets.all(appPadding),
              child: DropDownTextField(
                controller: controllerGender,
                textFieldDecoration: setInputDecoration(
                  labelText: "Gender",
                  hintText: "Gender",
                ),
                clearOption: true,
                searchDecoration: const InputDecoration(
                    hintText:
                    "enter your custom hint text here"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 3,
                dropDownList: const [
                  DropDownValueModel(
                      name: 'Male', value: "Male"),
                  DropDownValueModel(
                    name: 'Female',
                    value: "Female",
                  ),
                  DropDownValueModel(
                    name: 'Other',
                    value: "Other",
                  ),
                ],
                onChanged: (val) {},
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: appPadding,right: appPadding,top: appPadding),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                controller: passwordController,
                validator: (value){
                  if(passProvider.strength != PasswordStrength.strong){
                    return "Please select a strong password";
                  }
                },
                onChanged: (value){
                  passProvider.setStrength(value.trim());
                },
                decoration: setInputDecoration(hintText: 'Password', labelText: 'Generate password',suffixIcon: GestureDetector(
                  onTap: (){
                    if(passwordController.text != ""){
                      Clipboard.setData(ClipboardData(text: passwordController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied to clipboard')),
                      );
                    }
                  },

                    child: Icon(Icons.copy))),
              ),
            ),
            Container(padding: const EdgeInsets.only(left: appPadding,right: appPadding,top: appPadding),
              child: Consumer<PasswordProvider>(
                builder: (context,passProvider,child){
                  return Visibility(
                      visible: (passProvider.strength != PasswordStrength.none)?true:false,
                          child:Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: passProvider.getPasswordStrengthColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${passProvider.strength.name}",style: TextStyle(fontWeight: FontWeight.bold,color: passProvider.getPasswordStrengthColor),),
                              )
                            ],
                          ),
                  );
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: GestureDetector(
                onTap: (){
                  passwordController.text= passProvider.generateStrongPassword();
                  passProvider.setStrength(passwordController.text);
                },
                  child: Text("Generate Password",style: TextStyle(color: primaryColor,fontWeight: FontWeight.normal),)),
            ),
            Container(
              padding: EdgeInsets.all(appPadding),
              child: GestureDetector(
                onTap: () async {
                  if(_formKeyAddAdmin.currentState!.validate()){
                    final admin = AdminRegister(controllerGender.dropDownValue?.value??"",name:nameController.text.trim(),email:emailController.text.trim(),password: passwordController.text.trim());
                    bool result = await AdminController.handleRegistration(admin);
                    if(result){
                      controllerGender.clearDropDown();
                      passwordController.clear();
                      emailController.clear();
                      nameController.clear();
                    }
                  }
                },
                child: reusableButton(text: "Add Admin", isPrimary: true,),
              ),
            )
        ]
        )),
      ),
    );
  }
}
