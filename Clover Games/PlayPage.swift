import SwiftUI
import Combine // Импортируем Combine

struct PlayPage: View {
    // Основные состояния
    @State private var basketPosition: CGFloat = UIScreen.main.bounds.width / 2 - 60
    @State private var items: [FallingItem] = []
    @State private var score: Int = 0
    @State private var missedItems: Int = 0
    @State private var isBonusGame: Bool = false
    private let basketWidth: CGFloat = 120
    private let itemHeight: CGFloat = 60
    private let backgroundImage = Image("backgroundGame")
    
    // Состояние для отслеживания кнопки выхода
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Constants for item types
    private let itemImages: [String: Image] = [
        "coin": Image("coinGame"),
        "boot": Image("boot"),
        "flower": Image("flowers"),
        "diamond": Image("dimond_pink"),
        "leave": Image("leave"),
        "goldenClover": Image("golden_clover")
    ]
    
    // Используем для отслеживания перемещения корзины
    @GestureState private var dragOffset: CGSize = .zero
    
    // Таймер для появления новых предметов
    @State private var timerSubscription: Cancellable?
    private let itemFallSpeed: TimeInterval = 3.0
    
    var body: some View {
        ZStack {
            // Фон игры
            backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Счетчик очков в верхнем правом углу
                HStack {
                    Spacer()
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
            }
            
            // Корзина
            Image("basket")
                .resizable()
                .frame(width: basketWidth, height: 100)
                .position(x: basketPosition + dragOffset.width, y: UIScreen.main.bounds.height - 150) // Поднимаем корзину выше
                .gesture(DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        basketPosition += value.translation.width
                        basketPosition = max(0, min(basketPosition, UIScreen.main.bounds.width - basketWidth))
                    })
            
            // Выпадающие предметы
            ForEach(items) { item in
                itemImages[item.type]?
                    .resizable()
                    .frame(width: 60, height: itemHeight)
                    .position(x: item.position.x, y: item.position.y)
                    .onAppear {
                        startItemFallAnimation(item: item)
                    }
            }
        }
        .onAppear {
            startGame()
        }
        .onDisappear {
            stopGame()
        }
        .alert(isPresented: $isBonusGame) {
            Alert(title: Text("Bonus Game"), message: Text("You've caught a special item!"), dismissButton: .default(Text("Close")))
        }
        .navigationBarBackButtonHidden(true) // Скрываем стандартную кнопку "Назад"
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss() // Закрываем текущую страницу и возвращаемся в меню
        }) {
            // Используем изображение кнопки для выхода в меню
            Image("home_icon") // Ваше изображение для кнопки
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40) // Размер кнопки
                .padding(10) // Отступы для кнопки
                .padding(.top, 30) // Отступ сверху
        })
    }
    
    private func startGame() {
        // Запускаем таймер с использованием Timer.publish, который обновляет состояние игры
        timerSubscription = Timer.publish(every: itemFallSpeed, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                spawnNewItem()
            }
    }
    
    private func stopGame() {
        // Отписка от таймера при выходе из игры
        timerSubscription?.cancel()
    }
    
    private func spawnNewItem() {
        let randomX = CGFloat.random(in: 0...(UIScreen.main.bounds.width - 60))
        let itemTypes = ["coin", "boot", "flower", "diamond", "leave", "goldenClover"]
        let randomType = itemTypes.randomElement()!
        
        let newItem = FallingItem(type: randomType, position: CGPoint(x: randomX, y: -itemHeight)) // Начинаем с верхней части экрана
        
        items.append(newItem)
    }
    
    private func startItemFallAnimation(item: FallingItem) {
        // Плавная анимация падения предмета
        withAnimation(.linear(duration: itemFallSpeed)) {
            // Падаем вниз до корзины
            item.position.y = UIScreen.main.bounds.height - 150 // Падаем до корзины
        }
        
        // Проверяем, поймана ли вещь
        DispatchQueue.main.asyncAfter(deadline: .now() + itemFallSpeed) {
            // Проверка попадания в корзину
            if item.position.y >= UIScreen.main.bounds.height - 150 && item.position.x >= basketPosition && item.position.x <= basketPosition + basketWidth {
                // Предмет пойман
                handleItemCatch(item: item)
            } else if item.position.y >= UIScreen.main.bounds.height - 150 {
                // Предмет не пойман (он упал)
                handleItemMissed(item: item)
            }
        }
    }
    
    private func handleItemCatch(item: FallingItem) {
        if item.type == "goldenClover" {
            isBonusGame = true
        } else {
            updateScore(for: item.type)
        }
        // Удаляем предмет из массива
        items.removeAll { $0.id == item.id }
    }
    
    private func handleItemMissed(item: FallingItem) {
        // Если предмет не пойман, он должен исчезнуть
        missedItems += 1
        updateScore(for: nil) // Вычитаем очки за пропущенный предмет
        // Удаляем предмет из массива
        items.removeAll { $0.id == item.id }
    }
    
    private func updateScore(for itemType: String?) {
        if let type = itemType {
            switch type {
            case "coin":
                score += 1
            case "boot", "flower", "diamond", "leave":
                score = max(0, score - 1)
            default:
                break
            }
        } else {
            // За пропущенные предметы уменьшаем очки
            missedItems += 1
            score = max(0, score - 1)
        }
    }
}

class FallingItem: Identifiable {
    let id = UUID()
    var type: String
    var position: CGPoint
    
    init(type: String, position: CGPoint) {
        self.type = type
        self.position = position
    }
}

struct PlayPage_Previews: PreviewProvider {
    static var previews: some View {
        PlayPage()
    }
}
