// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'FlutterSocial Pro';

  @override
  String get welcomeTitle => 'ยินดีต้อนรับสู่ FlutterSocial Pro';

  @override
  String get welcomeDescription =>
      'เชื่อมต่อกับเพื่อนผู้เรียน แบ่งปันความรู้ และเติบโตไปด้วยกันในการเดินทาง Flutter ของคุณ';

  @override
  String get groupsTitle => 'เข้าร่วมกลุ่มศึกษา';

  @override
  String get groupsDescription =>
      'ร่วมมือกับเพื่อน เข้าร่วมการสนทนา และเรียนรู้จากนักพัฒนาที่มีประสบการณ์';

  @override
  String get quizTitle => 'ทำแบบทดสอบเชิงโต้ตอบ';

  @override
  String get quizDescription =>
      'ทดสอบความรู้ของคุณ ติดตามความก้าวหน้า และรับรางวัลขณะที่คุณเชี่ยวชาญ Flutter';

  @override
  String get chatTitle => 'แชทแบบเรียลไทม์';

  @override
  String get chatDescription =>
      'รับความช่วยเหลือทันที แบ่งปันโค้ด และสร้างความสัมพันธ์ที่ยั่งยืนกับชุมชน';

  @override
  String get progressTitle => 'ติดตามความก้าวหน้า';

  @override
  String get progressDescription =>
      'ติดตามการเดินทางการเรียนรู้ ฉลองเป้าหมาย และปลดล็อกระดับความสำเร็จใหม่';

  @override
  String get getStarted => 'เริ่มต้น';

  @override
  String get skip => 'ข้าม';

  @override
  String get next => 'ถัดไป';

  @override
  String get back => 'กลับ';

  @override
  String get finish => 'เสร็จสิ้น';

  @override
  String get loginTitle => 'ยินดีต้อนรับกลับ';

  @override
  String get loginSubtitle =>
      'เข้าสู่ระบบเพื่อดำเนินการต่อในการเดินทาง Flutter ของคุณ';

  @override
  String get email => 'อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get demoLogin => 'เข้าสู่ระบบทดลอง';

  @override
  String get loginAsDeveloper => 'เข้าสู่ระบบในฐานะนักพัฒนา';

  @override
  String get loginAsStudent => 'เข้าสู่ระบบในฐานะนักเรียน';

  @override
  String get loginAsInstructor => 'เข้าสู่ระบบในฐานะผู้สอน';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get dontHaveAccount => 'ยังไม่มีบัญชี?';

  @override
  String get createAccount => 'สร้างบัญชี';

  @override
  String get signupTitle => 'สร้างบัญชี';

  @override
  String get signupSubtitle => 'เข้าร่วมชุมชนการเรียนรู้ Flutter';

  @override
  String get firstName => 'ชื่อ';

  @override
  String get lastName => 'นามสกุล';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get alreadyHaveAccount => 'มีบัญชีอยู่แล้ว?';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get agreeToTerms => 'ฉันยอมรับข้อกำหนดและเงื่อนไข';

  @override
  String get dashboard => 'แดชบอร์ด';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get groups => 'กลุ่ม';

  @override
  String get chat => 'แชท';

  @override
  String get quiz => 'แบบทดสอบ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get english => 'English';

  @override
  String get thai => 'ไทย';

  @override
  String get changeLanguage => 'เปลี่ยนภาษา';

  @override
  String get myProgress => 'ความก้าวหน้าของฉัน';

  @override
  String get recentActivities => 'กิจกรรมล่าสุด';

  @override
  String get joinedGroups => 'กลุ่มที่เข้าร่วม';

  @override
  String get completedQuizzes => 'แบบทดสอบที่เสร็จสิ้น';

  @override
  String get currentStreak => 'สตรีคปัจจุบัน';

  @override
  String get totalPoints => 'คะแนนรวม';

  @override
  String get searchGroups => 'ค้นหากลุ่ม';

  @override
  String get createGroup => 'สร้างกลุ่ม';

  @override
  String get joinGroup => 'เข้าร่วมกลุ่ม';

  @override
  String get leaveGroup => 'ออกจากกลุ่ม';

  @override
  String get groupMembers => 'สมาชิก';

  @override
  String get startChat => 'เริ่มแชท';

  @override
  String get sendMessage => 'ส่งข้อความ';

  @override
  String get typeMessage => 'พิมพ์ข้อความ...';

  @override
  String get takeQuiz => 'ทำแบบทดสอบ';

  @override
  String get viewResults => 'ดูผลลัพธ์';

  @override
  String quizScore(int score) {
    return 'คะแนน: $score%';
  }

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get success => 'สำเร็จ';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get edit => 'แก้ไข';

  @override
  String get delete => 'ลบ';

  @override
  String get confirm => 'ยืนยัน';
}
