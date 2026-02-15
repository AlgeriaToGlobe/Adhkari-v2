import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../models/adhkar_category.dart';

/// Sample Adhkar data — replace with your custom collection.
/// Each Dhikr has: Arabic text, repetition count, virtue, hadith reference, and grade.
class SampleData {
  SampleData._();

  static List<AdhkarCategory> getCategories() {
    return [
      AdhkarCategory(
        id: 'morning',
        title: 'أذكار الصباح',
        subtitle: 'تُقال بعد صلاة الفجر',
        icon: Icons.wb_sunny_outlined,
        adhkar: _morningAdhkar(),
      ),
      AdhkarCategory(
        id: 'evening',
        title: 'أذكار المساء',
        subtitle: 'تُقال بعد صلاة العصر',
        icon: Icons.nightlight_outlined,
        adhkar: _eveningAdhkar(),
      ),
      AdhkarCategory(
        id: 'sleep',
        title: 'أذكار النوم',
        subtitle: 'تُقال قبل النوم',
        icon: Icons.bedtime_outlined,
        adhkar: _sleepAdhkar(),
      ),
      AdhkarCategory(
        id: 'wakeup',
        title: 'أذكار الاستيقاظ',
        subtitle: 'تُقال عند الاستيقاظ من النوم',
        icon: Icons.alarm_outlined,
        adhkar: _wakeUpAdhkar(),
      ),
      AdhkarCategory(
        id: 'afterSalah',
        title: 'أذكار بعد الصلاة',
        subtitle: 'تُقال بعد كل صلاة مفروضة',
        icon: Icons.mosque_outlined,
        adhkar: _afterSalahAdhkar(),
      ),
    ];
  }

  static List<Dhikr> _morningAdhkar() {
    return [
      Dhikr(
        id: 'm1',
        text: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ',
        targetCount: 1,
        fadl: 'دعاء شامل للخير والاستعاذة من الشر',
        reference: 'رواه مسلم ٢٧٢٣',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'm2',
        text: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
        targetCount: 1,
        fadl: 'التوكل على الله في بداية اليوم',
        reference: 'رواه الترمذي ٣٣٩١',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'm3',
        text: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
        targetCount: 1,
        fadl: 'سيد الاستغفار، من قالها موقنًا بها حين يُمسي فمات من ليلته دخل الجنة',
        reference: 'رواه البخاري ٦٣٠٦',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'm4',
        text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        targetCount: 100,
        fadl: 'من قالها مائة مرة حين يصبح وحين يمسي لم يأتِ أحد يوم القيامة بأفضل مما جاء به إلا أحد قال مثل ما قال أو زاد عليه',
        reference: 'رواه مسلم ٢٦٩٢',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'm5',
        text: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        targetCount: 10,
        fadl: 'كانت له عدل عشر رقاب، وكُتبت له مائة حسنة، ومُحيت عنه مائة سيئة، وكانت له حرزًا من الشيطان',
        reference: 'رواه البخاري ٦٤٠٣ ومسلم ٢٦٩٣',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'm6',
        text: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        targetCount: 3,
        fadl: 'لم يضره شيء',
        reference: 'رواه أبو داود ٥٠٨٨ والترمذي ٣٣٨٨',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'm7',
        text: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ. اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ',
        targetCount: 3,
        fadl: 'سؤال الله العافية في البدن والسمع والبصر',
        reference: 'رواه أبو داود ٥٠٩٠',
        grade: HadithGrade.hasan,
      ),
      Dhikr(
        id: 'm8',
        text: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
        targetCount: 3,
        fadl: 'كان حقًا على الله أن يُرضيه يوم القيامة',
        reference: 'رواه أبو داود ٥٠٧٢',
        grade: HadithGrade.sahih,
      ),
    ];
  }

