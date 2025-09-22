プロジェクトガイド（CLAUDE.md：汎用テンプレート・最新版）

このファイルは Claude Code が本リポジトリで iOS（SwiftUI） のクイズアプリを開発・改修するための作業指針です。以後の自動実装・修正・検証タスクは本ガイドに準拠してください。
重要：Claude Code 上の作業報告・出力はすべて日本語で行うこと。

1. プロジェクト概要（汎用）

アプリ名: APP_NAME（任意）

目的: 4択クイズ形式の学習アプリ。カテゴリ一覧 → 各カテゴリの複数問 → 結果表示。

最低対応OS: iOS 15+

UI: SwiftUI（必要に応じて UIKit 併用可）

広告: Google Mobile Ads (AdMob)（任意）

配布: Xcode + Transporter で App Store Connect に提出

除外: Expo/React Native のルールは適用しない（Swift/iOS ネイティブに統一）

2. 開発ルール

命名: Swift API Design Guidelines 準拠。略語は避ける。

依存管理: SPM を優先（Podsと併用しない）。どちらかに統一。

ビルド構成: Debug / Release で挙動分岐（ログレベル・広告ID）。

クラッシュ回避: 外部依存の失敗はリカバーし、UI を止めない。

ロギング: 重要イベント（広告ロード/表示、遷移、スコア）を print で簡易ログ（Debug は詳細）。

レビュー: PR は小さく、ビルド警告 0 を維持。

レポート言語: 以後の作業報告は日本語。

2.1 Xcode プロジェクト管理ルール（厳守）

.xcodeproj / project.pbxproj は手動編集禁止。

ファイル追加/削除は Xcode の UI で行う（または XcodeGen/Tuist 等で宣言的に生成）。

破損や競合が起きたら再生成で解消（手書き編集しない）。

2.2 Git運用ルール（重要・厳守）

デフォルトで GitHub に push しない。ローカルの commit までは可。

「こちらから『pushして』『プッシュして』『GitHubに反映して』『PR作って』と言った時のみ」push / PR / merge / tag / release を実行。

依頼がない限りは、git status と 変更ファイル一覧（diff/要約）を報告するだけ。

依頼があった場合は原則 新規ブランチ（例：feat/ads-switch-YYYYMMDD）に push → PR を作成（タイトル/要約/変更点/テスト手順を記載）→ PR URL を報告。

main へ直接 push 禁止（「直接pushして」と明示された場合のみ例外）。force-push 禁止。

誤push防止のため、push 直前に git remote -v と直近コミットログを表示して確認。

Tag/Release の作成も 指示があった時のみ。

3. ディレクトリ構成

App/            # エントリポイント, AppDelegate
Views/          # HomeView, QuizView, ResultView, Components/*
Models/         # Question, QuizCategory
Data/           # questions.json 等
Managers/       # AdsManager (AdMob), 他サービス層
Resources/      # 画像・音声・.plist
Docs/           # スクショ, 提出書類, ガイド（署名手順など）
scripts/        # ビルド・クリーニング等の補助スクリプト

4. 必須仕様（機能）

4.1 クイズ構成（汎用）

Home: データから読み込んだカテゴリ一覧（件数任意）を表示

出題: 各カテゴリにつき複数問を連続出題

形式: 各問題は4択（A〜D）。回答後に正誤と解説を表示

結果: 全問回答後に ResultView（得点・正答数など）へ遷移

4.1.1 ResultView の UI ルール（厳守・強化）

非ScrollView：1画面完結（SE2 相当でも収まる）。長文は .minimumScaleFactor(0.8) 等で対応。

構成要素は最小限：
タイトル（「結果発表」）／スコア表示（リング＋正解率 xx%）／モチベコメント／主ボタン1つ「最初に戻る」。

タイトルは上部グラデ帯の中央に大きく（約1.5×）。
リング・正解率・コメントは白地エリア中央にまとめて配置。

navigationBarBackButtonHidden(true) を設定（標準戻るボタンは非表示）。

4.2 データ（JSON スキーマ）

{
  "categories": [
    {
      "id": "category-id",
      "title": "カテゴリ表示名",
      "questions": [
        {
          "id": "uuid-or-string",
          "text": "問題文",
          "choices": ["選択肢A", "選択肢B", "選択肢C", "選択肢D"],
          "answerIndex": 0,
          "explanation": "解説（任意）"
        }
      ]
    }
  ]
}

ロード失敗時は ダミーデータでフェールセーフ。

4.3 広告（AdMob 採用時の確定ルール）

Info.plist：GADApplicationIdentifier を追加（なければ）。

初期化：AppDelegate で GADMobileAds.sharedInstance().start(...)

AdsManager.swift：preload(), present(from:completion:) を提供。GADFullScreenContentDelegate 実装。表示後は次をプリロード。

ユニットID切替：

Debug（テスト）: ca-app-pub-3940256099942544/4411468910

Release（本番）: YOUR-PRODUCTION-INTERSTITIAL-UNIT-ID

表示タイミング（改定・厳守）：
インタースティシャル広告は「結果表示画面の最初に戻るボタンを押した後」にのみ表示。
onAppear やクイズ終了直後の自動表示は禁止。
表示失敗時も completion を呼んで遷移継続（UI を止めない）。

5. 実装タスク（Claude にやらせる順序）

チェックリストを上から順に自動実装。終わったら日本語で「作成/変更ファイル一覧・ビルド手順・差し替えガイド」を出力。

5.1 準備

（必要なら）Google-Mobile-Ads-SDK を SPM 追加

