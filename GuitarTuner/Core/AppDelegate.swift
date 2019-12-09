import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarController = TabBarController()
        tabBarController.viewControllers = [NavigationController(rootViewController: TunerViewController()),
                                            NavigationController(rootViewController: ScalesViewController()),
                                            NavigationController(rootViewController: TabsViewController())]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
