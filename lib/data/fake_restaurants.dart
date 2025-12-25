import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';
import '../models/challenge.dart';

class FakeData {
  // Fake Restaurants (compatible with Firestore-backed model)
  static List<Restaurant> getRestaurants() {
    return [
      Restaurant(
        restaurantId: '1',
        name: 'Rimberio Spicy Food',
        location: GeoPoint(36.7, 3.0),
        address: 'Sidi Abdellah, Algiers',
        cuisine: 'Spicy',
        rating: 4.7,
        postsCount: 128,
        images: [
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&auto=format&fit=crop&q=80'
        ],
      ),
      Restaurant(
        restaurantId: '2',
        name: 'La Piazza Italiana',
        location: GeoPoint(36.75, 3.05),
        address: 'Hydra, Algiers',
        cuisine: 'Italian',
        rating: 4.5,
        postsCount: 89,
        images: [
          'https://images.unsplash.com/photo-1498579150354-977475b7ea0b?w=800&auto=format&fit=crop&q=80'
        ],
      ),
      Restaurant(
        restaurantId: '3',
        name: 'Sushi Paradise',
        location: GeoPoint(36.78, 3.02),
        address: 'El Biar, Algiers',
        cuisine: 'Japanese',
        rating: 4.8,
        postsCount: 156,
        images: [
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800&auto=format&fit=crop&q=80'
        ],
      ),
      Restaurant(
        restaurantId: '4',
        name: 'Burger House',
        location: GeoPoint(36.73, 3.03),
        address: 'Birkhadem, Algiers',
        cuisine: 'American',
        rating: 4.3,
        postsCount: 67,
        images: [
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80'
        ],
      ),
      Restaurant(
        restaurantId: '5',
        name: 'Café Parisien',
        location: GeoPoint(36.77, 3.04),
        address: 'Centre-ville, Algiers',
        cuisine: 'French',
        rating: 4.6,
        postsCount: 112,
        images: [
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop&q=80'
        ],
      ),
      Restaurant(
        restaurantId: '6',
        name: 'Tajine Royale',
        location: GeoPoint(36.79, 3.01),
        address: 'Bouzareah, Algiers',
        cuisine: 'Moroccan',
        rating: 4.4,
        postsCount: 94,
        images: [
          'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&auto=format&fit=crop&q=80'
        ],
      ),
    ];
  }

  // Get trending restaurants
  static List<Restaurant> getTrendingRestaurants() {
    return getRestaurants().where((r) => r.rating >= 4.7).toList();
  }

  // Search restaurants by query
  static List<Restaurant> searchRestaurants(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return getRestaurants()
        .where(
          (r) =>
              r.name.toLowerCase().contains(lowerQuery) ||
              (r.address.toLowerCase().contains(lowerQuery)) ||
              (r.cuisine.toLowerCase().contains(lowerQuery)),
        )
        .toList();
  }

  // Get restaurant by ID
  static Restaurant? getRestaurantById(String id) {
    try {
      return getRestaurants().firstWhere((r) => r.restaurantId == id);
    } catch (e) {
      return null;
    }
  }

  // Fake Challenges
  static List<Challenge> getChallenges() {
    final now = DateTime.now();
    return [
      Challenge(
        id: '1',
        title: 'Découvre 10 Restaurants',
        description:
            'Explorez 10 nouveaux restaurants dans votre ville et partagez vos découvertes',
        targetCount: 10,
        currentCount: 7,
        rewardBadge: '🏆 Explorateur',
        startDate: now.subtract(Duration(days: 7)),
        endDate: now.add(Duration(days: 23)),
        isActive: true,
        isJoined: true,
      ),
      Challenge(
        id: '2',
        title: 'Plats Épicés Challenge',
        description:
            'Goutez 5 plats épicés différents et documentez votre aventure culinaire',
        targetCount: 5,
        currentCount: 2,
        rewardBadge: '🌶️ Spicy Master',
        startDate: now.subtract(Duration(days: 3)),
        endDate: now.add(Duration(days: 27)),
        isActive: true,
        isJoined: false,
      ),
      Challenge(
        id: '3',
        title: 'Foodie du Mois',
        description: 'Publiez 20 posts ce mois-ci et devenez le foodie du mois',
        targetCount: 20,
        currentCount: 12,
        rewardBadge: '⭐ Foodie Star',
        startDate: DateTime(now.year, now.month, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
        isActive: true,
        isJoined: true,
      ),
      Challenge(
        id: '4',
        title: 'Tour du Monde en Cuisine',
        description:
            'Essayez des plats de 7 pays différents et partagez votre voyage culinaire',
        targetCount: 7,
        currentCount: 0,
        rewardBadge: '🌍 Globe Trotter',
        startDate: now.subtract(Duration(days: 10)),
        endDate: now.add(Duration(days: 20)),
        isActive: true,
        isJoined: false,
      ),
      Challenge(
        id: '5',
        title: 'Matinée Café',
        description: 'Visitez 5 cafés différents et partagez vos moments café',
        targetCount: 5,
        currentCount: 5,
        rewardBadge: '☕ Coffee Lover',
        startDate: now.subtract(Duration(days: 30)),
        endDate: now.subtract(Duration(days: 5)),
        isActive: false,
        isJoined: true,
      ),
    ];
  }

  // Get active challenges
  static List<Challenge> getActiveChallenges() {
    return getChallenges()
        .where((c) => c.isActive && c.endDate.isAfter(DateTime.now()))
        .toList();
  }

  // Get joined challenges
  static List<Challenge> getJoinedChallenges() {
    return getChallenges().where((c) => c.isJoined).toList();
  }

  // Recent searches (mock data)
  static List<String> getRecentSearches() {
    return ['Sushi', 'Pizza', 'Burger', 'Café', 'Italien'];
  }
}
