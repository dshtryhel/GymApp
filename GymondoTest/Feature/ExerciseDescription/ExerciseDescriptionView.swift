//
//  ExerciseDescription.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 26.01.2024.
//

import SwiftUI

struct ExerciseDescriptionView: View {
    
    @ObservedObject var viewModel: ExerciseDescriptionViewModel
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 20)
            VStack {
                Image("gymondo_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                Text(viewModel.title)
                    .bold()
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                
                if !viewModel.description.isEmpty {
                    let description: String = viewModel.description.attributedHtmlString?.string ?? viewModel.description
                    Text(description)
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                        .foregroundColor(.white)
                        .background(Color(UIColor.salmon))
                        .cornerRadius(40)
                        .padding(.horizontal, 15)
                }
                Spacer(minLength: 20)
            }
            .background(Color(UIColor.beautyBush))
            .cornerRadius(40)
            .padding(.horizontal, 15)
            
        }.shadow(color: .gray, radius: 60)
        
    }
}

struct ExerciseDescription_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDescriptionView(viewModel: ExerciseDescriptionViewModel(exerciseInfo: Exercise(id: 1, name: "Description", description: "Text")))
    }
}
