import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Pictures/models/category.dart';

import 'Models/roles.dart';

bool globalLoggedIn = false;
User? globalLoggedInUserValues;

bool editPermission = globalLoggedInUserValues!.roles.contains(Roles.Admin) ||
    globalLoggedInUserValues!.roles.contains(Roles.PhotoAlbumEdit);

Category? currentAlbum;