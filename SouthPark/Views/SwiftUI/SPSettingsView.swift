//
//  SPSettingsView.swift
//  SouthPark
//
//  Created by Nazar on 15.06.2023.
//

import SwiftUI

struct SPSettingsView: View {
    
    let viewModel: SPSettingsViewViewModel
    
    init(viewModel: SPSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                
                   Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct SPSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SPSettingsView(viewModel: .init(cellViewModels: SPSettingsOption.allCases.compactMap({
            return SPSettingsCellViewModel(type: $0) { option in
                
            }
        })))
    }
}
