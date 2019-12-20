//
//  KeychainFuncs.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-12-19.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import Foundation
import KeychainAccess

private let keychain = Keychain(service: "org.jbsystems.qrCodeScannerTest")
private let tokenKey = "token"

func setToken(token: String) {
    do {
        try keychain.set(token, key: tokenKey)
    } catch {
        print(error)
    }
}
func getToken() -> String? {
    do {
        let token = try keychain.get(tokenKey)
        return token
    } catch {
        print(error)
        return nil
    }
}
func deleteToken() {
    do {
        try keychain.remove(tokenKey)
    } catch {
        print(error)
    }
}
