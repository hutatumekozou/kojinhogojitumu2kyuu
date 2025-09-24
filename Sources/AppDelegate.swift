import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if canImport(GoogleMobileAds)
        GADMobileAds.sharedInstance().start(completionHandler: { _ in
            #if DEBUG
            print("[Ads] GoogleMobileAds started (DEBUG)")
            #endif
        })
        #else
        #if DEBUG
        print("[Ads] GoogleMobileAds not available (DEBUG build without SDK)")
        #endif
        #endif
        return true
    }
}