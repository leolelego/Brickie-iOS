import XCTest

@testable import Brickie

final class RouterTests: XCTestCase {
//    func testLoginURL_QueryParams() {
//        let mockUsername = "lego-user"
//        let mockPassword = "regular_password-with-no_plus"
//        let expectedURLString = "https://brickset.com/api/v3.asmx/login?apiKey=mock-api-key&username=lego-user&password=regular_password-with-no_plus"
//        let url = APIRouter<String>
//            .login(mockUsername, mockPassword)
//            .url
//
//        XCTAssertEqual(url?.absoluteString, expectedURLString)
//    }
//
//    func testLoginURL_QueryParamsPasswordHasPlusSign_EncodesCorrectly() throws {
//        let mockUsername = "lego-user"
//        let mockPassword = "123+456"
//        let expectedURLString = "https://brickset.com/api/v3.asmx/login?apiKey=mock-api-key&username=lego-user&password=123%2B456"
//        let url = APIRouter<String>
//            .login(mockUsername, mockPassword)
//            .url
//
//        XCTAssertEqual(url?.absoluteString, expectedURLString)
//    }
    
    func testGetTheme() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")

        APIRouter<[[String:Any]]>.themes.responseJSON{ response in
    
        
            print(response)
        
            switch response {
                
            case .success(let _):
                log("OK")

//                self.themes = data
//                for theme in data {
//                    if(theme.setCount == 0 ){
//                        log("WTF")
//                    }
//                    if(theme.subthemeCount != 0 ){
//
//                        APIRouter<[[String:Any]]>.subthemes(theme.theme).decode(ofType: [LegoTheme.Subtheme].self) { response in
//                        switch response {
//                        case .success(let data):
//                            self.subthemes.append(contentsOf: data.filter {$0.subtheme != "{None"})
//                            break
//                        case .failure:break
//                        }
//                    }
//                    }
//                }
//
                break
            case .failure:
                log("Themes Load failed UI")
                
                break
            }
        }
        wait(for: [expectation], timeout: 10.0)

    }
}
