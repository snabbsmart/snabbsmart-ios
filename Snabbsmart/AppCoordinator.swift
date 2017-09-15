import Foundation
import UIKit

class AppCoordinator {
    let window: UIWindow
    var root: UINavigationController!

    init(window: UIWindow, defaults: UserDefaults = .standard) {
        self.window = window
    }

    /**
     Transition to root view controller smoothly.

     If a root view controller exists it will animate the transision to the new
     one.

     - parameters:
     - to: the new root view controller

     */
    func transitionRoot(to vc: UIViewController) {
        guard window.rootViewController != nil else {
            window.rootViewController = vc
            return
        }

        let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: false)
        vc.view.addSubview(overlayView)
        window.rootViewController = vc

        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCrossDissolve, animations: {
            overlayView.alpha = 0
        }, completion: { finished in
            overlayView.removeFromSuperview()
        })
    }

    func start() {
        let vc = ViewController.makeFromStoryboard()
        root = vc.embedInNavigationController()
        self.transitionRoot(to: self.root)
        window.makeKeyAndVisible()
    }
    
}
