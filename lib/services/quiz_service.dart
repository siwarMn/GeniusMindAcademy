import 'package:codajoy/models/quiz_model.dart';

abstract class QuizService {
  Future<List<Quiz>> getAllQuizzes();
  Future<Quiz> getQuizById(int id); // Nouvelle méthode
}

class MockQuizService implements QuizService {
  @override
  Future<List<Quiz>> getAllQuizzes() async {
    await Future.delayed(Duration(seconds: 1)); // Simulation du délai

    return [
      Quiz(
        id: 1,
        title: 'Quiz de Mathématiques Avancées',
        description: 'Testez vos connaissances en algèbre et géométrie avancée',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'Quelle est la valeur de 2x + 5 = 15 ?',
            options: ['x = 5', 'x = 10', 'x = 7.5', 'x = 8'],
            correctAnswer: 'x = 5',
            explanation: '2x + 5 = 15 => 2x = 10 => x = 5',
          ),
          QuizQuestion(
            id: 2,
            question: 'Quelle est l\'aire d\'un cercle de rayon 3 cm ?',
            options: ['9π cm²', '6π cm²', '3π cm²', '12π cm²'],
            correctAnswer: '9π cm²',
            explanation: 'Aire = π × r² = π × 3² = 9π',
          ),
          QuizQuestion(
            id: 3,
            question: 'Quel est le résultat de √144 ?',
            options: ['11', '12', '14', '16'],
            correctAnswer: '12',
            explanation: '12 × 12 = 144, donc √144 = 12',
          ),
          QuizQuestion(
            id: 4,
            question: 'Quelle est la dérivée de x² ?',
            options: ['x', '2x', '2', 'x²'],
            correctAnswer: '2x',
            explanation: 'La dérivée de x^n est n × x^(n-1)',
          ),
        ],
        isActive: true,
        levelId: 3,
      ),
      Quiz(
        id: 2,
        title: 'Quiz de Français - Grammaire',
        description: 'Perfectionnez votre grammaire française',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'Quel est le pluriel de "cheval" ?',
            options: ['Chevals', 'Chevaux', 'Chevales', 'Chevauxs'],
            correctAnswer: 'Chevaux',
            explanation: 'Les mots terminant en -al font -aux au pluriel',
          ),
          QuizQuestion(
            id: 2,
            question: 'Quel est le féminin de "acteur" ?',
            options: ['Acteuse', 'Actrice', 'Acteure', 'Acteurse'],
            correctAnswer: 'Actrice',
            explanation: 'Acteur → Actrice (métiers en -eur → -rice)',
          ),
          QuizQuestion(
            id: 3,
            question: '"Ils se sont _____ la main."',
            options: ['Serrait', 'Serrais', 'Serré', 'Serrés'],
            correctAnswer: 'Serré',
            explanation:
                'Avec "se", le participe passé s\'accorde avec le complément d\'objet direct',
          ),
        ],
        isActive: true,
        levelId: 2,
      ),
      Quiz(
        id: 3,
        title: 'Quiz d\'Histoire Mondiale',
        description: 'Les grandes dates et événements historiques',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'En quelle année a eu lieu la Révolution française ?',
            options: ['1776', '1789', '1799', '1815'],
            correctAnswer: '1789',
            explanation: 'La prise de la Bastille a eu lieu le 14 juillet 1789',
          ),
          QuizQuestion(
            id: 2,
            question: 'Qui a découvert l\'Amérique en 1492 ?',
            options: [
              'Marco Polo',
              'Christophe Colomb',
              'Vasco de Gama',
              'Magellan'
            ],
            correctAnswer: 'Christophe Colomb',
          ),
          QuizQuestion(
            id: 3,
            question: 'Quand a eu lieu la Seconde Guerre mondiale ?',
            options: ['1914-1918', '1939-1945', '1941-1945', '1935-1945'],
            correctAnswer: '1939-1945',
            explanation: 'Début : 1er septembre 1939, Fin : 2 septembre 1945',
          ),
          QuizQuestion(
            id: 4,
            question: 'Qui était le premier président des États-Unis ?',
            options: [
              'Thomas Jefferson',
              'Abraham Lincoln',
              'George Washington',
              'John Adams'
            ],
            correctAnswer: 'George Washington',
          ),
        ],
        isActive: false,
        levelId: 3,
      ),
      Quiz(
        id: 4,
        title: 'Quiz de Sciences - Chimie',
        description: 'Connaissances fondamentales en chimie',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'Quel est le symbole chimique de l\'eau ?',
            options: ['H2O', 'O2', 'CO2', 'NaCl'],
            correctAnswer: 'H2O',
            explanation: 'Deux atomes d\'hydrogène et un atome d\'oxygène',
          ),
          QuizQuestion(
            id: 2,
            question: 'Quel gaz représente 78% de l\'atmosphère terrestre ?',
            options: ['Oxygène', 'Dioxyde de carbone', 'Azote', 'Hélium'],
            correctAnswer: 'Azote',
            explanation:
                'L\'azote (N2) est le gaz le plus abondant dans l\'atmosphère',
          ),
          QuizQuestion(
            id: 3,
            question: 'Quel est le pH de l\'eau pure ?',
            options: ['0', '7', '14', '5'],
            correctAnswer: '7',
            explanation: 'Le pH neutre est de 7 à 25°C',
          ),
        ],
        isActive: true,
        levelId: 2,
      ),
      Quiz(
        id: 5,
        title: 'Quiz de Géographie',
        description: 'Capitales, drapeaux et pays du monde',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'Quelle est la capitale du Japon ?',
            options: ['Séoul', 'Pékin', 'Tokyo', 'Bangkok'],
            correctAnswer: 'Tokyo',
          ),
          QuizQuestion(
            id: 2,
            question: 'Quel est le plus grand océan du monde ?',
            options: ['Atlantique', 'Indien', 'Pacifique', 'Arctique'],
            correctAnswer: 'Pacifique',
            explanation: 'Il couvre environ 1/3 de la surface de la Terre',
          ),
          QuizQuestion(
            id: 3,
            question: 'Quel pays a la forme d\'une botte ?',
            options: ['Grèce', 'Italie', 'Espagne', 'France'],
            correctAnswer: 'Italie',
          ),
        ],
        isActive: true,
        levelId: 1,
      ),
      Quiz(
        id: 6,
        title: 'Quiz d\'Informatique',
        description: 'Bases de la programmation et technologies',
        questions: [
          QuizQuestion(
            id: 1,
            question: 'Que signifie HTML ?',
            options: [
              'Hyper Text Markup Language',
              'High Tech Modern Language',
              'Hyper Transfer Markup Language',
              'Home Tool Markup Language'
            ],
            correctAnswer: 'Hyper Text Markup Language',
          ),
          QuizQuestion(
            id: 2,
            question: 'Quel langage est utilisé pour le style des pages web ?',
            options: ['HTML', 'JavaScript', 'CSS', 'Python'],
            correctAnswer: 'CSS',
            explanation: 'CSS = Cascading Style Sheets',
          ),
          QuizQuestion(
            id: 3,
            question: 'Quelle est la mascotte de Linux ?',
            options: ['Un panda', 'Un pingouin', 'Un renard', 'Un dauphin'],
            correctAnswer: 'Un pingouin',
            explanation: 'Tux le pingouin est la mascotte officielle',
          ),
        ],
        isActive: true,
        levelId: 2,
      ),
    ];
  }

  @override
  Future<Quiz> getQuizById(int id) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulation court délai

    // Récupère tous les quiz et trouve celui avec l'ID correspondant
    final quizzes = await getAllQuizzes();

    // Cherche le quiz par ID
    final quiz = quizzes.firstWhere(
      (quiz) => quiz.id == id,
      orElse: () => throw Exception('Quiz non trouvé avec l\'ID: $id'),
    );

    return quiz;
  }
}
