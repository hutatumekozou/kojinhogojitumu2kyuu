import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

enum AdsManager {

    // MARK: - UnitID 切替
    static var interstitialUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910" // テスト
        #else
        return "ca-app-pub-8365176591962448/5741807765"
        #endif
    }

    // MARK: - Internal holder
    private static var interstitial: AnyObject?

    // 事前ロード
    static func preload() {
        #if canImport(GoogleMobileAds)
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: interstitialUnitID, request: request) { ad, error in
            if let error = error {
                #if DEBUG
                print("[Ads] Interstitial load failed:", error.localizedDescription)
                #endif
                interstitial = nil
                return
            }
            interstitial = ad
            #if DEBUG
            print("[Ads] Interstitial loaded (unit: \(interstitialUnitID))")
            #endif
        }
        #else
        #if DEBUG
        print("[Ads] GoogleMobileAds not available: preload skipped")
        #endif
        #endif
    }

    // 表示
    static func show(from viewController: UIViewController) {
        #if canImport(GoogleMobileAds)
        guard let ad = interstitial as? GADInterstitialAd else {
            #if DEBUG
            print("[Ads] Interstitial not ready, reloading…")
            #endif
            preload()
            return
        }
        ad.fullScreenContentDelegate = InterstitialDelegate.shared
        ad.present(fromRootViewController: viewController)
        interstitial = nil
        #if DEBUG
        print("[Ads] Interstitial present requested")
        #endif
        // 次回に備えて再ロード
        preload()
        #else
        #if DEBUG
        print("[Ads] GoogleMobileAds not available: show skipped")
        #endif
        #endif
    }
}

// MARK: - Delegate（ログ用）
#if canImport(GoogleMobileAds)
final class InterstitialDelegate: NSObject, GADFullScreenContentDelegate {
    static let shared = InterstitialDelegate()

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        #if DEBUG
        print("[Ads] Interstitial will present")
        #endif
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        #if DEBUG
        print("[Ads] Interstitial failed to present:", error.localizedDescription)
        #endif
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        #if DEBUG
        print("[Ads] Interstitial did dismiss")
        #endif
    }
}
#endif