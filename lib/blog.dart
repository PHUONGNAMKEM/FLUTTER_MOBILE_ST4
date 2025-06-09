import 'package:flutter/material.dart';

void main() => runApp(MyApp_Blog_New());

class MyApp_Blog_New extends StatelessWidget {
  const MyApp_Blog_New({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAppExample(), debugShowCheckedModeBanner: false);
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
    return DefaultTabController(
      length: 3, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 5),
              Text(
                "Blog - Công ty Cho Thuê Thiết Bị",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.blue.shade800,
                unselectedLabelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                indicatorPadding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 4,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business, size: 15),
                        SizedBox(width: 8),
                        Text('CÔNG TY', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event, size: 15),
                        SizedBox(width: 8),
                        Text('HOẠT ĐỘNG', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.build, size: 15),
                        SizedBox(width: 8),
                        Text('KỸ THUẬT', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Nội dung tab CÔNG TY
            SingleChildScrollView(child: buildCompanyContent()),
            // Nội dung tab HOẠT ĐỘNG
            buildActivitiesContent(),
            // Nội dung tab KỸ THUẬT
            buildTechContent(),
          ],
        ),
      ),
    );
  }

  Widget buildCompanyContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Công ty TNHH '),
                TextSpan(
                  text: "Thiết Bị Số Việt",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 59, 108, 148),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            "CÔNG TY TNHH THIẾT BỊ SỐ VIỆT: ĐỒNG HÀNH CÙNG BẠN TRONG MỌI DỰ ÁN CÔNG NGHỆ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://th.bing.com/th?id=OIF.5jQ8t0ILRwfm5AL%2fsd7d4A&w=193&h=193&c=7&r=0&o=5&dpr=1.3&pid=1.7",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Công ty TNHH Thiết Bị Số Việt tự hào là đơn vị hàng đầu cung cấp dịch vụ cho thuê thiết bị công nghệ hiện đại, từ máy chiếu, máy in, laptop đến các thiết bị chuyên dụng cho sự kiện và doanh nghiệp. Với hơn 10 năm kinh nghiệm, chúng tôi cam kết mang đến giải pháp tối ưu, tiết kiệm chi phí và hỗ trợ kỹ thuật 24/7 cho khách hàng.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Điều hướng đến trang liên hệ hoặc trang dịch vụ
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text("Liên hệ ngay"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildActivitiesContent() {
    return Container(
      margin: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildActivityCard(
              title: "Triển Lãm Thiết Bị Công Nghệ 2025",
              author: "Tác giả: Minh Anh",
              description:
                  "Công ty Thiết Bị Số Việt tham gia triển lãm công nghệ lớn nhất năm 2025, giới thiệu các thiết bị cho thuê hiện đại như máy chiếu 4K, laptop cấu hình cao và máy in công nghiệp.",
              status: "Đã hoàn thành",
              reportedBy: "Báo cáo bởi: Ban Tổ Chức",
              timeAgo: "2 ngày trước",
              imageUrl:
                  "https://th.bing.com/th/id/OIP.gzVW0XaKrb_S6pP4ZrlmgwHaFh?w=213&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
              onButtonPressed: () {
                // Điều hướng đến trang chi tiết sự kiện
              },
              buttonText: "Xem chi tiết",
            ),
            buildActivityCard(
              title: "Chương Trình Khuyến Mãi Mùa Hè",
              author: "Tác giả: Thanh Tùng",
              description:
                  "Giảm giá 20% cho tất cả các dịch vụ thuê thiết bị trong tháng 6! Đừng bỏ lỡ cơ hội thuê máy chiếu, laptop và máy in với giá ưu đãi.",
              status: "Đang diễn ra",
              reportedBy: "Báo cáo bởi: Phòng Marketing",
              timeAgo: "5 giờ trước",
              imageUrl:
                  "https://th.bing.com/th/id/OIP.JXzRssLltm3Il7fvo2IMRQHaEC?w=323&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
              onButtonPressed: () {
                // Điều hướng đến trang khuyến mãi
              },
              buttonText: "Xem ưu đãi",
            ),
            buildActivityCard(
              title: "Hội Thảo Công Nghệ Cho Doanh Nghiệp",
              author: "Tác giả: Ngọc Hân",
              description:
                  "Công ty tổ chức hội thảo giới thiệu các giải pháp công nghệ cho doanh nghiệp, với sự tham gia của hơn 50 công ty đối tác.",
              status: "Đã hoàn thành",
              reportedBy: "Báo cáo bởi: Ban Sự Kiện",
              timeAgo: "1 tuần trước",
              imageUrl:
                  "data:image/jpeg;base64,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",
              onButtonPressed: () {
                // Điều hướng đến trang chi tiết hội thảo
              },
              buttonText: "Xem chi tiết",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTechContent() {
    return Container(
      margin: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildTechCard(
              title: "Hướng Dẫn Sử Dụng Máy Chiếu Hiệu Quả",
              author: "Tác giả: Kỹ thuật viên Hoàng",
              description:
                  "Tìm hiểu cách sử dụng máy chiếu đúng cách để đạt hiệu suất tối ưu, từ cài đặt ban đầu đến bảo quản sau khi sử dụng.",
              status: "Đã đăng",
              reportedBy: "Báo cáo bởi: Phòng Kỹ Thuật",
              timeAgo: "3 ngày trước",
              imageUrl:
                  "https://th.bing.com/th/id/OIP.tsBDbKp81AL9RsZg0ouzhwHaFk?w=233&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
              onButtonPressed: () {
                // Điều hướng đến bài viết chi tiết
              },
              buttonText: "Đọc thêm",
            ),
            buildTechCard(
              title: "Mẹo Bảo Trì Laptop Cho Thuê",
              author: "Tác giả: Kỹ thuật viên Nam",
              description:
                  "Hướng dẫn bảo trì laptop để đảm bảo thiết bị luôn hoạt động ổn định trong suốt thời gian thuê, từ vệ sinh đến kiểm tra phần mềm.",
              status: "Đã đăng",
              reportedBy: "Báo cáo bởi: Phòng Kỹ Thuật",
              timeAgo: "5 ngày trước",
              imageUrl:
                  "https://th.bing.com/th/id/OIP.fnAVcP8GqSJ71dT7z6y7FgHaEK?w=323&h=181&c=7&r=0&o=5&dpr=1.3&pid=1.7",
              onButtonPressed: () {
                // Điều hướng đến bài viết chi tiết
              },
              buttonText: "Đọc thêm",
            ),
            buildTechCard(
              title: "Công Nghệ Máy In Mới Nhất 2025",
              author: "Tác giả: Kỹ thuật viên Lan",
              description:
                  "Giới thiệu các dòng máy in mới nhất mà công ty đang cung cấp, với tính năng in nhanh, tiết kiệm mực và thân thiện với môi trường.",
              status: "Đã đăng",
              reportedBy: "Báo cáo bởi: Phòng Kỹ Thuật",
              timeAgo: "1 tuần trước",
              imageUrl:
                  "https://th.bing.com/th/id/OIP.KGZ3r8IJAw_Tx6dzoEfiAQHaFi?w=236&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
              onButtonPressed: () {
                // Điều hướng đến bài viết chi tiết
              },
              buttonText: "Đọc thêm",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActivityCard({
    required String title,
    required String author,
    required String description,
    required String status,
    required String reportedBy,
    required String timeAgo,
    required String imageUrl,
    required VoidCallback onButtonPressed,
    required String buttonText,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              author,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(127, 134, 144, 1),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(127, 134, 144, 1),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trạng thái: $status",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                    foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 1,
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reportedBy,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(127, 134, 144, 1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(127, 134, 144, 1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTechCard({
    required String title,
    required String author,
    required String description,
    required String status,
    required String reportedBy,
    required String timeAgo,
    required String imageUrl,
    required VoidCallback onButtonPressed,
    required String buttonText,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              author,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(127, 134, 144, 1),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(127, 134, 144, 1),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trạng thái: $status",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(197, 221, 243, 1),
                    foregroundColor: Color.fromRGBO(64, 140, 252, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 1,
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reportedBy,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(127, 134, 144, 1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(127, 134, 144, 1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
