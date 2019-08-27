//
//  ViewController.swift
//  rxswift-memory-leak
//
//  Created by wantedly on 2019/08/27.
//  Copyright © 2019 shota.kashihara.koala. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {}

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
