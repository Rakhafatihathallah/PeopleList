//
//  CheckmarkPopoverView.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 03/01/23.
//

import SwiftUI

struct CheckmarkPopoverView: View {
    var body: some View {
        Symbols.checkmark
            .font(.system(.title, design: .rounded).bold())
            .padding()
            .background(.thinMaterial,
                        in: RoundedRectangle(cornerRadius: 10,style: .continuous))
    }
}

struct CheckmarkPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        CheckmarkPopoverView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.blue)
    }
}
