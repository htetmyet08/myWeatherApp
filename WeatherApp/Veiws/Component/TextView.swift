//
//  TextView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/1/25.
//

import SwiftUI

struct TextView: View {
    var caption: String
    var source: String
    var hazard: String
    var body: some View {
        VStack(alignment: .leading){
            Text(caption)
                .fontWeight(.semibold)
            Text(source)
            Text(hazard)
        }
        .padding(.bottom, 15)
    }
}
#Preview {
    TextView(caption: "caption", source: "source", hazard: "hazard")
}
