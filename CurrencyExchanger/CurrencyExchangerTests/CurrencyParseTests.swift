//
//  CurrenceParseTests.swift
//  CurrencyExchangerTests
//
//  Created by Katerina Kostritsyna on 29.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import XCTest

class CurrencyParseTests: XCTestCase {
    
    var currenciesJSON: [String : Any] = ["currencies": [
        "AED": "United Arab Emirates Dirham",
        "ALL": "Albanian Lek",]]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCurrenciesParsingAsArray() {
        let jsonData = try! JSONSerialization.data(withJSONObject: currenciesJSON, options: .fragmentsAllowed)
        let currencies = try! JSONDecoder().decode(Currencies.self, from: jsonData)
        var array = currencies.asArray
        XCTAssertEqual(array.count, 2)
        array.sort(by: {$0.currencySymbol < $1.currencySymbol})
        let currency1 = array[0]
        XCTAssertEqual(currency1.currencyName, "United Arab Emirates Dirham")
        XCTAssertEqual(currency1.currencySymbol, "AED")
        
        let currency2 = array[1]
        XCTAssertEqual(currency2.currencyName, "Albanian Lek")
        XCTAssertEqual(currency2.currencySymbol, "ALL")
    }
}
