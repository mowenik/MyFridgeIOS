import Alamofire

protocol ConnectionChecking {
    func isConnected() -> Bool
}

extension ConnectionChecking {
    func isConnected() -> Bool {
        guard let isReachable = NetworkReachabilityManager()?.isReachable, isReachable == true else { return false }
        return true
    }
}
