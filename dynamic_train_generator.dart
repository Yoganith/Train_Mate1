import 'dart:math';

/// Dynamic Train Generator for Indian Railways
/// Generates realistic trains for any route based on distance and cities
class DynamicTrainGenerator {
  // Major Indian cities with their railway codes
  static final Map<String, String> stationCodes = {
    'New Delhi': 'NDLS',
    'Delhi': 'NDLS',
    'Mumbai Central': 'MMCT',
    'Mumbai': 'MMCT',
    'Bombay': 'MMCT',
    'Chennai Central': 'MAS',
    'Chennai': 'MAS',
    'Kolkata': 'HWH',
    'Howrah': 'HWH',
    'Bangalore City': 'SBC',
    'Bangalore': 'SBC',
    'Bengaluru': 'SBC',
    'Hyderabad': 'HYB',
    'Pune': 'PUNE',
    'Ahmedabad': 'ADI',
    'Jaipur': 'JP',
    'Lucknow': 'LKO',
    'Kanpur': 'CNB',
    'Nagpur': 'NGP',
    'Indore': 'INDB',
    'Bhopal': 'BPL',
    'Patna': 'PNBE',
    'Vadodara': 'BRC',
    'Agra': 'AGC',
    'Varanasi': 'BSB',
    'Surat': 'ST',
    'Coimbatore': 'CBE',
    'Madurai': 'MDU',
    'Trichy': 'TPJ',
    'Vijayawada': 'BZA',
    'Visakhapatnam': 'VSKP',
    'Bhubaneswar': 'BBS',
    'Guwahati': 'GHY',
    'Thiruvananthapuram': 'TVC',
    'Kochi': 'ERS',
    'Chandigarh': 'CDG',
    'Mysore': 'MYS',
    'Mangalore': 'MAQ',
    'Goa': 'MAO',
    'Madgaon': 'MAO',
    'Amritsar': 'ASR',
    'Jammu': 'JAT',
    'Dehradun': 'DDN',
    'Haridwar': 'HW',
    'Rishikesh': 'RKSH',
    'Jodhpur': 'JU',
    'Udaipur': 'UDZ',
    'Ajmer': 'AII',
    'Gwalior': 'GWL',
    'Jabalpur': 'JBP',
    'Raipur': 'R',
    'Ranchi': 'RNC',
    'Dhanbad': 'DHN',
    'Allahabad': 'ALD',
    'Prayagraj': 'ALD',
  };

  // Approximate distances between major city pairs (in km)
  static final Map<String, Map<String, int>> distances = {
    'delhi': {'mumbai': 1400, 'chennai': 2200, 'kolkata': 1500, 'bangalore': 2150, 'hyderabad': 1600},
    'mumbai': {'delhi': 1400, 'chennai': 1340, 'kolkata': 2000, 'bangalore': 980, 'hyderabad': 710, 'pune': 150, 'goa': 580},
    'chennai': {'delhi': 2200, 'mumbai': 1340, 'kolkata': 1670, 'bangalore': 350, 'hyderabad': 630, 'coimbatore': 505},
    'kolkata': {'delhi': 1500, 'mumbai': 2000, 'chennai': 1670, 'bangalore': 1880, 'hyderabad': 1500, 'patna': 540},
    'bangalore': {'delhi': 2150, 'mumbai': 980, 'chennai': 350, 'kolkata': 1880, 'hyderabad': 575, 'mysore': 140, 'coimbatore': 370},
    'hyderabad': {'delhi': 1600, 'mumbai': 710, 'chennai': 630, 'kolkata': 1500, 'bangalore': 575, 'pune': 565, 'vijayawada': 275},
    'pune': {'mumbai': 150, 'hyderabad': 565, 'bangalore': 840, 'goa': 450},
    'ahmedabad': {'delhi': 950, 'mumbai': 490, 'jaipur': 660},
    'jaipur': {'delhi': 280, 'ahmedabad': 660, 'jodhpur': 345},
  };

  // Train name templates
  static final List<String> trainNameTemplates = [
    '{from}-{to} Express',
    '{from} {to} SF',
    '{from} Mail',
    'Rajdhani Express',
    'Shatabdi Express',
    'Duronto Express',
    'Garib Rath Express',
    'Humsafar Express',
    'Jan Shatabdi',
    'Superfast Express',
    'Intercity Express',
    'Passenger',
  ];

  /// Generate trains for a specific route
  static List<Map<String, dynamic>> generateTrainsForRoute(String from, String to) {
    List<Map<String, dynamic>> trains = [];
    
    // Normalize city names
    final normalizedFrom = _normalizeCity(from);
    final normalizedTo = _normalizeCity(to);
    
    // Calculate approximate distance
    final distance = _getDistance(normalizedFrom, normalizedTo);
    
    // Generate 3-6 trains for the route
    final random = Random();
    final numTrains = 3 + random.nextInt(4); // 3 to 6 trains
    
    for (int i = 0; i < numTrains; i++) {
      trains.add(_generateTrain(from, to, normalizedFrom, normalizedTo, distance, i));
    }
    
    return trains;
  }

