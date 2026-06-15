/// Suggests up to [max] relevant tags from title + description text.
class TagClassifier {
  static List<String> suggest(
    String title,
    String description, {
    int max = 3,
  }) {
    final text = '${title.toLowerCase()} ${description.toLowerCase()}';
    final scores = <String, int>{};

    for (final entry in _keywords.entries) {
      var score = 0;
      for (final kw in entry.value) {
        if (text.contains(kw)) score++;
      }
      if (score > 0) scores[entry.key] = score;
    }

    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(max).map((e) => e.key).toList();
  }

  static const _keywords = <String, List<String>>{
    // ── 🎭 Entretenimiento ───────────────────────────────────────
    'Humor & Comedy': [
      'humor', 'comedia', 'comedy', 'chiste', 'broma', 'funny', 'meme',
      'gracioso', 'risas', 'jajaja', 'lol', 'chistoso', 'divertido',
    ],
    'Skits & Acting': [
      'skit', 'sketch', 'escena', 'actuación', 'acting', 'personaje',
      'roleplay', 'obra', 'teatro',
    ],
    'Challenges': [
      'reto', 'challenge', 'desafío', '#challenge', 'me too', 'duet',
    ],
    'Reactions': [
      'reacción', 'reaction', 'reacting', 'reacciono', 'reaccione',
      'mi reacción', 'reaccioné',
    ],
    'Pranks': [
      'prank', 'broma', 'engaño', 'trampa', 'brome', 'le hice', 'no sabe',
    ],
    'Compilations': [
      'compilación', 'compilation', 'mejores momentos', 'best of',
      'top 10', 'top 5', 'recopilación',
    ],

    // ── 📚 Educación ─────────────────────────────────────────────
    'Quick Tips': [
      'tip', 'tips', 'truco', 'hack', 'consejo', 'advice', 'quick tip',
      'life hack', 'pro tip', 'sabías que', 'did you know',
    ],
    'Tutorials': [
      'tutorial', 'cómo hacer', 'how to', 'aprende', 'paso a paso',
      'guía', 'guide', 'enseño', 'te enseño', 'aprende conmigo',
    ],
    'Technology': [
      'código', 'programar', 'programming', 'developer', 'software',
      'javascript', 'python', 'flutter', 'android', 'ios', 'coding',
      'github', 'react', 'web', 'tech', 'computer', 'computadora',
    ],
    'Finance': [
      'finanzas', 'dinero', 'inversión', 'investing', 'crypto', 'bitcoin',
      'stocks', 'bolsa', 'trading', 'economía', 'economy',
    ],
    'Languages': [
      'english', 'inglés', 'idioma', 'language', 'grammar', 'francés',
      'japonés', 'pronunciación', 'vocabulary', 'learn english',
      'aprender inglés', 'phrasal verb',
    ],
    'Science': [
      'ciencia', 'science', 'experimento', 'física', 'química', 'biología',
      'astronomía', 'universo', 'átomo', 'evolución', 'nasa',
    ],
    'History': [
      'historia', 'history', 'histórico', 'guerra', 'imperio', 'antiguo',
      'civilización', 'siglo', 'revolución', 'batalla',
    ],
    'Fun Facts': [
      'dato curioso', 'curiosidad', 'fun fact', 'sabías que', 'did you know',
      'increíble', 'sorprendente', 'impresionante', 'amazing fact',
    ],
    'Mythology & Culture': [
      'mitología', 'mythology', 'cultura', 'mito', 'leyenda', 'dios',
      'diosa', 'griega', 'nórdica', 'romana', 'cultura general',
    ],
    'Books & Reading': [
      'libro', 'book', 'lectura', 'leer', 'novela', 'autor', 'reseña libro',
      'book review', 'bibliofilo', 'bookstagram', 'booktok',
    ],

    // ── 🌿 Lifestyle ─────────────────────────────────────────────
    'Fitness & Health': [
      'workout', 'ejercicio', 'gym', 'fitness', 'entrenamiento', 'cardio',
      'abs', 'rutina', 'calistenia', 'crossfit', 'yoga', 'running',
      'adelgazar', 'bajar de peso', 'quemar grasa', 'pérdida de peso',
    ],
    'Food': [
      'comida', 'food', 'comer', 'plato', 'sabor', 'delicioso', 'rico',
      'gastronomía', 'cuisine',
    ],
    'Recipes': [
      'receta', 'recipe', 'cocinar', 'cooking', 'ingrediente', 'chef',
      'cómo preparar', 'hornear', 'baking', 'cocina fácil',
    ],
    'Restaurants': [
      'restaurante', 'restaurant', 'food review', 'reseña', 'probando',
      'taste test', 'mukbang', 'buffet', 'lo probé', 'visitamos',
    ],
    'Diets': [
      'dieta', 'diet', 'keto', 'vegan', 'vegano', 'ayuno', 'calorías',
      'nutrición', 'proteína', 'ayuno intermitente', 'sin gluten',
    ],
    'Travel': [
      'viaje', 'travel', 'trip', 'turismo', 'tourism', 'destino',
      'hotel', 'playa', 'beach', 'vlog viaje', 'aventura', 'vacaciones',
      'vuelo', 'backpacking', 'mochilero',
    ],
    'Fashion & Beauty': [
      'moda', 'fashion', 'outfit', 'ropa', 'belleza', 'beauty', 'makeup',
      'maquillaje', 'skincare', 'haul', 'estilo', 'look', 'ootd',
    ],
    'Home & Decor': [
      'hogar', 'decoración', 'home', 'decor', 'interiorismo', 'mueble',
      'organizar', 'organización', 'casa', 'habitación', 'room tour',
    ],
    'Minimalism': [
      'minimalismo', 'minimalism', 'minimalista', 'simplicidad', 'esencial',
      'desapego', 'menos es más', 'declutter',
    ],
    'Daily Routines': [
      'rutina', 'routine', 'día a día', 'morning routine', 'night routine',
      'grwm', 'get ready with me', 'día en mi vida', 'day in my life',
    ],

    // ── 👨‍👩‍👧 Familia ─────────────────────────────────────────────
    'Parenting': [
      'crianza', 'paternidad', 'papá', 'padre', 'dad', 'hijo', 'hija',
      'parenting', 'educar', 'niño', 'niña',
    ],
    'Motherhood': [
      'maternidad', 'mamá', 'madre', 'mom', 'mother', 'motherhood',
      'lactancia', 'postparto',
    ],
    'Relationships': [
      'pareja', 'relación', 'novio', 'novia', 'amor', 'love', 'relationship',
      'cita', 'date', 'boda', 'matrimonio', 'aniversario',
    ],
    'Pets': [
      'mascota', 'pet', 'perro', 'gato', 'dog', 'cat', 'gatito', 'perrito',
      'veterinario', 'adopción animal',
    ],
    'Family Moments': [
      'familia', 'family', 'familiar', 'reunión familiar', 'celebración',
      'cumpleaños', 'navidad', 'fiestas',
    ],
    'Pregnancy & Babies': [
      'embarazo', 'embarazada', 'pregnancy', 'bebé', 'baby', 'recién nacido',
      'newborn', 'parto', 'lactancia',
    ],

    // ── ✝️ Espiritualidad y religión ──────────────────────────────
    'Christianity': [
      'cristiano', 'cristianismo', 'jesucristo', 'jesús', 'dios', 'biblia',
      'evangelio', 'iglesia', 'protestante', 'bautista',
    ],
    'Catholicism': [
      'católico', 'catolicismo', 'misa', 'papa', 'vaticano', 'rosario',
      'virgen', 'santa', 'santo', 'parroquia',
    ],
    'Islam': [ // same key
      'islam', 'islámico', 'musulmán', 'alá', 'corán', 'ramadán',
      'mezquita', 'halal', 'hiyab',
    ],
    'Buddhism': [
      'budismo', 'budista', 'buda', 'karma', 'nirvana', 'dharma', 'zen',
      'templo budista',
    ],
    'Judaism': [
      'judaísmo', 'judío', 'torá', 'sinagoga', 'shabat', 'kosher',
      'israel', 'hebreo',
    ],
    'Spirituality': [
      'espiritualidad', 'spiritual', 'chakra', 'energía', 'universo',
      'manifestar', 'ley de atracción', 'alma', 'tarot', 'astrología',
    ],
    'Meditation & Mindfulness': [
      'meditación', 'meditation', 'mindfulness', 'respiración', 'consciencia',
      'plena conciencia', 'meditar', 'calma', 'paz interior',
    ],
    'Faith & Testimony': [
      'fe', 'testimonio', 'milagro', 'dios me ayudó', 'oración', 'pray',
      'bendición', 'gratitud espiritual',
    ],

    // ── 🗳️ Política y sociedad ────────────────────────────────────
    'News & Current Events': [
      'noticia', 'news', 'actualidad', 'breaking news', 'última hora',
      'hoy en el mundo', 'informativo',
    ],
    'Political Opinion': [
      'política', 'político', 'opinion', 'opinión', 'debate', 'partido',
      'presidente', 'gobierno', 'congreso', 'elecciones',
    ],
    'Human Rights': [
      'derechos humanos', 'human rights', 'justicia', 'igualdad',
      'discriminación', 'racismo', 'injusticia',
    ],
    'Economy & Policy': [
      'economía', 'política pública', 'impuesto', 'inflación', 'pib',
      'banco central', 'subsidio', 'presupuesto',
    ],
    'Environment & Climate': [
      'medio ambiente', 'clima', 'cambio climático', 'calentamiento global',
      'sostenible', 'ecológico', 'reciclaje', 'contaminación', 'planeta',
    ],
    'Feminism & Gender': [
      'feminismo', 'feminista', 'género', 'mujer', 'igualdad de género',
      'machismo', 'empoderamiento', 'lgbtq', 'lgbtq+',
    ],
    'Geopolitics': [
      'geopolítica', 'geopolitics', 'guerra', 'conflicto', 'tratado',
      'relaciones internacionales', 'onu', 'otan', 'sanción',
    ],

    // ── 💼 Negocios y marca ───────────────────────────────────────
    'Behind the Scenes': [
      'behind the scenes', 'bts', 'detrás de cámaras', 'proceso creativo',
      'cómo lo hago', 'making of',
    ],
    'Testimonials': [
      'testimonio', 'reseña', 'review', 'opinión de cliente',
      'caso de éxito', 'lo que opinan',
    ],
    'Launches & Promos': [
      'lanzamiento', 'promo', 'promoción', 'oferta', 'descuento', 'nuevo producto',
      'sale', 'disponible ahora', 'nuevo lanzamiento',
    ],
    'Entrepreneurship': [
      'emprendimiento', 'emprendedor', 'startup', 'negocio propio',
      'entrepreneur', 'freelance', 'mi negocio',
    ],
    'Digital Marketing': [
      'marketing', 'digital marketing', 'redes sociales', 'branding',
      'estrategia', 'contenido', 'seo', 'ads', 'publicidad',
    ],
    'Personal Finance': [
      'finanzas personales', 'presupuesto', 'ahorro personal', 'deuda',
      'inversión personal', 'fondo de emergencia', 'dinero inteligente',
    ],

    // ── 🎨 Creatividad ────────────────────────────────────────────
    'Art & Illustration': [
      'arte', 'art', 'ilustración', 'illustration', 'dibujo', 'drawing',
      'pintura', 'painting', 'diseño gráfico', 'artista',
    ],
    'Music & Covers': [
      'música', 'music', 'canción', 'song', 'cover', 'canto', 'guitarra',
      'piano', 'letra', 'acústico', 'acapella',
    ],
    'Dance': [
      'baile', 'dance', 'coreografía', 'choreography', 'bailar', 'dancing',
      'tiktok dance', 'salsa', 'reggaeton dance',
    ],
    'Photography': [
      'fotografía', 'photography', 'foto', 'photo', 'cámara', 'lente',
      'encuadre', 'edición de fotos', 'lightroom', 'preset',
    ],
    'Film & Editing': [
      'cine', 'film', 'película', 'edición de video', 'premiere', 'after effects',
      'cinematic', 'cortometraje', 'reseña película',
    ],
    'DIY & Crafts': [
      'diy', 'manualidades', 'hazlo tú mismo', 'craft', 'handmade', 'hecho a mano',
      'proyecto diy', 'tutorial manualidades',
    ],

    // ── 🤝 Comunidad ──────────────────────────────────────────────
    'Activism & Causes': [
      'activismo', 'activism', 'causa', 'protesta', 'marcha', 'campaña',
      'conciencia', 'impacto social',
    ],
    'Opinion & Culture': [
      'opinión', 'cultura', 'reflexión', 'pensamiento', 'perspectiva',
      'punto de vista', 'debate cultural',
    ],
    'Q&A': [
      'q&a', 'preguntas y respuestas', 'pregúntame', 'ask me', 'respondiendo',
      'petición', 'duet', 'stitch',
    ],
    'Volunteering': [
      'voluntariado', 'volunteering', 'voluntario', 'ayuda', 'donar',
      'donación', 'ong', 'fundación',
    ],
    'Diversity & Inclusion': [
      'diversidad', 'inclusión', 'incluyente', 'accesibilidad', 'lgbtq',
      'discapacidad', 'representación', 'equidad',
    ],

    // ── 🧠 Salud mental y bienestar ───────────────────────────────
    'Anxiety & Stress': [
      'ansiedad', 'anxiety', 'estrés', 'stress', 'ataque de pánico',
      'nervios', 'agotamiento', 'burnout',
    ],
    'Self-Esteem': [
      'autoestima', 'self esteem', 'amor propio', 'self love', 'confianza',
      'seguridad en mí', 'autoimagen',
    ],
    'Therapy & Psychology': [
      'terapia', 'therapy', 'psicología', 'psicólogo', 'terapeuta',
      'salud mental', 'mental health', 'trauma',
    ],
    'Motivation': [
      'motivación', 'motivation', 'inspiración', 'inspire', 'mindset',
      'éxito', 'superación', 'disciplina', 'habitos',
    ],
    'Grief & Loss': [
      'duelo', 'pérdida', 'grief', 'loss', 'muerte', 'superar', 'sanar',
      'luto', 'perder a alguien',
    ],

    // ── 🎮 Gaming y tecnología ────────────────────────────────────
    'Video Games': [
      'videojuego', 'gaming', 'gamer', 'gameplay', 'fortnite', 'minecraft',
      'ps5', 'xbox', 'nintendo', 'stream', 'twitch',
    ],
    'Gadget Reviews': [
      'gadget', 'review', 'reseña', 'unboxing', 'smartphone', 'auriculares',
      'laptop', 'tablet', 'iphone', 'samsung',
    ],
    'Artificial Intelligence': [
      'inteligencia artificial', 'ia', 'ai', 'chatgpt', 'gpt', 'machine learning',
      'llm', 'prompt', 'automatización', 'robot',
    ],
    'Apps & Software': [
      'app', 'aplicación', 'software', 'herramienta', 'productividad',
      'notion', 'figma', 'excel', 'google', 'extensión',
    ],
    'Cybersecurity': [
      'ciberseguridad', 'cybersecurity', 'hacker', 'hack', 'contraseña',
      'phishing', 'vpn', 'privacidad', 'datos personales',
    ],

    // ── ⚽ Deportes ───────────────────────────────────────────────
    'Soccer': [
      'fútbol', 'soccer', 'football', 'gol', 'goal', 'partido', 'match',
      'liga', 'champions', 'messi', 'ronaldo', 'neymar', 'mundial',
    ],
    'Basketball': [
      'básquet', 'basketball', 'nba', 'canasta', 'dunk', 'curry',
      'lebron', 'baloncesto',
    ],
    'Martial Arts': [
      'artes marciales', 'ufc', 'mma', 'karate', 'judo', 'taekwondo',
      'boxeo', 'pelea', 'combate', 'kick boxing',
    ],
    'Extreme Sports': [
      'deporte extremo', 'extreme', 'parkour', 'skate', 'surf', 'bmx',
      'motocross', 'adrenalina', 'stunt', 'freestyle',
    ],
    'Highlights & Plays': [
      'highlight', 'jugada', 'gol del día', 'top jugadas', 'mejores momentos deportivos',
      'resumen', 'clip deportivo',
    ],

    // ── 🔥 Tendencias ─────────────────────────────────────────────
    'Viral Audio': [
      'audio viral', 'sonido viral', 'trending sound', 'audio original',
      'con este audio', 'using this sound',
    ],
    'Memes & Formats': [
      'meme', 'formato', 'template', 'trend', 'viral format',
      'this is me', 'when you', 'pov meme',
    ],
    'Trending Challenges': [
      'reto viral', 'viral challenge', 'trending challenge', 'todo el mundo hace',
      'hazlo también',
    ],
    'POV': [ // same key
      'pov', 'point of view', 'imagina que', 'imagine', 'es cuando',
      'en el papel de',
    ],
    'Viral News': [
      'noticia viral', 'viral news', 'lo que pasó', 'te cuento',
      'esto pasó', 'increíble pero real',
    ],
  };
}
