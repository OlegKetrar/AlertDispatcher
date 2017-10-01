//
//  AsyncBlockOperation.swift
//  AlertDispatcher
//
//  Created by Oleg Ketrar on 26.04.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import Dispatch

final class AsyncBlockOperation: Operation {
    private static let stateKeyPath: String = "state"

    class func keyPathsForValuesAffectingIsReady()     -> Set<NSObject> { return [stateKeyPath as NSObject] }
    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> { return [stateKeyPath as NSObject] }
    class func keyPathsForValuesAffectingIsFinished()  -> Set<NSObject> { return [stateKeyPath as NSObject] }

    // MARK: State machine

    private enum State {
        case initialized
        case executing
        case finished

        func canTransition(to newState: State) -> Bool {
            switch (self, newState) {
            case (.executing, .finished),
                 (.initialized, .executing):
                return true

            default:
                return false
            }
        }
    }

    private var _state = State.initialized
    private let stateLock = NSLock()

    private var state: State {
        get { return stateLock.withCriticalScope { _state } }
        set(newState) {
            /*
             It's important to note that the KVO notifications are NOT called from inside
             the lock. If they were, the app would deadlock, because in the middle of
             calling the `didChangeValueForKey()` method, the observers try to access
             properties like "isReady" or "isFinished". Since those methods also
             acquire the lock, then we'd be stuck waiting on our own lock. It's the
             classic definition of deadlock.
             */
            willChangeValue(forKey: AsyncBlockOperation.stateKeyPath)
            stateLock.withCriticalScope {
                guard _state != .finished else { return }
                guard _state.canTransition(to: newState) else { fatalError("invalid state transition from \(_state) to \(newState)") }
                _state = newState
            }
            didChangeValue(forKey: AsyncBlockOperation.stateKeyPath)
        }
    }

    // MARK:

    var delayAfter: TimeInterval  = 0
    var delayBefore: TimeInterval = 0

    private let executionClosure: Alert.Handler

    init(_ closure: @escaping Alert.Handler) {
        self.executionClosure = closure
        super.init()
    }

    /// Add a completion block to be executed after the `NSOperation` enters the "finished" state.
    func addCompletionBlock(_ block: @escaping () -> Void) {
        if let existing = completionBlock {
            completionBlock = { existing(); block() }
        } else {
            completionBlock = block
        }
    }

    // MARK: Overrides

    override func main() {
        guard state == .initialized else { return }
        state = .executing

        DispatchQueue.main.asyncAfter(deadline: .now() + delayBefore) { [weak self] in
            self?.executionClosure {
                guard let time = self?.delayAfter else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + time) { self?.state = .finished }
            }
        }
    }

    override var isReady: Bool     { return state == .initialized && super.isReady }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool  { return state == .finished }

    // MARK: Unsupported

    override func cancel() {}
    override func waitUntilFinished() {}
}
