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
    
    func socialMediaViewModelData() -> [PostViewModel]
    var numberOfRows: Int { get }
}

final class LeagueSocialMediaInteractor {
    private let service: LeagueSocialMediaServicing
    private let presenter: LeagueSocialMediaPresenting
    private var users: [User] = []
    private var posts: [Post] = []
    
    var numberOfRows: Int {
        return socialMediaViewModelData().count
    }
    
    func socialMediaViewModelData() -> [PostViewModel] {
        var socialMediaPosts: [PostViewModel] = []
        
        posts.forEach { post in
            let user = users.first { $0.id == post.userID }
            socialMediaPosts.append(
                PostViewModel(
                    userName: user?.username ?? "",
                    title: post.title,
                    description: post.body,
                    avatar: user?.avatar
                )
            )
        }
        
        return socialMediaPosts
    }

    init(service: LeagueSocialMediaServicing, presenter: LeagueSocialMediaPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

extension LeagueSocialMediaInteractor: LeagueSocialMediaInteracting {
    
    func fetchPosts() {
        presenter.presentLoading()
       
        self.service.fetchUsers { [weak self] response in
            guard let self = self else { return }

            switch response {
            case let .success(users):
                self.users = users
                self.service.fetchPosts { response in
                    self.presenter.hideLoading()
                    switch response {
                    case let .success(posts):
                        self.posts = posts
                        self.presenter.presentPosts()
                    case .failure:
                        self.presenter.presentError(retryAction: self.fetchPosts)
                    }
                }
                
            case .failure:
                self.presenter.presentError(retryAction: self.fetchPosts)
                self.presenter.hideLoading()
            }
        }
    }
    
    func prefechImages(indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { self.socialMediaViewModelData()[$0.row].avatarURL }
        ImagePrefetcher(urls: urls).start()
        
    }
    
    func cancelPrefetchingImages(indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { self.socialMediaViewModelData()[$0.row].avatarURL }
        ImagePrefetcher(urls: urls).stop()
    }
}
