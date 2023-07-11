
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appRouter: AppRoutingProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }

        let router = appDelegate.appAssembly.assembleAppRouter()
        let window = UIWindow(windowScene: windowScene)
        router.showInitialUI(from: window)
        self.appRouter = router
    }
}
