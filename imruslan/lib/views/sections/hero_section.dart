import 'package:flutter/material.dart';
import 'package:imruslan/components/get_custom_button.dart';
import 'package:imruslan/controllers/responsive_service.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context)?60:30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Responsive.isMobile(context)? Container():getHeroImage(400),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 5,
                          width: 55,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10),child: Text("I’m ruslan babar",style: TextStyle(fontSize: 15,color: colorScheme.inversePrimary),),)
                      ],
                    ),
                    Text("Software Eng.\nMobile Developer",style: TextStyle(fontSize: Responsive.isDesktop(context)?65:35,fontWeight: FontWeight.bold,height: 1.15),),
                    Container(
                      padding:  EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context)?0.4:0.7),
                      child: Text("I’m a full stack creative software engineer & Mobile developer based in Pakistan. Providing the best developent services for your next projects",style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: colorScheme.inversePrimary),),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GetCustomButton(cta:true),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: (){},
                            child: Image(image: AssetImage("./assets/icons/behance.png"),height: 22,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){},
                            child: Image(image: AssetImage("./assets/icons/linkedin.png"),height: 22,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){},
                            child: Image(image: AssetImage("./assets/icons/github.png"),height: 22,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){},
                            child: Image(image: AssetImage("./assets/icons/whatsapp.png"),height: 22,),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

              ],
            ),
          ),
          Spacer(),
          Container(
            width: double.maxFinite,
              child: Image(image: AssetImage("./assets/images/banner.png"),))
        ],
      ),
    );
  }

  getHeroImage(height) {
    return Image(image: AssetImage("./assets/images/hero_ruslan.png"),height: height,);
  }
}
