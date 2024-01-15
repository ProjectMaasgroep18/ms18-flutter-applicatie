import '../Api/apiManager.dart';
import '../Models/planning.dart';
import '../config.dart';
Future<List<Planning>> getPlanning() async {
  List<Planning> planningItems = [];

  await ApiManager.get<List<dynamic>>('Calendar/upcoming', await getHeaders())
      .then((data) {
      planningItems = castListDynamicToPlanning(data);
  });
  return planningItems;
}

Planning castMapToPlanning(Map<String, dynamic> apiPlanning) {
  //Parsing the color from the db
  DateTime startDate = DateTime.parse(apiPlanning["starDateTime"]);
  DateTime endDate = DateTime.parse(apiPlanning["endDateTime"]);

  Planning planning = Planning(
    heading: apiPlanning["title"],
    subHeading: "Datum: ${startDate.day}-${startDate.month} Tijd: ${startDate.hour.toString().padLeft(2,'0')}:${startDate.minute.toString().padLeft(2,'0')} - ${endDate.hour.toString().padLeft(2,'0')}:${endDate.minute.toString().padLeft(2,'0')}",

  );

  return planning;
}

List<Planning> castListDynamicToPlanning(List<dynamic> data) {
  List<Planning> planningItems = [];
  for (Map<String, dynamic> product in data) {
    Map<String, dynamic> map = product;

    planningItems.add(castMapToPlanning(map));
  }
  return planningItems;
}

Future<int> getDeclarationsCount() async {
  int count = 0;

  await ApiManager.get<List<dynamic>>('api/v1/Receipt', await getHeaders())
      .then((data) {
  count = data.length;
  });
  return count;
}