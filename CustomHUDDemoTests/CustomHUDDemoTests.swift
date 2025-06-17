//
//  CustomHUDDemoTests.swift
//  CustomHUDDemoTests
//
//  Created by Allen_Hsu on 2025/5/2.
//

import Testing
@testable import CustomHUDDemo

struct CustomHUDDemoTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

  @Test func testNetHexInitializer() async throws {
      let color = UIColor(netHex: 0xFF0000)
      #expect(color == UIColor(red: 1, green: 0, blue: 0, alpha: 1))
  }

  @Test func testCreateMutableString() async throws {
      let message = "Hello"
      let attr = CustomHUD.createMutableString(message: message)
      #expect(attr?.string == message)
      let attributes = attr?.attributes(at: 0, effectiveRange: nil)
      let color = attributes?[.foregroundColor] as? UIColor
      let font = attributes?[.font] as? UIFont
      #expect(color == UIColor(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1))
      #expect(font?.pointSize == 16)
  }

  @Test func testCreateMutableStringNil() async throws {
      let attr = CustomHUD.createMutableString(message: nil)
      #expect(attr == nil)
  }

}
