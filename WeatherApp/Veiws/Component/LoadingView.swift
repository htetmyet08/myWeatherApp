//
//  LoadingView.swift
//  WeatherApp
//
//  Created by htetmyet on 1/17/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(width: 90, height: 40)
    }
}

#Preview {
    LoadingView()
}
