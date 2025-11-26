
//  Created by DharaniDharanR on 16/10/25.
//  dharanidharanr13.dev@gmail.com


import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    var assembler = Assembler.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            let navController = UINavigationController()
            navController.setNavigationBarHidden(true, animated: false)
            
            coordinator = AppCoordinator(navigationController: navController, assembler: assembler)
            coordinator?.start()
            
            window.rootViewController = navController
            window.makeKeyAndVisible()
            self.window = window
        }
        UIView.appearance().overrideUserInterfaceStyle = .dark
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
