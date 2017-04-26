//
//  Extensions.swift
//  AlertDispatcher
//
//  Created by Oleg Ketrar on 31.03.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

// TODO: Use UIKitExtensions

// MARK: - Convenience localization

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(with bundle: Bundle?) -> String {
        guard let bundle = bundle else { return localized }
        return bundle.localizedString(forKey: self, value: "", table: nil)
    }
}

extension Bundle {
    static var UIKit: Bundle? {
        return Bundle(identifier: "com.apple.UIKit")
    }
}

// MARK: - NSLock

extension NSLock {
    func withCriticalScope<T>(_ block: (Void) -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}

// MARK: - Convenience closures

/// we need add delay to onFinish closure because
/// onFinish will be called before animation
/// (standart dismiss animation delay is 0.33 seconds = 330 milliseconds)

func delayed(_ closure: @escaping () -> Void) -> () -> Void {
    return { DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) { closure() } }
}

func delay(_ closure: @escaping () -> Void) {
    delayed(closure)()
}
