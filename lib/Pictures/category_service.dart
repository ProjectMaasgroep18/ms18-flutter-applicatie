import 'category.dart';

class CategoryService {
  static final List<Category> _allCategories = [
    Category(id: '1', name: 'Album 1',  parentAlbumId: null, coverPhotoId: '123', photoCount: 0, year: 2000),
    Category(id: '2', name: 'Album 2',  parentAlbumId: null, coverPhotoId: '111', photoCount: 3, year: 2000),
    Category(id: '3', name: 'Sub Album 1',  parentAlbumId: '2', coverPhotoId: '222', photoCount: 5, year: 2000),
  ];

  static Future<List<Category>> getCategoriesWithNullParentId() async {
    await Future.delayed(Duration(seconds: 2));

    return _allCategories.where((category) => category.parentAlbumId == null).toList();
  }

  static Future<List<Category>> getSubCategories(String parentId) async {
    await Future.delayed(Duration(seconds: 2));

    return _allCategories.where((category) => category.parentAlbumId == parentId).toList();
  }
}
