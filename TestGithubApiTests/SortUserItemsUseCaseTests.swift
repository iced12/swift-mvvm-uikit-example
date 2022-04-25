//
//  SortUserItemsUseCaseTests.swift
//  TestGithubApiTests
//
//  Created by Minh Le Ngoc on 25/04/2022.
//

import XCTest
@testable import TestGithubApi

class SortUserItemsUseCaseTests: XCTestCase {
    var usecase: SortUserItemsUseCase!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        usecase = SortUserItemsUseCaseImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        usecase = nil
    }

    func testEmptyDictionary() {
        // context: add new Users to empty dictionary
        // it should return a sorted dictionary when adding new users to a empty dictionary
        let sorted = usecase.sortAlphabetically(dictionary: [:], with: mockedNewUsers)
        XCTAssertTrue(sorted.count == 5, "Number of sections is incorrect")
        XCTAssertTrue(sorted["A"]?.count == 2, "Number of elements in section A is incorrect")
        XCTAssertTrue(sorted["B"]?.count == 2, "Number of elements in section B is incorrect")
        XCTAssertTrue(sorted["C"]?.count == 1, "Number of elements in section C is incorrect")
        XCTAssertTrue(sorted["E"]?.count == 1, "Number of elements in section E is incorrect")
        XCTAssertTrue(sorted["Z"]?.count == 1, "Number of elements in section Z is incorrect")
        XCTAssertTrue(sorted["!"] == nil, "Only sections with alphabet letters should be added")
    }

    func testDictionary() {
        // context: add new Users to a sorted not empty dictionary
        // it should return a sorted dictionary when adding new users to a sorted not empty dictionary

        let dictionary = [
            "C": [makeUserCell(with: "cda")],
            "T": [makeUserCell(with: "t")],
            "Q": [makeUserCell(with: "qa")],
            "S": [makeUserCell(with: "sss")],
            "Y": [makeUserCell(with: "yeah")],
            "Z": [makeUserCell(with: "zzz")]
        ]

        let sorted = usecase.sortAlphabetically(dictionary: dictionary, with: mockedNewUsers)

        XCTAssertTrue(sorted.count == 9, "Number of sections is incorrect")
        XCTAssertTrue(sorted["A"]?.count == 2, "Number of elements in section A is incorrect")
        XCTAssertTrue(sorted["B"]?.count == 2, "Number of elements in section B is incorrect")
        XCTAssertTrue(sorted["C"]?.count == 2, "Number of elements in section C is incorrect")
        XCTAssertTrue(sorted["E"]?.count == 1, "Number of elements in section E is incorrect")
        XCTAssertTrue(sorted["T"]?.count == 1, "Number of elements in section T is incorrect")
        XCTAssertTrue(sorted["Q"]?.count == 1, "Number of elements in section Q is incorrect")
        XCTAssertTrue(sorted["S"]?.count == 1, "Number of elements in section S is incorrect")
        XCTAssertTrue(sorted["Y"]?.count == 1, "Number of elements in section Y is incorrect")
        XCTAssertTrue(sorted["Z"]?.count == 2, "Number of elements in section Z is incorrect")
        XCTAssertTrue(sorted["!"] == nil, "Only sections with alphabet letters should be added")

        // this might not be the best way to test this usecase :) but for the simplicity of this example project i will only test this
    }
}

private extension SortUserItemsUseCaseTests {
    var mockLogins: [String] {
        ["a", "aa", "b", "c", "bb", "z", "!!", "efg"]
    }

    var mockedNewUsers: [User] {
        mockLogins.map(makeUser)
    }

    func makeUser(with login: String) -> User {
        let user = User()
        user.id = UUID().hashValue
        user.login = login
        user.node_id = "node_id"
        user.avatar_url = "avatar_url"
        user.gravatar_id = "gravatar_id"
        user.url = "url"
        user.html_url = "html_url"
        return user
    }

    func makeUserCell(with login: String) -> UserItemCellType {
        let vm = UserItemCellViewModel(user: makeUser(with: login))
        return UserItemCellType.userCellType(vm)
    }
}
