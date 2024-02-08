
import UIKit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try KeychainManager.getToken(for: UserDefaults.standard.object(forKey: "login") as? String ?? "")
            let router = MainListRouter.createMainList()
            let initialViewController = router.entry!
            let navigation = UINavigationController()
            navigation.viewControllers = [initialViewController]
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.backgroundColor = .systemBackground
            window?.rootViewController = navigation
        } catch {
            let router = LoginRouter.startExecution()
            let initialViewController = router.entry!
            let navigation = UINavigationController()
            navigation.viewControllers = [initialViewController]
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.backgroundColor = .systemBackground
            window?.rootViewController = navigation
        }
        
        YMKMapKit.setApiKey(YMapApiKey)
        YMKMapKit.sharedInstance()
        
        let navigationBarAppearnce = UINavigationBar.appearance()
        navigationBarAppearnce.barTintColor = mainColor
        navigationBarAppearnce.tintColor = mainColor
        navigationBarAppearnce.titleTextAttributes = [.foregroundColor: mainColor]
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: mainColor]
        navigationBarAppearnce.standardAppearance = appearance
        navigationBarAppearnce.scrollEdgeAppearance = appearance
        
        return true
    }
}

