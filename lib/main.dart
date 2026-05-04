import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '零食库存管理',
      theme: ThemeData(
        fontFamily: 'system',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const FullStockApp(),
    );
  }
}

class FullStockApp extends StatefulWidget {
  const FullStockApp({super.key});

  @override
  State<FullStockApp> createState() => _FullStockAppState();
}

class _FullStockAppState extends State<FullStockApp> {
  String currentPage = "home";
  final List<Map<String, dynamic>> goods = [];

  bool voiceEnabled = true;
  String remindTime = "09:00";

  // 社群聊天消息列表（提到外面来，页面切换不会清空）
  List<Map<String, dynamic>> chatMessages = [
    {"isSelf": false, "text": "欢迎来到零食社区！", "time": "10:00"}
  ];

  @override
  void initState() {
    super.initState();
    if (goods.isEmpty) {
      goods.addAll([
        {"id": 1, "name": "薯片", "price": "10.00", "quantity": 3, "expiry": getExpiryDate(3), "platform": "淘宝"},
        {"id": 2, "name": "可乐", "price": "5.50", "quantity": 6, "expiry": getExpiryDate(7), "platform": "超市"},
        {"id": 3, "name": "巧克力", "price": "25.00", "quantity": 2, "expiry": getExpiryDate(30), "platform": "京东"},
        {"id": 4, "name": "饼干", "price": "12.80", "quantity": 4, "expiry": getExpiryDate(5), "platform": "拼多多"},
      ]);
    }
  }

  String getExpiryDate(int days) {
    final now = DateTime.now();
    final exp = now.add(Duration(days: days));
    return "${exp.year.toString().padLeft(4, '0')}-${exp.month.toString().padLeft(2, '0')}-${exp.day.toString().padLeft(2, '0')}";
  }

  void switchPage(String page) {
    setState(() {
      currentPage = page;
    });
  }

