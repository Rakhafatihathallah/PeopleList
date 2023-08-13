//
//  PeopleViewModel.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 30/12/22.
//

import Foundation


final class PeopleViewModel: ObservableObject {
    //private(set) is to be able to get access this property from outside the vm or we dont want give capability to change it
    //from outside
    @Published private(set) var users : [User] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState : ViewState?
    @Published var hasError = false
    
    private var page = 1
    private var totalPages: Int?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    var isFinished: Bool {
        viewState == .finished
    }
    
    
    
    @MainActor
    func fetchUser() async {
        reset()
        viewState = .loading
        defer { viewState = .finished }

        do {
            let response = try await NetworkingManager.shared.request(.people(page: page), type: UserResponse.self)
            self.totalPages = response.totalPages
            self.users = response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfUsers() async {
        
        guard page != totalPages else { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        page += 1
        
        do {
            let response = try await NetworkingManager.shared.request(.people(page: page), type: UserResponse.self)
            self.totalPages = response.totalPages
            self.users += response.data 
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachedEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
}

extension PeopleViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

private extension PeopleViewModel {
    func reset() {
        if viewState == .finished {
            users.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}


//defer = last statement that will get evaluated when everything else is finished
