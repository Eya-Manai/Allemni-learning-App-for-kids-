import 'package:allemni/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message, required color}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: AppColors.white,
    fontSize: 16,
  );
}
