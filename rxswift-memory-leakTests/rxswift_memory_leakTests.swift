//
//  rxswift_memory_leakTests.swift
//  rxswift-memory-leakTests
//
//  Created by wantedly on 2019/08/27.
//  Copyright © 2019 shota.kashihara.koala. All rights reserved.
//

import XCTest
@testable import rxswift_memory_leak
import RxSwift

class rxswift_memory_leakTests: XCTestCase {

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
}
