//
//  AuthValidatorTests.swift
//  MainTargetTests
//
//  Created by o.sander on 20.06.2023.
//  
//

import XCTest
@testable import MainTarget

final class AuthValidatorTests: XCTestCase {

    func testValidPassword() {
        let validPassword = "SecurePwd123"
        let validErrors = Auth.Validator.validate(password: validPassword)

        XCTAssertTrue(validErrors.isEmpty, "Valid password should not have any errors")
    }

    func testEmptyPassword() {
        let emptyPassword = ""
        let errors = Auth.Validator.validate(password: emptyPassword)

        XCTAssertFalse(errors.isEmpty, "Empty password should have errors")
        XCTAssertTrue(errors.contains(Auth.PasswordError.empty))

        let passwordWithWiteSpaces = " \t \n \r "
        let errorsForWiteSpacesAndNewLines = Auth.Validator.validate(password: passwordWithWiteSpaces)
        XCTAssertTrue(errorsForWiteSpacesAndNewLines.contains(Auth.PasswordError.empty))
    }

    func testPasswordWithoutDigit() {
        let passwordWithoutDigit = "Abcdefgh"
        let errors = Auth.Validator.validate(password: passwordWithoutDigit)

        XCTAssertFalse(errors.isEmpty, "Password without digit should have errors")
        XCTAssertTrue(errors.contains(Auth.PasswordError.oneDigit))
    }

    func testPasswordWithoutLowercase() {
        let passwordWithoutLowercase = "ABCDEFGH1\n2_13"
        let errors = Auth.Validator.validate(password: passwordWithoutLowercase)

        XCTAssertFalse(errors.isEmpty, "Password without lowercase should have errors")
        XCTAssertTrue(errors.contains(Auth.PasswordError.oneLowerChar))
    }

    func testPasswordWithoutUppercase() {
        let passwordWithoutLowercase = "asdfwqer\n2_13"
        let errors = Auth.Validator.validate(password: passwordWithoutLowercase)

        XCTAssertFalse(errors.isEmpty, "Password without uppercase should have errors")
        XCTAssertTrue(errors.contains(Auth.PasswordError.oneUpperChar))
    }

    func testPasswordLength() {

        let longPassword = "ThisIsALongPasswordWithMoreThan32Characters"
        let longErrors = Auth.Validator.validate(password: longPassword)
        XCTAssertFalse(longErrors.isEmpty, "Long password should have errors")
        XCTAssertTrue(longErrors.contains(Auth.PasswordError.length))

        let shortPassword = "Pwd123"
        let shortErrors = Auth.Validator.validate(password: shortPassword)
        XCTAssertFalse(shortErrors.isEmpty, "Short password should have errors")
        XCTAssertTrue(shortErrors.contains(Auth.PasswordError.length))
    }

    func testValidEmail() {
        let validEmail = "test@example.com"
        let validationErrors = Auth.Validator.validate(email: validEmail)

        XCTAssertTrue(validationErrors.isEmpty, "Valid email should not have any errors")
    }

    func testEmptyEmail() {
        let emptyEmail = ""
        let validationErrors = Auth.Validator.validate(email: emptyEmail)

        XCTAssertEqual(validationErrors.first, .empty)
    }

    func testInvalidFormatEmail() {
        let invalidFormatEmail = "invalid-email"
        let validationErrors = Auth.Validator.validate(email: invalidFormatEmail)

        XCTAssertEqual(validationErrors.count, 1, "Invalid format email should have one error")
        XCTAssertEqual(validationErrors.first, .invalidFormat)
    }

    func testLongEmail() {
        let longEmail = "a" + String(repeating: "b", count: 254) + "@example.com"
        let validationErrors = Auth.Validator.validate(email: longEmail)

        XCTAssertEqual(validationErrors.count, 1, "Long email should have one error")
        XCTAssertEqual(validationErrors.first, .length)
    }
}
