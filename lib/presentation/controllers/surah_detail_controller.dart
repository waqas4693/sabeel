import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sabeelapp/data/models/verse_model.dart';
import 'package:sabeelapp/domain/entities/surah.dart';

class SurahDetailController extends GetxController {
  final Surah surah = Get.arguments;
  var verses = <Verse>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVerses();
  }

  Future<void> fetchVerses() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(
          'https://api.quran.com/api/v4/verses/by_chapter/${surah.id}?words=false&translations=131&fields=text_uthmani,text_simple&per_page=300',
        ),
      );

      if (response.statusCode == 200) {
        verses.value = parseVerses(response.body);
      } else {
        // Handle error state
        Get.snackbar('Error', 'Failed to load verses');
      }
    } catch (e) {
      // Handle exception
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
