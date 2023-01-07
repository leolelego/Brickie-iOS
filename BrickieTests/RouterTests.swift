import XCTest

@testable import Brickie_Debug

final class RouterTests: XCTestCase {
    func testLoginURL_QueryParams() {
        let mockUsername = "lego-user"
        let mockPassword = "regular_password-with-no_plus"
        let expectedURLString = "https://brickset.com/api/v3.asmx/login?apiKey=mock-api-key&username=lego-user&password=regular_password-with-no_plus"
        let url = APIRouter<String>
            .login(mockUsername, mockPassword)
            .url

        XCTAssertEqual(url?.absoluteString, expectedURLString)
    }

    func testLoginURL_QueryParamsPasswordHasPlusSign_EncodesCorrectly() throws {
        let mockUsername = "lego-user"
        let mockPassword = "123+456"
        let expectedURLString = "https://brickset.com/api/v3.asmx/login?apiKey=mock-api-key&username=lego-user&password=123%2B456"
        let url = APIRouter<String>
            .login(mockUsername, mockPassword)
            .url

        XCTAssertEqual(url?.absoluteString, expectedURLString)
    }
}
