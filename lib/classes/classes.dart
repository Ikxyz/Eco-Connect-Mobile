import 'package:eco_connect/components/nav_bar.dart';
import 'package:flutter/material.dart';

class Clasess extends NavBarComponet {
  String isNotNull(val) {
    return val.toString().isNotEmpty ? null : 'Can\'t be left empty ';
  }

  String isEmail(val) {
    return val.toString().isNotEmpty &&
            val.toString().contains('@') &&
            val.toString().contains('.')
        ? null
        : 'enter a valid email ';
  }

  String isNumber(val) {
    return val.toString().length == 10 && val.toString().isNotEmpty
        ? null
        : 'Telepnone number mush be 10 digit';
  }

  String isPassword(val) {
    return val.toString().isNotEmpty && val.toString().length > 7
        ? null
        : 'Password must be up to 8 charaters';
  }
}

class MESSAGE {
  String id, msg, type, status, to, from, canRead;
  dynamic time;

  MESSAGE(
      {@required this.id,
      @required this.msg,
      @required this.type,
      @required this.status,
      @required this.time,
      @required this.to,
      @required this.from});
  factory MESSAGE.object(Map map) {
    return MESSAGE(
        id: map['id'],
        msg: map['msg'],
        type: map['type'],
        status: map['status'],
        time: map['time'],
        from: map['from'],
        to: map['to']);
  }
}

class PAYMENT {
  String paymentId,
      agentUid,
      clientUid,
      amount,
      status,
      requestPayment,
      makePayment,
      confirmPayment,
      hasPaid,
      time,
      startTime,
      endTime;

  PAYMENT(
      {@required this.paymentId,
      @required this.agentUid,
      @required this.clientUid,
      @required this.amount,
      @required this.status,
      @required this.requestPayment,
      @required this.makePayment,
      @required this.confirmPayment,
      @required this.hasPaid,
      @required this.time,
      @required this.startTime,
      @required this.endTime});

  factory PAYMENT.object(Map map) {
    return PAYMENT(
        paymentId: map['paymentId'],
        agentUid: map['agentUid'],
        clientUid: map['clientUid'],
        amount: map['amount'],
        status: map['status'],
        requestPayment: map['requestPayment'],
        makePayment: map['makePayment'],
        confirmPayment: map['confirmPayment'],
        hasPaid: map['hasPaid'],
        time: map['time'],
        startTime: map['startTime'],
        endTime: map['endTime']);
  }
}

class UsersProfile {
  String firstName,
      lastName,
      email,
      tel,
      address,
      city,
      state,
      country,
      zip,
      passport,
      identification,
      utilityBill,
      uid;
  int time;
  double latitude, longitude;
  bool isAdmin, isAgent, isMember, isDev, isVerified;
  dynamic online;
  UsersProfile(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.tel,
      @required this.state,
      this.isAdmin,
      this.isAgent,
      this.isDev,
      this.isMember,
      this.address,
      this.city,
      this.country,
      this.zip,
      this.passport,
      this.identification,
      this.utilityBill,
      this.uid,
      this.time,
      this.online,
      this.isVerified,
      this.latitude,
      this.longitude});

  factory UsersProfile.object(Map map) {
    if (map == null) return null;
    return UsersProfile(
        firstName: map['firstName'],
        lastName: map['lastName'],
        email: map['email'],
        tel: map['tel'],
        state: map['state'],
        address: map['address'],
        isAdmin: map['isAdmin'],
        isAgent: map['isAgent'],
        isDev: map['isDev'],
        isMember: map['isMember'],
        city: map['city'],
        country: map['country'],
        zip: map['zip'],
        passport: map['passport'],
        identification: map['identification'],
        utilityBill: map['utility_bill'],
        uid: map['uid'],
        time: map['time'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        isVerified: map['isVerified'],
        online: map['online']);
  }
}

class UsersContacts {
  String uid;
  String time;
  UsersContacts({@required uid, @required time});
}

class NOTIFICATION {
  String title, desc, type;
  bool status;
  dynamic time;

  NOTIFICATION({this.title, this.desc, this.type, this.status, this.time});

  factory NOTIFICATION.object(Map map) {
    if (map == null) return null;
    return NOTIFICATION(
      type: map['type'],
      time: map['time'],
      status: map['status'],
      title: map['title'],
      desc: map['desc'],
    );
  }
}

Map<String, dynamic> jsonNotifications({title, desc, type, status, time}) => {
      'title': title,
      'desc': desc,
      'type': type,
      'status': status,
      'time': time
    };
Map<String, dynamic> jsonMessage(
        {id, msg, type, status, to, from, canRead, dynamic time}) =>
    {
      "id": id,
      "msg": msg,
      "type": type,
      "status": status,
      "time": time,
      "from": from,
      "to": to
    };

