/// Classifies a video into a category path based on title + description keywords.
/// Returns a category path like "Lifestyle/Comida/Recetas", or null if no match.
class CategoryClassifier {
  static String? classify(String title, String description) {
    final text = '${title.toLowerCase()} ${description.toLowerCase()}';
    final scores = <String, int>{};

    for (final entry in _keywords.entries) {
      var score = 0;
      for (final kw in entry.value) {
        if (text.contains(kw)) score++;
      }
      if (score > 0) scores[entry.key] = score;
    }

    if (scores.isEmpty) return null;
    final best = scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    // Require at least 2 hits to avoid false positives on common words
    return best.value >= 2 ? best.key : null;
  }

  static const _keywords = <String, List<String>>{
    'Entretenimiento/Humor': [
      'chiste', 'broma', 'funny', 'meme', 'humor', 'comedia', 'comedy',
      'gracioso', 'risas', 'jajaja', 'lol', 'haha', 'chistoso', 'divertido',
    ],
    'Entretenimiento/Skits': [
      'skit', 'escena', 'acting', 'actuación', 'personaje', 'roleplay', 'sketch',
    ],
    'Entretenimiento/Retos / Challenges': [
      'reto', 'challenge', 'desafío', 'viral', '#challenge', 'me too',
    ],
    'Educación/Tips rápidos': [
      'tip', 'tips', 'truco', 'hack', 'consejo', 'advice', 'quick tip',
      'life hack', 'sabías que', 'did you know', 'pro tip',
    ],
    'Educación/Tutoriales/Tecnología': [
      'tutorial', 'código', 'programar', 'programming', 'developer', 'software',
      'javascript', 'python', 'flutter', 'android', 'ios', 'coding', 'github',
      'react', 'css', 'html', 'app', 'tech', 'tecnología', 'inteligencia artificial',
      'ai', 'machine learning', 'chatgpt',
    ],
    'Educación/Tutoriales/Finanzas': [
      'finanzas', 'dinero', 'inversión', 'investing', 'crypto', 'bitcoin',
      'stocks', 'ahorro', 'economía', 'economy', 'bolsa', 'trading', 'deuda',
      'ingresos', 'pasivos', 'riqueza', 'wealth',
    ],
    'Educación/Tutoriales/Idiomas': [
      'english', 'inglés', 'idioma', 'language', 'grammar', 'francés',
      'japonés', 'japanese', 'pronunciación', 'vocabulary', 'aprender idioma',
      'learn english', 'phrasal verb',
    ],
    'Educación/Datos curiosos': [
      'curiosidad', 'dato curioso', 'sabías que', 'fun fact', 'did you know',
      'amazing fact', 'increíble', 'interesante', 'sorprendente', 'impresionante',
    ],
    'Lifestyle/Fitness y salud': [
      'workout', 'ejercicio', 'gym', 'fitness', 'salud', 'health', 'yoga',
      'running', 'entrenamiento', 'abs', 'cardio', 'muscle', 'pérdida de peso',
      'weight loss', 'rutina', 'stretching', 'calistenia', 'calisthenics',
      'pérdida', 'adelgazar', 'bajar de peso', 'quemar grasa',
    ],
    'Lifestyle/Comida/Recetas': [
      'receta', 'recipe', 'cocinar', 'cooking', 'ingrediente', 'chef',
      'preparar', 'cómo hacer', 'how to make', 'cocina', 'hornear', 'baking',
      'paso a paso', 'step by step', 'fácil receta',
    ],
    'Lifestyle/Comida/Restaurantes': [
      'restaurante', 'restaurant', 'food review', 'reseña', 'probando',
      'taste test', 'mukbang', 'buffet', 'café', 'lo probé', 'probé',
      'el mejor', 'mejor restaurant',
    ],
    'Lifestyle/Comida/Dietas': [
      'dieta', 'diet', 'keto', 'vegan', 'vegano', 'ayuno', 'calorías',
      'nutrition', 'nutrición', 'proteína', 'protein', 'intermittent fasting',
      'ayuno intermitente', 'sin gluten', 'gluten free',
    ],
    'Lifestyle/Viajes': [
      'viaje', 'travel', 'trip', 'turismo', 'tourism', 'destino', 'destination',
      'hotel', 'playa', 'beach', 'vlog', 'explore', 'aventura', 'vacaciones',
      'vacation', 'backpacking', 'vuelo', 'flight',
    ],
    'Música/Covers': [
      'cover', 'versión', 'canción', 'song', 'singing', 'acústico', 'acoustic',
      'guitar', 'piano', 'canto', 'voz', 'voice', 'letra',
    ],
    'Música/Baile': [
      'baile', 'dance', 'coreografía', 'choreography', 'bailar', 'dancing',
      'tiktok dance', 'paso', 'moves', 'hip hop dance', 'reggaeton dance',
    ],
    'Música/Beats': [
      'beat', 'instrumental', 'producción', 'trap', 'hiphop', 'reggaeton',
      'producer', 'fl studio', 'ableton', 'sample', 'freestyle', 'rap',
    ],
    'Deportes/Fútbol': [
      'fútbol', 'soccer', 'football', 'gol', 'goal', 'partido', 'match',
      'liga', 'champions', 'messi', 'ronaldo', 'neymar', 'premier league',
      'laliga', 'uefa', 'mundial',
    ],
    'Deportes/Gym': [
      'gym', 'levantamiento', 'weights', 'powerlifting', 'crossfit',
      'bodybuilding', 'squat', 'deadlift', 'bench press', 'press banca',
      'sentadilla', 'peso muerto',
    ],
    'Deportes/Extreme': [
      'extreme', 'parkour', 'skate', 'surf', 'bmx', 'motocross', 'adrenalina',
      'adrenaline', 'stunts', 'freestyle', 'ramp', 'halfpipe', 'truco',
    ],
  };
}
