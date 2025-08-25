import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if canImport(GoogleMobileAds)
        GADMobileAds.sharedInstance().start(completionHandler: { status in
            #if DEBUG
            print("[Ads] GoogleMobileAds started (DEBUG - test ads)")
            #else
            print("[Ads] GoogleMobileAds started (RELEASE - production ads)")
            #endif
        })
        #endif
        return true
    }
}