  static List<Dhikr> _eveningAdhkar() {
    return [
      Dhikr(
        id: 'e1',
        text: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ',
        targetCount: 1,
        fadl: 'دعاء شامل للخير والاستعاذة من الشر',
        reference: 'رواه مسلم ٢٧٢٣',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'e2',
        text: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
        targetCount: 1,
        fadl: 'التوكل على الله في المساء',
        reference: 'رواه الترمذي ٣٣٩١',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'e3',
        text: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
        targetCount: 1,
        fadl: 'سيد الاستغفار، من قالها موقنًا بها حين يُمسي فمات من ليلته دخل الجنة',
        reference: 'رواه البخاري ٦٣٠٦',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'e4',
        text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        targetCount: 100,
        fadl: 'من قالها مائة مرة حين يصبح وحين يمسي لم يأتِ أحد يوم القيامة بأفضل مما جاء به',
        reference: 'رواه مسلم ٢٦٩٢',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'e5',
        text: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
        targetCount: 3,
        fadl: 'لم يضره شيء تلك الليلة',
        reference: 'رواه مسلم ٢٧٠٩',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'e6',
        text: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        targetCount: 3,
        fadl: 'لم يضره شيء',
        reference: 'رواه أبو داود ٥٠٨٨ والترمذي ٣٣٨٨',
        grade: HadithGrade.sahih,
      ),
    ];
  }

  static List<Dhikr> _sleepAdhkar() {
    return [
      Dhikr(
        id: 's1',
        text: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        targetCount: 1,
        fadl: 'سنة النبي ﷺ عند النوم',
        reference: 'رواه البخاري ٦٣٢٤',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 's2',
        text: 'سُبْحَانَ اللَّهِ',
        targetCount: 33,
        fadl: 'التسبيح قبل النوم',
        reference: 'رواه البخاري ٥٣٦١ ومسلم ٢٧٢٧',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 's3',
        text: 'الْحَمْدُ لِلَّهِ',
        targetCount: 33,
        fadl: 'التحميد قبل النوم',
        reference: 'رواه البخاري ٥٣٦١ ومسلم ٢٧٢٧',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 's4',
        text: 'اللَّهُ أَكْبَرُ',
        targetCount: 34,
        fadl: 'التكبير قبل النوم',
        reference: 'رواه البخاري ٥٣٦١ ومسلم ٢٧٢٧',
        grade: HadithGrade.sahih,
      ),
    ];
  }

  static List<Dhikr> _wakeUpAdhkar() {
    return [
      Dhikr(
        id: 'w1',
        text: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَمَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        targetCount: 1,
        fadl: 'شكر الله على نعمة الحياة بعد النوم',
        reference: 'رواه البخاري ٦٣٢٤',
        grade: HadithGrade.sahih,
      ),
    ];
  }

  static List<Dhikr> _afterSalahAdhkar() {
    return [
      Dhikr(
        id: 'a1',
        text: 'أَسْتَغْفِرُ اللَّهَ',
        targetCount: 3,
        fadl: 'الاستغفار بعد الصلاة',
        reference: 'رواه مسلم ٥٩١',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'a2',
        text: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        targetCount: 1,
        fadl: 'يُقال بعد السلام من الصلاة',
        reference: 'رواه مسلم ٥٩٢',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'a3',
        text: 'سُبْحَانَ اللَّهِ',
        targetCount: 33,
        fadl: 'التسبيح بعد الصلاة',
        reference: 'رواه مسلم ٥٩٧',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'a4',
        text: 'الْحَمْدُ لِلَّهِ',
        targetCount: 33,
        fadl: 'التحميد بعد الصلاة',
        reference: 'رواه مسلم ٥٩٧',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'a5',
        text: 'اللَّهُ أَكْبَرُ',
        targetCount: 33,
        fadl: 'التكبير بعد الصلاة',
        reference: 'رواه مسلم ٥٩٧',
        grade: HadithGrade.sahih,
      ),
      Dhikr(
        id: 'a6',
        text: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        targetCount: 1,
        fadl: 'تمام المائة بعد التسبيح والتحميد والتكبير',
        reference: 'رواه مسلم ٥٩٧',
        grade: HadithGrade.sahih,
      ),
    ];
  }
}
