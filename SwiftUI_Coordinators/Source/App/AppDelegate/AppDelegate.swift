
import UIKit
import FirebaseCore
import GoogleSignIn

typealias VoidBlock = () -> ()

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.startServices(withLaunchOptions: launchOptions)
        return true
    }

    func startServices(withLaunchOptions options: [UIApplication.LaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        Log.enabled = AppConfig().loggingEnabled
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
