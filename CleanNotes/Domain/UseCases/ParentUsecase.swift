
import Foundation


public protocol Request {}
public protocol Response {}

public class ParentUsecase {
    private let queue = DispatchQueue(label: "ParentUsecaseQueue", attributes: .concurrent)
    public init() {}

    public func execute(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.run(request: request, onSuccess: onSuccess, onFailure: onFailure)
        }
    }

    public func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {}
    
    public func invokeSuccess(response: Response, onSuccess: @escaping (Response) -> Void) {
        DispatchQueue.main.async {
            onSuccess(response)
        }
    }
    
    public func invokeFailure(error: Error, onFailure: @escaping (Error) -> Void) {
        DispatchQueue.main.async {
            onFailure(error)
        }
    }
}




public enum DomainError: String, LocalizedError {
    case invalidRequest = "Invalid request."

    public var errorDescription: String? {
        rawValue
    }
}