Map<String, dynamic> jsonPayment(
        paymentId,
        agentUid,
        clientUid,
        amount,
        status,
        requestPayment,
        makePayment,
        confirmPayment,
        hasPaid,
        time,
        startTime,
        endTime) =>
    {
      "paymentId": paymentId,
      "agentUid": agentUid,
      "clientUid": clientUid,
      "amount": amount,
      "status": status,
      "requestPayment": requestPayment,
      "makePayment": makePayment,
      "confirmPayment": confirmPayment,
      "hasPaid": hasPaid,
      "time": time,
      "startTime": startTime,
      "endTime": endTime,
    };
Map<String, dynamic> jsonUserProfile(
        {firstName,
        lastName,
        email,
        tel,
        state,
        isAdmin,
        isAgent,
        isDev,
        isMember,
        address,
        city,
        country,
        zip,
        passport,
        identification,
        utilityBill,
        uid,
        latitude,
        longitude,
        time,
        isVerified}) =>
    {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "tel": tel,
      "address": address,
      "city": city,
      "state": state,
      "isAdmin": isAdmin != null ? isAdmin : false,
      "isAgent": isAgent != null ? isAgent : false,
      "isDev": isDev != null ? isDev : false,
      "isMember": isMember != null ? isMember : true,
      "country": country,
      "zip": zip,
      "passport": passport,
      "identification": identification,
      "utilityBill": utilityBill,
      "uid": uid,
      "time": time,
      "isVerified": isVerified != null ? isVerified : false,
      "latitude": latitude,
      "longitude": longitude
    };

Map<String, dynamic> jsonUserContacts() => {
      "uid": null,
      "time": null,
    };

