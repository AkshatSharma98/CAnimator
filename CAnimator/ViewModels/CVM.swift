//
//  ViewModel.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation

protocol CVMDelegate: AnyObject {
    func didFetchData(_ forClass: CVMProtocol, response: Response?)
    func didFailToFetchData(_ forClass: CVMProtocol)
}

protocol CVMProtocol: AnyObject {
    var delegate: CVMDelegate? { get set }
    func getData()
}

final class CVM: CVMProtocol {
    
    private var apiManagerRepo: CApiProtocol?
    private let modelCase: ModelCase
    weak var delegate: CVMDelegate?
    
    init(modelCase: ModelCase, delegate: CVMDelegate?, api: CApiProtocol?) {
        self.modelCase = modelCase
        self.delegate = delegate
        self.apiManagerRepo = api
    }

    func getData() {
        apiManagerRepo?.delegate = self
        switch modelCase {
        case .success:
            apiManagerRepo?.fetchSuccessData()
        case .failure:
            apiManagerRepo?.fetchFailureData()
        }
    }
}

extension CVM: CApiDelegate {
    
    func didFetchData(_ forClass: CApiProtocol, response: Response?) {
        self.delegate?.didFetchData(self, response: response)
    }
    
    func didFailToFetchData(_ forClass: CApiProtocol) {
        self.delegate?.didFailToFetchData(self)
    }
}
