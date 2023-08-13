//
//  DetailView.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 11/12/22.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    
    let userId: Int
    @StateObject private var vm = DetailViewModel()
    
    var body: some View {
        ZStack {
            background
            
            if vm.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        
                        
                       avatar
                        
                        Group {
                            general
                            link
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 18 )
                        .background(Theme.detailBackground,
                                    in: RoundedRectangle(cornerRadius: 16,
                                                         style: .continuous))
                    }
                     .padding()
                }
            }
        }
        .navigationTitle("Details")
        .task {
            await vm.fetchDetail(for: userId)
        }
        .alert(isPresented: $vm.hasError, error: vm.error) {
            Button("Retry") { }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    
    //we need jsonMapper for this kind of usecase
    private static var previewUserId: Int {
        let users = try! StaticJSONMapper.decode(file: "UserStaticData",
                                                 type: UserResponse.self)
        return users.data.first!.id
    }
    
    static var previews: some View {
        NavigationView {
            DetailView(userId: previewUserId)
        }
    }
}

//computed property
private extension DetailView {
     
    var background : some View {
        Theme.lightGray
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var link: some View {
        if let supportAbsoluteString = vm.userInfo?.support.url,
           let supportURL = URL(string: supportAbsoluteString),
           let supportText = vm.userInfo?.support.text {
            
            Link(destination: supportURL) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(supportText)
                        .foregroundColor(Theme.text)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    Text(supportAbsoluteString)
                }

                Spacer()
                Symbols.link
                    .font(.system(.title3, design: .rounded))
            }
        }
    }
    
    @ViewBuilder
    //need @ViewBuilder because we cannot return optional view.
    var avatar : some View {
        if let avatarAbsoluteString = vm.userInfo?.data.avatar,
           let avatarURL = URL(string: avatarAbsoluteString) {
            
            KFImage(avatarURL)
                .resizable()
                .placeholder({
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                })
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16,
                                            style: .continuous
                                        ))
        }
    }
}

private extension DetailView {
    
    var general: some View {
        VStack(alignment: .leading, spacing: 8) {
            PillView(id: vm.userInfo?.data.id ?? 0)
            
            //matching style automaticly to all components by using group
            Group {
                firstName
                lastName
                emailName
            }
            .foregroundColor(Theme.text)
        }
        
    }
    
    @ViewBuilder
    var firstName: some View {
        Text("First Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text(vm.userInfo?.data.firstName ?? "-")
            .font(.system(.subheadline, design: .rounded))
        
        Divider()
    }
    
    @ViewBuilder
    var lastName: some View {
        Text("Last Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text(vm.userInfo?.data.lastName ?? "-")
            .font(.system(.subheadline, design: .rounded))
        
        Divider()
        
    }
    
    @ViewBuilder
    var emailName: some View {
        Text("Email")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text(vm.userInfo?.data.email ?? "-")
            .font(.system(.subheadline, design: .rounded))
        
        Divider()
    }
    
}
