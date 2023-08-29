import 'dart:convert';
import 'package:http/http.dart' as http;
Future pushMessage(String body,String token) async {
  try {
   var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAYMhN2YU:APA91bEZQBx5jtLCo8bXSfvZlmdLBuMCWVVKAlHjTjCSqjIzK5eHSVDC-SGIuuxU52nu3W6pzKI9ZcYPuWFXdjvLSXjnPENOl6kl3k87-rvXIeWP3Iv2N7hUjORCxxN4KPE-sfu__WF_',
      },
      body: jsonEncode(
        <String, dynamic>{
          "to": token,
          'notification': <String, dynamic>{
            'body': body,
            'title': 'HairAndMore',
            'imageUrl':'https://firebasestorage.googleapis.com/v0/b/hairandmore-90341.appspot.com/o/productsImages%2Fbb4a9f50-9350-11ed-abf4-edb87f8e7228?alt=media&token=f4328f0a-e175-496d-9d7c-f5e074073f7b'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },

        },
      ),
    );
    print('send notif ${res.statusCode} ${res.body}');
    print(token.toString());
  } catch (e) {
    print("error push notification");
  }
}