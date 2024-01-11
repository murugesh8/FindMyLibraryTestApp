import XCTest
import Combine
import Alamofire

@testable import FindMyIPLibraryProject

final class FIndMyAppTestProjectTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    var getIpViewModel: GetIPViewModel?
    
    var mockNetwork:MockNetworkManager?
   
    public override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let mockNetworkManager = MockNetworkManager()
        self.getIpViewModel = GetIPViewModel(networking: mockNetworkManager)
        self.mockNetwork = getIpViewModel?.networking as? MockNetworkManager

    }

    public override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.getIpViewModel = nil
        self.mockNetwork = nil
        super.tearDown()
    }

    func testGetIPAPISuccess(){

        let expectation = XCTestExpectation(description: "Get IP API call expectation")

        let expected = GetIPAPIResponse(ip: "192.168.1.1", network: "2405:201:e000", version: "", city: "Chennai", region: "Tamil Nadu", regionCode: "TN", country: "IN", countryName: "India", countryCode: "IN", countryCodeIso3: "04", countryCapital: "New Delhi", countryTLD: ".in", continentCode: "1020", inEu: true, postal: "600001", latitude: 10.500, longitude: 102, timezone: "", utcOffset: "", countryCallingCode: "", currency: "", currencyName: "", languages: "", countryArea: 10, countryPopulation: 11, asn: "", org: "")

        self.mockNetwork?.shouldReturnError = false
        
        self.mockNetwork?.getIP()
                   .sink { completion in
                       switch completion {
                       case .failure:
                           XCTFail("Expected a successful completion")
                       case .finished:
                           break
                       }
                   } receiveValue: { value in
                       XCTAssertEqual(value, expected) // Adjust based on your expected response
                       expectation.fulfill()
                   }
                   .store(in: &cancellables)
   

            wait(for: [expectation], timeout: 1.0)

            // Assert any expectations or outcomes here
    }
    
    
    func testGetIPFailure() {
        let expectation = XCTestExpectation(description: "Get IP API call expectation")

        // Set up your mock networking to return an error
      

        self.mockNetwork?.shouldReturnError = true
        
        let expectedError = AFError.invalidURL(url: "https://ipapi./json/")
        
        self.mockNetwork?.getIP()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected a failure completion")
                }
            } receiveValue: { _ in
                XCTFail("Expected a failure value")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

}
