//
//  CurrenceParseTests.swift
//  CurrencyExchangerTests
//
//  Created by Katerina Kostritsyna on 29.03.2020.
//  Copyright © 2020 Katerina Kostritsyna. All rights reserved.
//

import XCTest

class CurrenceParseTests: XCTestCase {
    var fullCurrencyJSON: [String : Any] = ["currencyName" : "Albanian Lek",
                                            "currencySymbol": "Lek",
                                            "id": "ALL"
    ]
    
    var currencyWithoutSymbolJSON: [String : Any] = ["currencyName" : "Albanian Lek",
                                                     "id": "ALL"
    ]
    
    var incorrectCurrencyJSON: [String : Any] = ["currencySymbol": "Lek",
                                                 "id": "ALL"
    ]
    
    var currenciesJSON: [String : Any] = [ "results" : ["ALL" : ["currencyName" : "Albanian Lek",
                                                                 "currencySymbol": "Lek",
                                                                 "id": "ALL"],
                                                        
                                                        "XCD" : ["currencyName": "East Caribbean Dollar",
        "currencySymbol": "$",
        "id": "XCD"]]]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParseFullCurrency() {
        let jsonData = try! JSONSerialization.data(withJSONObject: fullCurrencyJSON, options: .fragmentsAllowed)
        let currency = try! JSONDecoder().decode(Currency.self, from: jsonData)
        XCTAssertEqual(currency.id, "ALL")
        XCTAssertEqual(currency.currencyName, "Albanian Lek")
        XCTAssertEqual(currency.currencySymbol, "Lek")
    }
    
    func testParseCurrencyWithoutSymbol() {
        let jsonData = try! JSONSerialization.data(withJSONObject: currencyWithoutSymbolJSON, options: .fragmentsAllowed)
        let currency = try! JSONDecoder().decode(Currency.self, from: jsonData)
        XCTAssertEqual(currency.id, "ALL")
        XCTAssertEqual(currency.currencyName, "Albanian Lek")
        XCTAssertNil(currency.currencySymbol)
    }
    
    func testCurrencyWithoutNameCauseError() {
        let jsonData = try! JSONSerialization.data(withJSONObject: incorrectCurrencyJSON, options: .fragmentsAllowed)
        var exception: Error? = nil
        do {
            _ = try JSONDecoder().decode(Currency.self, from: jsonData)
        } catch let e {
            exception = e
        }
        XCTAssertNotNil(exception)
    }
    
    func testCurrenciesParsing() {
        let jsonData = try! JSONSerialization.data(withJSONObject: currenciesJSON, options: .fragmentsAllowed)
        let currencies = try! JSONDecoder().decode(Currencies.self, from: jsonData)
        XCTAssertEqual(currencies.results.count, 2)
        let currency1 = currencies.results["ALL"]
        XCTAssertEqual(currency1?.id, "ALL")
        XCTAssertEqual(currency1?.currencyName, "Albanian Lek")
        XCTAssertEqual(currency1?.currencySymbol, "Lek")
        
        let currency2 = currencies.results["XCD"]
        XCTAssertEqual(currency2?.id, "XCD")
        XCTAssertEqual(currency2?.currencyName, "East Caribbean Dollar")
        XCTAssertEqual(currency2?.currencySymbol, "$")
    }
    
    func testCurrenciesParsingAsArray() {
        let jsonData = try! JSONSerialization.data(withJSONObject: currenciesJSON, options: .fragmentsAllowed)
        let currencies = try! JSONDecoder().decode(Currencies.self, from: jsonData)
        var array = currencies.asArray
        XCTAssertEqual(array.count, 2)
        array.sort(by: {$0.id < $1.id})
        let currency1 = array[0]
        XCTAssertEqual(currency1.id, "ALL")
        XCTAssertEqual(currency1.currencyName, "Albanian Lek")
        XCTAssertEqual(currency1.currencySymbol, "Lek")
        
        let currency2 = array[1]
        XCTAssertEqual(currency2.id, "XCD")
        XCTAssertEqual(currency2.currencyName, "East Caribbean Dollar")
        XCTAssertEqual(currency2.currencySymbol, "$")
    }
}
