
import UIKit
import FirebaseCore
import GoogleSignIn

typealias VoidBlock = () -> ()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private(set) var appAssembly: AppAssemblyProtocol
    private(set) var appConfig: AppConfig

    override init() {
        appConfig = AppConfig()
        appAssembly = AppAssembly(with: appConfig)
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.startServices(withLaunchOptions: launchOptions)
        return true
    }

    func startServices(withLaunchOptions options: [UIApplication.LaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        Log.enabled = appConfig.loggingEnabled
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
