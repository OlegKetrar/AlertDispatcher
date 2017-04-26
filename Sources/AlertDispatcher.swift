//
//  AlertDispatcher.swift
//  AlertDispatcher
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

// MARK: - Dispatcher

private struct Dispatcher {
	private static let underlyingQueue: OperationQueue = {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		queue.qualityOfService            = .background
		return queue
	}()

	// MARK: Dispatch
	
    static func dispatch(alert: Alert) {

		// ignore ignorable alerts)
		guard !alert.isIgnorable else { return }
		
		// form operation with completion
		let alertOperation = AsyncBlockOperation(alert)
		alertOperation.addCompletionBlock {
			DispatchQueue.main.async { alert.completionClosure() }
		}
		
		/// dispatch if dispatchable
		/// or attempt to present now if queue is empty
		if alert.isDispatchable {
			underlyingQueue.addOperation(alertOperation)
		} else if underlyingQueue.operationCount == 0 {
			underlyingQueue.addOperation(alertOperation)
		}
	}
}

// MARK: - Adapter Alert -> AsyncBlockOperation

private extension AsyncBlockOperation {
	convenience init(_ alert: Alert) {
		self.init { alert.handlerClosure($0) }
		self.delayBefore   = alert.beforeDelay
		self.delayAfter    = alert.afterDelay
		self.queuePriority = alert.priority
	}
}

// MARK: - Alert Dispatching

public extension Alert {
	
	/// dispatch alert with alert dispatch rules
	/// enqueue() if alert dispatchable otherwise present()
    public func dispatch(_ completion: @escaping () -> Void = {}) {
		Dispatcher.dispatch(alert: addCompletion { completion() })
	}
	
	/// present alert now if alert queue is empty
	/// otherwise alert will be ignored
    public func present(_ completion: @escaping () -> Void = {}) {
		Dispatcher.dispatch(alert: dispatched(false).addCompletion { completion() })
	}
	
	/// send alert to alert queue 
	/// will be dispatched guaranteed
    public func enqueue(_ completion:  @escaping () -> Void = {}) {
		Dispatcher.dispatch(alert: dispatched().addCompletion { completion() })
	}
}