  static String _normalizeCity(String city) {
    city = city.toLowerCase().trim();
    if (city.contains('delhi')) return 'delhi';
    if (city.contains('mumbai') || city.contains('bombay')) return 'mumbai';
    if (city.contains('chennai') || city.contains('madras')) return 'chennai';
    if (city.contains('kolkata') || city.contains('calcutta') || city.contains('howrah')) return 'kolkata';
    if (city.contains('bangalore') || city.contains('bengaluru')) return 'bangalore';
    if (city.contains('hyderabad')) return 'hyderabad';
    if (city.contains('pune')) return 'pune';
    if (city.contains('ahmedabad')) return 'ahmedabad';
    if (city.contains('jaipur')) return 'jaipur';
    if (city.contains('coimbatore')) return 'coimbatore';
    if (city.contains('patna')) return 'patna';
    if (city.contains('goa') || city.contains('madgaon')) return 'goa';
    if (city.contains('mysore')) return 'mysore';
    if (city.contains('vijayawada')) return 'vijayawada';
    return city;
  }

  static int _getDistance(String from, String to) {
    // Try to find actual distance
    if (distances.containsKey(from) && distances[from]!.containsKey(to)) {
      return distances[from]![to]!;
    }
    if (distances.containsKey(to) && distances[to]!.containsKey(from)) {
      return distances[to]![from]!;
    }
    
    // Return estimated distance based on common routes
    return 800; // Default ~800km for unknown routes
  }

  static Map<String, dynamic> _generateTrain(
    String fromOriginal,
    String toOriginal,
    String fromNormalized,
    String toNormalized,
    int distance,
    int index,
  ) {
    final random = Random(fromOriginal.hashCode + toOriginal.hashCode + index);
    
    // Generate train number (12xxx for superfast, 1xxxx for express, 2xxxx for shatabdi)
    final trainNumber = _generateTrainNumber(index, distance);
    
    // Generate train name
    final trainName = _generateTrainName(fromOriginal, toOriginal, index, distance);
    
    // Determine train type based on distance
    final trainType = _getTrainType(distance, index);
    
    // Calculate journey duration based on distance and train type
    final duration = _calculateDuration(distance, trainType);
    
    // Generate departure time (spread throughout the day)
    final departureHour = 6 + (index * 4) % 18; // 6am to midnight
    final departureMinute = random.nextInt(12) * 5; // 0, 5, 10... 55
    final departure = '${departureHour.toString().padLeft(2, '0')}:${departureMinute.toString().padLeft(2, '0')}';
    
    // Calculate arrival time
    final arrival = _calculateArrival(departureHour, departureMinute, duration);
    
    // Generate price based on distance and class
    final basePrice = _calculatePrice(distance, trainType);
    
    // Determine available classes based on train type
    final classes = _getAvailableClasses(trainType);
    
    // Generate availability status
    final availabilityOptions = ['Available', 'Available', 'Available', 'RAC', 'WL 5', 'WL 12'];
    final availability = availabilityOptions[random.nextInt(availabilityOptions.length)];
    
    // Running days
    final runningDaysOptions = [
      'Daily',
      'Daily',
      'Daily',
      'Mon, Wed, Fri',
      'Tue, Thu, Sat',
      'Mon, Wed, Fri, Sun',
    ];
    final runningDays = runningDaysOptions[random.nextInt(runningDaysOptions.length)];
    
    // Generate class-specific fares and availability
    final faresMap = _generateClassFares(classes, basePrice);
    final availabilityMap = _generateClassAvailability(classes, random);
    
    return {
      'number': trainNumber,
      'name': trainName,
      'type': trainType,
      'from': fromOriginal,
      'to': toOriginal,
      'departure': departure,
      'arrival': arrival,
      'duration': duration,
      'classes': classes,
      'price': '₹$basePrice',
      'fares': faresMap,
      'availability': availabilityMap,
      'runningDays': runningDays,
      'rating': 3.8 + (random.nextInt(8) / 10), // 3.8 to 4.5
      'amenities': _getAmenities(trainType),
      'delay': index == 0 ? 'On Time' : (random.nextBool() ? 'On Time' : '${5 + random.nextInt(15)} min late'),
      'platform': '${1 + random.nextInt(7)}',
    };
  }

  static String _generateTrainNumber(int index, int distance) {
    if (distance > 1500 && index == 0) {
      return '12${Random().nextInt(900) + 100}'; // Rajdhani range
    } else if (distance < 400 && index == 0) {
      return '22${Random().nextInt(900) + 100}'; // Shatabdi range
    } else if (index % 2 == 0) {
      return '12${Random().nextInt(900) + 100}'; // Superfast
    } else {
      return '1${Random().nextInt(9000) + 1000}'; // Express
    }
  }

