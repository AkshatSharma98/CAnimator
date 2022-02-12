//
//  APIManager.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation

protocol APIManagerDelegate: AnyObject {
    func didFetchData(_ forClass: APIManager, response: Response?)
    func didFailToFetchData(_ forClass: APIManager)
}

final class APIManager {
    private let baseUrl = "https://api.mocklets.com/p68348/"
    private let successApi = "success_case"
    private let failureApi = "failure_case"
    private let sessionManager = URLSession(configuration: .default)
    private weak var delegate: APIManagerDelegate?
    
    init(delegate: APIManagerDelegate?) {
        self.delegate = delegate
    }
    
    func fetchSuccessData() {
        
        guard let url = URL(string: baseUrl + successApi) else {
            self.delegate?.didFailToFetchData(self)
            return
        }
        
        let task = sessionManager.dataTask(with: url) { [weak self] data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data
            else {
                self?.sendFailure()
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                self?.sendSuccess(response: response)
            } catch {
                self?.sendFailure()
            }
        }
        task.resume()
    }
    
    func fetchFailureData() {
        
        guard let url = URL(string: baseUrl + failureApi) else {
            self.delegate?.didFailToFetchData(self)
            return
        }
        
        let task = sessionManager.dataTask(with: url) { [weak self] data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (400...499).contains(response.statusCode),
                  error == nil,
                  let data = data
            else {
                self?.sendFailure()
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                self?.sendSuccess(response: response)
            } catch {
                self?.sendFailure()
            }
        }
        task.resume()
    }
    
    func sendSuccess(response: Response?) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.delegate?.didFetchData(weakSelf, response: response)
        }
    }
    
    func sendFailure() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.delegate?.didFailToFetchData(weakSelf)
        }
    }
}

