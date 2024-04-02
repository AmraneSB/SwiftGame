import Foundation

// Structure représentant une question
struct Question: Codable {
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let difficulty: Difficulty
    let category: String
}

// Enumération pour le niveau de difficulté
enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
}

// Structure représentant le classement des scores des utilisateurs
struct UserScore: Codable {
    let playerName: String
    let score: Int
    let difficulty: Difficulty
}

// Fonction pour charger les questions
func loadQuestions(from file: String) -> [Question]? {
    if let url = Bundle.main.url(forResource: file, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let questions = try decoder.decode([Question].self, from: data)
            return questions
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    } else {
        print("File not found")
        return nil
    }
}



// Fonctions d'interface utilisateur et de manipulation des données à implémenter


// Fonction Nom du Joueur
func getPlayerName() -> String {
    print("Entrez votre nom:")
    if let playerName = readLine() {
        return playerName
    } else {
        return "Joueur"
    }
}

// Fonction Sélection de la difficulté
func selectDifficulty() -> Difficulty {
    print("Sélectionnez le niveau de difficulté:")
    print("1. Facile")
    print("2. Moyen")
    print("3. Difficile")
    
    var difficulty: Difficulty?
    var isValidInput = false
    
    repeat {
        if let input = readLine(), let choice = Int(input), (1...3).contains(choice) {
            switch choice {
                case 1: difficulty = .easy
                case 2: difficulty = .medium
                case 3: difficulty = .hard
                default: break
            }
            isValidInput = true
        } else {
            print("Choix invalide. Veuillez entrer le numéro correspondant au niveau de difficulté.")
        }
    } while !isValidInput
    
    return difficulty ?? .medium
}


// Fonction Chargement des Questions en rapport avec la difficulté
func loadQuestions(for difficulty: Difficulty) -> [Question]? {
    guard let allQuestions = loadQuestions(from: "questions") else {
        return nil
    }
    
    let filteredQuestions = allQuestions.filter { $0.difficulty == difficulty }
    
    return filteredQuestions.isEmpty ? nil : filteredQuestions
}


// Fonction Mélange des Questions 
func shuffleQuestions(_ questions: [Question]) -> [Question] {
    return questions.shuffled()
}


// Fonction Récuperation de la réponse du Joueur
func getUserAnswer(for question: Question) -> Int? {
    print(question.question)
    for (index, option) in question.options.enumerated() {
        print("\(index + 1). \(option)")
    }
    
    var userAnswer: Int?
    var isValidInput = false
    
    repeat {
        if let input = readLine(), let choice = Int(input), (1...question.options.count).contains(choice) {
            userAnswer = choice - 1
            isValidInput = true
        } else {
            print("Réponse invalide. Veuillez entrer le numéro correspondant à votre choix.")
        }
    } while !isValidInput
    
    return userAnswer
}

// Fonction Sauvegarde du Score du Joueur
func saveUserScore(playerName: String, score: Int, difficulty: Difficulty) {
    let userScore = UserScore(playerName: playerName, score: score, difficulty: difficulty)
    
    // Charger les scores existants à partir du fichier
    var scores = loadUserScores() ?? []
    
    // Ajouter le nouveau score à la liste
    scores.append(userScore)
    
    // Convertir les scores en données JSON
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
        let data = try encoder.encode(scores)
        
        // Enregistrer les données JSON dans un fichier
        let fileURL = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("scores.json")
        try data.write(to: fileURL)
        
        print("Score de \(playerName) enregistré: \(score) (Difficulté: \(difficulty.rawValue))")
    } catch {
        print("Erreur lors de l'enregistrement du score : \(error)")
    }
}


// Fonction Chargement du Score du Joueur
func loadUserScores() -> [UserScore]? {
    // Charger les données JSON à partir du fichier
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("scores.json")
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let scores = try decoder.decode([UserScore].self, from: data)
        return scores
    } catch {
        print("Erreur lors du chargement des scores : \(error)")
        return nil
    }
}

// Fonction Affichage de la Question
func displayQuestion(_ question: Question) {
    print(question.question)
    for (index, option) in question.options.enumerated() {
        print("\(index + 1). \(option)")
    }
}


// Fonction Retour de la réponse
func displayFeedback(_ isCorrect: Bool) {
    if isCorrect {
        print("Correct!")
    } else {
        print("Incorrect.")
    }
}

// Fonction Score Final
func displayFinalScore(_ score: Int) {
    print("Votre score final est de \(score) points.")
}


// Fonction Lancement du Jeu
func startGame() {
    // Interface utilisateur pour saisir le nom et sélectionner le niveau de difficulté
    let playerName = getPlayerName()
    let difficulty = selectDifficulty()
    
    // Charger les questions en fonction du niveau de difficulté
    guard let questions = loadQuestions(for: difficulty) else {
        print("Failed to load questions.")
        return
    }
    
    // Mélanger les questions
    let shuffledQuestions = shuffleQuestions(questions)
    
    var score = 0
    
    // Boucle à travers les questions
    for question in shuffledQuestions {
        // Afficher la question à l'utilisateur et obtenir sa réponse
        let userAnswer = getUserAnswer(for: question)
        
        // Vérifier si la réponse est correcte et attribuer des points
        if userAnswer == question.correctAnswerIndex {
            score += 1
            print("Correct!")
        } else {
            print("Incorrect.")
        }
        
        // Afficher le score actuel de l'utilisateur
        print("Score: \(score)")
    }
    
    // Afficher le score final de l'utilisateur
    print("Final score: \(score)")
    
    // Enregistrer le score de l'utilisateur
    saveUserScore(playerName: playerName, score: score, difficulty: difficulty)
}


startGame()