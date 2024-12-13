import 'package:flutter/material.dart';
import '../../services/send_otp_service.dart';


class OtpSendView extends StatelessWidget {
  OtpSendView({super.key});
  final controller = TextEditingController();
  final service = SendOTPService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent ,
        surfaceTintColor: Colors.transparent,
        
        title: const Text("Tic Tac Toe",style: TextStyle(color: Colors.white,fontSize:24,fontWeight: FontWeight.bold),),
        centerTitle: true,
      
      ),
      backgroundColor: const Color(0xff5A1E76),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //-----------------------Logo-----------------------
            Column(
              children: [
                Image.asset(
                  "assets/images/logo.png", // Replace with your image asset path
                  height: 150.0,
                ),
                const SizedBox(height: 10.0),
                //-----------------------welcome text-----------------------
              ],
            ),

            Column(
              children: [
                //-----------------------Register-----------------------
                SizedBox(
                  height: 53,
                  child: TextField(
                    controller: controller,

                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15),
                        fillColor:Colors.white,
                        filled: true,
                        hintText: "Enter your Robi/Airtel number...",
                        hintStyle:const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color:Color(0xff43115B))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Color(0xff43115B)))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    await service.sendOTP(context, controller);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color:Colors.white ),

                      ),
                    ),
                  ),
                ),
              ],
            )

            //-----------------------Sign Up-----------------------
          ],
        ),
      ),
    );
  }
}
