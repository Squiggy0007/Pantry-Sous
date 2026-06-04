import SwiftUI

/// A container that wraps a feed card and reveals a green "Add Missing" action
/// button when the user swipes left. Uses `simultaneousGesture` so vertical
/// ScrollView scrolling is not blocked.
struct SwipeToAddContainer<Content: View>: View {
    /// Called when the user taps the revealed action button.
    let onAdd: () -> Void
    @ViewBuilder let content: () -> Content

    @State private var dragOffset: CGFloat = 0

    private let maxReveal: CGFloat = 72
    private let snapThreshold: CGFloat = 36

    var body: some View {
        ZStack(alignment: .trailing) {
            // Action button — sits behind the content, revealed on left-swipe
            Button {
                snap(to: 0)
                HapticFeedback.medium()
                onAdd()
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Add")
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(width: maxReveal)
                .frame(maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color("AccentSage"))
                )
            }
            .buttonStyle(.plain)
            .opacity(dragOffset < -2 ? 1 : 0)

            // Main card — slides left to reveal the action button
            content()
                .offset(x: dragOffset)
                // Tap anywhere on the card while open → close the action button
                .onTapGesture {
                    if dragOffset < 0 { snap(to: 0) }
                }
        }
        .clipped()
        .simultaneousGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onChanged { value in
                    let dx = value.translation.width
                    let dy = value.translation.height
                    // Require a clearly horizontal gesture — vertical component must not dominate.
                    // The 1.5x multiplier gives vertical scrolling a strong priority advantage.
                    guard abs(dx) > abs(dy) * 1.5 else { return }
                    if dx < 0 {
                        dragOffset = max(dx * 0.8, -maxReveal)
                    } else if dragOffset < 0 {
                        dragOffset = min(0, dragOffset + dx)
                    }
                }
                .onEnded { value in
                    let dx = value.translation.width
                    let dy = value.translation.height
                    // Only snap if the gesture was horizontal OR the card is already open.
                    // Skipping this for vertical gestures prevents unnecessary animation
                    // transactions that interfere with the ScrollView's gesture recognizer.
                    guard abs(dx) > abs(dy) * 1.5 || dragOffset != 0 else { return }
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        dragOffset = dragOffset < -snapThreshold ? -maxReveal : 0
                    }
                }
        )
    }

    private func snap(to value: CGFloat) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            dragOffset = value
        }
    }
}
