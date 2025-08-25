import Foundation
import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

class AdsManager: NSObject, ObservableObject {
    static let shared = AdsManager()
    
    #if canImport(GoogleMobileAds)
    private var interstitial: GADInterstitialAd?
    #endif
    
    private override init() {
        super.init()
    }
    
    private var adUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910" // テスト用
        #else
        return "ca-app-pub-8365176591962448/3970919969" // 本番用
        #endif
    }
    
    func preload() {
        #if canImport(GoogleMobileAds)
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                #if DEBUG
                print("[Ads] Failed to load interstitial: \(error.localizedDescription)")
                #endif
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            #if DEBUG
            print("[Ads] Interstitial loaded (DEBUG)")
            #endif
        }
        #endif
    }
    
    func show(from viewController: UIViewController) {
        #if canImport(GoogleMobileAds)
        guard let interstitial = interstitial else {
            #if DEBUG
            print("[Ads] Interstitial not ready")
            #endif
            return
        }
        
        interstitial.present(fromRootViewController: viewController)
        #if DEBUG
        print("[Ads] Interstitial presented (DEBUG)")
        #endif
        #else
        #if DEBUG
        print("[Ads] GoogleMobileAds not available - simulating ad display")
        #endif
        #endif
    }
}

#if canImport(GoogleMobileAds)
extension AdsManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        #if DEBUG
        print("[Ads] Interstitial dismissed (DEBUG)")
        #endif
        // 次の広告をプリロード
        preload()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        #if DEBUG
        print("[Ads] Failed to present interstitial: \(error.localizedDescription)")
        #endif
        // 失敗時も次の広告をプリロード
        preload()
    }
}
#endif