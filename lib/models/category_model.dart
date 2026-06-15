class CategoryNode {
  final String name;
  final String? emoji;
  final List<CategoryNode> children;

  const CategoryNode({
    required this.name,
    this.emoji,
    this.children = const [],
  });

  String get displayName => emoji != null ? '$emoji $name' : name;
  bool get isLeaf => children.isEmpty;
}

const List<CategoryNode> kCategoryTree = [
  CategoryNode(
    name: 'Entretenimiento',
    emoji: '🎭',
    children: [
      CategoryNode(name: 'Humor'),
      CategoryNode(name: 'Skits'),
      CategoryNode(name: 'Retos / Challenges'),
    ],
  ),
  CategoryNode(
    name: 'Educación',
    emoji: '📚',
    children: [
      CategoryNode(name: 'Tips rápidos'),
      CategoryNode(
        name: 'Tutoriales',
        children: [
          CategoryNode(name: 'Tecnología'),
          CategoryNode(name: 'Finanzas'),
          CategoryNode(name: 'Idiomas'),
        ],
      ),
      CategoryNode(name: 'Datos curiosos'),
    ],
  ),
  CategoryNode(
    name: 'Lifestyle',
    emoji: '🌿',
    children: [
      CategoryNode(name: 'Fitness y salud'),
      CategoryNode(
        name: 'Comida',
        children: [
          CategoryNode(name: 'Recetas'),
          CategoryNode(name: 'Restaurantes'),
          CategoryNode(name: 'Dietas'),
        ],
      ),
      CategoryNode(name: 'Viajes'),
    ],
  ),
  CategoryNode(
    name: 'Música',
    emoji: '🎵',
    children: [
      CategoryNode(name: 'Covers'),
      CategoryNode(name: 'Baile'),
      CategoryNode(name: 'Beats'),
    ],
  ),
  CategoryNode(
    name: 'Deportes',
    emoji: '⚽',
    children: [
      CategoryNode(name: 'Fútbol'),
      CategoryNode(name: 'Gym'),
      CategoryNode(name: 'Extreme'),
    ],
  ),
  CategoryNode(name: 'Sin categoría', emoji: '📌'),
];
