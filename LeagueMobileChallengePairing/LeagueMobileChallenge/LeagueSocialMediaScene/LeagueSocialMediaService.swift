import Foundation

//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

typealias LoginCompletion = (Swift.Result<Void, SocialMediaError>) -> Void
typealias PostCompletion = (Swift.Result<[Post], SocialMediaError>) -> Void
typealias UserCompletion = (Swift.Result<[User], SocialMediaError>) -> Void

protocol LeagueSocialMediaServicing {
    func fetchUserToken(
        userName: String,
        password: String,
        completion: @escaping LoginCompletion)
    func fetchPosts(completion: @escaping PostCompletion)
    func fetchUsers(completion: @escaping UserCompletion)
}

class LeagueSocialMediaService: LeagueSocialMediaServicing {
    static let user = "user"
    static let password = "password"
    
    static let domain = "https://engineering.league.dev/challenge/api/"
    let loginAPI = domain + "login"
    let postAPI = domain + "posts"
    let userAPI = domain + "users"
    
    fileprivate var userToken: String?
    
    func fetchUserToken(
        userName: String = "",
        password: String = "",
        completion: @escaping LoginCompletion) {
        
        guard let url = URL(string: loginAPI) else {
            return
        }
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(url, headers: headers).responseJSON { [weak self] (response) in
            guard let self = self else { return }
            
            guard response.error == nil else {
                completion(.failure(.token))
                return
            }
            
            if let value = response.result.value as? [AnyHashable : Any] {
                self.userToken = value["api_key"] as? String
            }
            
            completion(.success(Void()))
        }
    }

    func fetchPosts(completion: @escaping PostCompletion) {
        guard let url = URL(string: postAPI) else {
            return
        }
        
        guard userToken != nil else {
            fetchUserToken(userName: "", password: "") { response in
                switch response {
                case .success:
                    self.request(url, errorType: .post, completion: completion)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            
            return
        }

        request(url, errorType: .post, completion: completion)
    }
    
    func fetchUsers(completion: @escaping UserCompletion) {
        guard let url = URL(string: userAPI) else {
            return
        }
        
        guard userToken != nil else {
            fetchUserToken(userName: "", password: "") { response in
                switch response {
                case .success:
                    self.request(url, errorType: .user, completion: completion)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            
            return
        }
        
        request(url, errorType: .user, completion: completion)
    }

    private func request<T: Decodable>(
        _ url: URL, errorType: SocialMediaError,
        completion: @escaping (Swift.Result<T, SocialMediaError>) -> Void) {
        
        requestWithTokenValidation(url: url) { data, error in
            guard error == nil else {
                completion(.failure(errorType))
                    
                return
            }
                
            guard let data = data else {
                completion(.failure(.emptyData))
                    
                return
            }
                
            do {
                let data: T = try Parser.decode(from: data)
                    completion(.success(data))
            } catch {
                    completion(.failure(.parse))
            }
        }
    }
    
    private func requestWithTokenValidation(
        url: URL, completion: @escaping (Data?, Error?) -> Void) {
        
        guard let userToken = userToken else {
            NSLog("No user token set")
            completion(nil, nil)
            return
        }
            
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
            
            completion(response.data, response.error)
        }
    }
}
