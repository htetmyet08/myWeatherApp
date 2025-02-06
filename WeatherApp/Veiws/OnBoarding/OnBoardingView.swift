//
//  OnBoardingView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/4/25.
//

import SwiftUI

struct OnBoardingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State var counter = 0
    @AppStorage("onBoardingFinished") var onBoardingFinished = false
    var buttonText: String {
        switch counter {
        case 0: return "Get Started"
        case 1: return "Next"
        case 2: return "Finish"
        default: return "Next"
        }
    }
    var body: some View {
        VStack {
            TabView(selection: $counter) {
                OnBoard(text1: "Stay ahead of the Weather", photo: "onboard1", text2: "Get real-time forecasts, air quality updates, and health alerts tailored to your needs")
                    .tag(0)
                OnBoard(text1: "More than just Weather", photo: "onboard2", text2: "Know when to go outside, when to stay indoors, and how the weather impacts your health—all in one simple app")
                    .tag(1)
                OnBoard(text1: "Get real-time air quality", photo: "onboard3", text2: "Breathe easy, live better! Our app gives you real-time air quality updates, pollution levels, and health advice")
                    .tag(2)
            }
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            

            Button {
                if counter < 2 {
                    counter += 1
                } else {
                    onBoardingFinished = true
                }
            } label: {
                Text(buttonText)
                    .padding()
                    .frame(width: 150, height: 50)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                    .shadow(radius: 3)
            }
            .padding(.bottom, 40)
        }
    }
}


#Preview {
    OnBoardingView()
        .environmentObject(WeatherViewModel())
}
struct OnBoard: View {
    var text1: String
    var photo: String
    var text2: String
    let screenWidth =  UIScreen.main.bounds.width
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                Text(text1)
                    .padding()
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                Image(photo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.8)
                    .padding(.bottom, 20)
                Text(text2)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
}
