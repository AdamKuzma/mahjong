//
//  TagCloud.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/24/24.
//

import SwiftUI


struct TagCloudView: View {
    var tags: [String]

    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateWrappedContent(in: geometry.size.width)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateWrappedContent(in availableWidth: CGFloat) -> some View {
        var currentRow: [String] = []
        var rows: [[String]] = []

        // Calculate rows based on available width
        var currentRowWidth: CGFloat = 0
        for tag in tags {
            let tagWidth = estimateTagWidth(for: tag) + 20 // Including padding

            if currentRowWidth + tagWidth > availableWidth {
                rows.append(currentRow)
                currentRow = [tag]
                currentRowWidth = tagWidth
            } else {
                currentRow.append(tag)
                currentRowWidth += tagWidth + 8 // Include spacing
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        return VStack(alignment: .center, spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { tag in
                        self.item(for: tag)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center) // Center align each row
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        Text(text)
            .font(.system(size: 14))  // Match HandScoreView font size
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color(red: 36/255, green: 36/255, blue: 36/255)) // Match background color
            .foregroundColor(.white) // Match text color
            .cornerRadius(16) // Match corner radius
    }
    
    private func estimateTagWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 12) // Match HandScoreView font size
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.size.height
            }
            return Color.clear
        }
    }
}

struct TestTagCloudView : View {
    var body: some View {
        VStack {
            Text("Header").font(.largeTitle)
            TagCloudView(tags: ["Ninetendo", "XBox", "PlayStation", "PlayStation 2", "PlayStation 3", "PlayStation 4"])
            Text("Some other text")
            Divider()
            Text("Some other cloud")
            TagCloudView(tags: ["Apple", "Google", "Amazon", "Microsoft", "Oracle", "Facebook"])
        }
    }
}

#Preview {
    TagCloudView(tags: ["Mahjong", "Tile", "East Wind", "Self Drawn", "Dragon", "Flower"])
}
