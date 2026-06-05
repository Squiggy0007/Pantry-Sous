import SwiftUI

struct QuantityPickerView: View {
    @Binding var amount: Double
    @Binding var unit: QuantityUnit
    var ingredientName: String = ""
    /// Optional per-container size binding (only shown when container category is selected)
    var containerSize: Binding<Double>? = nil
    var containerSizeUnit: Binding<QuantityUnit>? = nil
    /// When true (barcode was just scanned), only show the Count tab
    var isBarcodeScanned: Bool = false
    /// The current ingredient category — used to decide whether to show the Container tab
    var ingredientCategory: IngredientCategory? = nil

    @State private var selectedCategory: QuantityCategory
    @State private var showContainerSize: Bool = false

    init(amount: Binding<Double>, unit: Binding<QuantityUnit>, ingredientName: String = "",
         containerSize: Binding<Double>? = nil, containerSizeUnit: Binding<QuantityUnit>? = nil,
         isBarcodeScanned: Bool = false, ingredientCategory: IngredientCategory? = nil) {
        _amount = amount
        _unit = unit
        self.ingredientName = ingredientName
        self.containerSize = containerSize
        self.containerSizeUnit = containerSizeUnit
        self.isBarcodeScanned = isBarcodeScanned
        self.ingredientCategory = ingredientCategory

        // If egg ingredient, default to eggs category; if barcode scanned, default to count
        let isEgg = isEggIngredient(ingredientName)
        let initialCategory: QuantityCategory
        if isBarcodeScanned {
            initialCategory = .count
        } else if isEgg {
            initialCategory = .eggs
        } else {
            initialCategory = unit.wrappedValue.category
        }
        _selectedCategory = State(initialValue: initialCategory)

        let cs = containerSize?.wrappedValue ?? 0.0
        _showContainerSize = State(initialValue: initialCategory == .container && cs > 0)
    }

    // Categories to show based on context
    var visibleCategories: [QuantityCategory] {
        // After a barcode scan — count only
        if isBarcodeScanned {
            return [.count]
        }
        let isHerbsAndSpices = ingredientCategory == .herbsAndSpices
        return QuantityCategory.allCases.filter { cat in
            if cat == .eggs { return isEggIngredient(ingredientName) }
            if cat == .container { return isHerbsAndSpices }
            return true
        }
    }

    var body: some View {
        if isBarcodeScanned {
            BarcodeQuantityWheelView(
                amount: $amount,
                unit: unit,
                containerSize: containerSize,
                containerSizeUnit: containerSizeUnit
            )
        } else {
            manualQuantityPicker
        }
    }

    private var manualQuantityPicker: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Category selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(visibleCategories, id: \.self) { category in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                                if let firstUnit = category.units.first {
                                    unit = firstUnit
                                }
                                showContainerSize = (category == .container)
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 16))
                                Text(category.rawValue)
                                    .font(.system(.caption2, design: .rounded, weight: .medium))
                            }
                            .frame(minWidth: 60)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedCategory == category
                                          ? Color("AccentSage")
                                          : Color("BackgroundSecondary"))
                            )
                            .foregroundStyle(selectedCategory == category
                                             ? .white
                                             : Color("TextSecondary"))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            HStack(spacing: 12) {
                // Amount input — always visible
                if true {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Amount")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(Color("TextSecondary"))

                        DecimalQuantityWheelView(amount: $amount, allowZero: false)
                    }
                    .frame(width: 156)
                }

                // Unit picker
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unit")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Color("TextSecondary"))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(selectedCategory.units, id: \.self) { unitOption in
                                Button {
                                    unit = unitOption
                                } label: {
                                    Text(unitOption.label(for: amount))
                                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(unit == unitOption
                                                      ? Color("AccentSage")
                                                      : Color("BackgroundSecondary"))
                                        )
                                        .foregroundStyle(unit == unitOption
                                                         ? .white
                                                         : Color("TextSecondary"))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .frame(height: 44)
                }
            }

            // Container size row — optional, only for container units
            if showContainerSize && containerSize != nil {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Size per container")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(Color("TextSecondary"))
                        Text("(optional)")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(Color("TextSecondary").opacity(0.6))
                    }
                    HStack(spacing: 8) {
                        if let containerSize {
                            DecimalQuantityWheelView(amount: containerSize, allowZero: true)
                                .frame(width: 156)
                        }

                        // Size unit picker (weight/volume only)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach([QuantityUnit.oz, .lbs, .flOz, .cup], id: \.self) { u in
                                    Button {
                                        containerSizeUnit?.wrappedValue = u
                                    } label: {
                                        Text(u.rawValue)
                                            .font(.system(.caption, design: .rounded, weight: .medium))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(containerSizeUnit?.wrappedValue == u
                                                          ? Color("AccentSage")
                                                          : Color("BackgroundSecondary"))
                                            )
                                            .foregroundStyle(containerSizeUnit?.wrappedValue == u
                                                             ? .white : Color("TextSecondary"))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                        .frame(height: 36)
                    }
                }
            }

            // Preview
            HStack {
                Text("Preview:")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
                let base = IngredientQuantity(amount: amount, unit: unit).displayString
                let cs = containerSize?.wrappedValue ?? 0
                let csu = containerSizeUnit?.wrappedValue
                let preview: String = {
                    if cs > 0, let csu, showContainerSize {
                        let f = cs.truncatingRemainder(dividingBy: 1) == 0
                            ? String(Int(cs)) : String(format: "%.2f", cs)
                        return "\(base) · \(f) \(csu.rawValue)"
                    }
                    return base
                }()
                Text(preview)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("AccentSage"))
            }
        }
    }
}

