//
//  ConvertationParsinfTests.swift
//  CurrencyExchangerTests
//
//  Created by Kate Dundukova on 31.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import XCTest

class ConvertationParsinfTests: XCTestCase {
    
    var json: [String: Any] = [
        "amount": "2.0000",
        "base_currency_code": "AUD",
        "base_currency_name": "Australian Dollar",
        "rates": [
            "AED": [
                "currency_name": "United Arab Emirates Dirham",
                "rate": "2.2559",
                "rate_for_amount": "4.5119"
            ]
        ],
        "status": "success",
        "updated_date": "2020-03-31"
    ]
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        let convertationResult = try! JSONDecoder().decode(ConvertationResult.self, from: jsonData)
        let value = convertationResult.value
        XCTAssertEqual(value.rate_for_amount, "4.5119")
    }
    
}
