/// Comprehensive Indian Railways Train Data
/// This file contains train data for major routes across India
class IndianTrainsData {
  static List<Map<String, dynamic>> getAllTrains() {
    return [
      // DELHI ROUTES
      ...getDelhiToMumbaiTrains(),
      ...getDelhiToBangaloreTrains(),
      ...getDelhiToChennaiTrains(),
      ...getDelhiToKolkataTrains(),
      ...getDelhiToHyderabadTrains(),
      
      // MUMBAI ROUTES
      ...getMumbaiToBangaloreTrains(),
      ...getMumbaiToChennaiTrains(),
      ...getMumbaiToKolkataTrains(),
      ...getMumbaiToHyderabadTrains(),
      ...getMumbaiToPuneTrains(),
      ...getMumbaiToAhmedabadTrains(),
      ...getMumbaiToGoa(),
      
      // CHENNAI ROUTES
      ...getChennaiToHyderabadTrains(),
      ...getChennaiToBangaloreTrains(),
      ...getChennaiToCoimbatoreTrains(),
      ...getChennaiToKolkataTrains(),
      ...getChennaiToMaduraiTrains(),
      ...getChennaiToTrichy(),
      
      // BANGALORE ROUTES
      ...getBangaloreToHyderabadTrains(),
      ...getBangaloreToCoimbatoreTrains(),
      ...getBangaloreToMysoreTrains(),
      ...getBangaloreToMangaloreTrains(),
      
      // KOLKATA ROUTES
      ...getKolkataToChennaiTrains(),
      ...getKolkataToHyderabadTrains(),
      ...getKolkataToPatnaTrains(),
      ...getKolkataToBhubaneswarTrains(),
      
      // HYDERABAD ROUTES
      ...getHyderabadToPuneTrains(),
      ...getHyderabadToVijayawadaTrains(),
      
      // OTHER MAJOR ROUTES
      ...getAhmedabadToJaipurTrains(),
      ...getPuneToGoaTrains(),
      ...getLucknowToVaranasiTrains(),
    ];
  }

  // DELHI → MUMBAI
  static List<Map<String, dynamic>> getDelhiToMumbaiTrains() {
    return [
      {
        'number': '12951',
        'name': 'Mumbai Rajdhani',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Mumbai Central',
        'departure': '16:55',
        'arrival': '08:15',
        'duration': '15h 20m',
        'classes': ['1A', '2A', '3A'],
        'price': '₹1,845',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12953',
        'name': 'August Kranti Rajdhani',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Mumbai Central',
        'departure': '17:20',
        'arrival': '09:45',
        'duration': '16h 25m',
        'classes': ['1A', '2A', '3A'],
        'price': '₹1,965',
        'availability': 'RAC',
        'runningDays': 'Mon, Wed, Fri, Sun',
      },
      {
        'number': '12909',
        'name': 'Garib Rath Express',
        'type': 'AC Express',
        'from': 'New Delhi',
        'to': 'Mumbai Central',
        'departure': '15:25',
        'arrival': '10:35',
        'duration': '19h 10m',
        'classes': ['3A'],
        'price': '₹1,125',
        'availability': 'Available',
        'runningDays': 'Tue, Thu, Sat',
      },
    ];
  }

