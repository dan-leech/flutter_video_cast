class getLocalNetworkAccessPermission : NSObject {
    var service: NetService
    var denied: DispatchWorkItem?
    var completion: ((Bool) -> Void)
    
    @discardableResult
    init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        
        service = NetService(domain: "local.", type:"_googlecast._tcp", name: "LocalNetworkPrivacy", port: 1100)
        
        super.init()
        
        denied = DispatchWorkItem {
            self.completion(false)
            self.service.stop()
            self.denied = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: denied!)
        
        service.delegate = self
        self.service.publish()
    }
}

extension getLocalNetworkAccessPermission : NetServiceDelegate {
    
    func netServiceDidPublish(_ sender: NetService) {
        denied?.cancel()
        denied = nil

        completion(true)
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Error: \(errorDict)")
    }
}