  static String _generateTrainName(String from, String to, int index, int distance) {
    // Extract city names without "Central", "Junction" etc
    final fromCity = from.split(' ')[0];
    final toCity = to.split(' ')[0];
    
    if (distance > 1500 && index == 0) {
      return 'Rajdhani Express';
    } else if (distance < 400 && index == 0) {
      return 'Shatabdi Express';
    } else if (index == 1) {
      return 'Duronto Express';
    } else if (index == 2) {
      return '$fromCity $toCity Express';
    } else if (index == 3) {
      return '$fromCity Mail';
    } else if (index == 4) {
      return '$fromCity $toCity SF';
    } else {
      return '$fromCity-$toCity Passenger';
    }
  }

  static String _getTrainType(int distance, int index) {
    if (distance > 1500 && index == 0) return 'Superfast';
    if (distance < 400 && index == 0) return 'Fast';
    if (index % 3 == 0) return 'Superfast';
    if (index % 3 == 1) return 'AC Express';
    return 'Fast';
  }

  static String _calculateDuration(int distance, String trainType) {
    // Average speed: Superfast ~75km/h, AC Express ~60km/h, Fast ~50km/h
    double speed = trainType == 'Superfast' ? 75 : (trainType == 'AC Express' ? 60 : 50);
    double hours = distance / speed;
    int totalMinutes = (hours * 60).toInt();
    int h = totalMinutes ~/ 60;
    int m = totalMinutes % 60;
    return '${h}h ${m}m';
  }

  static String _calculateArrival(int depHour, int depMinute, String duration) {
    // Parse duration
    final parts = duration.split(' ');
    final hours = int.parse(parts[0].replaceAll('h', ''));
    final minutes = int.parse(parts[1].replaceAll('m', ''));
    
    int totalMinutes = depHour * 60 + depMinute + hours * 60 + minutes;
    int days = totalMinutes ~/ 1440; // 1440 minutes in a day
    totalMinutes = totalMinutes % 1440;
    
    int arrHour = totalMinutes ~/ 60;
    int arrMinute = totalMinutes % 60;
    
    String arrivalTime = '${arrHour.toString().padLeft(2, '0')}:${arrMinute.toString().padLeft(2, '0')}';
    if (days > 0) {
      arrivalTime += ' +${days}d';
    }
    
    return arrivalTime;
  }

  static int _calculatePrice(int distance, String trainType) {
    // Base price per km
    double pricePerKm = trainType == 'Superfast' ? 0.65 : (trainType == 'AC Express' ? 0.55 : 0.40);
    int basePrice = (distance * pricePerKm).toInt();
    
    // Round to nearest 5
    return ((basePrice + 2) ~/ 5) * 5;
  }

  static List<String> _getAvailableClasses(String trainType) {
    if (trainType == 'Superfast') {
      return ['1A', '2A', '3A', 'SL'];
    } else if (trainType == 'AC Express') {
      return ['2A', '3A', 'SL'];
    } else {
      return ['SL', '2S'];
    }
  }

  static List<String> _getAmenities(String trainType) {
    if (trainType == 'Superfast') {
      return ['Wi-Fi', 'Pantry', 'AC', 'Charging Points'];
    } else if (trainType == 'AC Express') {
      return ['Pantry', 'AC', 'Charging Points'];
    } else {
      return ['Pantry'];
    }
  }
  
  static Map<String, int> _generateClassFares(List<String> classes, int basePrice) {
    Map<String, int> fares = {};
    
    for (String classType in classes) {
      int fare;
      switch (classType) {
        case '1A':
          fare = (basePrice * 2.7).toInt();
          break;
        case '2A':
          fare = (basePrice * 1.85).toInt();
          break;
        case '3A':
          fare = basePrice;
          break;
        case 'SL':
          fare = (basePrice * 0.38).toInt();
          break;
        case '2S':
          fare = (basePrice * 0.25).toInt();
          break;
        case 'CC':
          fare = (basePrice * 0.85).toInt();
          break;
        case 'EC':
          fare = (basePrice * 1.1).toInt();
          break;
        default:
          fare = basePrice;
      }
      
      // Round to nearest 5
      fares[classType] = ((fare + 2) ~/ 5) * 5;
    }
    
    return fares;
  }
  
  static Map<String, String> _generateClassAvailability(List<String> classes, Random random) {
    Map<String, String> availability = {};
    
    final availabilityOptions = [
      'Available',
      'Available',
      'Available',
      'Limited',
      'RAC',
      'Waiting',
    ];
    
    for (String classType in classes) {
      availability[classType] = availabilityOptions[random.nextInt(availabilityOptions.length)];
    }
    
    return availability;
  }
}
