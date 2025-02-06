//
//  RectangleView.swift
//  WeatherApp
//
//  Created by htetmyet on 1/31/25.
//

import SwiftUI

struct RectangleView: View {
    var caption: String
    var text1: String
    var text2: String
    var customColor: LinearGradient
    var body: some View {
        VStack {
            Image(systemName: caption)
                .font(.title)
            Text(text1)
            Text(text2)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(RoundedRectangle(cornerRadius: 10).fill(customColor))
    }
}
#Preview {
    RectangleView(caption: "sun.max", text1: "text1", text2: "text2", customColor: LinearGradient(
        gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.blue.opacity(0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    ))
}
