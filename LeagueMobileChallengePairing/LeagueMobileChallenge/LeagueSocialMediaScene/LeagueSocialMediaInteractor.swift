import Foundation
import Kingfisher
import UIKit

enum SocialMediaError: Error {
    case token
    case user
    case post
    case emptyData
    case parse
}

protocol LeagueSocialMediaInteracting: AnyObject {
    func fetchPosts()
    func prefechImages(indexPaths: [IndexPath])
    func cancelPrefetchingImages(indexPaths: [IndexPath])
}

final class LeagueSocialMediaInteractor {
    private let service: APIServicing
    private let presenter: LeagueSocialMediaPresenting
    private var users: [User] = []
    private var posts: [Post] = []
    private lazy var socialMediaViewModel: [SocialMediaViewModel] = {
        var socialMediaPosts: [SocialMediaViewModel] = []
        
        posts.forEach { post in
            let user = users.first { $0.id == post.userID }
            socialMediaPosts.append(
                SocialMediaViewModel(
                    userName: user?.username ?? "",
                    title: post.title,
                    description: post.body,
                    avatar: user?.avatar
                )
            )
        }
        
        return socialMediaPosts
    }()

    init(service: APIServicing, presenter: LeagueSocialMediaPresenting) {
        self.service = service
        self.presenter = presenter
    }
}


extension LeagueSocialMediaInteractor: LeagueSocialMediaInteracting {
    
    func fetchPosts() {
        presenter.presentLoading()
        
        service.fetchUserToken(
            userName: "",
            password: "") { [weak self] response in
                
                guard let self = self else { return }
                    switch response {
                    case .success:
                        
                        self.service.fetchUsers { response in
                            switch response {
                            
                            case let .success(users):
                                self.users = users
                                self.service.fetchPosts { response in
                                    switch response {
                                    
                                    case let .success(posts):
                                        self.posts = posts
                                        
                                        self.presenter.present(self.socialMediaViewModel)
                                    case .failure:
                                        self.presenter.presentError()
                                    }
                                }
                            case .failure:
                                self.presenter.presentError()
                            }
                        }
                    case .failure:
                        self.presenter.presentError()
                    }
                    
                    self.presenter.hideLoading()
                }
       
    }
    
    func prefechImages(indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { self.socialMediaViewModel[$0.row].avatarURL }
        ImagePrefetcher(urls: urls).start()
        
    }
    
    func cancelPrefetchingImages(indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { socialMediaViewModel[$0.row].avatarURL }
        ImagePrefetcher(urls: urls).stop()
    }
}
