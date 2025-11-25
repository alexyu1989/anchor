import SwiftUI

struct GridBackground: View {
    var spacing: CGFloat = 60
    var lineWidth: CGFloat = 0.5
    var lineColor: Color = .primary.opacity(0.06)

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                let horizontalCount = Int(ceil(size.height / spacing))
                let verticalCount = Int(ceil(size.width / spacing))

                var path = Path()

                for index in 0...verticalCount {
                    let x = CGFloat(index) * spacing
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }

                for index in 0...horizontalCount {
                    let y = CGFloat(index) * spacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }

                context.stroke(
                    path,
                    with: .color(lineColor),
                    lineWidth: lineWidth
                )
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GridBackground()
}
