//
//  HandScoreView.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/21/24.
//

import SwiftUI
import UIKit


// MARK: - Hand Score View
struct HandScoreView: View {
    @ObservedObject var viewModel: MahjongViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var currentDetent: PresentationDetent
    @Binding var showBreakdown: Bool
    
    private var totalPoints: Int {
        let windPoints = viewModel.seatWindPoints + viewModel.prevailingWindPoints
        let bonusPoints = viewModel.selfDrawnPoints + viewModel.concealedHandPoints
        let basePoints = viewModel.handPoints + viewModel.flowerPoints + viewModel.dragonPoints
        return windPoints + bonusPoints + basePoints
    }
    
    private var pointsMessage: String {
        switch totalPoints {
        case 13:
            return "You’ve achieved the impossible!"
        case 12:
            return "That’s a legendary win!"
        case 11:
            return "Unbelievable hand! That’s a huge score!"
        case 10:
            return "Wow! That’s a powerful hand!"
        case 8...9:
            return "Impressive hand! You’re on fire!"
        case 7:
            return "Getting serious now! You’re in the game!"
        case 5...6:
            return "Great job! You’re stacking up nicely!"
        case 4:
            return "Solid hand! You’re building up!"
        case 3:
            return "A good hand—keep up the pace!"
        case 1...2:
            return "A small win! Every point counts!"
        case 0:
            if viewModel.handMessage == "Chicken Hand" {
                return "Chicken Hand! Better luck next time!"
            } else {
                return "Oh no! That’s not a valid hand!"
            }
        default:
            return "Total Points"
        }
    }
        
    private var handTypeEmoji: String {
        switch viewModel.handMessage {
        case let message where message.contains("Thirteen Orphans"):
            return "🦄"
        case let message where message.contains("Great Winds"):
            return "🌪️"
        case let message where message.contains("Orphans"):
            return "🌚"
        case let message where message.contains("Nine Gates"):
            return "⛩️"
        case let message where message.contains("All Honor"):
            return "👑"
        case let message where message.contains("Great Dragons"):
            return "🔥"
        case let message where message.contains("Pure Hand"):
            return "💎"
        case let message where message.contains("Small Winds"):
            return "🍃"
        case let message where message.contains("Small Dragons"):
            return "🐉"
        case let message where message.contains("Seven Pairs"):
            return "🔗"
        case let message where message.contains("All Triplets"):
            return "🌟"
        case let message where message.contains("Mixed One Suit"):
            return "🎨"
        case let message where message.contains("All Chows"):
            return "🌿"
        case let message where message.contains("Chicken Hand"):
            return "🐔"
        default:
            return ""
        }
    }
    
    // Helper function to generate tags
    private var tags: [String] {
        var result: [String] = [viewModel.handMessage]

        if viewModel.flowerPoints > 0 { result.append("Flowers") }
        if viewModel.dragonPoints > 0 { result.append("Dragons") }
        if viewModel.seatWindPoints > 0 { result.append("Seat Wind") }
        if viewModel.prevailingWindPoints > 0 { result.append("Prevailing Wind") }
        if viewModel.selfDrawnPoints > 0 { result.append("Self Drawn") }
        if viewModel.concealedHandPoints > 0 { result.append("Concealed") }

        return result
    }
    
    private func PointRow(label: String, points: Int, color: Color, isBold: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold(isBold)  // Make label bold if needed

            Spacer()

            // Conditionally show the "+" for all points except Total Points
            Text(label == "Total Points" ? "\(points)" : "+\(points)")
                .font(.body)
                .foregroundColor(.white)
                .bold(isBold)  // Make points bold if needed
        }
    }
    
    private func PointBreakdownView() -> some View {
        ScrollView {
            VStack {
                // Hand Points
                if viewModel.handPoints > 0 || viewModel.handMessage == "Chicken Hand" {
                    PointRow(label: viewModel.handMessage, points: viewModel.handPoints, color: .white)
                }
                
                // Flower Points
                if viewModel.flowerPoints > 0 {
                    Divider().padding(.top, 7).padding(.bottom, 11)
                    PointRow(label: "Flower Points", points: viewModel.flowerPoints, color: .white)
                }
                
                // Dragon Points
                if viewModel.dragonPoints > 0 {
                    Divider().padding(.top, 7).padding(.bottom, 11)
                    PointRow(label: "Dragon Points", points: viewModel.dragonPoints, color: .white)
                }
                
                // Seat Wind Points
                if viewModel.seatWindPoints > 0 {
                    Divider().padding(.top, 7).padding(.bottom, 11)
                    PointRow(label: "Seat Wind", points: viewModel.seatWindPoints, color: .white)
                }
                
                // Prevailing Wind Points
                if viewModel.prevailingWindPoints > 0 {
                    Divider().padding(.top, 7).padding(.bottom, 11)
                    PointRow(label: "Prevailing Wind", points: viewModel.prevailingWindPoints, color: .white)
                }
                
                // Self Drawn Points
                if viewModel.selfDrawnPoints > 0 {
                    Divider().padding(.top, 7).padding(.bottom, 11)
                    PointRow(label: "Self Drawn", points: viewModel.selfDrawnPoints, color: .white)
                }
                
                // Concealed Hand Points
                if viewModel.concealedHandPoints > 0 {
                    Divider().padding(.top, 7).padding(.bottom, 11)
                    PointRow(label: "Concealed Hand", points: viewModel.concealedHandPoints, color: .white)
                }
                
                // Total Points
                if totalPoints > 0 {
                    Divider().padding(.top, 7).padding(.bottom, 11)
                    PointRow(label: "Total Points", points: totalPoints, color: .white, isBold: true)
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: 300)
    }

    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // Top content that should stay anchored
                            if viewModel.handPoints > 0 || viewModel.handMessage == "Chicken Hand" {
                                VStack(spacing: 24) {
                                    Text(handTypeEmoji)
                                        .font(.system(size: 42))
                                        .lineSpacing(70)
                                    
                                    VStack(spacing: 16) {
                                        Text(pointsMessage)
                                            .font(.system(size: 15))
                                            .fontWeight(.regular)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        
                                        Text("\(totalPoints) points")
                                            .font(.system(size: 32, weight: .bold))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    
                                    TagCloudView(tags: tags)
                                        .onTapGesture {
                                            withAnimation {
                                                showBreakdown.toggle()
                                                currentDetent = showBreakdown ? .large : .medium
                                            }
                                        }
                                }
                                .padding(.vertical, 24)
                            }
                            
                            if showBreakdown {
                                PointBreakdownView()
                            }
                            
                            Spacer(minLength: 80) // Space for the button
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                    .scrollDisabled(true)
                    
                    // Button fixed at bottom
                    Button(action: {
                        viewModel.resetTiles()
                        dismiss()
                    }) {
                        Text("Start New Hand")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 26)
                .padding(.vertical, 42)
            }
            .onChange(of: currentDetent) { oldDetent, newDetent in
                if newDetent == .medium {
                    showBreakdown = false
                } else if newDetent == .large {
                    showBreakdown = true
                }
            }
        }
}

