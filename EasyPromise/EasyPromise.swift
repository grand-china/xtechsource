//
//  EasyPromise.swift
//  XTech
//
//  Created by Grand on 2021/11/5.
//

import Foundation

public typealias TaskNode = (_ observer: EasyPromiseObserver,
                             _ result: Any?) -> Void


open class EasyPromise {
    private var observer: EasyPromiseObserver!
    private var toDoList: [TaskNode]? = []
    private var _retainSelf: Any?
    private var _started: Bool = false
    private var _onError: ((_ error: Error?) -> Void)?
    private var _onFinish: (() -> Void)?
    
    // MARK: - life cycle
    private func dispose() {
        self.toDoList = nil
        self._retainSelf = nil
    }
    
    public init() {
        _retainSelf = self
        toDoList = []
        self.observer = EasyPromiseObserver({ [weak self] result in
            switch result {
            case .complete:
                self?.onComplete()
            case .error(let err):
                self?.onError(err)
            case .next(let data):
                self?.onNext(data)
            }
        })
    }
    
    // MARK: - Public
    
    /// register task
    /// - Parameter task: task node
    /// - Returns: self
    func then(task: @escaping TaskNode) ->  Self {
        self.toDoList?.append(task)
        if _started == false {
            _started = true
            DispatchQueue.main.async { [weak self] in
                self?.doneTask(task, with: nil)
            }
        }
        return self
    }
    
    /// Task finish or normal stop  handler
    /// - Parameter finish: handler
    /// - Returns: self
    func finalFinish(_ finish: (() -> Void)?) ->  Self {
        self._onFinish = finish
        return self
    }
    
    
    /// Task finish with error handler
    /// - Parameter error: handler
    /// - Returns: self
    func catchError(_ error: ((_ error: Error?) -> Void)?) -> Self {
        self._onError = error
        return self
    }
    
    
    // MARK: - Private
    private func doneTask(_ task: @escaping TaskNode,
                          with result: Any?) {
        self.toDoList?.removeFirst()
        task(self.observer, result)
    }
    
    // MARK: - Event Handler
    fileprivate func onNext(_ result: Any? = nil) {
        if let task = self.toDoList?.first {
            self.doneTask(task, with: result)
        } else {
            self.onComplete()
        }
    }
    
    fileprivate func onError(_ error: Error?) {
        self._onError?(error)
        self.dispose()
    }
    
    fileprivate func onComplete() {
        self._onFinish?()
        self.dispose()
    }
}


enum EasyResult {
    case next(_ result: Any?)
    case error(_ error: Error?)
    case complete
}

open class EasyPromiseObserver {
    typealias EventHandler = (EasyResult) -> Void
    private let eventHandler: EventHandler
    
    init(_ eventHandler: @escaping EventHandler) {
        self.eventHandler = eventHandler
    }
    
    /// pass next loop with result
    func next(_ result: Any? = nil) {
        self.eventHandler(.next(result))
    }
    
    ///  complete loop with error
    func error(_ error: Error? = nil) {
        self.eventHandler(.error(error))
    }
    
    /// complete loop
    func complete() {
        self.eventHandler(.complete)
    }
}
