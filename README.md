# ios-game
タイトル：スロから始まる異世界生活  
ジャンル：クリッカーRPG  
世界観：異世界学園生活  
バトル：スロット魔法  
制作開始時期：2019年8月  

# Development
### Architecture
MVVM

### Libraries
RxSwift https://github.com/ReactiveX/RxSwift
Realm https://github.com/realm/realm-cocoa

 ### Install
 1. リポジトリをクローン
 2. 'pod install'

### CustomViews

#### NavigationViewController
UIKitのUINavigationControllerにあたるカスタムビューで、ユーザーステータスを表示するナビゲーションバー相当のビューとContainerを持つ。
Containerに表示するChildViewControllerはUIViewControllerとNavigationChildViewControllerを継承する必要がある。
NavigationChildViewControllerはtopSpacerというUIViewを必ず持ち、ステータス表示部分の戻るボタンの下までのサイズとなる。
そのため、ステータス表示部分を考慮したレイアウトを設定したい時はこのtopSpacerを基準としてアートレイアウトを設定する事で、ステータス表示部分と画面要素の被りを防ぐことが可能となる。

次画面への遷移はNavigationViewControllerクラスの`push(viewController:, animate:)`を使用して行い、前画面に戻る際はNavigationViewControllerクラスの`popViewController(animate:)`を利用する。

ステータス表示部分に画面のタイトルを表示したい場合は、ChildViewControllerのtitleプロパティに値を設定する。
