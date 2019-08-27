English / [Japanese](https://github.com/ShotaKashihara/rxswift-memory-leak/blob/master/README-ja.md)

# rxswift-memory-leak

Check the memory leak inspection method of code using `RxSwift.Resources`

reference: https://medium.com/flawless-app-stories/guarantee-rx-memory-leaks-absence-3a90636ec49e 

## Demonstration

1. Prepare ViewController that leaks memory and ViewController that does not leak memory.

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

2. In XCTest, compare the value of `RxSwift.Resources.total` before and after` init ()-> viewDidLoad ()-> deinit () `for each ViewController

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

Run test (short cut): `cmd + U`

## Results

Memory leaking ViewController does not have a zero value for `Resources.total` even after` deinit () `.
So the test fails

<img src="https://raw.githubusercontent.com/ShotaKashihara/rxswift-memory-leak/images/img/result.png" >

- Using `RxSwift.Resources.total`, RxSwift memory leak can be verified with UnitTest
- You can avoid memory leaks by adding the `unowned` keyword (or `weak` keyword).
