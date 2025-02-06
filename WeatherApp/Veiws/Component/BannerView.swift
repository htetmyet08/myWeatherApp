//
//  BannerView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/1/25.
//

import SwiftUI

struct BannerView: View {
    var title: String
    var index: String
    var description: String
    var customBackground: LinearGradient
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            
            Text(index)
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, -8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(customBackground)
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.3), lineWidth: 1))
        .padding(.horizontal)
    }
}
#Preview {
    BannerView(
        title: "title",
        index: "2",
        description: "hello",
        customBackground: LinearGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.blue.opacity(0.5)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
