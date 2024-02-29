//
//  ApiCaller.swift
//  CombineMVVMTest
//
//  Created by Vitaliy Halai on 29.02.24.
//

import Foundation
import Combine

class ApiCaller {
    static let shared = ApiCaller()
    
    func fetchCompanies() -> Future<[String], Never> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(.success(["Apple", "Google", "Microsoft", "Faceboook"]))
            }
        }
    }
}
