import 'package:flutter/material.dart';

void main() => runApp(MyApp_Stats());

class MyApp_Stats extends StatelessWidget {
  const MyApp_Stats({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAppExample(), debugShowCheckedModeBanner: false,);
  }
}

class MyAppExample extends StatefulWidget {
  const MyAppExample({super.key});
  
  @override
  State<MyAppExample> createState() => _MyAppExampleState();
}

class _MyAppExampleState extends State<MyAppExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 224, 29, 29),
                  size: 40,
                ),
                const SizedBox(width: 5,),
                Text(
                  "Ngành Công nghệ thông tin STATS",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 5,),
                Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 224, 29, 29),
                      size: 40,
                    ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 224, 29, 29),
                  size: 40,
                ),
                const SizedBox(width: 5,),
                Text(
                  "Ngành An toàn thông tin",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 5,),
                Icon(
                      Icons.favorite,
                      color: const Color.fromARGB(255, 224, 29, 29),
                      size: 40,
                    ),
              ],
            ),
            const SizedBox(height : 10,),

            
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(text: 'Khoa ', style: TextStyle(),),
                      TextSpan(text: "Công nghệ thông tin trường Đại học Công thương thành phố Hồ Chí Minh", style: TextStyle(color: const Color.fromARGB(255, 59, 108, 148),),)
                    ]
                  ),
                ), 
              ),
            const SizedBox(height: 20,),

            Center(
              child: 
                Text(
                "KHOA CÔNG NGHỆ THÔNG TIN – ĐẠI HỌC CÔNG THƯƠNG TP.HCM: NƠI CHẮP CÁNH ƯỚC MƠ TRONG KỶ NGUYÊN SỐ",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(  
              color: Colors.grey, // Màu của thanh 
              thickness: 2,       // Độ dày của thanh 
              indent: 50,        // Khoảng cách từ lề trái 
              endIndent: 50,     // Khoảng cách từ lề phải 
            )  ,
            Center(
              child: 
                Text(
                "CÔNG NGHỆ THÔNG TIN",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 7, 233, 127)),
                textAlign: TextAlign.center,
              ),
            ),
            Row(  
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                children: [  
                  const SizedBox(height: 20,),  
                  Container(  
                    margin: EdgeInsets.all(10),  
                    child: ClipRRect(  
                      borderRadius: BorderRadius.circular(10),   
                      // child: Image.asset("assets/images/cntt.png", fit: BoxFit.contain, width: 200, height: 200,),  
                    ),  
                  ),  
                  const SizedBox(height: 10,),  
                ],  
              ),  
              Row(  
                mainAxisAlignment: MainAxisAlignment.center,  
                children: [  
                  Expanded(
                    child: Container(  
                    height: 110,
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(6),  
                    decoration: BoxDecoration(  
                      border: Border.all(  
                        color: Color.fromARGB(255, 7, 233, 127),  
                        width: 1.0,        
                      ),  
                      borderRadius: BorderRadius.circular(8.0),  
                    ),  
                    child:   
                      Column( 
                        children: [  
                          Text(
                            "Khoa Công nghệ Thông tin (CNTT) thuộc Trường Đại học Công Thương TP.HCM tự hào là một trong những đơn vị đào tạo uy tín, cung cấp nguồn nhân lực chất lượng cao, đáp ứng nhu cầu ngày càng tăng của thị trường lao động trong lĩnh vực CNTT và ATTT. Với đội ngũ giảng viên giàu kinh nghiệm, tâm huyết, cùng chương trình đào tạo tiên tiến, cập nhật, Khoa CNTT cam kết mang đến cho sinh viên môi trường học tập năng động, sáng tạo, giúp các em phát triển toàn diện cả về kiến thức chuyên môn và kỹ năng mềm.",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4, 
                            textAlign: TextAlign.justify,
                          ),const SizedBox(height: 10,),  
                          
                        ],  
                      )  
                  ),
                  ),
                  const SizedBox(height: 10,),  
                ],  
              ),  
            Center(
              child: 
                Text(
                "AN TOÀN THÔNG TIN",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
            Row(  
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                children: [  
                  const SizedBox(height: 20,),  
                  Container(  
                    margin: EdgeInsets.all(10),  
                    child: ClipRRect(  
                      borderRadius: BorderRadius.circular(10),  
                      // child: Image.asset("assets/images/attt.jpeg", fit: BoxFit.cover, width: 300, height: 200,),  
                    ),  
                  ),  
                  const SizedBox(height: 10,),  
                ],  
              ),  
              Row(  
                mainAxisAlignment: MainAxisAlignment.center,  
                children: [  
                  Expanded(
                    child: Container(  
                    height: 110,
                    margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                    padding: const EdgeInsets.all(6),  
                    decoration: BoxDecoration(  
                      border: Border.all(  
                        color: Colors.redAccent,  
                        width: 1.0,        
                      ),  
                      borderRadius: BorderRadius.circular(8.0),  
                    ),  
                    child:   
                      Column( 
                        children: [  
                          Text(
                            "Khoa Công nghệ Thông tin (CNTT) thuộc Trường Đại học Công Thương TP.HCM tự hào là một trong những đơn vị đào tạo uy tín, cung cấp nguồn nhân lực chất lượng cao, đáp ứng nhu cầu ngày càng tăng của thị trường lao động trong lĩnh vực CNTT và ATTT. Với đội ngũ giảng viên giàu kinh nghiệm, tâm huyết, cùng chương trình đào tạo tiên tiến, cập nhật, Khoa CNTT cam kết mang đến cho sinh viên môi trường học tập năng động, sáng tạo, giúp các em phát triển toàn diện cả về kiến thức chuyên môn và kỹ năng mềm.",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4, 
                            textAlign: TextAlign.justify,
                          ),const SizedBox(height: 10,),  
                          
                        ],  
                      )  
                  ),
                  ),
                  const SizedBox(height: 10,),  
                ],  
              ),  
          ],
        ),
      ),
    );
  }

}

class muahang extends StatelessWidget {  
  const muahang({super.key});  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text("Breakfast"),  
      ),  
      body: Center(  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,  
          children: [  
            ClipRRect(  
              // borderRadius: BorderRadius.circular(150),  
              // child: Image.asset("assets/images/done_cart.png", fit: BoxFit.contain, width: 300, height: 300),  
            ),  
            const SizedBox(height: 20),  
          ],  
        ),  
      ),  
    );  
  }  
}  