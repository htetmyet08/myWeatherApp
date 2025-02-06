//
//  PollutantCard.swift
//  WeatherApp
//
//  Created by htetmyet on 2/1/25.
//

import SwiftUI

struct PollutantCard: View {
    var icon: String
    var title: String
    var value: String
    var body: some View {
        VStack{
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue.opacity(0.8))
                .clipShape(Circle())

            Text(title)
                .font(.headline)
                .bold()

            Text(value)
                .font(.caption)
                .bold()
        }
        .frame(width: 180, height: 160)
        .background(RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.3)))
    }
}


#Preview {
    PollutantCard(icon: "gear", title: "gear", value: "6")
}
