//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by GiN Eugene on 3/6/2022.
//

import Foundation
import LocalAuthentication

protocol LocalAuthorizationServiceProtocol {
    func checkBiometricAuthorizePossibility()
    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, Error>) -> Void)
}

class LocalAuthorizationService: LocalAuthorizationServiceProtocol {
    //MARK: - props
    private var localAuthContext: LAContext
    private var canUseBiometric: Bool?
    private var error: NSError?
    var biometryType: LABiometryType?
    
    //MARK: - init
    init(localAuthContext: LAContext) {
        self.localAuthContext = localAuthContext
    }
    //MARK: - methods
    func checkBiometricAuthorizePossibility() {
        canUseBiometric = localAuthContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        
        if let unwrError = error {
            print(unwrError.localizedDescription)
        }
        
        if #available(iOS 11.0, *) {
            switch localAuthContext.biometryType {
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
            
            localAuthContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authorize") { result, error in
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
