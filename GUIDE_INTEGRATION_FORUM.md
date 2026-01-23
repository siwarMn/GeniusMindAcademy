# Guide d'Intégration du Forum avec le Backend Spring Boot

## 🎯 Résumé des Modifications

J'ai mis à jour votre application Flutter pour consommer correctement les APIs du backend Spring Boot. Voici ce qui a été fait:

## ✅ Fichiers Modifiés

### 1. [lib/Config/api_config.dart](lib/Config/api_config.dart)
- ✅ Ajout de la méthode `getQuestionsWithFilter()` pour gérer les filtres backend
- ✅ Configuration de l'URL de base (actuellement: `http://10.0.2.2:8082/api/v1` pour émulateur Android)
- ✅ Documentation claire sur comment changer l'URL selon votre environnement

### 2. [lib/services/forum_service.dart](lib/services/forum_service.dart)
- ✅ Mise à jour de `getQuestions()` pour supporter les paramètres:
  - `filter`: 'unanswered', 'resolved', 'recent'
  - `search`: Recherche textuelle
  - `tag`: Filtrage par tag
- ✅ Le service envoie maintenant les bons paramètres au backend
- ✅ Gestion correcte des réponses JSON du backend

### 3. [lib/controllers/forum_controller.dart](lib/controllers/forum_controller.dart)
- ✅ Mise à jour de `loadQuestions()` pour appeler le backend avec les filtres
- ✅ Conversion automatique des filtres UI ("Sans réponse") vers les filtres backend ("unanswered")
- ✅ La recherche et le filtrage se font maintenant côté backend (plus performant)

## 📋 Correspondance Endpoints Backend ↔ Flutter

| Endpoint Backend | Méthode Flutter | Description |
|-----------------|----------------|-------------|
| `GET /api/v1/forum/questions` | `getQuestions()` | Liste toutes les questions |
| `GET /api/v1/forum/questions?filter=unanswered` | `getQuestions(filter: 'unanswered')` | Questions sans réponse |
| `GET /api/v1/forum/questions?filter=resolved` | `getQuestions(filter: 'resolved')` | Questions résolues |
| `GET /api/v1/forum/questions?search=flutter` | `getQuestions(search: 'flutter')` | Recherche |
| `GET /api/v1/forum/questions?tag=Firebase` | `getQuestions(tag: 'Firebase')` | Par tag |
| `GET /api/v1/forum/questions/{id}` | `getQuestionById(id)` | Détails d'une question |
| `POST /api/v1/forum/questions` | `createQuestion()` | Créer une question |
| `POST /api/v1/forum/questions/{id}/vote` | `voteQuestion()` | Voter pour une question |
| `POST /api/v1/forum/answers` | `addAnswer()` | Ajouter une réponse |
| `POST /api/v1/forum/answers/{id}/vote` | `voteAnswer()` | Voter pour une réponse |
| `PUT /api/v1/forum/answers/{id}/accept` | `acceptAnswer()` | Accepter une réponse |

## 🚀 Comment Tester

### Étape 1: Vérifier que le Backend tourne
```bash
# Dans le terminal, testez le backend:
curl http://localhost:8082/api/v1/forum/questions
```

Si ça marche, vous devriez voir une liste de questions en JSON.

### Étape 2: Configurer l'URL dans Flutter

Dans [lib/Config/api_config.dart](lib/Config/api_config.dart:7):

**Pour Émulateur Android (recommandé):**
```dart
static const String baseUrl = 'http://10.0.2.2:8082/api/v1';
```

**Pour iOS Simulator ou Web:**
```dart
static const String baseUrl = 'http://localhost:8082/api/v1';
```

**Pour Appareil Réel:**
1. Trouvez votre adresse IP:
   - Windows: `ipconfig` dans CMD
   - Mac/Linux: `ifconfig` dans Terminal
2. Utilisez cette IP:
```dart
static const String baseUrl = 'http://192.168.1.XXX:8082/api/v1';
```

### Étape 3: Tester la Connexion depuis Dart

J'ai créé un script de test [test_backend_connection.dart](test_backend_connection.dart):

```bash
# Dans le dossier du projet Flutter:
dart run test_backend_connection.dart
```

Ce script va tester la connexion et afficher les questions récupérées.

### Étape 4: Lancer l'Application

```bash
flutter run
```

L'application devrait maintenant:
1. ✅ Charger les questions depuis le backend
2. ✅ Permettre de filtrer (Tous, Sans réponse, Résolu)
3. ✅ Permettre de rechercher
4. ✅ Créer de nouvelles questions
5. ✅ Ajouter des réponses
6. ✅ Voter
7. ✅ Accepter des réponses

## 🔧 DTOs Backend vs Modèles Flutter