Info.plist に GADApplicationIdentifier

AppDelegate.swift で初期化（@UIApplicationDelegateAdaptor）

5.2 モデル & データ

Models/Question.swift, Models/QuizCategory.swift

Data/questions.json（失敗時はダミー生成）

5.3 画面

HomeView: カテゴリ一覧

QuizView: 4択・正誤・解説・最後に結果へ

ResultView: 非ScrollView・1画面完結・主ボタンは**「最初に戻る」1つ**
→ 押下時に AdsManager.present()、閉じた後にホームへ戻す

5.4 広告マネージャ（採用時）

Managers/AdsManager.swift（プリロード/表示/デリゲート/ID切替）

UIApplication.topMostViewController() ユーティリティ

5.5 ログ & テスト

Debug でテスト広告ログが出る

簡易ユニットテスト（JSON ロード、状態遷移）

UI テスト：SE2 と 6.7inch で ResultView が非スクロールで収まる／
「最初に戻る」押下時のみ広告表示（onAppear では出ない）

5.6 ドキュメント

README.md：ビルド手順・データ差し替え・テスト端末登録（採用時）・
結果画面 UI ルール・Xcode プロジェクト管理ルール・日本語報告方針

6. ビルド・実行

シミュレータ: 任意の iPhone（例：iPhone 16 Pro）を選び ⌘R
※ No Selection や実機が選ばれていると署名が必須になるので注意。

実機: Developer Mode ON → Team 選択 → Bundle ID を一意 → ⌘R

Debug: テスト広告（採用時）

Release: 本番広告（自分でクリックしない／テスト端末登録）

署名が未設定でも、シミュレータは CODE_SIGNING_ALLOWED=NO でビルド可能。
例：
xcodebuild -project "NKen3Quiz.xcodeproj" -scheme "NKen3Quiz" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' CODE_SIGNING_ALLOWED=NO build

7. リリース（Transporter 経由）

Xcode Product > Archive

Organizer Distribute App →

Export して Transporter からアップロード、または

直接 Upload

App Store Connect でビルド選択 → メタデータ/スクショ → 提出

8. トラブルシューティング（今回の教訓を反映）

8.1 署名（Signing）

エラー：Signing for "APP" requires a development team.

原因：ターゲットに Team 未選択／デバイスが実機/No Selection。

対処：シミュレータを選ぶか、Signing & Capabilities で
Automatically manage signing ✅、Team を選択、Bundle ID を一意に。

8.2 SPM / パッケージ

エラー：Missing package product 'GoogleMobileAds'

対処：Resolve Packages（xcodebuild -resolvePackageDependencies）。

エラー：Could not compute dependency graph ... same GUID 'PACKAGE:...::MAINGROUP'

対処：project.xcworkspace/xcshareddata/swiftpm と Package.resolved を再生成 → Resolve。

ダイアログ「project.xcworkspace が変更」→ Use Version on Disk を選択。

直接 .pbxproj を編集しない（破損防止）。操作は Xcode UI か xcodebuild。

8.3 結果画面 UI

はみ出す／押せない：非ScrollView・1画面完結を厳守。
フォントは minimumScaleFactor、余白は Spacer で調整。

8.4 広告が出ない/出過ぎる

onAppear で表示していないかを確認（禁止）。

preload() の呼び出しタイミングを見直す（Home 等で先行ロード）。

表示後は必ず次をプリロード。失敗時も UI は遷移継続。

8.5 ストレージ掃除（安全版の考え方）

DerivedData / SwiftPM キャッシュ / 古い Archives を定期削除。

OS/DeviceSupport の削除はフラグ付きでたまに（容量大・慎重に）。

Before/After の使用量をレポートに残す。

9. Claude Code 用プロンプト例（抜粋）

新規作成

iOS 15+ / SwiftUI の4択クイズアプリを新規作成。
ResultView は非ScrollView・1画面完結・主ボタンは「最初に戻る」1つ。
「最初に戻る」押下時に AdsManager.present(from:) を呼び、広告閉後にホームへ戻す。
.xcodeproj/project.pbxproj は手動編集禁止。ファイル追加/削除は Xcode UI（または XcodeGen/Tuist）。
完了後、作成/変更ファイル一覧・ビルド手順・差し替えガイドを日本語で出力。

SPM 復旧

.xcodeproj は触らず、xcodebuild -resolvePackageDependencies を実行。
Package.resolved を再生成し、GoogleMobileAds/UMP が含まれることを確認。
必要なら Add Packages の UI 手順を日本語で提示。

署名回避ビルド（シミュレータ）

scripts/build-sim.sh を作成し、CODE_SIGNING_ALLOWED=NO でビルド。
実行権限付与と実行ログを日本語で報告。

結果画面 UI 改修

Views/ResultView.swift を編集。
タイトルは上部グラデ帯中央・1.5倍、リング/正解率/コメントは白地中央。
非ScrollView。onAppear では広告を出さない。

10. 受け入れ基準（Definition of Done）

ResultView が非スクロール・1画面完結・主ボタンは「最初に戻る」1つ

「最初に戻る」押下でのみ広告表示し、閉後にホームへ戻る（1回限り）

Debug でテスト広告ログ／Release で本番IDログ（採用時）

JSON 差し替えで反映・クラッシュなし

README に結果画面 UI・Xcode プロジェクト管理ルール・日本語報告方針が記載

ビルド警告 0／依存管理は SPM に統一

.xcodeproj/.pbxproj を手動編集していない（差分で確認）