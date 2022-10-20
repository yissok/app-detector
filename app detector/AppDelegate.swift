import SwiftUI
import Foundation
import AppKit

var externalModel:ExternalModel=ExternalModel()
#if os(macOS)
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var lastChecked:Int = 0
    var diffDayOne:Int = 0
    let source = """
                  delay 1
                  
                  tell application "Day One"
                      
                      activate
                      
                  end tell

                  delay 2

                  tell application "System Events"
                      
                      tell process "Day One"
                          
                          click menu item "JSON" of menu 1 of menu item "Export" of menu "File" of menu bar 1
                          delay 1
                          tell application "System Events" to key code 36 #return
                          delay 1
                          tell application "System Events" to key code 36 #return
                          
                      end tell
                      
                  end tell

                  tell application "Day One"
                      
                      quit
                      
                  end tell
                  """
        
     func applescript() -> Void {
            if let script = NSAppleScript(source: source) {
                var error: NSDictionary?
                script.executeAndReturnError(&error)
                if let err = error {
                    print(err)
                }
            }
        }
    
    func unzipMoveRemove() -> Void {
        do {
            let a:String = try! safeShell("""
cd /Users/andrea/Desktop
unzip "$(ls *-*-*_*-*-*.zip | sort -V | tail -n1)"
mv -f The\\ Daily\\ Daily.json /Users/andrea/Documents/PROGETTI/GIT/the-daily-daily/The\\ Daily\\ Daily.json
rm "$(ls *-*-*_*-*-*.zip | sort -V | tail -n1)"
""")
            print(a)
        }
    }
    var countSinceStart=0
    var countSinceStart2=0
    func pushChanges() -> Void {
//        if countSinceStart==0 {
//            countSinceStart=1
//            do {
//                _ = try! safeShell("""
//    cd /Users/andrea/Documents/PROGETTI/GIT/the-daily-daily
//    git add .
//    git commit -m "batch"
//    git pull origin main
//    git push origin main
//    """)
//            }
//        } else {
            do {
                _ = try! safeShell("""
    cd /Users/andrea/Documents/PROGETTI/GIT/the-daily-daily
    git add .
    """)
            }
//        }
    }
    
    func pullChanges() -> Void {
        do {
            _ = try! safeShell("""
cd /Users/andrea/Documents/PROGETTI/GIT/the-daily-daily
git pull origin main
cd misc/other/code
sh divert.sh
""")
        }
    }
    
    

    func logBoth(_ s: String) {
        externalModel.log(s)
        print(s)
    }

    func proceed() {
        let intdate:Int = Int(Date().timeIntervalSince1970)
        self.diffDayOne=Int(Date().timeIntervalSince1970)-self.lastChecked
        self.logBoth("date check: "+String(intdate)+"\nlast check: "+String(self.lastChecked)+"\ndiff: "+String(self.diffDayOne))
        if self.diffDayOne>10 {
            self.lastChecked=intdate
            print("Day One terminated")
            self.logBoth("applescript start")
            self.applescript()
            self.logBoth("applescript done")
            self.unzipMoveRemove()
            self.logBoth("unzipMoveRemove done")
            self.pushChanges()
            self.logBoth("pushed\n\n\n")
        }
    }

    func pull() {
        self.pullChanges()
        self.logBoth("pulled\n\n\n")
    }


    func notWiTi(_ ti: String) {
        let notification = NSUserNotification()
        notification.title = ti
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryDate = Date(timeIntervalSinceNow: 0)
        NSUserNotificationCenter.default.scheduleNotification(notification)
    }



    func applicationWillFinishLaunching(_ notification: Notification) {
        
        
        print("start")
        
        let center = NSWorkspace.shared.notificationCenter
        center.addObserver(forName: NSWorkspace.didTerminateApplicationNotification,
                            object: nil,
                           queue: OperationQueue.main) { [self] (notification: Notification) in
                                if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                                    self.logBoth(app.bundleIdentifier!)
                                    if app.bundleIdentifier == "com.bloombuilt.dayone-mac" {
                                        if self.lastChecked==0 {
                                            self.proceed()
                                        } else if Int(Date().timeIntervalSince1970)-self.lastChecked>10 {
                                            self.logBoth("self.diffDayOne: "+String(self.diffDayOne))
                                            self.proceed()
                                        } else {
                                            self.logBoth("not doing bc diff is: "+String(Int(Date().timeIntervalSince1970)-self.lastChecked))
                                        }
                                        
                                        
                                    }
                                    if app.bundleIdentifier == "com.github.atom" {
                                        print("Atom terminated")
                                        self.logBoth("pushed\n\n\n")
                                        self.pushChanges()
//                                        if self.countSinceStart2==0 {
//                                            self.countSinceStart2=1
//                                            self.notWiTi("Pushed")
//                                        } else {
                                            self.notWiTi("Added")
//                                        }
                                    }
                                }
        }
        center.addObserver(forName: NSWorkspace.willLaunchApplicationNotification,
                            object: nil,
                             queue: OperationQueue.main) { (notification: Notification) in
                                if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                                    self.logBoth(app.bundleIdentifier!)
                                    if app.bundleIdentifier == "com.github.atom" {
                                        self.logBoth("Atom started")
                                        self.pull()
                                        self.notWiTi("Pulled")
                                    }
                                }
        }
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(functionOne), userInfo: nil, repeats: false)

    }
    

    @objc func functionOne () {
        print("hiding")
        NSApplication.shared.hide(nil)
    }
}
#endif

func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

// Example usage:


