//
//  MiniSplitBar.swift
//  SimpleFramework
//
//  Created by David Thorn on 21.03.2026.
//

import SwiftUI

public struct MiniSplitBar: View {
    public let left: TimeInterval
    public let right: TimeInterval
    public let leftColor: Color
    public let rightColor: Color

    public init(
        left: TimeInterval,
        right: TimeInterval,
        leftColor: Color,
        rightColor: Color
    ) {
        self.left = left
        self.right = right
        self.leftColor = leftColor
        self.rightColor = rightColor
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.quaternaryLabel))

                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(leftColor)
                        .frame(width: proxy.size.width * leftProportion)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(rightColor)
                        .frame(width: proxy.size.width * rightProportion)
                }
            }
        }
        .frame(height: 8)
    }

    private var total: Double {
        max(0, left + right)
    }

    private var leftProportion: CGFloat {
        total > 0 ? CGFloat(left / total) : 0
    }

    private var rightProportion: CGFloat {
        1 - leftProportion
    }
}

#if DEBUG
    #Preview {
        MiniSplitBar(
            left: 600,
            right: 300,
            leftColor: .orange,
            rightColor: .pink
        )
        .padding()
    }
#endif
