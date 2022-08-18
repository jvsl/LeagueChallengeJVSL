//
//  LeagueMobileChallengeTests.swift
//  LeagueMobileChallengeTests
//
//  Created by Kelvin Lau on 2019-01-09.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import XCTest
@testable import LeagueMobileChallenge

class LeagueMobileChallengeTests: XCTestCase {

    private var serviceMock = LeagueAPIServiceMock()
    private var presenterSpy = LeagueSocialMediaPresenterSpy()
    private lazy var sut = LeagueSocialMediaInteractor(
        service: serviceMock, presenter: presenterSpy)
    
    func testFetchPosts_whenUserTokenPostsAndUsersAreValid_shouldPresentPosts() {
        sut.fetchPosts()
        
        XCTAssertEqual(presenterSpy.didPresentLoading, 1)
        XCTAssertEqual(presenterSpy.didHideLoading, 1)
        XCTAssertEqual(presenterSpy.didPresentPosts, 1)
    }
    
    func testFetchPosts_whenUserTokenIsInValid_shouldPresentError() {
        serviceMock.tokenResult = .failure(.token)
        sut.fetchPosts()
        
        XCTAssertEqual(presenterSpy.didPresentLoading, 1)
        XCTAssertEqual(presenterSpy.didHideLoading, 1)
        XCTAssertEqual(presenterSpy.didPresentError, 1)
    }
    
    func testFetchPosts_whenUserFail_shouldPresentError() {
        serviceMock.usersResult = .failure(.user)
        sut.fetchPosts()
        
        XCTAssertEqual(presenterSpy.didPresentLoading, 1)
        XCTAssertEqual(presenterSpy.didHideLoading, 1)
        XCTAssertEqual(presenterSpy.didPresentError, 1)
    }

    func testFetchPosts_whenPostFail_shouldPresentError() {
        serviceMock.postsResult = .failure(.post)
        sut.fetchPosts()
        
        XCTAssertEqual(presenterSpy.didPresentLoading, 1)
        XCTAssertEqual(presenterSpy.didHideLoading, 1)
        XCTAssertEqual(presenterSpy.didPresentError, 1)
    }
}

final class LeagueAPIServiceMock: APIServicing {
    var tokenResult: Result<Void, SocialMediaError> = .success(Void())
    var postsResult: Result<[Post], SocialMediaError> = .success([.fixture()])
    var usersResult: Result<[User], SocialMediaError> = .success([.fixture()])
    
    func fetchUserToken(userName: String, password: String, completion: @escaping LoginCompletion) {
        completion(tokenResult)
    }
    
    func fetchPosts(completion: @escaping PostCompletion) {
        completion(postsResult)
    }
    
    func fetchUsers(completion: @escaping UserCompletion) {
        completion(usersResult)
    }
}

final class LeagueSocialMediaPresenterSpy: LeagueSocialMediaPresenting {
    var viewController: LeagueSocialMediaDisplaying?
    var didPresentPosts = 0
    var didPresentError = 0
    var didPresentLoading = 0
    var didHideLoading = 0
    var socialMediaViewModel: [SocialMediaViewModel] = []
    
    func present(_ posts: [SocialMediaViewModel]) {
        didPresentPosts += 1
        self.socialMediaViewModel = posts
    }
    
    func presentError() {
        didPresentError += 1
    }
    
    func presentLoading() {
        didPresentLoading += 1
    }
    
    func hideLoading() {
        didHideLoading += 1
    }
}
