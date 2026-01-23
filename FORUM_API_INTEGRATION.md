# Intégration des APIs Forum avec le Backend Spring Boot

## Configuration

### Backend Configuration
Le backend Spring Boot tourne sur le port **8082** avec la base de données MySQL sur le port **3307**.

### Flutter Configuration
Dans [lib/Config/api_config.dart](lib/Config/api_config.dart), configurez l'URL selon votre environnement:

```dart
// Pour l'émulateur Android
static const String baseUrl = 'http://10.0.2.2:8082/api/v1';

// Pour iOS Simulator ou Web
static const String baseUrl = 'http://localhost:8082/api/v1';

// Pour un appareil réel
static const String baseUrl = 'http://192.168.1.XXX:8082/api/v1';
```

## Endpoints Implémentés

### Questions

#### 1. GET /api/v1/forum/questions
Récupère toutes les questions avec filtres optionnels.

**Paramètres de requête:**
- `filter` (optionnel): `unanswered`, `resolved`, `recent`
- `search` (optionnel): Recherche dans le titre et contenu
- `tag` (optionnel): Filtre par tag

**Utilisation Flutter:**
```dart
// Toutes les questions
await forumService.getQuestions();

// Questions non répondues
await forumService.getQuestions(filter: 'unanswered');

// Recherche
await forumService.getQuestions(search: 'Flutter');

// Par tag
await forumService.getQuestions(tag: 'Firebase');
```

#### 2. GET /api/v1/forum/questions/{id}
Récupère une question spécifique par son ID.

**Utilisation Flutter:**
```dart
final question = await forumService.getQuestionById('123');
```

#### 3. POST /api/v1/forum/questions
Crée une nouvelle question.

**Body (CreateQuestionDTO):**
```json
{
  "title": "Titre de la question",
  "content": "Description détaillée",
  "tags": ["Flutter", "Firebase"],
  "author": "Nom de l'utilisateur"
}
```

**Utilisation Flutter:**
```dart
await forumService.createQuestion(
  'Titre',
  'Description',
  ['Flutter', 'Firebase']
);
```

#### 4. POST /api/v1/forum/questions/{id}/vote
Vote pour une question (upvote ou downvote).

**Body (VoteDTO):**
```json
{
  "isUpvote": true,
  "userId": "user123"
}
```

**Utilisation Flutter:**
```dart
// Upvote
await forumService.voteQuestion('123', true);

// Downvote
await forumService.voteQuestion('123', false);
```

### Réponses

#### 5. GET /api/v1/forum/questions/{questionId}/answers
Récupère toutes les réponses d'une question.

**Note:** Les réponses sont déjà incluses dans la question lors du GET /questions/{id}

#### 6. POST /api/v1/forum/answers
Crée une nouvelle réponse.

**Body (CreateAnswerDTO):**
```json
{
  "questionId": 123,
  "content": "Contenu de la réponse",
  "author": "Nom de l'utilisateur"
}
```

**Utilisation Flutter:**
```dart
await forumService.addAnswer('123', 'Contenu de la réponse');
```

#### 7. POST /api/v1/forum/answers/{id}/vote
Vote pour une réponse.

**Body (VoteDTO):**
```json
{
  "isUpvote": true,
  "userId": "user123"
}
```

**Utilisation Flutter:**
```dart
await forumService.voteAnswer('456', true);
```

#### 8. PUT /api/v1/forum/answers/{id}/accept
Accepte une réponse comme solution.

**Utilisation Flutter:**
```dart
await forumService.acceptAnswer('456');
```

## Modèles de Données

### ForumQuestion (Flutter)
```dart
class ForumQuestion {
  final String id;
  final String title;
  final String description;  // Mappé à 'content' dans le backend
  final String author;
  final List<String> tags;
  final int votes;
  final int views;
  final DateTime createdAt;
  final List<ForumAnswer> answers;
  final List<String> upvotedBy;
  final List<String> downvotedBy;
}
```

### ForumAnswer (Flutter)
```dart
class ForumAnswer {
  final String id;
  final String questionId;
  final String author;
  final String content;
  final int votes;
  final DateTime createdAt;
  final bool isAccepted;
  final List<String> upvotedBy;
  final List<String> downvotedBy;
}
```

## Tests de Connexion

### 1. Vérifier que le backend est en cours d'exécution
```bash
curl http://localhost:8082/api/v1/forum/questions
```

### 2. Tester depuis Flutter
Dans votre application, l'appel à `loadQuestions()` au démarrage du `ForumController` devrait charger les données automatiquement.

### 3. Déboguer les problèmes de connexion

**Problème:** Cannot connect to localhost:8082

**Solutions:**
1. **Android Emulator:** Utilisez `10.0.2.2` au lieu de `localhost`
2. **Appareil réel:** Utilisez l'adresse IP de votre ordinateur
3. **Vérifiez le firewall:** Autorisez le port 8082
4. **Backend CORS:** Le backend a `@CrossOrigin(origins = "*")`, donc pas de problème CORS

### 4. Logs de débogage
Le service affiche les erreurs dans la console:
```dart
print('Error fetching questions: $e');
```

Surveillez ces logs pour identifier les problèmes de connexion.

## Fonctionnalités Implémentées

✅ Liste des questions avec filtres
✅ Recherche de questions
✅ Filtrage par tag
✅ Création de question
✅ Détails d'une question
✅ Ajout de réponse
✅ Vote sur question
✅ Vote sur réponse
✅ Acceptation de réponse

## Points Importants

1. **ID de type Long:** Le backend utilise des IDs de type Long. Le service Flutter convertit automatiquement les IDs en String.

2. **Content vs Description:** Le backend utilise `content` tandis que Flutter utilise `description`. La conversion est automatique dans le service.

3. **Authentification:** Pour l'instant, l'author est hardcodé. Il faudra intégrer le système d'authentification pour récupérer l'utilisateur connecté.

4. **Gestion des erreurs:** Toutes les méthodes du service gèrent les erreurs et retournent des booléens ou null en cas d'échec.

## Prochaines Étapes

1. Intégrer le système d'authentification pour récupérer l'utilisateur connecté
2. Ajouter des tests unitaires pour le service
3. Implémenter le cache local pour les questions
4. Ajouter la pagination pour les grandes listes
5. Implémenter les notifications push pour les nouvelles réponses

## Exemples de Tests Manuels

### Créer une question
1. Ouvrez l'application Flutter
2. Cliquez sur le bouton "Poser une question"
3. Remplissez le formulaire
4. Soumettez
5. Vérifiez que la question apparaît dans la liste

### Répondre à une question
1. Cliquez sur une question
2. Scrollez vers le bas
3. Tapez votre réponse
4. Soumettez
5. Vérifiez que la réponse apparaît

### Voter
1. Ouvrez une question
2. Cliquez sur les flèches haut/bas
3. Vérifiez que le compteur se met à jour

## Dépannage

### Erreur 404
- Vérifiez que le backend est en cours d'exécution
- Vérifiez l'URL de base dans api_config.dart
- Vérifiez que les endpoints correspondent

### Erreur 400
- Vérifiez le format des données envoyées
- Assurez-vous que tous les champs requis sont présents

### Erreur de connexion
- Vérifiez que le backend tourne sur le port 8082
- Vérifiez la configuration réseau (localhost vs 10.0.2.2)
- Vérifiez le firewall
