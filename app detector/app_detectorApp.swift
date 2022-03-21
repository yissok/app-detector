import SwiftUI

@main
struct app_detectorApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif


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
            ContentView()
        }
    }
    
}


