//
//  ContentView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/2/24.
//

import SwiftUI
import UIKit


// MARK: - Main Content View

struct ContentView: View {
    @StateObject private var viewModel = MahjongViewModel()
    @State private var isSheetPresented = false
    @State private var selectedCount = 0
    @State private var currentDetent: PresentationDetent = .medium
    @State private var showBreakdown: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(viewModel: viewModel)
                    TileSectionView(viewModel: viewModel)
                }
                .padding()
                .padding(.bottom, 30)
            }
            .refreshable {
                await performRefresh()
            }
            
            StickyBarView(
                selectedCount: viewModel.selectedTilesCount,
                onTap: { isSheetPresented = true },
                calculateScore: viewModel.calculateScore
            )
        }
        .padding(.top, 50)
        .background(Color(red: 12/255, green: 13/255, blue: 13/255))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isSheetPresented) {
            HandScoreView(
                viewModel: viewModel,
                currentDetent: $currentDetent, 
                showBreakdown: $showBreakdown
                )
                .background(Color(red: 26/255, green: 27/255, blue: 29/255))
                .ignoresSafeArea()
                .presentationDetents([.medium, .large], selection: $currentDetent)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
        }
    }
    
    func performRefresh() async {
        // Simulate a brief delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Reset tiles
        viewModel.resetTiles()
        
        // Trigger haptic feedback
        HapticFeedbackManager.triggerLightFeedback()
    }
    
}



// MARK: - Preview

#Preview {
    ContentView()
}
