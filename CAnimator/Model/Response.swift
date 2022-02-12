//
//  Response.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation

struct Response: Decodable {
    let success: Bool?
}

enum ModelCase {
    case success
    case failure
}
