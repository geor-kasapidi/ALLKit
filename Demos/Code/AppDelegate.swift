import UIKit
import PinIt

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let nc = UINavigationController(rootViewController: RootViewController())
        nc.navigationBar.isTranslucent = false

        let wnd = UIWindow()

        if #available(iOS 11.0, *) {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white

            vc.addChild(nc)
            vc.view.addSubview(nc.view)
            nc.view.pinEdges(to: vc.view.safeAreaLayoutItem)
            nc.didMove(toParent: vc)

            wnd.rootViewController = vc
        } else {
            wnd.rootViewController = nc
        }

        window = wnd

        wnd.makeKeyAndVisible()

        return true
    }
}
