//
//  onboardingView.swift
//  MyApp
//
//  Created by Lujain on 29/05/1448 AH.
//
import SwiftUI
import Playgrounds

struct onboardingView: View {
    @State private var learn=""
    @State private var selectedPeriod: LearningPeriod = .week
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 70){
                    Image(systemName: "flame.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.orange)
                        .padding()
                    Text("Hello **Learner**")
                        .font(.system(size: 34))
                        .frame(maxWidth:.infinity, alignment:.leading)
                }
                Group {
                    
                    Text("This app will help you learn everyday!")
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                    
                    Text("I want to learn")
                        .font(.system(size: 16))
                        .font(.headline)
                        .padding()
                    
                    TextField("Swift",text:$learn )
                    
                    Text("I want to learn it in a ")
                        .padding()
                    
                    
                }.frame(maxWidth:.infinity, alignment:.leading)
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
                
                Spacer()
                NavigationLink(destination: CurrentDayView(selectedPeriod: selectedPeriod)) {
                    Text("Start Learning")
                        .frame(width: 151, height: 46)
                        .background(.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(22)
                }
                Text("You can edit your desire later")
            }
           
            
        }
    }
}
#Preview {
    onboardingView()
        .preferredColorScheme(.dark)
}

#Playground {
    _ = 1 + 2
}
