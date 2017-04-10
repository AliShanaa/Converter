//
//  ConverterTests.swift
//  ConverterTests
//
//  Created by Ali on 4/10/17.
//  Copyright © 2017 Ali. All rights reserved.
//

import XCTest
@testable import Converter

class ConverterTest: XCTestCase {
    
    func testConverterInitializer() {
        
        let incorrectUrl = "it's not a url"
        let validUrl = "https://vk.com"
        let validApiTwo = "https://api.fixer.io/latest"
        
        var converter = Converter(source: incorrectUrl)
        XCTAssertNil(converter)
        converter = Converter(source: validUrl)
        XCTAssertNil(converter)
        converter = Converter(source: validApiTwo)
        XCTAssertNotNil(converter)
        
    }
    
    func testConverter() {
        let validApiOne = "https://openexchangerates.org/api/latest.json?app_id=e999ef8c12de48039b1c1ceb2f9bbfc6"
        let converter = Converter(source: validApiOne)!
        XCTAssertNotNil(converter)
        
        /// numberOfCurrencies() -> Int
        XCTAssertTrue(converter.numberOfCurrencies ==  6)
        ///
        
        /// get() ->
        let numberOfCorrenciesFromApi = 159
        XCTAssertTrue(converter.get().count == numberOfCorrenciesFromApi)
        
        /// getCountry() -> String
        XCTAssertNoThrow(try converter.getRate(with: "EUR"))
        XCTAssertNoThrow(try converter.getRate(with: "USD"))
        XCTAssertThrowsError(try converter.getRate(with: "NOT ISO4217"))
        
        ///
        converter.deleteCurrency(with: "AUD")
        XCTAssertTrue(converter.numberOfCurrencies ==  5)
        converter.addCurrency(with: "AUD")
        XCTAssertTrue(converter.numberOfCurrencies ==  6)
        
        /// searchBar emulation
        converter.filter(with: "NOT VALID REQUEST")
        XCTAssertEqual(converter.numberOfCurrencies, 0)
        
        /// searchBar emulation
        converter.filter(with: "Eur")
        XCTAssertNotEqual(converter.numberOfCurrencies, 0)
        
        ///
        converter.convert(str: "EUR", value: 0)
        converter.filter(with: "")
        XCTAssertEqual(try! converter.getRate(with: "EUR"), "0")
    }
}
