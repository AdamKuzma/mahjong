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
            if viewModel.handMessage == "Chicken Hand 雞糊" {
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
        case let message where message.contains("Seven Pair"):
            return "🔗"
        case let message where message.contains("All Triplets"):
            return "🌟"
        case let message where message.contains("Mixed One Suit"):
            return "🎨"
        case let message where message.contains("All Chow"):
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
        if viewModel.concealedHandPoints > 0 { result.append("Concealed Hand") }

        return result
    }
    
    private func PointRow(label: String, points: Int, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text("+\(points)")
                .font(.body)
                .foregroundColor(.white)
        }
    }
    
    private func PointBreakdownView() -> some View {
        ScrollView {
            VStack {
                // Hand Points
                if viewModel.handPoints > 0 || viewModel.handMessage == "Chicken Hand" {
                    PointRow(label: "Hand Points", points: viewModel.handPoints, color: .white)
                }
                
                // Flower Points
                if viewModel.flowerPoints > 0 {
                    Divider().padding(.top, 8).padding(.bottom, 11)
                    PointRow(label: "Flower Points", points: viewModel.flowerPoints, color: .white)
                }
                
                // Dragon Points
                if viewModel.dragonPoints > 0 {
                    Divider().padding(.top, 8).padding(.bottom, 11)
                    PointRow(label: "Dragon Points", points: viewModel.dragonPoints, color: .white)
                }
                
                // Seat Wind Points
                if viewModel.seatWindPoints > 0 {
                    Divider().padding(.top, 8).padding(.bottom, 11)
                    PointRow(label: "Seat Wind Points", points: viewModel.seatWindPoints, color: .white)
                }
                
                // Prevailing Wind Points
                if viewModel.prevailingWindPoints > 0 {
                    Divider().padding(.top, 8).padding(.bottom, 11)
                    PointRow(label: "Prevailing Wind Points", points: viewModel.prevailingWindPoints, color: .white)
                }
                
                // Self Drawn Points
                if viewModel.selfDrawnPoints > 0 {
                    Divider().padding(.top, 8).padding(.bottom, 11)
                    PointRow(label: "Self Drawn", points: viewModel.selfDrawnPoints, color: .white)
                }
                
                // Concealed Hand Points
                if viewModel.concealedHandPoints > 0 {
                    Divider().padding(.top, 8).padding(.bottom, 11)
                    PointRow(label: "Concealed Hand", points: viewModel.concealedHandPoints, color: .white)
                }
                
                // Total Points
                if totalPoints > 0 {
                    Divider().padding(.top, 8).padding(.bottom, 11)
                    PointRow(label: "Total Points", points: totalPoints, color: .white)
                }
            }
        }
        .frame(height: 300)
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if viewModel.handPoints > 0 || viewModel.handMessage == "Chicken Hand 雞糊" {
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
                                    if showBreakdown {
                                        currentDetent = .large  // Set sheet to large when tapped
                                    } else {
                                        currentDetent = .medium  // Reset to medium when closed
                                    }
                                }
                            }
                    }
                    .padding(.vertical, 24)
                }
            }
            
            if showBreakdown {
                PointBreakdownView()
            }
            
            Spacer()  // This pushes everything up and the button to the bottom
                        
            Button(action: {
                viewModel.resetTiles()  // Reset the tiles
                dismiss()  // Dismiss the sheet
            }) {
                Text("Start New Hand")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)  // Or any color you prefer
                    .cornerRadius(10)
            }
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 26)
        .padding(.vertical, 42)
        .onChange(of: currentDetent) { oldDetent, newDetent in
            withAnimation {
                if newDetent == .medium {
                    showBreakdown = false
                } else if newDetent == .large {
                    showBreakdown = true
                }
            }
        }
    }
}

