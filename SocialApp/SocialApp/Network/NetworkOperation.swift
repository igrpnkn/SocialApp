//
//  NetworkOperation.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 24.01.2021.
//

import Foundation
import Alamofire

class NetworkOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Data?
//    var json: Any?
    
    init(request: DataRequest) {
        self.request = request
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
            print("\nINFO: NetworkOperation has done.")
        }
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }

    override func cancel() {
        request.cancel()
        super.cancel()
        state = .finished
    }

}
