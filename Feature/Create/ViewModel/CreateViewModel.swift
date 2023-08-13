//
//  CreateViewModel.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 01/01/23.
//

import Foundation


final class CreateViewModel: ObservableObject {
    
    @Published var person = NewPerson()
    //private(set) = read only, cant make changes
    @Published private(set) var state: SubmissionState?
    @Published private(set) var error: FormError?
    @Published var hasError = false
    
    private let validator = CreateValidator()
    
    @MainActor
    func create() async {
        
        do {
            
            try validator.validate(person)
            
            state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(person)
            
            try await NetworkingManager.shared.request(.create(submissionData: data))
            
            //if submission doesn't throw any error so the state will be successful
            state = .successful
            
        } catch {
            
            self.hasError = true
            self.state = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            case is CreateValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
         
    }
    
}

extension CreateViewModel {
    
    enum SubmissionState {
        case successful
        case unsuccessful
        case submitting
    }
    
}

extension CreateViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(let error),
             .validation(let error):
            return error.errorDescription
        case .system(let error):
            return error.localizedDescription
        }
    }
}
