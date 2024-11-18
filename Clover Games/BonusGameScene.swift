import SpriteKit

class BonusGameScene: SKScene {
    
    var score = 0
    var scoreUpdateHandler: ((Int) -> Void)?
    var gameOverHandler: (() -> Void)?
    
    // Категории объектов
    let goldenCloverCategory: UInt32 = 0x1 << 0
    let greenCloverCategory: UInt32 = 0x1 << 1
    
    // Таймер бонусной игры
    var bonusGameTimer: Timer?
    var timeRemaining: Int = 10
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        
        // Запуск бонусной игры
        startBonusGame()
    }
    
    // Запуск бонусной игры, если она еще не была активна
    func startBonusGame() {
        // Таймер на 10 секунд
        bonusGameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // Спавним клеверов
        spawnBonusItems()
    }
    
    // Обновление таймера
    @objc func updateTimer() {
        timeRemaining -= 1
        if timeRemaining <= 0 {
            // Завершаем бонусную игру, если время истекло
            endBonusGame()
        }
    }
    
    // Спавн бонусных клеверов (золотой и зеленый)
    func spawnBonusItems() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnRandomBonusItem()
        }
        
        let waitAction = SKAction.wait(forDuration: 1.0)  // Клеверы будут появляться каждую секунду
        let sequenceAction = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        run(repeatAction)
    }
    
    // Спавн случайного бонусного предмета (клевер)
    func spawnRandomBonusItem() {
        let randomX = CGFloat.random(in: 0...(size.width - 50))
        let randomY = CGFloat.random(in: 50...(size.height - 50))  // Теперь Y координата будет случайной внутри экрана
        
        let itemType = ["goldenClover", "greenClover"].randomElement()!
        
        let item = SKSpriteNode(imageNamed: itemType)
        item.size = CGSize(width: 50, height: 50)
        item.position = CGPoint(x: randomX, y: randomY)
        
        // Создаем физическое тело для клеверного объекта, чтобы он стал кликабельным
        item.physicsBody = SKPhysicsBody(circleOfRadius: item.size.width / 2)
        item.physicsBody?.categoryBitMask = getItemCategory(type: itemType)
        item.physicsBody?.contactTestBitMask = 0  // Без столкновений
        item.physicsBody?.collisionBitMask = 0
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.isDynamic = false  // Чтобы не падали
        item.physicsBody?.isResting = false  // Убираем состояние покоя
        
        // Добавляем объект в сцену
        addChild(item)
        
        // Добавляем действие для удаления через 2 секунды, если на клевера не нажали
        let delayAction = SKAction.wait(forDuration: 2.0)
        let removeAction = SKAction.removeFromParent()
        let removeSequence = SKAction.sequence([delayAction, removeAction])
        item.run(removeSequence)
    }
    
    // Получение категории для бонусного предмета
    func getItemCategory(type: String) -> UInt32 {
        switch type {
        case "goldenClover": return goldenCloverCategory
        case "greenClover": return greenCloverCategory
        default: return 0
        }
    }
    
    // Метод для обработки кликов на клевера
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Проверяем, на что кликнул игрок
        if let node = nodes(at: touchLocation).first {
            if node.physicsBody != nil {
                if node.physicsBody!.categoryBitMask == goldenCloverCategory {
                    // Золотой клевер — увеличиваем счет и удаляем его
                    score += 1
                    scoreUpdateHandler?(score)
                    node.removeFromParent()
                }
                else if node.physicsBody!.categoryBitMask == greenCloverCategory {
                    // Зеленый клевер — завершаем бонусную игру
                    endBonusGame()
                    node.removeFromParent()
                }
            }
        }
    }
    
    // Завершение бонусной игры
    func endBonusGame() {
        // Останавливаем таймер
        bonusGameTimer?.invalidate()
        bonusGameTimer = nil
        
        // Завершаем бонусную игру
        removeAllChildren()  // Убираем все объекты
        gameOverHandler?()  // Завершаем бонусную игру
    }
}
