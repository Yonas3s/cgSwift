import SwiftUI

struct ProgressPage: View {
    var body: some View {
        VStack {
            Text("Your Progress")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Progress") // Название на верхней панели
    }
}

struct ProgressPage_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPage()
    }
}
