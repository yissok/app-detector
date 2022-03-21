import SwiftUI

struct ContentView: View {
    @AppStorage("name") var name = "Anonymous"
    var body: some View {
        Text("Your name is \(name).")
            .padding()
    }
}
