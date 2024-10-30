//
//  FeedViewModelTests.swift
//  NavigationTests
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation
import XCTest
@testable import Navigation
@testable import StorageService

final class FeedViewModelTests: XCTestCase {
    
    private var viewModel: FeedVM!
      private var modelMock: FeedModelMock!
    private var postMock: PostServiceMock!
      
      override func setUp() {
          super.setUp()
          postMock = PostServiceMock()
          modelMock = FeedModelMock()
          viewModel = FeedVM(feedModel: modelMock, postService: postMock)
      }
      
      override func tearDown() {
          viewModel = nil
          modelMock = nil
          postMock = nil
          super.tearDown()
      }
      
    func testCheck_withValidInput_setsLoadedCheckTrue() {
            modelMock.fakeResult = .success(true)
            viewModel.check(input: "validInput")
            XCTAssertEqual(viewModel.state, .loadedCheck(true))
        }

        func testCheck_withInvalidInput_setsLoadedCheckFalse() {
            modelMock.fakeResult = .success(false)
            viewModel.check(input: "invalidInput")
            XCTAssertEqual(viewModel.state, .loadedCheck(false))
        }


        func testFetchPost_setsLoadingState() {
            let post = Post(author: "", postDescription: "", image: "", likes: 0, views: 0)
            postMock.fakeResult = .success(post)
            viewModel.fetchPost()
            XCTAssertEqual(viewModel.state, .loadedPost(post))
        }


    
}
