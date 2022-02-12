//
//  APIManagerRepo.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation

final class APIManagerRepo: CApiProtocol {
    private lazy var apiManager: APIManager = APIManager(delegate: self)
    weak var delegate: CApiDelegate?
    
    func fetchSuccessData() {
        apiManager.fetchSuccessData()
    }
    
    func fetchFailureData() {
        apiManager.fetchFailureData()
    }
}

extension APIManagerRepo: APIManagerDelegate {
    func didFetchData(_ forClass: APIManager, response: Response?) {
        self.delegate?.didFetchData(self, response: response)
    }
    
    func didFailToFetchData(_ forClass: APIManager) {
        self.delegate?.didFailToFetchData(self)
    }
}
