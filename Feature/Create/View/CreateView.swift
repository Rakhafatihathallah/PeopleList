//
//  CreateView.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 16/12/22.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = CreateViewModel()
    @FocusState private var focusField: Field?
    let successfulAction: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    firstName
                    lastName
                    job
                } footer: {
                    if case .validation(let err) = vm.error,
                       let errorDesc = err.errorDescription {
                        Text(errorDesc)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    submit
                }
            }
            .disabled(vm.state == .submitting)
            .navigationTitle("Create")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    done
                }
            }
            .onChange(of: vm.state) { formState in
                if formState == .successful {
                    dismiss()
                    successfulAction()
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) { }
            .overlay {
                if vm.state == .submitting {
                    ProgressView()
                }
            }
        }
    }
}

extension CreateView {
    enum Field: Hashable {
        case firstName
        case lastName
        case job
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView {}
    }
}
 
private extension CreateView {
    
    var done: some View {
        Button("Done") {
            dismiss()
        }
    }
    
    var firstName: some View {
        TextField("First Name", text: $vm.person.firstName)
            .focused($focusField, equals: .firstName)
    }
    var lastName: some View {
        TextField("Last Name", text: $vm.person.lastName)
            .focused($focusField, equals: .lastName)
    }
    var job: some View {
        TextField("Job", text: $vm.person.job)
            .focused($focusField, equals: .job)
    }
    
    var submit: some View {
        Button("Submit") {
            focusField = nil
            Task {
                await vm.create()
            }
        }
    }
    
}
