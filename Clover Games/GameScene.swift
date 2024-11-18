import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Объявляем корзину
    var basket: SKSpriteNode!
    
    // Счет игры
    var score = 0
    var gameOverHandler: (() -> Void)?
    var scoreUpdateHandler: ((Int) -> Void)?
    var bonusGameHandler: (() -> Void)?
    
    // Категории объектов
    let basketCategory: UInt32 = 0x1 << 0
    let coinGameCategory: UInt32 = 0x1 << 1
    let bootCategory: UInt32 = 0x1 << 2
    let flowerCategory: UInt32 = 0x1 << 3
    let leaveCategory: UInt32 = 0x1 << 4
    let diamondPinkCategory: UInt32 = 0x1 << 5
    let goldenCloverCategory: UInt32 = 0x1 << 6
    
    // Флаг для добавления фона
    var backgroundAdded = false
    var background: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.physicsWorld.contactDelegate = self
        
        // Добавляем фон, если он еще не был добавлен
        if !backgroundAdded {
            addBackground()
            backgroundAdded = true
        }
        
        setupBasket()
        spawnItems()
        
        // Добавляем обработчик жестов для панорамирования
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(swipeGesture)
    }
    
    // Добавление фона
    func addBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")  // Используйте свое изображение фона
        let backgroundNode = SKSpriteNode(texture: backgroundTexture)
        
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -1  // Размещаем фон ниже всех объектов
        backgroundNode.size = CGSize(width: size.width, height: size.height)
        
        addChild(backgroundNode)
        background = backgroundNode  // Сохраняем ссылку на фон
    }
    
    // Настройка корзины
    func setupBasket() {
        if basket != nil {
            return  // Корзина уже существует, ничего не делаем
        }
        
        basket = SKSpriteNode(imageNamed: "basket")
        basket.size = CGSize(width: 120, height: 100)
        basket.position = CGPoint(x: size.width / 2, y: 50)
        
        basket.physicsBody = SKPhysicsBody(rectangleOf: basket.size)
        basket.physicsBody?.categoryBitMask = basketCategory
        basket.physicsBody?.contactTestBitMask = coinGameCategory | bootCategory | flowerCategory | leaveCategory | diamondPinkCategory | goldenCloverCategory
        basket.physicsBody?.collisionBitMask = 0
        basket.physicsBody?.affectedByGravity = false
        basket.physicsBody?.isDynamic = true
        
        addChild(basket)
    }

    
    // Обработка жестов (перетаскивание корзины)
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        
        if let basket = basket {
            let newPositionX = basket.position.x + translation.x
            basket.position = CGPoint(x: newPositionX, y: basket.position.y)
            basket.position.x = min(max(basket.position.x, basket.size.width / 2), size.width - basket.size.width / 2)
            gesture.setTranslation(.zero, in: gesture.view)
        }
    }
    
    // Спавн случайных предметов
    func spawnItems() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnRandomItem()
        }
        
        let waitAction = SKAction.wait(forDuration: 1.0)
        let sequenceAction = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        run(repeatAction)
    }
    
    // Спавн случайного предмета
    func spawnRandomItem() {
        let randomX = CGFloat.random(in: 0...(size.width - 50))
        
        // Случайный выбор предмета
        let itemType = ["coinGame", "boot", "flower", "leave", "diamond_pink", "goldenClover"].randomElement()!
        
        let item = SKSpriteNode(imageNamed: itemType)
        item.size = CGSize(width: 50, height: 50)
        item.position = CGPoint(x: randomX, y: size.height)
        
        item.physicsBody = SKPhysicsBody(circleOfRadius: item.size.width / 2)
        item.physicsBody?.categoryBitMask = getItemCategory(type: itemType)
        item.physicsBody?.contactTestBitMask = basketCategory  // Корзина взаимодействует с предметами
        item.physicsBody?.collisionBitMask = 0
        item.physicsBody?.affectedByGravity = true
        item.physicsBody?.isDynamic = true
        
        addChild(item)
    }
    
    // Получение категории для предмета
    func getItemCategory(type: String) -> UInt32 {
        switch type {
        case "coinGame": return coinGameCategory
        case "boot": return bootCategory
        case "flower": return flowerCategory
        case "leave": return leaveCategory
        case "diamond_pink": return diamondPinkCategory
        case "goldenClover": return goldenCloverCategory
        default: return 0
        }
    }
    
    // Метод столкновений
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Столкновение с монетой
        if contactMask == (basketCategory | coinGameCategory) {
            score += 1
            scoreUpdateHandler?(score)
            removeItem(contact)  // Удаляем монету
        }
        // Столкновение с неудачными предметами
        else if contactMask == (basketCategory | bootCategory) ||
                contactMask == (basketCategory | flowerCategory) ||
                contactMask == (basketCategory | leaveCategory) ||
                contactMask == (basketCategory | diamondPinkCategory) {
            score -= 1
            scoreUpdateHandler?(score)
            removeItem(contact)  // Удаляем предмет
            if score < 0 {
                gameOverHandler?()  // Завершаем игру
            }
        }
        // Столкновение с золотым клевером
        else if contactMask == (basketCategory | goldenCloverCategory) {
            bonusGameHandler?()  // Запуск бонусной игры
            removeItem(contact)  // Удаляем золотой клевер
        }
    }
    
    // Удаление предмета (не корзины)
    func removeItem(_ contact: SKPhysicsContact) {
        let itemNode: SKNode
        
        // Удаляем только тот объект, который столкнулся с корзиной
        if contact.bodyA.categoryBitMask == basketCategory {
            itemNode = contact.bodyB.node!
        } else {
            itemNode = contact.bodyA.node!
        }
        
        // Удаляем предмет
        itemNode.removeFromParent()
    }
    
    // Сброс игры
    func resetGame() {
        score = 0
        // Удаляем все объекты, кроме фона и корзины
        enumerateChildNodes(withName: "basket") { node, _ in
            node.removeFromParent()  // Удаляем корзину
        }
        // Сбрасываем все остальные элементы
        removeAllChildren()  // Убираем все объекты, кроме корзины и фона
        addChild(background!) // Добавляем фон обратно
        setupBasket()  // Снова создаем корзину, если она не была создана
        spawnItems()  // Перезапускаем спаун предметов
    }

}
