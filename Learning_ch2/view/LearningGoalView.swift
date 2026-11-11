//
//  LearningGoal.swift
//  MyApp
//
//  Created by Lujain on 01/06/1448 AH.
//


import SwiftUI
import Playgrounds

struct LearningGoalView: View {
    @State private var learn=""
    @State private var selectedPeriod: LearningPeriod = .week
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20){
                
                Text("I want to learn")
                
                TextField("Swift",text:$learn )
                
                Text("I want to learn it in a ")
                
            }
            HStack(spacing: 12){
                Button("Week"){
                    selectedPeriod = .week
                }.frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            selectedPeriod == .week ? .orange : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)
                    .cornerRadius(22)
                Button("Month"){
                    selectedPeriod = .month
                }.frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            selectedPeriod == .month ? .orange : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)
                
                Button("Year"){
                    selectedPeriod = .year
                }.frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            selectedPeriod == .year ? .orange : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)
                
            }.frame(maxWidth:.infinity, alignment:.leading)
            
                .navigationTitle("Learning Goal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        NavigationLink {
                            CurrentDayView(selectedPeriod: selectedPeriod)
                        }label: {
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(.orange, in: Circle())
                        }
                        .buttonStyle(.plain)
                    }            }
            
            Spacer()
        }
    }
}
#Preview {
    NavigationStack {
        LearningGoalView()
            .preferredColorScheme(.dark)
    }
}

#Playground {
    _ = 1 + 2
}

