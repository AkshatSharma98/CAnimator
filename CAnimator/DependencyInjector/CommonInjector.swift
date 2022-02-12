//
//  CommonInjector.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation

final class CommonInjector {
    
    static func getCVM(modelCase: ModelCase, delegate: CVMDelegate?, api: CApiProtocol?) -> CVMProtocol? {
        return CVM(modelCase: modelCase, delegate: delegate, api: api)
    }
}