  void showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
      ),
    );
  }

  // 登录弹窗
  void showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("欢迎回来"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(hintText: "用户名")),
            const SizedBox(height: 8),
            TextField(decoration: InputDecoration(hintText: "邮箱（选填）")),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: "密码"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); showToast("登录成功"); }, child: const Text("登录")),
          TextButton(onPressed: () { Navigator.pop(context); showToast("注册成功"); }, child: const Text("注册")),
        ],
      ),
    );
  }

  // 财务报表
  void showFinanceReportDialog() {
    double total = goods.fold(0.0, (s, g) => s + (double.tryParse(g["price"] ?? "0") ?? 0) * (g["quantity"] ?? 1));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("💰 财务报表"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("总库存价值 ¥${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("临期损失预估 ¥0.00"),
            const Text("已消耗金额 ¥0.00"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("关闭")),
        ],
      ),
    );
  }

  // VIP
  void showVIPDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("👑 VIP会员体系"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("月卡：¥9.9"),
            Text("季卡：¥25"),
            Text("年卡：¥79"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("关闭")),
          TextButton(onPressed: () { Navigator.pop(context); showToast("开通成功"); }, child: const Text("立即开通")),
        ],
      ),
    );
  }

  // 语音设置
  void showVoiceSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("🔊 语音提醒设置"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text("启用语音提醒"),
                    const Spacer(),
                    Switch(
                      value: voiceEnabled,
                      onChanged: (v) => setDialog(() => voiceEnabled = v),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: remindTime,
                  items: const [
                    DropdownMenuItem(value: "09:00", child: Text("09:00")),
                    DropdownMenuItem(value: "12:00", child: Text("12:00")),
                    DropdownMenuItem(value: "18:00", child: Text("18:00")),
                  ],
                  onChanged: (v) => setDialog(() => remindTime = v!),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("关闭")),
              TextButton(onPressed: () { showToast("语音测试"); }, child: const Text("测试语音")),
            ],
          );
        },
      ),
    );
  }

  Widget menuItem(String icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 15)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 重点修复：页面整体改用 IndexedStack，保证每个页面正常显示、不塌陷
      body: IndexedStack(
        index: {
          "home": 0,
          "import": 1,
          "stock": 2,
          "medicine": 3,
          "community": 4,
          "profile": 5,
        }[currentPage] ?? 0,
        children: [
          buildHome(),
          buildImport(),
          buildStock(),
          buildMedicine(),
          buildCommunity(),
          buildProfile(),
        ],
      ),
      bottomNavigationBar: buildNav(),
    );
  }

  // 首页
  Widget buildHome() {
    int total = goods.length;
    int exp = goods.where((g) {
      final d = DateTime.parse(g["expiry"]).difference(DateTime.now()).inDays;
      return d <= 7 && d >= 0;
    }).length;
    double val = goods.fold(0.0, (s, g) => s + (double.tryParse(g["price"] ?? "0") ?? 0) * (g["quantity"] ?? 1));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 44, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("🍿 零食库存管理", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("智能管理，新鲜每一天", style: TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12,
              children: [
                quickBtn("📷", "扫码入库"),
                quickBtn("📸", "拍照录入"),
                quickBtn("🏷️", "条形码"),
                quickBtn("🧾", "小票录入"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          statsCard(total, exp, val),
          const SizedBox(height: 16),
          warningCard(),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget quickBtn(String icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Column(children: [Text(icon, style: const TextStyle(fontSize: 32)), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 12))]),
    );
  }

  Widget statsCard(int total, int exp, double val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("📊 库存统计", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              statItem("$total", "商品总数"),
              statItem("$exp", "临期预警"),
              statItem("¥${val.toStringAsFixed(2)}", "库存价值"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget statItem(String v, String l) {
    return Column(children: [Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF4FACFE))), const SizedBox(height: 4), Text(l, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
  }

  Widget warningCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFF3CD), Color(0xFFFFEAA7)]), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("⚠️ 临期预警", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF856404))),
            const SizedBox(height: 12),
            ...goods.where((g) {
              final d = DateTime.parse(g["expiry"]).difference(DateTime.now()).inDays;
              return d <= 7 && d >= 0;
            }).take(5).map((g) {
              final d = DateTime.parse(g["expiry"]).difference(DateTime.now()).inDays;
              return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(g["name"]), Text("$d天后过期", style: const TextStyle(color: Color(0xFFD63031)))]);
            }),
            if (goods.where((g) => DateTime.parse(g["expiry"]).difference(DateTime.now()).inDays <= 7 && DateTime.parse(g["expiry"]).difference(DateTime.now()).inDays >= 0).isEmpty)
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("暂无临期商品"), Text("-")]),
          ],
        ),
      ),
    );
  }

  // 入库
  Widget buildImport() {
    final name = TextEditingController();
    final price = TextEditingController();
    final qty = TextEditingController(text: "1");
    final days = TextEditingController(text: "30");
    String plat = "淘宝";

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 44, 24, 32),
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📥 扫码入库", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("快速录入商品信息", style: TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                inputBox("商品名称", name),
                inputBox("购买价格", price),
                inputBox("数量", qty),
                inputBox("保质期（天）", days),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: plat,
                  items: const [
                    DropdownMenuItem(value: "淘宝", child: Text("淘宝")),
                    DropdownMenuItem(value: "京东", child: Text("京东")),
                    DropdownMenuItem(value: "拼多多", child: Text("拼多多")),
                    DropdownMenuItem(value: "超市", child: Text("超市")),
                  ],
                  onChanged: (v) => plat = v!,
                  decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (name.text.isEmpty || price.text.isEmpty) { showToast("请填写名称和价格"); return; }
                    setState(() {
                      goods.add({
                        "id": Random().nextInt(999999),
                        "name": name.text,
                        "price": price.text,
                        "quantity": int.tryParse(qty.text) ?? 1,
                        "expiry": getExpiryDate(int.tryParse(days.text) ?? 30),
                        "platform": plat,
                      });
                    });
                    showToast("✅ 入库成功");
                    switchPage("stock");
                  },
                  child: Container(
                    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]), borderRadius: BorderRadius.circular(12)),
                    child: const Center(child: Text("确认入库", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget inputBox(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(controller: ctrl, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      ]),
    );
  }

  // 库存
  Widget buildStock() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 44, 24, 32),
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📦 库存管理", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("查看和管理所有商品", style: TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (goods.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("暂无库存数据", style: TextStyle(color: Colors.grey))))
          else
            ...goods.map((g) {
              final d = DateTime.parse(g["expiry"]).difference(DateTime.now()).inDays;
              final isExp = d <= 7 && d >= 0;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(g["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), Text("x${g["quantity"]}")]),
                      const SizedBox(height: 8),
                      Row(children: [Text(g["platform"]), const SizedBox(width: 16), Text(isExp ? "$d天后过期" : "保质期至 ${g["expiry"]}", style: TextStyle(color: isExp ? Colors.red : Colors.grey))]),
                      const SizedBox(height: 4),
                      Text("¥${g["price"]}", style: const TextStyle(color: Color(0xFF4FACFE), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: actionBtn("消耗", const Color(0xFFFFF3CD), const Color(0xFF856404), () {
                          setState(() { g["quantity"] -= 1; if (g["quantity"] <= 0) goods.remove(g); });
                          showToast("✅ 消耗成功");
                        })),
                        const SizedBox(width: 8),
                        Expanded(child: actionBtn("删除", const Color(0xFFF8D7DA), const Color(0xFF721C24), () {
                          setState(() => goods.remove(g));
                          showToast("✅ 删除成功");
                        })),
                      ]),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget actionBtn(String t, Color c, Color tc, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(t, style: TextStyle(color: tc)))));
  }

  // 用药
  Widget buildMedicine() {
    final name = TextEditingController();
    final time = TextEditingController(text: "09:00");
    final days = TextEditingController(text: "7");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 44, 24, 32),
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("💊 用药提醒", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("定时提醒，按时服药", style: TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                inputBox("药品名称", name),
                inputBox("服用时间", time),
                inputBox("服用天数", days),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () { name.text.isEmpty ? showToast("请填写药品名称") : showToast("✅ 已添加提醒：${name.text}，每天${time.text}，共${days.text}天"); },
                  child: Container(
                    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]), borderRadius: BorderRadius.circular(12)),
                    child: const Center(child: Text("添加提醒", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  // ✅【已修复】社群页面，现在 100% 能显示、能聊天、能自动回复
  Widget buildCommunity() {
    final chatCtrl = TextEditingController();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 44, 24, 32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("💬 零食社区", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text("分享零食，结交朋友", style: TextStyle(fontSize: 13, color: Colors.white70)),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: chatMessages.map((msg) {
              return chatMsg(msg["isSelf"], msg["text"], msg["time"]);
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chatCtrl,
                  decoration: InputDecoration(
                    hintText: "输入消息...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  String text = chatCtrl.text.trim();
                  if (text.isEmpty) return;

                  final now = DateTime.now();
                  final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

                  setState(() {
                    chatMessages.add({
                      "isSelf": true,
                      "text": text,
                      "time": timeStr,
                    });
                  });
                  chatCtrl.clear();

                  Future.delayed(const Duration(seconds: 1), () {
                    final replies = ["好的！", "太棒了！", "👍", "哈哈😄", "收到！"];
                    setState(() {
                      chatMessages.add({
                        "isSelf": false,
                        "text": replies[DateTime.now().microsecond % replies.length],
                        "time": timeStr,
                      });
                    });
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FACFE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text("发送", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget chatMsg(bool self, String text, String time) {
    return Align(
      alignment: self ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: self ? const LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]) : null,
          color: !self ? Colors.white : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: self ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text, style: TextStyle(color: self ? Colors.white : Colors.black)),
            const SizedBox(height: 4),
            Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // 我的
  Widget buildProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]), borderRadius: BorderRadius.circular(24)),
            child: const Column(
              children: [
                CircleAvatar(radius: 40, backgroundColor: Color(0xFFFFD700), child: Text("👤", style: TextStyle(fontSize: 36))),
                SizedBox(height: 12),
                Text("未登录", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("点击下方按钮登录", style: TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: showLoginDialog,
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text("登录/注册", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600))),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  menuItem("💬", "零食社区", () => switchPage("community")),
                  menuItem("📊", "财务报表", showFinanceReportDialog),
                  menuItem("👑", "VIP开通", showVIPDialog),
                  menuItem("🔊", "语音提醒设置", showVoiceSettingsDialog),
                  menuItem("🚪", "退出登录", () => showToast("已退出登录")),
                ],
              ),
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  // 底部导航
  Widget buildNav() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem("🏠", "首页", currentPage == "home", () => switchPage("home")),
          navItem("📥", "入库", currentPage == "import", () => switchPage("import")),
          navItem("📦", "库存", currentPage == "stock", () => switchPage("stock")),
          navItem("💊", "用药", currentPage == "medicine", () => switchPage("medicine")),
          navItem("💬", "社群", currentPage == "community", () => switchPage("community")),
          navItem("👤", "我的", currentPage == "profile", () => switchPage("profile")),
        ],
      ),
    );
  }

  Widget navItem(String icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: TextStyle(fontSize: 24, color: active ? const Color(0xFF4FACFE) : Colors.grey)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: active ? const Color(0xFF4FACFE) : Colors.grey)),
      ]),
    );
  }
}
