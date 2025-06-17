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

}
