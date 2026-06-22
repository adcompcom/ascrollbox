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

  @override
  String get privateTitle => 'Privado';

  @override
  String get privateSetupTitle => 'Crear clave privada';

  @override
  String get privateSetupSubtitle =>
      'Elige una clave de 6 dígitos para proteger tus videos privados';

  @override
  String get privateConfirmTitle => 'Confirmar clave';

  @override
  String get privateConfirmSubtitle => 'Repite los 6 dígitos';

  @override
  String get privateEnterSubtitle => 'Ingresa tu clave de 6 dígitos';

  @override
  String get privatePinMismatch => 'Las claves no coinciden';

  @override
  String get privatePinWrong => 'Clave incorrecta';

  @override
  String get privateEmpty => 'No tienes videos privados';

  @override
  String get privateEmptySubtitle =>
      'Mueve videos aquí o márcalos como\nprivados al guardar';

  @override
  String get markAsPrivate => 'Privado';

  @override
  String get moveToPrivate => 'Mover a Privado';

  @override
  String get moveToHome => 'Mover a Inicio';

  @override
  String get movedToPrivate => 'Movido a Privado';

  @override
  String get movedToHome => 'Movido a Inicio';

  @override
  String get privateForgotPin => '¿Olvidaste tu clave?';

  @override
  String get sqTitle => 'Preguntas de seguridad';

  @override
  String get sqSetupSubtitle =>
      'Responde 3 preguntas para poder recuperar tu clave si la olvidas.';

  @override
  String get sqVerifySubtitle =>
      'Responde tus preguntas de seguridad para restablecer tu clave.';

  @override
  String get sqSelectHint => 'Selecciona una pregunta…';

  @override
  String get sqAnswerHint => 'Tu respuesta…';

  @override
  String get sqSave => 'Guardar preguntas';

  @override
  String get sqVerify => 'Verificar';

  @override
  String get sqWrong =>
      'Una o más respuestas son incorrectas. Intenta de nuevo.';

  @override
  String get sqSelectAll => 'Por favor selecciona y responde las 3 preguntas.';

  @override
  String get sqDuplicate => 'Por favor elige 3 preguntas diferentes.';

  @override
  String get sqPet => '¿Cómo se llamaba tu primera mascota?';

  @override
  String get sqMother => '¿Cuál es el apellido de soltera de tu madre?';

  @override
  String get sqSchool => '¿Cómo se llamaba tu primera escuela?';

  @override
  String get sqFriend =>
      '¿Cuál es el nombre de tu mejor amigo/a de la infancia?';

  @override
  String get sqCity => '¿En qué ciudad naciste?';

  @override
  String get sqSibling => '¿Cuál es el nombre de tu hermano/a mayor?';

  @override
  String get sqCar => '¿Cuál era la marca de tu primer auto?';

  @override
  String get sqStreet => '¿En qué calle creciste?';

  @override
  String get myPacks => 'Mis Packs';

  @override
  String get sharedPacks => 'Compartidos';

  @override
  String get packDescription => 'Descripción';

  @override
  String get packDescriptionHint => 'Describe tu pack…';

  @override
  String get packShare => 'Compartir pack';

  @override
  String get packPublish => 'Publicar';

  @override
  String get packUnpublish => 'Dejar de compartir';

  @override
  String get packPublicLabel => 'Público';

  @override
  String get packPublicSubtitle =>
      'Visible para todos los usuarios de la comunidad';

  @override
  String get packCodeOnlyLabel => 'Solo por código';

  @override
  String get packCodeOnlySubtitle => 'Solo accesible con el código de acceso';

  @override
  String get packShareCode => 'Código de acceso';

  @override
  String get packShareCodeCopied => '¡Código copiado!';

  @override
  String packViews(int count) {
    return '$count visualizaciones';
  }

  @override
  String packShares(int count) {
    return '$count guardados';
  }

  @override
  String packRatingCount(int count) {
    return '$count calificaciones';
  }

  @override
  String get packAddToShared => 'Agregar a Compartidos';

  @override
  String get packAddedToShared => '¡Agregado a Compartidos!';

  @override
  String get packRemoveFromShared => 'Quitar de Compartidos';

  @override
  String get packRemovedFromShared => 'Eliminado de Compartidos';

  @override
  String get packRateTitle => 'Califica este pack';

  @override
  String get packRated => '¡Gracias por calificar!';

  @override
  String get packEnterCode => 'Ingresar código';

  @override
  String get packCodeHint => 'Código de 6 caracteres (ej. A3K9F2)';

  @override
  String get packNotFound =>
      'Pack no encontrado. Verifica el código e intenta de nuevo.';

  @override
  String get packSearch => 'Buscar';

  @override
  String get packExplore => 'Explorar comunidad';

  @override
  String get sharedEmpty => 'Aún no tienes packs guardados';

  @override
  String get sharedEmptySubtitle =>
      'Explora la comunidad o ingresa un código\npara encontrar packs compartidos.';

  @override
  String get communityEmpty => 'Aún no hay packs públicos';

  @override
  String get communityEmptySubtitle =>
      '¡Sé el primero en compartir un pack con la comunidad!';

  @override
  String get packPublished => '¡Pack publicado!';

  @override
  String get packUnpublished => 'Pack eliminado de la comunidad';

  @override
  String packBy(String name) {
    return 'Por $name';
  }

  @override
  String get packNoDescription => 'Sin descripción';

  @override
  String get packIsPublic => 'Este pack es público';

  @override
  String get packIsCodeOnly => 'Accesible por código';

  @override
  String get packShareSettings => 'Configurar compartido';

  @override
  String get packAlreadySaved => 'Ya está en tu sección Compartidos';
}
