//
//  AlertUIKit.swift
//  AlertDispatcher
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

extension Alert {

    /// Tint color for all alerts.
    public static var tintColor: UIColor?

    /// Default localized title for `OK` button.
    public static var defaultOkeyTitle: String = {
        return "Ok".localized(with: .UIKit)
    }()

    /// Default localized title for `Cancel` button.
    public static var defaultCancelTitle: String = {
        return "Cancel".localized(with: .UIKit)
    }()

    /// Recursivelly find top `UIViewController`.
    public static var topViewController: UIViewController {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("UIApplication.keyWindow does not have rootViewController")
        }

        func presentedVC(to parent: UIViewController) -> UIViewController {
            if let modal = parent.presentedViewController {
                return presentedVC(to: modal)
            } else {
                return parent
            }
        }
        return presentedVC(to: rootVC)

    }

    /// Simple alert with `OK` button.
    public static func alert(
        title: String,
        message: String? = nil,
        tintColor: UIColor? = Alert.tintColor,
        cancelTitle: String = defaultOkeyTitle,
        completion: @escaping () -> Void = {}) -> Alert {

        return Alert { onFinish in
            let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: cancelTitle, style: .default) { _ in delay { onFinish(); completion() }}

            alert.addAction(cancel)

            if let tintColor = tintColor {
                alert.view.tintColor = tintColor
            }

            Alert.topViewController.present(alert, animated: true)
        }
    }

    /// Dialog with `ACTION` & `CANCEL` buttons (perform action with UI request).
    public static func dialog(
        title: String,
        message: String? = nil,
        tintColor: UIColor? = Alert.tintColor,
        cancelTitle: String = defaultCancelTitle,
        actionTitle: String = defaultOkeyTitle,
        isDestructive: Bool = false,
        actionClosure: @escaping () -> Void,
        completion: @escaping () -> Void = {}) -> Alert {

        return Alert { onFinish in
            let actionStyle = isDestructive ? UIAlertActionStyle.destructive : UIAlertActionStyle.default

            let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in delay { onFinish(); completion() }}
            let action = UIAlertAction(title: actionTitle, style: actionStyle) { _ in delay { onFinish(); actionClosure(); completion() }}

            alert.addAction(cancel)
            alert.addAction(action)

            if #available(iOS 9.0, *) {
                alert.preferredAction = isDestructive ? cancel : action
            }

            if let tintColor = tintColor {
                alert.view.tintColor = tintColor
            }

            Alert.topViewController.present(alert, animated: true)
        }
    }
}
