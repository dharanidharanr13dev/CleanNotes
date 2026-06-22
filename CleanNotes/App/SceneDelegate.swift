
import UIKit


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    let assembler = Assembler.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .dark
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        coordinator = AppCoordinator(navigationController: navController, assembler: assembler)
        coordinator?.start()
        
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
