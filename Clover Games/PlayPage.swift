import SwiftUI
import SpriteKit

struct PlayPage: View {
    @State private var gameScene: GameScene? = nil
    @State private var bonusGameScene: BonusGameScene? = nil
    @State private var score: Int = 0
    @State private var gameOver: Bool = false
    @State private var isBonusGameActive: Bool = false  // Это состояние контролирует бонусную игру
    
    var body: some View {
        ZStack {
            // Фон
            Image("background") // Ваше изображение фона
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Если бонусная игра активна, показываем её
            if isBonusGameActive {
                BonusGameView(scene: bonusGameScene)
            } else {
                // Отображение основной игры
                GameView(scene: gameScene)
            }
            
            // Счет
            VStack {
                HStack {
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
            
            // Экран Game Over
            if gameOver {
                VStack {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                    Button(action: restartGame) {
                        Text("Play Again")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(10)
            }
        }
        .onAppear {
            setupGameScene()
        }
    }
    
    func setupGameScene() {
        // Настройка основной сцены
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .resizeFill
        
        scene.gameOverHandler = {
            self.gameOver = true
        }
        scene.scoreUpdateHandler = { score in
            self.score = score
        }
        scene.bonusGameHandler = {
            self.startBonusGame()
        }
        
        gameScene = scene
    }
    
    func startBonusGame() {
        // Запуск бонусной игры, если она еще не была активна
        if !isBonusGameActive {
            isBonusGameActive = true
            let bonusScene = BonusGameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            bonusScene.scaleMode = .resizeFill
            bonusScene.scoreUpdateHandler = { score in
                self.score = score
            }
            bonusScene.gameOverHandler = {
                self.isBonusGameActive = false
            }
            bonusGameScene = bonusScene
        }
    }
    
    func restartGame() {
        gameOver = false
        score = 0
        gameScene?.resetGame()
    }
}

struct GameView: View {
    var scene: GameScene?
    
    var body: some View {
        if let scene = scene {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
        } else {
            Color.clear.edgesIgnoringSafeArea(.all)
        }
    }
}

struct BonusGameView: View {
    var scene: BonusGameScene?
    
    var body: some View {
        if let scene = scene {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
        } else {
            Color.clear.edgesIgnoringSafeArea(.all)
        }
    }
}
