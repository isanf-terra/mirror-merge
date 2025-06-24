//
// Copyright (c) Vatsal Manot
//

import Combine
import Swallow
import SwiftUI

@frozen
public enum ObservableTaskStatusDescription: CustomDebugStringConvertible, Hashable {
    case idle
    case active
    case paused
    case canceled
    case success
    case error(AnyError)
    
    public var debugDescription: String {
        switch self {
            case .idle:
                return "idle"
            case .active:
                return "active"
            case .paused:
                return "paused"
            case .canceled:
                return "canceled"
            case .success:
                return "success"
            case .error:
                return "error"
        }
    }
}

extension ObservableTaskStatusDescription {
    public var isTerminal: Bool {
        switch self {
            case .success, .canceled, .error:
                return true
            default:
                return false
        }
    }

    public var isOutput: Bool {
        switch self {
            case .idle:
                return false
            case .active, .paused, .success:
                return true
            case .canceled, .error:
                return false
        }
    }
    
    public var isFailure: Bool {
        switch self {
            case .idle:
                return false
            case .active, .paused, .success:
                return false
            case .canceled, .error:
                return true
        }
    }
}

extension ObservableTaskStatusDescription {
    public var isCompletion: Bool {
        switch self {
            case .idle, .active, .paused:
                return false
            case .canceled, .success, .error:
                return true
        }
    }
}

extension ObservableTaskStatusDescription {
    public var isActive: Bool {
        switch self {
            case .active:
                return true
            default:
                return false
        }
    }
    
    public init<Success, Error: Swift.Error>(
        _ status: ObservableTaskStatus<Success, Error>
    ) {
        switch status {
            case .idle:
                self = .idle
            case .active:
                self = .active
            case .paused:
                self = .paused
            case .canceled:
                self = .canceled
            case .success:
                self = .success
            case .error(let error):
                self = .error(AnyError(erasing: error))
        }
    }
    
    public init<Success, Error: Swift.Error>(
        for status: Result<Success, Error>
    ) {
        switch status {
            case .success:
                self = .success
            case .failure(let error):
                if error is CancellationError {
                    self = .canceled
                } else {
                    self = .error(AnyError(erasing: error))
                }
        }
    }
}

// MARK: - Auxiliary

extension ObservableTaskStatusDescription {
    public enum Comparison {
        case idle
        case active
        case success
        case failure
        
        public static func == (
            lhs: ObservableTaskStatusDescription?,
            rhs: Self
        ) -> Bool {
            if let lhs = lhs {
                switch rhs {
                    case .idle:
                        return lhs == .idle
                    case .active:
                        return lhs.isActive
                    case .success:
                        if case .success = lhs {
                            return true
                        } else {
                            return false
                        }
                    case .failure:
                        return lhs.isFailure
                }
            } else {
                switch rhs {
                    case .idle:
                        return true
                    case .active:
                        return false
                    case .success:
                        return false
                    case .failure:
                        return false
                }
            }
        }
        
        public static func != (
            lhs: ObservableTaskStatusDescription?,
            rhs: Self
        ) -> Bool {
            !(lhs == rhs)
        }
    }
}

extension ObservableTaskStatus {
    @_disfavoredOverload
    public static func == (lhs: Self, rhs: ObservableTaskStatusDescription.Comparison) -> Bool {
        ObservableTaskStatusDescription(lhs) == rhs
    }
    
    @_disfavoredOverload
    public static func != (lhs: Self, rhs: ObservableTaskStatusDescription.Comparison) -> Bool {
        ObservableTaskStatusDescription(lhs) != rhs
    }
}
