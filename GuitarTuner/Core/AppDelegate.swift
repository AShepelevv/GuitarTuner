import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .orange
        tabBarController.tabBar.barTintColor = .graphite
        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = [TunerViewController(),
                                            ScalesViewController(),
                                            UINavigationController(rootViewController: TabsViewController()),
                                            SettingsViewController()]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
