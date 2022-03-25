import SwiftUI


class ExternalModel: ObservableObject {
    @Published var textToUpdate: String = ""
    func log(_ s: String) {
        // other functionality
        textToUpdate = textToUpdate+"\n\n"+s
    }
}


struct ContentView: View {
    @State var name = "Anonymous"
    @ObservedObject var viewModel: ExternalModel
    var body: some View {
        VStack {
            ScrollView {
                Text(self.viewModel.textToUpdate).padding()
            }
        }.frame(width: 500, height: 300)
    }
}
