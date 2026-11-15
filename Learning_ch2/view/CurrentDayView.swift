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
    @State private var history = LearningHistoryStore()
    @State private var testTimer: Timer?
    @Environment(\.scenePhase) private var scenePhase
    
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
                            Image(systemName: "pencil.and.outline")
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
                                        if history.isLearned(date) {
                                            Circle()
                                                .fill(
                                                    Color(red: 1, green: 146/255, blue: 48/255)
                                                        .opacity(0.45)
                                                )
                                                .frame(width: 40, height: 40)

                                        } else if history.isFreezed(date) {
                                            Circle()
                                                .fill(
                                                    Color(red: 60/255, green: 211/255, blue: 254/255)
                                                        .opacity(0.45)
                                                )
                                                .frame(width: 40, height: 40)

                                        } else if calendar.isDate(date, inSameDayAs: Date()) {
                                            Circle()
                                                .fill(
                                                    Color(red: 1, green: 146/255, blue: 48/255)
                                                )
                                                .frame(width: 40, height: 40)
                                        }
                                    }                        }
                            .frame(maxWidth: .infinity)
                            
                            
                        }
                    }
                }
                .padding()
                      
                HStack(spacing: 12) {

                    // MARK: - Learned Card

                    VStack {

                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)

                        Text("\(viewModel.streak.currentStreak) \(viewModel.streak.currentStreak == 1 ? "day" : "days")")
                            .font(.system(size: 16))
                            .bold()

                        Text("Learned")
                            .font(.system(size: 12))

                    }
                    .frame(width: 177, height: 102)
                    .background(
                        Color(white: 0.10),
                        in: RoundedRectangle(cornerRadius: 35)
                    )
                    .glassEffect(
                        .regular.tint(Color.black.opacity(0.8)),
                        in: .rect(cornerRadius: 35)
                    )

                    .shadow(
                        color: .white.opacity(0.10),
                        radius: 7,
                        x: 0,
                        y: 2
                    )

                    // MARK: - Freezed Card

                    VStack {

                        Image(systemName: "snowflake")
                            .foregroundStyle(.cyan)

                        Text("\(viewModel.activity.freezedDays) \(viewModel.activity.freezedDays == 1 ? "day" : "days")")
                            .font(.system(size: 16))
                            .bold()

                        Text("Freezed")
                            .font(.system(size: 12))

                    }
                    .frame(width: 177, height: 102)
                    .background(
                        Color(white: 0.10),
                        in: RoundedRectangle(cornerRadius: 35)
                    )
                    .glassEffect(
                        .regular.tint(Color.black.opacity(0.8)),
                        in: .rect(cornerRadius: 35)
                    )
                  
                    .shadow(
                        color: .white.opacity(0.10),
                        radius: 7,
                        x: 0,
                        y: 2
                    )
                }

                
                
                
                VStack {

                    switch viewModel.goalStatus {

                    case .active:

        
                       
                        Button("Log as Learned") {

                            if history.isLearned(Date()) {
                                viewModel.removeLearning()
                                history.removeLearnedDate()
                            } else {
                                viewModel.logLearning()

                                if viewModel.isLearnedToday {
                                    history.addLearnedDate()
                                }
                            }
                        }
                        .frame(width: 272, height: 272)
                        .glassEffect(
                            .regular.tint(
                                history.isLearned(Date())
                                ? Color.black.opacity(0.8)
                                : Color(red: 1, green: 146/255, blue: 48/255)
                            ),
                            in: .circle
                        )
                        .foregroundStyle(
                            history.isLearned(Date())
                            ? Color.gray
                            : Color.white
                        )
                        .font(.system(size: 25, weight: .bold))
                        .disabled(
                            !history.isLearned(Date()) && !viewModel.canLogLearning
                        )



                        Spacer()


                      
                   
                        Button("Freeze for a day") {

                            if history.isFreezed(Date()) {

                                viewModel.removeFreeze()
                                history.removeFreezedDate()

                            } else {

                                viewModel.freezeDay()

                                if viewModel.isFreezedToday {
                                    history.addFreezedDate()
                                }
                            }
                        }
                        .frame(width: 272, height: 46)
                        .glassEffect(
                            .regular.tint(
                                history.isFreezed(Date())
                                ? Color.black.opacity(0.8)
                                : viewModel.canFreeze
                                    ? Color(red: 60/255, green: 211/255, blue: 254/255)
                                    : Color.black.opacity(0.5)
                            ),
                            in: .rect(cornerRadius: 22)
                        )
                        .foregroundStyle(
                            history.isFreezed(Date())
                            ? Color.gray
                            : viewModel.canFreeze ? Color.white : Color.gray.opacity(0.6)
                        )
                        .font(.system(size: 25))
                        .disabled(
                            !history.isFreezed(Date()) && !viewModel.canFreeze
                        )

                        
                        Text(
                            "\(viewModel.activity.freezedDays) out of \(viewModel.maxFreezes) Freezes used"
                        )

                    case .expired:

                        Spacer()

                        Image(systemName: "xmark.seal.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.orange)

                        Text("You didn't reach your goal this time.")
                            .font(.system(size: 28, weight: .bold))

                        Text("Want to set another goal?")
                            .foregroundStyle(.gray)

//                        Button("set a goal"){
//                            
//                        }label:{
//                            
//                        }
//                        
                        Spacer()

                    case .done:

                        Spacer()

                        Image(systemName: "hands.clap.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.orange)

                        Text("Will done!")
                            .font(.system(size: 28, weight: .bold))

                        Text("Ready for your next goal?")
                            .foregroundStyle(.gray)

                        Spacer()
                    }
                }            }
        }
        .onAppear {
            viewModel.updateStreak()

            testTimer?.invalidate()

            testTimer = Timer.scheduledTimer(
                withTimeInterval: 1,
                repeats: true
            ) { _ in
                viewModel.updateStreak()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.updateStreak()
            }
        }
        .onDisappear {
            testTimer?.invalidate()
            testTimer = nil
        }
    }
    
}

#Preview {
    CurrentDayView(selectedPeriod: .week)
        .preferredColorScheme(.dark)
}
