//
//  PersonItemView.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 10/12/22.
//

import SwiftUI
import Kingfisher

struct PersonItemView: View {
    
    let user: User
    
    var body: some View {
        VStack(spacing: .zero) {
            
            
            AsyncImage(url: URL(string: user.avatar)) { Image in
                Image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 130)
                    .clipped()
            } placeholder: {
                ProgressView()
            }

                

            
            VStack(alignment: .leading) {
                
                PillView(id: user.id)
                
                Text("\(user.firstName) \(user.lastName)")
                    .foregroundColor(.primary)
                    .font(.system(.body, design: .rounded))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Theme.detailBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16,
                                    style: .continuous
        ))
        .shadow(color: Theme.text.opacity(0.1),
                radius: 2,
                x: 0,
                y: 1)
    }
}

struct PersonItemView_Previews: PreviewProvider {
    
    static var previewUser: User {
        //assuming that we never fail to get the data
        //because atleast there will be 1 user to get
        let users = try! StaticJSONMapper.decode(file: "UserStaticData",
                                                 type: UserResponse.self)
        return users.data.first!
    }
    
    static var previews: some View {
        PersonItemView(user: previewUser)
            .frame(width: 250)
    }
}
