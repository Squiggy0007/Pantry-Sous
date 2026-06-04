import SwiftUI
import CodeScanner
import AVFoundation

struct BarcodeScannerView: View {
    let onScan: (Result<ScanResult, ScanError>) -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Scanner
            CodeScannerView(
                codeTypes: [.ean8, .ean13, .upce],
                scanInterval: 0.1,
                completion: onScan
            )
            .ignoresSafeArea()

            // Overlay
            VStack {
                // Top bar
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4)
                    }
                    Spacer()
                    Text("Scan Barcode")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4)
                    Spacer()
                    // Balance the X button
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)

                Spacer()

                // Targeting box
                ZStack {
                    // Dimmed overlay with cutout
                    Color.black.opacity(0.5)
                        .reverseMask {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 280, height: 160)
                        }

                    // Targeting box border
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("AccentSage"), lineWidth: 3)
                        .frame(width: 280, height: 160)

                    // Corner accents
                    CornerAccentsView()
                        .frame(width: 280, height: 160)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer()

                // Instruction text
                Text("Place barcode inside the box")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.4), radius: 4)
                    .padding(.bottom, 80)
            }
        }
    }
}

// MARK: - Corner Accents
struct CornerAccentsView: View {
    let cornerLength: CGFloat = 24
    let lineWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Top left
                Path { path in
                    path.move(to: CGPoint(x: 0, y: cornerLength))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: cornerLength, y: 0))
                }
                .stroke(Color("AccentSage"), lineWidth: lineWidth)

                // Top right
                Path { path in
                    path.move(to: CGPoint(x: w - cornerLength, y: 0))
                    path.addLine(to: CGPoint(x: w, y: 0))
                    path.addLine(to: CGPoint(x: w, y: cornerLength))
                }
                .stroke(Color("AccentSage"), lineWidth: lineWidth)

                // Bottom left
                Path { path in
                    path.move(to: CGPoint(x: 0, y: h - cornerLength))
                    path.addLine(to: CGPoint(x: 0, y: h))
                    path.addLine(to: CGPoint(x: cornerLength, y: h))
                }
                .stroke(Color("AccentSage"), lineWidth: lineWidth)

                // Bottom right
                Path { path in
                    path.move(to: CGPoint(x: w - cornerLength, y: h))
                    path.addLine(to: CGPoint(x: w, y: h))
                    path.addLine(to: CGPoint(x: w, y: h - cornerLength))
                }
                .stroke(Color("AccentSage"), lineWidth: lineWidth)
            }
        }
    }
}

// MARK: - Reverse Mask
extension View {
    func reverseMask<Mask: View>(@ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask(
            ZStack {
                Rectangle()
                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}