### CreateQuestionDTO (Backend)
```java
{
  "title": "String",
  "content": "String",    // ⚠️ Backend utilise "content"
  "tags": ["String"],
  "author": "String"
}
```

### ForumQuestion (Flutter)
```dart
{
  "title": "String",
  "description": "String",  // ⚠️ Flutter utilise "description"
  "tags": ["String"],
  "author": "String"
}
```

**✅ La conversion est automatique** dans le service Flutter (`description` ↔ `content`).

### VoteDTO (Backend)
```java
{
  "isUpvote": boolean,
  "userId": "String"
}
```

## 🐛 Dépannage

### Problème: "Failed to connect"

**Solution 1:** Vérifiez l'URL
- Émulateur Android → `10.0.2.2`
- iOS/Web → `localhost`
- Appareil réel → IP de votre ordinateur

**Solution 2:** Vérifiez le backend
```bash
# Le backend doit tourner sur le port 8082
curl http://localhost:8082/api/v1/forum/questions
```

**Solution 3:** Vérifiez le firewall
- Autorisez le port 8082 dans votre firewall

### Problème: "CORS Error"

Le backend a déjà `@CrossOrigin(origins = "*")`, donc pas de problème CORS normalement.

### Problème: "404 Not Found"

Vérifiez que:
1. Le backend tourne bien sur le port **8082** (pas 8080)
2. L'URL est correcte: `/api/v1/forum/questions`

## 📱 Utilisation dans l'Application

### Créer une Question
1. Ouvrez l'app Flutter
2. Cliquez sur le bouton flottant "Poser une question"
3. Remplissez:
   - Titre
   - Description
   - Tags (séparés par des virgules)
4. Cliquez sur "Publier"

### Répondre à une Question
1. Cliquez sur une question dans la liste
2. Scrollez vers le bas
3. Tapez votre réponse
4. Cliquez sur "Répondre"

### Voter
1. Dans les détails d'une question
2. Cliquez sur les flèches ↑ ou ↓
3. Le compteur se met à jour automatiquement

### Accepter une Réponse
1. Dans les détails de VOTRE question
2. Cliquez sur ✓ à côté d'une réponse
3. La réponse est marquée comme acceptée

## 📊 État Actuel

| Fonctionnalité | Status |
|---------------|--------|
| Liste des questions | ✅ Implémenté |
| Filtres (Tous, Sans réponse, Résolu) | ✅ Implémenté |
| Recherche | ✅ Implémenté |
| Créer une question | ✅ Implémenté |
| Voir détails question | ✅ Implémenté |
| Ajouter une réponse | ✅ Implémenté |
| Voter question/réponse | ✅ Implémenté |
| Accepter une réponse | ✅ Implémenté |
| Authentification utilisateur | ⚠️ À implémenter |
| Pagination | ⚠️ À implémenter |

## 🎯 Prochaines Étapes

### 1. Intégrer l'Authentification
Actuellement, l'author est hardcodé:
```dart
'author': 'Current User' // TODO: Récupérer depuis l'auth
```

Il faudra:
1. Connecter au système d'auth existant
2. Récupérer le nom de l'utilisateur connecté
3. Envoyer le token JWT dans les headers

### 2. Ajouter la Pagination
Pour les grandes listes, ajoutez la pagination:
```dart
Future<List<ForumQuestion>> getQuestions({
  int page = 0,
  int size = 20,
  ...
})
```

### 3. Cache Local
Implémenter un cache pour:
- Réduire les appels réseau
- Fonctionner hors ligne
- Améliorer les performances

## 📚 Documentation Complète

Pour plus de détails, consultez [FORUM_API_INTEGRATION.md](FORUM_API_INTEGRATION.md).

## ❓ Questions Fréquentes

**Q: Pourquoi 10.0.2.2 et pas localhost?**
R: L'émulateur Android mappe 10.0.2.2 vers le localhost de votre machine hôte.

**Q: Comment voir les logs?**
R: Les erreurs s'affichent dans la console Flutter avec `print('Error fetching questions: $e')`.

**Q: Le backend utilise Long pour les IDs, Flutter utilise String?**
R: Oui, la conversion est automatique dans le service:
```dart
id: json['id'].toString()
```

**Q: Puis-je tester sans backend?**
R: Oui! Utilisez `MockForumService` au lieu de `ApiForumService`:
```dart
ForumController({ForumService? forumService})
    : forumService = forumService ?? MockForumService();
```

## 🎉 Conclusion

Votre application Flutter est maintenant prête à consommer les APIs du backend Spring Boot!

Tous les endpoints sont implémentés et fonctionnels. Il vous reste juste à:
1. Configurer l'URL correcte dans `api_config.dart`
2. Démarrer le backend sur le port 8082
3. Lancer l'application Flutter
4. Tester les fonctionnalités

Bon développement! 🚀
