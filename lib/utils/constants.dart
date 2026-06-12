class QAConstants {
  QAConstants._();

  static const appName       = 'Quran Audio';
  static const appSubtitle   = 'Free Quran MP3';
  static const tagline       = 'Listen. Learn. Reflect.';
  static const playStoreUrl  = 'https://play.google.com/store/apps/details?id=com.appswella.quran_audio';
  static const appStoreUrl   = '#'; // Replace with real App Store URL

  static const heroArabic    = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
  static const downloadArabic= 'وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا';
  static const downloadArabicTrans = '"...And recite the Quran with measured recitation."';
  static const downloadArabicRef  = '— Al-Muzzammil 73:4';

  static const List<_FeatureData> features = [
    _FeatureData('📖', 'Mushaf Page View', 'مصحف',
      'Read the Quran as it appears in the printed Mushaf. Tap any ayah to play, translate, copy or share — with audio highlighting the verse in perfect sync.',
      'Sync Highlighting'),
    _FeatureData('🎧', 'Beautiful Audio', 'صوت',
      'Crystal-clear recitations from 50+ renowned Qaris worldwide. Create playlists, shuffle Surahs, and control playback with ease.',
      '50+ Reciters'),
    _FeatureData('🕌', 'Prayer Times', 'أوقات',
      'Accurate daily prayer times based on your location with the Hijri calendar. Never miss Salah with smart contextual notifications.',
      'Location-based'),
    _FeatureData('🌙', 'Sleep Timer', 'نوم',
      'Fall asleep to soothing recitation. Set a countdown timer or choose "Stop at end of Surah" — let the Quran carry you to sleep.',
      'End of Surah'),
    _FeatureData('🔖', 'Timestamp Bookmarks', 'علامة',
      'Mark any moment in a recitation to listen back later. Capture the exact second you felt something — and return to it anytime.',
      'Audio Bookmarks'),
    _FeatureData('🔥', 'Streaks & Progress', 'تقدم',
      'Track your listening history with a daily streak. Shareable milestone cards let you celebrate and inspire others on WhatsApp and Instagram.',
      'Shareable Cards'),
    _FeatureData('📚', 'Ayah-by-Ayah', 'تعلم',
      'Tap any Arabic Ayah during recitation to instantly see its meaning. Turn passive listening into active learning of the Quran\'s language.',
      'Interactive'),
  ];

  static const List<_QariData> qaris = [
    _QariData('Abdul Azeez Al-Ahmad',   'Saudi Arabia', 'Murattal',  'assets/qaris/abdulAzeezAlAhmad.png'),
    _QariData('Abdul Basit Al-Samad',   'Egypt',        'Mujawwad',  'assets/qaris/abdusSamad.png'),
    _QariData('Abubakr Al-Shatri',      'Saudi Arabia', 'Murattal',  'assets/qaris/abubakrAlShatri.png'),
    _QariData('Mishary Al-Afasy',       'Kuwait',       'Murattal',  'assets/qaris/alafasy.png'),
    _QariData('Mahmoud Al-Hussary',     'Egypt',        'Mujawwad',  'assets/qaris/alHussary.png'),
    _QariData('Bander Baleela',         'Saudi Arabia', 'Murattal',  'assets/qaris/banderBaleela.png'),
    _QariData('Mufti Menk',             'Zimbabwe',     'Murattal',  'assets/qaris/muftiMenk.png'),
    _QariData('Saad Al-Ghamdi',         'Saudi Arabia', 'Murattal',  'assets/qaris/saadAlGhamidi.png'),
    _QariData('Salah Al-Bukhatir',      'Saudi Arabia', 'Murattal',  'assets/qaris/salahAlBukhatir.png'),
    _QariData('Saud Al-Shuraim',        'Saudi Arabia', 'Mujawwad',  'assets/qaris/shuraim.png'),
    _QariData('Abdul Rahman Al-Sudais', 'Saudi Arabia', 'Mujawwad',  'assets/qaris/sudais.png'),
    _QariData('Yasser Al-Dossari',      'Saudi Arabia', 'Murattal',  'assets/qaris/yasserAlDossari.png'),
  ];

  static const List<_StatData> stats = [
    _StatData('114',   'Surahs'),
    _StatData('6,236', 'Ayahs'),
    _StatData('50+',   'Reciters'),
    _StatData('Free',  'Always'),
  ];

  static const List<_PrayerData> prayers = [
    _PrayerData('Fajr',    '04:52 AM', false),
    _PrayerData('Sunrise', '06:18 AM', false),
    _PrayerData('Dhuhr',   '12:27 PM', true),
    _PrayerData('Asr',     '03:44 PM', false),
    _PrayerData('Maghrib', '06:59 PM', false),
    _PrayerData('Isha',    '08:29 PM', false),
  ];

  static const List<_ScreenData> screens = [
    _ScreenData('Dashboard',    'assets/screens/screen_dashboard.png'),
    _ScreenData('Audio Player', 'assets/screens/screen_player.png'),
    _ScreenData('Ayah View',    'assets/screens/screen_ayah.png'),
    _ScreenData('Offline Library', 'assets/screens/screen_qari_list.png'),
    _ScreenData('Playlist',     'assets/screens/screen_playlist.png'),
  ];
}

class _FeatureData {
  final String emoji, title, arabic, desc, tag;
  const _FeatureData(this.emoji, this.title, this.arabic, this.desc, this.tag);
}

class _QariData {
  final String name, country, style, imagePath;
  const _QariData(this.name, this.country, this.style, this.imagePath);
}

class _StatData {
  final String value, label;
  const _StatData(this.value, this.label);
}

class _PrayerData {
  final String name, time;
  final bool isNext;
  const _PrayerData(this.name, this.time, this.isNext);
}

class _ScreenData {
  final String label, imagePath;
  const _ScreenData(this.label, this.imagePath);
}