List<Map> tempUserDatabase = [
  {
    "uid": "7b11801b-3ab1-4564-afab-72436593163f",
    "firstName": "Dolores",
    "lastName": "Rose",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "doloresrose@perkle.com",
    "tel": "+234 (868) 446-3877",
    "address": "618 High Street, Martinez, Puerto Rico, 9488",
    "isVerified": true,
    "state": "Kansas",
    "latitude": 55.102434,
    "longitude": -56.177553,
    "isAgent": false,
    "online": "offline"
  },
  {
    "uid": "1e5a2909-eac8-4a0d-b989-a141fb8da6ca",
    "firstName": "Rita",
    "lastName": "Knox",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "ritaknox@perkle.com",
    "tel": "+234 (923) 506-2684",
    "address": "205 Furman Avenue, Jacumba, Tennessee, 5946",
    "isVerified": true,
    "state": "New Mexico",
    "latitude": -11.414787,
    "longitude": 69.945757,
    "isAgent": true,
    "online": "offline"
  },
  {
    "uid": "ffa21922-ab55-4bea-8e76-c46854d6239b",
    "firstName": "Finley",
    "lastName": "Rodgers",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "finleyrodgers@perkle.com",
    "tel": "+234 (897) 512-3200",
    "address": "420 Maple Street, Waumandee, North Carolina, 3997",
    "isVerified": false,
    "state": "Nebraska",
    "latitude": 40.308103,
    "longitude": -126.200531,
    "isAgent": true,
    "online": "online"
  },
  {
    "uid": "4e1a1978-91e9-4469-8bcf-9947849b19e5",
    "firstName": "David",
    "lastName": "Harding",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "davidharding@perkle.com",
    "tel": "+234 (804) 558-2120",
    "address": "763 Sapphire Street, Eden, Alabama, 607",
    "isVerified": false,
    "state": "Oregon",
    "latitude": -82.425761,
    "longitude": 52.336318,
    "isAgent": true,
    "online": "offline"
  },
  {
    "uid": "b71662b5-2ebf-45ef-ad0c-bc14209b886c",
    "firstName": "Margery",
    "lastName": "Madden",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "margerymadden@perkle.com",
    "tel": "+234 (991) 413-2240",
    "address": "531 Louise Terrace, Santel, Alaska, 2890",
    "isVerified": true,
    "state": "New York",
    "latitude": 22.238825,
    "longitude": 96.1889,
    "isAgent": false,
    "online": "offline"
  },
  {
    "uid": "24f7447e-1811-4cfa-99bc-e5955a067e9d",
    "firstName": "Whitehead",
    "lastName": "Mann",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "whiteheadmann@perkle.com",
    "tel": "+234 (838) 424-2269",
    "address": "279 Eckford Street, Fairacres, Washington, 8764",
    "isVerified": false,
    "state": "Minnesota",
    "latitude": 34.153626,
    "longitude": 159.457939,
    "isAgent": true,
    "online": "online"
  },
  {
    "uid": "d9aca40c-f270-48d0-9815-24a34b3e4ef9",
    "firstName": "Tabatha",
    "lastName": "Guthrie",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "tabathaguthrie@perkle.com",
    "tel": "+234 (876) 422-2156",
    "address": "127 Grattan Street, Brenton, Florida, 9803",
    "isVerified": false,
    "state": "Georgia",
    "latitude": -41.757667,
    "longitude": -171.897658,
    "isAgent": false,
    "online": "offline"
  },
  {
    "uid": "224289a5-9184-4a45-841a-b07344a3d16a",
    "firstName": "Bean",
    "lastName": "Nicholson",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "beannicholson@perkle.com",
    "tel": "+234 (912) 434-2339",
    "address": "315 Times Placez, Whitmer, Pennsylvania, 8315",
    "isVerified": false,
    "state": "Arizona",
    "latitude": 22.968105,
    "longitude": 49.414797,
    "isAgent": false,
    "online": "offline"
  },
  {
    "uid": "8c4ca1da-ab3a-4d54-83ff-8604a1db394e",
    "firstName": "Mann",
    "lastName": "Phelps",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "mannphelps@perkle.com",
    "tel": "+234 (823) 598-2535",
    "address": "877 Otsego Street, Gerton, Marshall Islands, 5921",
    "isVerified": true,
    "state": "Texas",
    "latitude": -4.280388,
    "longitude": 42.139883,
    "isAgent": true,
    "online": "offline"
  },
  {
    "uid": "4b03d961-648c-4452-b6df-877122a0947b",
    "firstName": "Katelyn",
    "lastName": "Reynolds",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "katelynreynolds@perkle.com",
    "tel": "+234 (946) 486-2610",
    "address": "712 Brighton Avenue, Helen, California, 769",
    "isVerified": false,
    "state": "Connecticut",
    "latitude": 8.647375,
    "longitude": 157.516566,
    "isAgent": false,
    "online": "online"
  },
  {
    "uid": "a1c3a4b0-9827-4d5b-a510-1cc4a3c540aa",
    "firstName": "Bonner",
    "lastName": "Woodward",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "bonnerwoodward@perkle.com",
    "tel": "+234 (875) 548-3065",
    "address": "492 Willow Street, Smock, Vermont, 652",
    "isVerified": false,
    "state": "Virginia",
    "latitude": 39.824101,
    "longitude": -25.491973,
    "isAgent": false,
    "online": "offline"
  },
  {
    "uid": "7361977d-b841-494d-9239-98fe7bbd893c",
    "firstName": "Dickerson",
    "lastName": "Valenzuela",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "dickersonvalenzuela@perkle.com",
    "tel": "+234 (919) 454-3723",
    "address": "723 Lombardy Street, Dubois, South Dakota, 1488",
    "isVerified": true,
    "state": "Guam",
    "latitude": 60.971314,
    "longitude": 74.187827,
    "isAgent": false,
    "online": "offline"
  },
  {
    "uid": "84276d8d-5b17-457b-a8fe-13f9951dae83",
    "firstName": "Ford",
    "lastName": "Bruce",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "fordbruce@perkle.com",
    "tel": "+234 (813) 553-2336",
    "address":
        "241 Roosevelt Place, Flintville, Northern Mariana Islands, 1240",
    "isVerified": true,
    "state": "Montana",
    "latitude": 12.960141,
    "longitude": -178.705792,
    "isAgent": false,
    "online": "online"
  },
  {
    "uid": "2c1436c7-ce4f-484d-a462-de94d5040747",
    "firstName": "Ruthie",
    "lastName": "Rocha",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "ruthierocha@perkle.com",
    "tel": "+234 (994) 532-3076",
    "address": "973 Powell Street, Driftwood, Oklahoma, 4952",
    "isVerified": true,
    "state": "Indiana",
    "latitude": -6.035172,
    "longitude": 128.285938,
    "isAgent": false,
    "online": "offline"
  },
  {
    "uid": "560823ad-77e1-438a-967a-01472c081423",
    "firstName": "Marquita",
    "lastName": "Steele",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "marquitasteele@perkle.com",
    "tel": "+234 (824) 522-2979",
    "address": "495 Paerdegat Avenue, Allendale, Maryland, 8049",
    "isVerified": false,
    "state": "Massachusetts",
    "latitude": 78.580642,
    "longitude": 21.671779,
    "isAgent": true,
    "online": "online"
  },
  {
    "uid": "a83d21a2-080f-4353-9b5b-5bbe3dd6cb0c",
    "firstName": "Melanie",
    "lastName": "Grant",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "melaniegrant@perkle.com",
    "tel": "+234 (903) 442-2085",
    "address": "957 Albany Avenue, Lookingglass, Missouri, 1520",
    "isVerified": false,
    "state": "Idaho",
    "latitude": -62.944318,
    "longitude": -139.110174,
    "isAgent": true,
    "online": "online"
  },
  {
    "uid": "0965bf1b-8151-4fc7-9159-9289b382b11e",
    "firstName": "Hull",
    "lastName": "Hernandez",
    "passport":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "email": "hullhernandez@perkle.com",
    "tel": "+234 (922) 529-2463",
    "address": "417 Conselyea Street, Connerton, New Jersey, 1585",
    "isVerified": false,
    "state": "Colorado",
    "latitude": -10.044136,
    "longitude": 65.482371,
    "isAgent": true,
    "online": "offline"
  }
];
