//
//  CurrentDay.swift
//  MyApp
//
//  Created by Lujain on 29/05/1448 AH.
//
import SwiftUI
import Playgrounds

struct CurrentDayView: View {
    @State private var viewModel: CurrentDayViewModel
    
    init(selectedPeriod: LearningPeriod) {
        _viewModel = State(
            initialValue: CurrentDayViewModel(
                selectedPeriod: selectedPeriod
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            let calendar = Calendar.current
            
            
            VStack{
                HStack{
                    Text("Activity")
                        .font(.system(size: 40))
                    // .bold()
                        .fontWeight(.heavy)
                    Spacer()
                    Group{
                        NavigationLink{
                            BeginningView()
                        }label:{
                            Image(systemName: "calendar")
                        }.frame(width: 44,height: 44)
                       // NavigationLink(destination:LearningGoalView){
                        NavigationLink {
                            LearningGoalView()
                            }label:{
                                Image(systemName: "pencil.circle")
                            }.frame(width: 44,height: 44)
                            
                            
                        }.glassEffect()
                            .foregroundStyle(.white)
                    }
                //}
                Text(Date(), format: .dateTime
                    .weekday(.wide)
                    .day()
                    .month(.wide)
                ).frame(maxWidth:.infinity, alignment:.leading)
                    .foregroundStyle(.gray)
                
                HStack(spacing: 12) {
                    
                    ForEach(0..<7, id: \.self) { day in
                        
                        if let startOfWeek = calendar.dateInterval(
                            of: .weekOfYear,
                            for: Date()
                        )?.start,
                           
                            let date = calendar.date(
                                byAdding: .day,
                                value: day,
                                to: startOfWeek
                            ) {
                            
                            VStack(spacing: 8) {
                                
                                Text(date, format: .dateTime.weekday(.narrow))
                                    .font(.system(size:18))
                                    .font(.caption)
                                //.foregroundStyle(Color())
                                
                                
                                Text(date, format: .dateTime.day())
                                    .font(.system(size:18))
                                    .font(.headline)
                                    .background {
                                        if calendar.isDate(date, inSameDayAs: Date()) {
                                            Circle()
                                                .fill(
                                                    viewModel.activity.isFreezed
                                                    ? Color.blue
                                                    : Color.orange
                                                )
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                
                            }
                            .frame(maxWidth: .infinity)
                            
                            
                        }
                    }
                }
                .padding()
                
                HStack{
                    
                    VStack{
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(viewModel.activity.learnedDays) \(viewModel.activity.learnedDays == 1 ? "day" : "days")")
                            .font(.system(size: 16))
                            .bold()
                        Text("Learned")
                            .font(.system(size: 12))
                        
                    }.frame(width: 177,height: 102)
                        .glassEffect(.regular.tint(Color(.black).opacity(0.8)),in:
                                .rect(cornerRadius: 35))
                    //                    .overlay {
                    //                        RoundedRectangle(cornerRadius: 35)
                    //                            .stroke(
                    //                                LinearGradient(
                    //                                    colors: [
                    //                                        .white.opacity(0.2),
                    //                                        .white.opacity(0.2),
                    //                                        .white.opacity(0.2)
                    //                                    ],
                    //                                    startPoint: .top,
                    //                                    endPoint: .bottom
                    //                                ),
                    //                                lineWidth: 1.5
                    //                            )
                    //                    }
                    //                    .shadow(
                    //                        color: .white.opacity(0.12),
                    //                        radius: 6,
                    //                        x: 0,
                    //                        y: 2
                    //                    )
                    
                    
                    VStack{
                        Image(systemName: "snowflake")
                            .foregroundColor(.blue)
                        Text("\(viewModel.activity.freezedDays) \(viewModel.activity.freezedDays == 1 ? "day" : "days")")
                            .font(.system(size: 16))
                            .bold()
                        Text("Freezed")
                            .font(.system(size: 12))
                        
                    }.frame(width: 177,height: 102)
                        .glassEffect(.regular.tint(Color(.black).opacity(0.8)),in:
                                .rect(cornerRadius: 35))
                        .overlay {
                            RoundedRectangle(cornerRadius: 35)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.2),
                                            .white.opacity(0.2),
                                            .white.opacity(0.2)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1.5
                                )
                        }
                        .shadow(
                            color: .white.opacity(0.12),
                            radius: 6,
                            x: 0,
                            y: 2
                        )
                    
                }
                
                
                
                
                
                
                
                Button("Log as Learned"){
                    viewModel.logLearning()
                }   .frame(width: 272, height: 272)
                    .background(.orange)
                    .foregroundStyle(.white)
                    .cornerRadius(272)
                    .font(.system(size: 25))
                    .bold()
                
                Spacer()
                Button("Freeze for a day"){
                    
                    viewModel.freezeDay()
                    
                }.frame(width: 272, height: 46)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(22)
                    .font(.system(size: 25))
                
                Text("\(viewModel.activity.freezedDays) out of \(viewModel.maxFreezes) Freezes used")
            }
        }
    }
    
}

#Preview {
    CurrentDayView(selectedPeriod: .week)
        .preferredColorScheme(.dark)
}
