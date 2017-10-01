//
//  Alert.swift
//  AlertDispatcher
//
//  Created by Oleg Ketrar on 26.04.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct Alert {
    public typealias Handler = (@escaping () -> Void) -> Void

    public var beforeDelay: TimeInterval = 0
    public var afterDelay:  TimeInterval = 0
    public var priority:    Operation.QueuePriority = .normal

    var isDispatchable: Bool = true
    var isIgnorable:    Bool = false

    let presentationClosure: Alert.Handler
    var conditionClosure:  () -> Bool = { return true }
    var completionClosure: () -> Void = {}

    // MARK: Init

    public init(_ closure: @escaping Alert.Handler) {
        self.presentationClosure = closure
    }

    ///
    var handlerClosure: Alert.Handler {
        return {
            if self.conditionClosure() {
                self.presentationClosure($0)
            } else {
                $0()
            }
        }
    }
}

// MARK: Configuring

extension Alert {

    public func waitOnAppear(_ delay: TimeInterval) -> Alert {
        var copy = self
        copy.beforeDelay = delay
        return copy
    }

    public func waitOnDisappear(_ delay: TimeInterval) -> Alert {
        var copy = self
        copy.afterDelay = delay
        return copy
    }

    public func onCompletion(_ closure: @escaping () -> Void) -> Alert {
        var copy = self
        copy.completionClosure = closure
        return copy
    }

    public func priority(_ newPriority: Operation.QueuePriority) -> Alert {
        var copy = self
        copy.priority = newPriority
        return copy
    }

    public func dispatched(_ dispatch: Bool = true) -> Alert {
        var copy = self
        copy.isDispatchable = dispatch
        return copy
    }

    public func ignored() -> Alert {
        var copy = self
        copy.isIgnorable = true
        return copy
    }

    public func addCondition(_ closure: @escaping () -> Bool) -> Alert {
        var copy = self
        copy.conditionClosure = closure
        return copy
    }

    /// Append `completion` closure to existing `completion`.
    /// Completions will be called by FIFO rule (queue).
    public func addCompletion(_ closure: @escaping () -> Void) -> Alert {
        var copy = self
        let oldClosure = self.completionClosure
        copy.completionClosure = { oldClosure(); closure() }
        return copy
    }
}

extension Alert {
    public static var empty: Alert {
        return Alert { $0() }.ignored()
    }
}
