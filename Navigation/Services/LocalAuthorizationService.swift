//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by GiN Eugene on 3/6/2022.
//

import Foundation
import LocalAuthentication

protocol LocalAuthorizationServiceProtocol {
    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, Error>) -> Void)
}

class LocalAuthorizationService: LocalAuthorizationServiceProtocol {
    
    private var laContext: LAContext
    private var canUseBiometric: Bool?
    private var error: NSError?
    var biometryType: LABiometryType?
    
    init(laContext: LAContext) {
        self.laContext = laContext
    }
    
    func checkBiometricAuthorizePossibility() {
        canUseBiometric = laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        
        if let unwrError = error {
            print(unwrError.localizedDescription)
        }
        
        if #available(iOS 11.0, *) {
            switch laContext.biometryType {
            case .faceID:
                biometryType = .faceID
                print("FaceId support")
            case .touchID:
                biometryType = .touchID
                print("TouchId support")
            default:
                biometryType = nil
                print("No Biometric support")
            }
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, Error>) -> Void) {
        if let unwrCanUseBiometric = canUseBiometric {
            guard unwrCanUseBiometric else { return }
            
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authorize") { result, error in
                if let unwrError = error {
                    authorizationFinished(.failure(unwrError))
                    print("Try another method, \(unwrError.localizedDescription)")
                    return
                }
                
                authorizationFinished(.success(result))
                print("Auth: \(result)")
            }
        }
    }
}
