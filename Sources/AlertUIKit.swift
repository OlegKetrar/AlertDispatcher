//
//  AlertUIKit.swift
//  AlertDispatcher
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

// MARK: - Wrap UIAlertController into Alert

private var alertTintColor: UIColor?

extension Alert {

    ///
    public static var tintColor: UIColor? {
        get { return alertTintColor }
        set { alertTintColor = newValue }
    }
	
	/// recursivelly find top UIViewController
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
	
	/// simple alert with ok button
	public static func alert(title: String,
	                  message: String? = nil,
	                  tintColor: UIColor? = Alert.tintColor,
	                  cancelTitle: String = "Ok".localized(with: .UIKit),
	                  completion: @escaping () -> Void = {}) -> Alert {
		
		return Alert { (onFinish) in
			let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let cancel = UIAlertAction(title: cancelTitle, style: .default) { _ in delay { onFinish(); completion() }}

			alert.addAction(cancel)

            if let tintColor = tintColor {
                alert.view.tintColor = tintColor
            }
			
			Alert.topViewController.present(alert, animated: true)
		}
	}
	
	/// dialog with action & cancel buttons (perform action with UI request)
	public static func dialog(title: String,
	                   message: String? = nil,
	                   tintColor: UIColor? = Alert.tintColor,
	                   cancelTitle: String = "Cancel".localized(with: .UIKit),
	                   actionTitle: String = "Ok".localized(with: .UIKit),
	                   isDestructive: Bool = false,
	                   actionClosure: @escaping () -> Void,
	                   completion: @escaping () -> Void = {}) -> Alert {
		
		return Alert { (onFinish) in
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
