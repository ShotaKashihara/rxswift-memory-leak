[English](https://github.com/ShotaKashihara/rxswift-memory-leak/blob/master/README.md) / Japanese

# rxswift-memory-leak

`RxSwift.Resources` を使ったコードのメモリリーク検査手法を残す

参考: https://medium.com/flawless-app-stories/guarantee-rx-memory-leaks-absence-3a90636ec49e 

## 検証

1. メモリリークする ViewController とメモリリークしない ViewController を用意する。

```swift
final class LeakViewController: UIViewController {

    lazy var button = UIButton()
    lazy var label = UILabel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        button.rx.tap
            .subscribe(onNext: {
                self.label.text = "Hello world"
            })
            .disposed(by: disposeBag)
    }
}

final class NoLeakViewController: UIViewController {

    lazy var button = UIButton()
    lazy var label = UILabel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        button.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.label.text = "Hello world"
            })
            .disposed(by: disposeBag)
    }
}
```

2. UnitTest にて、各ViewController を `init() -> viewDidLoad() -> deinit()` した前後で `RxSwift.Resources.total` の値を比較する

```swift
func testメモリリーク() {
    let expectedCount = RxSwift.Resources.total

    autoreleasepool {
        let viewController = LeakViewController()
        _ = viewController.view
    }

    XCTAssertEqual(Resources.total, expectedCount)
}

func testNoメモリリーク() {
    let expectedCount = Resources.total

    autoreleasepool {
        let viewController = NoLeakViewController()
        _ = viewController.view
    }

    XCTAssertEqual(Resources.total, expectedCount)
}
```

テスト実行: `cmd + U`

## 結果

メモリリークする ViewController `deinit()` の後でも `Resources.total` の値がゼロにならない
よってテストに失敗した

<img src="https://raw.githubusercontent.com/ShotaKashihara/rxswift-memory-leak/images/img/result.png" >

- `RxSwift.Resources.total` を用いて、UnitTest で RxSwift のメモリリーク検証が可能
- `unowned` キーワード (または `weak`キーワード) をつけることでメモリリークを回避できる
