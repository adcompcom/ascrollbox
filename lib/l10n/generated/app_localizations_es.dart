// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Ascrollbox';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get add => 'Agregar';

  @override
  String get rename => 'Renombrar';

  @override
  String get open => 'Abrir';

  @override
  String get edit => 'Editar';

  @override
  String get next => 'Siguiente';

  @override
  String get confirm => 'Confirmar';

  @override
  String get loginTagline => 'Guarda y organiza tus videos favoritos';

  @override
  String get loginWithGoogle => 'Continuar con Google';

  @override
  String get loginWithMicrosoft => 'Continuar con Microsoft';

  @override
  String get loginWithMeta => 'Continuar con Meta';

  @override
  String get loginTerms => 'Al continuar aceptas los Términos de servicio';

  @override
  String loginError(String error) {
    return 'Error al iniciar sesión: $error';
  }

  @override
  String get home => 'Inicio';

  @override
  String get searchHint => 'Buscar videos…';

  @override
  String get addVideo => 'Agregar';

  @override
  String get addVideoTitle => 'Agregar video';

  @override
  String get pasteUrlHint => 'Pega el URL aquí';

  @override
  String get noVideosSaved => 'No tienes videos guardados';

  @override
  String get sharePrompt =>
      'Comparte un video desde YouTube,\nTikTok, Instagram o Facebook';

  @override
  String get addByUrl => 'Agregar por URL';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get videoSaved => 'Video guardado';

  @override
  String get deleteVideo => 'Eliminar video';

  @override
  String deleteVideoConfirm(String title) {
    return '¿Eliminar \"$title\"?';
  }

  @override
  String get addToPack => 'Agregar a Pack';

  @override
  String addedToPack(String name) {
    return 'Agregado a \"$name\"';
  }

  @override
  String get createPackFirst => 'Crea un pack primero en la sección Packs';

  @override
  String get play => 'Reproducir';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get labelsTitle => 'Etiquetas';

  @override
  String get labelsSectionMostUsed => 'Tus etiquetas más usadas';

  @override
  String get labelsEmpty => 'Aún no tienes etiquetas';

  @override
  String get labelsEmptySubtitle =>
      'Guarda videos y asígnales etiquetas\npara que aparezcan aquí';

  @override
  String get labelsSuggested => 'Sugeridas para este video';

  @override
  String get labelsCustomPlaceholder => 'Etiqueta personalizada…';

  @override
  String get labelsMaxReached => 'Máximo 5 etiquetas';

  @override
  String labelsRemaining(int count) {
    return '$count restantes';
  }

  @override
  String get labelsDetecting => 'Detectando…';

  @override
  String get labelsSectionPopular => 'Populares';

  @override
  String get packsTitle => 'Packs';

  @override
  String get newPack => 'Nuevo Pack';

  @override
  String get packName => 'Nombre del pack';

  @override
  String get createPack => 'Crear';

  @override
  String get renamePack => 'Renombrar Pack';

  @override
  String get deletePack => 'Eliminar Pack';

  @override
  String deletePackConfirm(String name) {
    return '¿Eliminar el pack \"$name\"? Los videos no se borrarán.';
  }

  @override
  String get packsEmpty => 'No tienes packs todavía';

  @override
  String get packsEmptySubtitle => 'Crea colecciones de tus videos favoritos';

  @override
  String packVideosCount(int count) {
    return '$count video';
  }

  @override
  String packVideosCountPlural(int count) {
    return '$count videos';
  }

  @override
  String get packEmpty => 'Este pack está vacío';

  @override
  String get addVideos => 'Agregar videos';

  @override
  String get addVideosToPack => 'Agregar videos al pack';

  @override
  String get noAvailableVideos => 'No hay videos disponibles para agregar';

  @override
  String get videoAddedToPack => 'Video agregado al pack';

  @override
  String get removeFromPack => 'Quitar del pack';

  @override
  String openInApp(String appName) {
    return 'Abrir en $appName';
  }

  @override
  String get openAppFailed => 'No se pudo abrir la app';

  @override
  String savedOn(String date) {
    return 'Guardado el $date';
  }

  @override
  String get sectionEntertainment => 'Entretenimiento';

  @override
  String get sectionEducation => 'Educación';

  @override
  String get sectionLifestyle => 'Lifestyle';

  @override
  String get sectionFamily => 'Familia';

  @override
  String get sectionSpirituality => 'Espiritualidad y religión';

  @override
  String get sectionPolitics => 'Política y sociedad';

  @override
  String get sectionBusiness => 'Negocios y marca';

  @override
  String get sectionCreativity => 'Creatividad';

  @override
  String get sectionCommunity => 'Comunidad';

  @override
  String get sectionMentalHealth => 'Salud mental y bienestar';

  @override
  String get sectionGaming => 'Gaming y tecnología';

  @override
  String get sectionSports => 'Deportes';

  @override
  String get sectionTrending => 'Tendencias';

  @override
  String get tagHumorComedy => 'Humor y comedia';

  @override
  String get tagSkitsActing => 'Skits y actuación';

  @override
  String get tagChallenges => 'Retos / Challenges';

  @override
  String get tagReactions => 'Reacciones';

  @override
  String get tagPranks => 'Prank / broma';

  @override
  String get tagCompilations => 'Compilaciones';

  @override
  String get tagQuickTips => 'Tips rápidos';

  @override
  String get tagTutorials => 'Tutoriales';

  @override
  String get tagTechnology => 'Tecnología';

  @override
  String get tagFinance => 'Finanzas';

  @override
  String get tagLanguages => 'Idiomas';

  @override
  String get tagScience => 'Ciencia';

  @override
  String get tagHistory => 'Historia';

  @override
  String get tagFunFacts => 'Datos curiosos';

  @override
  String get tagMythologyCulture => 'Mitología y cultura general';

  @override
  String get tagBooksReading => 'Libros y lectura';

  @override
  String get tagFitnessHealth => 'Fitness y salud';

  @override
  String get tagFood => 'Comida';

  @override
  String get tagRecipes => 'Recetas';

  @override
  String get tagRestaurants => 'Restaurantes';

  @override
  String get tagDiets => 'Dietas';

  @override
  String get tagTravel => 'Viajes';

  @override
  String get tagFashionBeauty => 'Moda y belleza';

  @override
  String get tagHomeDecor => 'Hogar y decoración';

  @override
  String get tagMinimalism => 'Minimalismo';

  @override
  String get tagDailyRoutines => 'Rutinas / día a día';

  @override
  String get tagParenting => 'Crianza y paternidad';

  @override
  String get tagMotherhood => 'Maternidad';

  @override
  String get tagRelationships => 'Pareja y relaciones';

  @override
  String get tagPets => 'Mascotas';

  @override
  String get tagFamilyMoments => 'Momentos familiares';

  @override
  String get tagPregnancyBabies => 'Embarazo y bebés';

  @override
  String get tagChristianity => 'Cristianismo';

  @override
  String get tagCatholicism => 'Catolicismo';

  @override
  String get tagIslam => 'Islam';

  @override
  String get tagBuddhism => 'Budismo';

  @override
  String get tagJudaism => 'Judaísmo';

  @override
  String get tagSpirituality => 'Espiritualidad general';

  @override
  String get tagMeditationMindfulness => 'Meditación y mindfulness';

  @override
  String get tagFaithTestimony => 'Fe y testimonio';

  @override
  String get tagNewsCurrentEvents => 'Noticias y actualidad';

  @override
  String get tagPoliticalOpinion => 'Opinión política';

  @override
  String get tagHumanRights => 'Derechos humanos';

  @override
  String get tagEconomyPolicy => 'Economía y política pública';

  @override
  String get tagEnvironmentClimate => 'Medio ambiente y clima';

  @override
  String get tagFeminismGender => 'Feminismo y género';

  @override
  String get tagGeopolitics => 'Geopolítica';

  @override
  String get tagBehindTheScenes => 'Behind the scenes';

  @override
  String get tagTestimonials => 'Testimonios';

  @override
  String get tagLaunchesPromos => 'Lanzamientos / promos';

  @override
  String get tagEntrepreneurship => 'Emprendimiento';

  @override
  String get tagDigitalMarketing => 'Marketing digital';

  @override
  String get tagPersonalFinance => 'Finanzas personales';

  @override
  String get tagArtIllustration => 'Arte e ilustración';

  @override
  String get tagMusicCovers => 'Música y covers';

  @override
  String get tagDance => 'Baile';

  @override
  String get tagPhotography => 'Fotografía';

  @override
  String get tagFilmEditing => 'Cine y edición';

  @override
  String get tagDiyCrafts => 'DIY y manualidades';

  @override
  String get tagActivism => 'Activismo y causas';

  @override
  String get tagOpinionCulture => 'Opinión y cultura';

  @override
  String get tagQa => 'Q&A / peticiones';

  @override
  String get tagVolunteering => 'Voluntariado';

  @override
  String get tagDiversityInclusion => 'Diversidad e inclusión';

  @override
  String get tagAnxietyStress => 'Ansiedad y estrés';

  @override
  String get tagSelfEsteem => 'Autoestima';

  @override
  String get tagTherapyPsychology => 'Terapia y psicología';

  @override
  String get tagMotivation => 'Motivación';

  @override
  String get tagGriefLoss => 'Duelo y pérdida';

  @override
  String get tagVideoGames => 'Videojuegos';

  @override
  String get tagGadgetReviews => 'Reseñas de gadgets';

  @override
  String get tagArtificialIntelligence => 'Inteligencia artificial';

  @override
  String get tagAppsSoftware => 'Apps y software';

  @override
  String get tagCybersecurity => 'Ciberseguridad';

  @override
  String get tagSoccer => 'Fútbol';

  @override
  String get tagBasketball => 'Básquet';

  @override
  String get tagMartialArts => 'Artes marciales';

  @override
  String get tagExtremeSports => 'Deportes extremos';

  @override
  String get tagSportsHighlights => 'Highlights y jugadas';

  @override
  String get tagViralAudio => 'Audios virales';

  @override
  String get tagMemesFormats => 'Memes y formatos';

  @override
  String get tagTrendingChallenges => 'Retos del momento';

  @override
  String get tagPov => 'POV';

  @override
  String get tagViralNews => 'Noticias virales';

  @override
  String get filterAll => 'Todas';

  @override
  String get notes => 'Notas';

  @override
  String get notesHint => 'Agregar una nota…';

  @override
  String get sortBy => 'Ordenar';

  @override
  String get sortNewest => 'Más recientes';

  @override
  String get sortOldest => 'Más antiguos';

  @override
  String get sortByPlatform => 'Por plataforma';

  @override
  String get editVideo => 'Editar';

  @override
  String get saveChanges => 'Guardar cambios';
}
