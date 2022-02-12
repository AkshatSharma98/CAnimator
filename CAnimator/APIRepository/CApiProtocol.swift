//
//  CApiProtocol.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation

protocol CApiDelegate: AnyObject {
    func didFetchData(_ forClass: CApiProtocol, response: Response?)
    func didFailToFetchData(_ forClass: CApiProtocol)
}

protocol CApiProtocol: AnyObject {
    var delegate: CApiDelegate? { get set }
    func fetchFailureData()
    func fetchSuccessData()
}