  // DELHI → BANGALORE
  static List<Map<String, dynamic>> getDelhiToBangaloreTrains() {
    return [
      {
        'number': '12429',
        'name': 'Rajdhani Express',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Bangalore City',
        'departure': '20:15',
        'arrival': '06:00',
        'duration': '33h 45m',
        'classes': ['1A', '2A', '3A'],
        'price': '₹3,245',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12639',
        'name': 'Brindavan Express',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Bangalore City',
        'departure': '22:30',
        'arrival': '07:15',
        'duration': '32h 45m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹2,645',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // DELHI → CHENNAI
  static List<Map<String, dynamic>> getDelhiToChennaiTrains() {
    return [
      {
        'number': '12615',
        'name': 'Grand Trunk Express',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Chennai Central',
        'departure': '19:35',
        'arrival': '06:45',
        'duration': '35h 10m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹3,145',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12621',
        'name': 'Tamil Nadu Express',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Chennai Central',
        'departure': '22:30',
        'arrival': '09:30',
        'duration': '35h',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹3,085',
        'availability': 'RAC',
        'runningDays': 'Daily',
      },
    ];
  }

  // DELHI → KOLKATA
  static List<Map<String, dynamic>> getDelhiToKolkataTrains() {
    return [
      {
        'number': '12301',
        'name': 'Howrah Rajdhani',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Howrah',
        'departure': '16:55',
        'arrival': '10:05',
        'duration': '17h 10m',
        'classes': ['1A', '2A', '3A'],
        'price': '₹2,445',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12311',
        'name': 'Kalka Mail',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Howrah',
        'departure': '23:10',
        'arrival': '21:45',
        'duration': '22h 35m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹1,865',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // DELHI → HYDERABAD
  static List<Map<String, dynamic>> getDelhiToHyderabadTrains() {
    return [
      {
        'number': '12723',
        'name': 'Telangana Express',
        'type': 'Superfast',
        'from': 'New Delhi',
        'to': 'Hyderabad',
        'departure': '17:45',
        'arrival': '16:30',
        'duration': '22h 45m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹2,345',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // MUMBAI → BANGALORE
  static List<Map<String, dynamic>> getMumbaiToBangaloreTrains() {
    return [
      {
        'number': '12628',
        'name': 'Karnataka Express',
        'type': 'Superfast',
        'from': 'Mumbai Central',
        'to': 'Bangalore City',
        'departure': '20:10',
        'arrival': '10:40',
        'duration': '14h 30m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹1,245',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '11302',
        'name': 'Udyan Express',
        'type': 'Fast',
        'from': 'Mumbai Central',
        'to': 'Bangalore City',
        'departure': '08:05',
        'arrival': '05:40',
        'duration': '21h 35m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹945',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // MUMBAI → CHENNAI
  static List<Map<String, dynamic>> getMumbaiToChennaiTrains() {
    return [
      {
        'number': '12163',
        'name': 'Chennai Dadar Express',
        'type': 'Superfast',
        'from': 'Mumbai Central',
        'to': 'Chennai Central',
        'departure': '21:35',
        'arrival': '20:25',
        'duration': '22h 50m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹1,545',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // MUMBAI → KOLKATA
  static List<Map<String, dynamic>> getMumbaiToKolkataTrains() {
    return [
      {
        'number': '12809',
        'name': 'Howrah Mail',
        'type': 'Superfast',
        'from': 'Mumbai Central',
        'to': 'Howrah',
        'departure': '20:05',
        'arrival': '06:55',
        'duration': '34h 50m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹2,745',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // MUMBAI → HYDERABAD
  static List<Map<String, dynamic>> getMumbaiToHyderabadTrains() {
    return [
      {
        'number': '12701',
        'name': 'Hussainsagar Express',
        'type': 'Superfast',
        'from': 'Mumbai Central',
        'to': 'Hyderabad',
        'departure': '21:55',
        'arrival': '10:25',
        'duration': '12h 30m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹945',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // MUMBAI → PUNE
  static List<Map<String, dynamic>> getMumbaiToPuneTrains() {
    return [
      {
        'number': '12123',
        'name': 'Deccan Queen',
        'type': 'Fast',
        'from': 'Mumbai CST',
        'to': 'Pune',
        'departure': '17:10',
        'arrival': '20:25',
        'duration': '3h 15m',
        'classes': ['CC', '2S'],
        'price': '₹285',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12127',
        'name': 'Intercity Express',
        'type': 'Fast',
        'from': 'Mumbai CST',
        'to': 'Pune',
        'departure': '07:10',
        'arrival': '10:25',
        'duration': '3h 15m',
        'classes': ['CC', '2S'],
        'price': '₹265',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // MUMBAI → AHMEDABAD
  static List<Map<String, dynamic>> getMumbaiToAhmedabadTrains() {
    return [
      {
        'number': '12901',
        'name': 'Gujarat Mail',
        'type': 'Superfast',
        'from': 'Mumbai Central',
        'to': 'Ahmedabad',
        'departure': '21:05',
        'arrival': '06:25',
        'duration': '9h 20m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹645',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12927',
        'name': 'Shatabdi Express',
        'type': 'Superfast',
        'from': 'Mumbai Central',
        'to': 'Ahmedabad',
        'departure': '06:25',
        'arrival': '13:15',
        'duration': '6h 50m',
        'classes': ['CC', 'EC'],
        'price': '₹845',
        'availability': 'Available',
        'runningDays': 'Daily except Wed',
      },
    ];
  }

  // MUMBAI → GOA
  static List<Map<String, dynamic>> getMumbaiToGoa() {
    return [
      {
        'number': '10103',
        'name': 'Mandovi Express',
        'type': 'Superfast',
        'from': 'Mumbai CST',
        'to': 'Madgaon',
        'departure': '07:10',
        'arrival': '19:05',
        'duration': '11h 55m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹745',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '10111',
        'name': 'Konkan Kanya Express',
        'type': 'Superfast',
        'from': 'Mumbai CST',
        'to': 'Madgaon',
        'departure': '23:00',
        'arrival': '12:40',
        'duration': '13h 40m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹685',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // CHENNAI → HYDERABAD
  static List<Map<String, dynamic>> getChennaiToHyderabadTrains() {
    return [
      {
        'number': '12759',
        'name': 'Charminar Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Hyderabad',
        'departure': '18:00',
        'arrival': '05:55',
        'duration': '11h 55m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹865',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12604',
        'name': 'Chennai-Hyderabad Express',
        'type': 'AC Express',
        'from': 'Chennai Central',
        'to': 'Hyderabad',
        'departure': '06:30',
        'arrival': '19:15',
        'duration': '12h 45m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹745',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12760',
        'name': 'Tamil Nadu Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Hyderabad',
        'departure': '22:30',
        'arrival': '10:25',
        'duration': '11h 55m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹920',
        'availability': 'RAC',
        'runningDays': 'Daily',
      },
      {
        'number': '17644',
        'name': 'Circar Express',
        'type': 'Fast',
        'from': 'Chennai Central',
        'to': 'Hyderabad',
        'departure': '16:45',
        'arrival': '06:30',
        'duration': '13h 45m',
        'classes': ['SL', '2S'],
        'price': '₹465',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // CHENNAI → BANGALORE
  static List<Map<String, dynamic>> getChennaiToBangaloreTrains() {
    return [
      {
        'number': '12639',
        'name': 'Brindavan Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Bangalore City',
        'departure': '07:00',
        'arrival': '13:15',
        'duration': '6h 15m',
        'classes': ['CC', 'EC'],
        'price': '₹545',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12608',
        'name': 'Lalbagh Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Bangalore City',
        'departure': '06:00',
        'arrival': '12:00',
        'duration': '6h',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹465',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12607',
        'name': 'Bangalore Mail',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Bangalore City',
        'departure': '23:30',
        'arrival': '06:50',
        'duration': '7h 20m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹485',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // CHENNAI → COIMBATORE
  static List<Map<String, dynamic>> getChennaiToCoimbatoreTrains() {
    return [
      {
        'number': '12679',
        'name': 'Kovai Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Coimbatore',
        'departure': '06:00',
        'arrival': '12:30',
        'duration': '6h 30m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹645',
        'fares': {'2A': 1195, '3A': 645, 'SL': 245},
        'availability': {'2A': 'Available', '3A': 'Available', 'SL': 'Available'},
        'runningDays': 'Daily',
      },
      {
        'number': '12673',
        'name': 'Cheran Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Coimbatore',
        'departure': '21:30',
        'arrival': '04:45',
        'duration': '7h 15m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹585',
        'fares': {'2A': 1095, '3A': 585, 'SL': 230},
        'availability': {'2A': 'Available', '3A': 'RAC', 'SL': 'Available'},
        'runningDays': 'Daily',
      },
      {
        'number': '12675',
        'name': 'Kovai SF Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Coimbatore',
        'departure': '15:30',
        'arrival': '22:45',
        'duration': '7h 15m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹595',
        'fares': {'2A': 1125, '3A': 595, 'SL': 235},
        'availability': {'2A': 'RAC', '3A': 'Limited', 'SL': 'Available'},
        'runningDays': 'Daily',
      },
    ];
  }

  // CHENNAI → KOLKATA
  static List<Map<String, dynamic>> getChennaiToKolkataTrains() {
    return [
      {
        'number': '12841',
        'name': 'Coromandel Express',
        'type': 'Superfast',
        'from': 'Chennai Central',
        'to': 'Howrah',
        'departure': '08:35',
        'arrival': '17:20',
        'duration': '32h 45m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹2,545',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }
  
  // KOLKATA → CHENNAI (reverse route)
  static List<Map<String, dynamic>> getKolkataToChennaiTrains() {
    return [
      {
        'number': '12842',
        'name': 'Coromandel Express',
        'type': 'Superfast',
        'from': 'Howrah',
        'to': 'Chennai Central',
        'departure': '14:45',
        'arrival': '23:15',
        'duration': '32h 30m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹2,545',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12663',
        'name': 'Howrah - Chennai SF',
        'type': 'Superfast',
        'from': 'Howrah',
        'to': 'Chennai Central',
        'departure': '19:50',
        'arrival': '05:30',
        'duration': '33h 40m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹2,345',
        'availability': 'Available',
        'runningDays': 'Tue, Thu, Sat',
      },
      {
        'number': '12844',
        'name': 'Howrah - Chennai Mail',
        'type': 'Superfast',
        'from': 'Howrah',
        'to': 'Chennai Central',
        'departure': '23:55',
        'arrival': '08:15',
        'duration': '32h 20m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹2,445',
        'availability': 'RAC',
        'runningDays': 'Daily',
      },
      {
        'number': '22841',
        'name': 'Chennai Raj',
        'type': 'Superfast',
        'from': 'Howrah',
        'to': 'Chennai Central',
        'departure': '06:15',
        'arrival': '13:45',
        'duration': '31h 30m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹2,245',
        'availability': 'Available',
        'runningDays': 'Mon, Wed, Fri',
      },
    ];
  }

  // CHENNAI → MADURAI
  static List<Map<String, dynamic>> getChennaiToMaduraiTrains() {
    return [
      {
        'number': '12635',
        'name': 'Vaigai Express',
        'type': 'Superfast',
        'from': 'Chennai Egmore',
        'to': 'Madurai',
        'departure': '12:40',
        'arrival': '20:20',
        'duration': '7h 40m',
        'classes': ['CC', '2S'],
        'price': '₹385',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12637',
        'name': 'Pandian Express',
        'type': 'Superfast',
        'from': 'Chennai Egmore',
        'to': 'Madurai',
        'departure': '21:00',
        'arrival': '06:15',
        'duration': '9h 15m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹445',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // CHENNAI → TRICHY
  static List<Map<String, dynamic>> getChennaiToTrichy() {
    return [
      {
        'number': '16787',
        'name': 'Tiruchchirapalli Express',
        'type': 'Fast',
        'from': 'Chennai Egmore',
        'to': 'Trichy',
        'departure': '17:30',
        'arrival': '22:45',
        'duration': '5h 15m',
        'classes': ['SL', '2S'],
        'price': '₹285',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // BANGALORE → HYDERABAD
  static List<Map<String, dynamic>> getBangaloreToHyderabadTrains() {
    return [
      {
        'number': '12785',
        'name': 'Kacheguda SF Express',
        'type': 'Superfast',
        'from': 'Bangalore City',
        'to': 'Hyderabad',
        'departure': '20:20',
        'arrival': '06:50',
        'duration': '10h 30m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹745',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
      {
        'number': '12799',
        'name': 'Seshadri Express',
        'type': 'Superfast',
        'from': 'Bangalore City',
        'to': 'Hyderabad',
        'departure': '07:00',
        'arrival': '18:55',
        'duration': '11h 55m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹685',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // BANGALORE → COIMBATORE
  static List<Map<String, dynamic>> getBangaloreToCoimbatoreTrains() {
    return [
      {
        'number': '12678',
        'name': 'Bangalore-Coimbatore Express',
        'type': 'Superfast',
        'from': 'Bangalore City',
        'to': 'Coimbatore',
        'departure': '15:45',
        'arrival': '22:15',
        'duration': '6h 30m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹545',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // BANGALORE → MYSORE
  static List<Map<String, dynamic>> getBangaloreToMysoreTrains() {
    return [
      {
        'number': '12614',
        'name': 'Tippu Express',
        'type': 'Fast',
        'from': 'Bangalore City',
        'to': 'Mysore',
        'departure': '15:00',
        'arrival': '18:15',
        'duration': '3h 15m',
        'classes': ['CC', '2S'],
        'price': '₹185',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // BANGALORE → MANGALORE
  static List<Map<String, dynamic>> getBangaloreToMangaloreTrains() {
    return [
      {
        'number': '16595',
        'name': 'Mangalore Express',
        'type': 'Fast',
        'from': 'Bangalore City',
        'to': 'Mangalore Central',
        'departure': '22:30',
        'arrival': '09:45',
        'duration': '11h 15m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹645',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // KOLKATA → HYDERABAD
  static List<Map<String, dynamic>> getKolkataToHyderabadTrains() {
    return [
      {
        'number': '17016',
        'name': 'Visakha Express',
        'type': 'Superfast',
        'from': 'Howrah',
        'to': 'Hyderabad',
        'departure': '09:00',
        'arrival': '15:15',
        'duration': '30h 15m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹2,345',
        'availability': 'Available',
        'runningDays': 'Tue, Thu, Sun',
      },
    ];
  }

  // KOLKATA → PATNA
  static List<Map<String, dynamic>> getKolkataToPatnaTrains() {
    return [
      {
        'number': '12333',
        'name': 'Vibhuti Express',
        'type': 'Superfast',
        'from': 'Howrah',
        'to': 'Patna',
        'departure': '21:50',
        'arrival': '07:00',
        'duration': '9h 10m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹645',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // KOLKATA → BHUBANESWAR
  static List<Map<String, dynamic>> getKolkataToBhubaneswarTrains() {
    return [
      {
        'number': '12821',
        'name': 'Dhauli Express',
        'type': 'Superfast',
        'from': 'Howrah',
        'to': 'Bhubaneswar',
        'departure': '06:35',
        'arrival': '13:45',
        'duration': '7h 10m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹545',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // HYDERABAD → PUNE
  static List<Map<String, dynamic>> getHyderabadToPuneTrains() {
    return [
      {
        'number': '12702',
        'name': 'Hussainsagar Express',
        'type': 'Superfast',
        'from': 'Hyderabad',
        'to': 'Pune',
        'departure': '19:10',
        'arrival': '07:05',
        'duration': '11h 55m',
        'classes': ['1A', '2A', '3A', 'SL'],
        'price': '₹845',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // HYDERABAD → VIJAYAWADA
  static List<Map<String, dynamic>> getHyderabadToVijayawadaTrains() {
    return [
      {
        'number': '12759',
        'name': 'Charminar Express',
        'type': 'Superfast',
        'from': 'Hyderabad',
        'to': 'Vijayawada',
        'departure': '16:50',
        'arrival': '22:20',
        'duration': '5h 30m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹385',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // AHMEDABAD → JAIPUR
  static List<Map<String, dynamic>> getAhmedabadToJaipurTrains() {
    return [
      {
        'number': '12957',
        'name': 'Swarna Jayanti Express',
        'type': 'Superfast',
        'from': 'Ahmedabad',
        'to': 'Jaipur',
        'departure': '23:45',
        'arrival': '09:05',
        'duration': '9h 20m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹645',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // PUNE → GOA
  static List<Map<String, dynamic>> getPuneToGoaTrains() {
    return [
      {
        'number': '10103',
        'name': 'Mandovi Express',
        'type': 'Superfast',
        'from': 'Pune',
        'to': 'Madgaon',
        'departure': '10:25',
        'arrival': '19:05',
        'duration': '8h 40m',
        'classes': ['2A', '3A', 'SL'],
        'price': '₹545',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }

  // LUCKNOW → VARANASI
  static List<Map<String, dynamic>> getLucknowToVaranasiTrains() {
    return [
      {
        'number': '15017',
        'name': 'Gorakhpur Express',
        'type': 'Fast',
        'from': 'Lucknow',
        'to': 'Varanasi',
        'departure': '13:15',
        'arrival': '20:30',
        'duration': '7h 15m',
        'classes': ['SL', '2S'],
        'price': '₹285',
        'availability': 'Available',
        'runningDays': 'Daily',
      },
    ];
  }
}