private struct DecimalQuantityWheelView: View {
    @Binding var amount: Double
    let allowZero: Bool

    @State private var whole: Int
    @State private var tenths: Int
    @State private var hundredths: Int

    init(amount: Binding<Double>, allowZero: Bool) {
        _amount = amount
        self.allowZero = allowZero
        let parts = Self.parts(from: amount.wrappedValue, allowZero: allowZero)
        _whole = State(initialValue: parts.whole)
        _tenths = State(initialValue: parts.tenths)
        _hundredths = State(initialValue: parts.hundredths)
    }

    var body: some View {
        HStack(spacing: 0) {
            wheel(selection: $whole, range: (allowZero ? 0 : 1)...99, label: "Whole amount")

            Text(".")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color("TextSecondary"))
                .frame(width: 14)

            wheel(selection: $tenths, range: 0...9, label: "Tenths")
            wheel(selection: $hundredths, range: 0...9, label: "Hundredths")
        }
        .frame(height: 118)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("BackgroundSecondary"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("TextSecondary").opacity(0.12), lineWidth: 1)
        )
        .onAppear {
            syncFromAmount()
        }
        .onChange(of: whole) { _, _ in updateAmount() }
        .onChange(of: tenths) { _, _ in updateAmount() }
        .onChange(of: hundredths) { _, _ in updateAmount() }
        .onChange(of: amount) { _, _ in syncFromAmount() }
    }

    private func wheel(selection: Binding<Int>, range: ClosedRange<Int>, label: String) -> some View {
        Picker(label, selection: selection) {
            ForEach(Array(range), id: \.self) { value in
                Text("\(value)")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .tag(value)
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
        .frame(width: 46, height: 118)
        .clipped()
    }

    private func updateAmount() {
        let value = Double(whole) + (Double(tenths) / 10.0) + (Double(hundredths) / 100.0)
        amount = allowZero ? value : max(value, 0.01)
        HapticFeedback.light()
    }

    private func syncFromAmount() {
        let parts = Self.parts(from: amount, allowZero: allowZero)
        if whole != parts.whole { whole = parts.whole }
        if tenths != parts.tenths { tenths = parts.tenths }
        if hundredths != parts.hundredths { hundredths = parts.hundredths }
    }

    private static func parts(from amount: Double, allowZero: Bool) -> (whole: Int, tenths: Int, hundredths: Int) {
        let minValue = allowZero ? 0.0 : 1.0
        let clamped = min(max(amount, minValue), 99.99)
        let cents = Int((clamped * 100).rounded())
        return (
            whole: cents / 100,
            tenths: (cents % 100) / 10,
            hundredths: cents % 10
        )
    }
}

private struct BarcodeQuantityWheelView: View {
    @Binding var amount: Double
    let unit: QuantityUnit
    let containerSize: Binding<Double>?
    let containerSizeUnit: Binding<QuantityUnit>?

    private let packageSizeUnits: [QuantityUnit] = [.oz, .lbs, .g, .kg, .flOz, .cup]

    private var selectedCount: Binding<Int> {
        Binding(
            get: {
                let rounded = Int(amount.rounded())
                return min(max(rounded, 1), 99)
            },
            set: { newValue in
                amount = Double(newValue)
                HapticFeedback.light()
            }
        )
    }

    private var previewText: String {
        let quantity = IngredientQuantity(amount: amount, unit: unit).displayString
        guard let size = containerSize?.wrappedValue,
              size > 0,
              let sizeUnit = containerSizeUnit?.wrappedValue
        else {
            return quantity
        }

        let formattedSize = size.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(size))
            : String(format: "%.2f", size)
        return "\(quantity) · \(formattedSize) \(sizeUnit.rawValue) each"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Package Count")
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Color("TextSecondary"))

            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color("BackgroundSecondary"))
                        .frame(width: 68, height: 48)

                    Picker("Amount", selection: selectedCount) {
                        ForEach(1...99, id: \.self) { count in
                            Text("\(count)")
                                .font(.system(.title, design: .rounded, weight: .semibold))
                                .tag(count)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width: 68, height: 136)
                    .clipped()
                }
                .frame(width: 72, height: 136)
                .accessibilityLabel("Quantity")
                .accessibilityValue("\(selectedCount.wrappedValue)")

                Text(unit.label(for: amount))
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                let rounded = Int(amount.rounded())
                amount = Double(min(max(rounded, 1), 99))
            }

            if let containerSize {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Package Size")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Color("TextSecondary"))

                    HStack(spacing: 10) {
                        DecimalQuantityWheelView(amount: containerSize, allowZero: true)
                            .frame(width: 156)

                        if let containerSizeUnit {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 6) {
                                    ForEach(packageSizeUnits, id: \.self) { sizeUnit in
                                        Button {
                                            containerSizeUnit.wrappedValue = sizeUnit
                                            HapticFeedback.light()
                                        } label: {
                                            Text(sizeUnit.rawValue)
                                                .font(.system(.caption, design: .rounded, weight: .medium))
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(containerSizeUnit.wrappedValue == sizeUnit
                                                              ? Color("AccentSage")
                                                              : Color("BackgroundSecondary"))
                                                )
                                                .foregroundStyle(containerSizeUnit.wrappedValue == sizeUnit
                                                                 ? .white
                                                                 : Color("TextSecondary"))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                            .frame(height: 36)
                        }
                    }
                }
            }

            HStack(spacing: 6) {
                Text("Preview:")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
                Text(previewText)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color("AccentSage"))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
