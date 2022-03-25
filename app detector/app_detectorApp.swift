import SwiftUI

@main
struct app_detectorApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif

    @Environment(\.scenePhase) private var scenePhase

    init() {
        UserDefaults.standard.register(defaults: [
            "name": "Taylor Swift",
            "highScore": 10
        ])
//        print("ello.")
//        
//        let ws = NSWorkspace.shared
//        let apps = ws.runningApplications
//        for currentApp in apps
//        {
//            if(currentApp.activationPolicy == .regular){
//                print(currentApp.localizedName!)
//            }
//        }

    }
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: externalModel)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                print("scene is now active!")
            case .inactive:
                print("scene is now inactive!")
            case .background:
                print("scene is now in the background!")
            @unknown default:
                print("Apple must have added something new!")
            }
        }
    }
    
}



