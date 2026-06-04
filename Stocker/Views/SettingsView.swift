import SwiftUI

struct SettingsView: View {
    @ObservedObject var staplesManager = PantryStaplesManager.shared
    @AppStorage("hasSeenOnboardingV2") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // ── Info Card ─────────────────────────────────────
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 10) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("AccentSage"))
                                Text("About Pantry Staples")
                                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color("TextPrimary"))
                            }
                            Text("Enabled staples are assumed to be in your kitchen. They appear at the bottom of recipe ingredient lists without a checkbox and are never counted as missing.")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(Color("TextSecondary"))
                                .lineSpacing(4)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("CardBackground"))
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                        // ── Tier 1: Spoonacular Core Staples ─────────────
                        VStack(alignment: .leading, spacing: 0) {
                            sectionHeader(
                                title: "Core Staples",
                                subtitle: "What Spoonacular assumes every kitchen always has"
                            )

                            VStack(spacing: 0) {
                                Toggle(isOn: $staplesManager.spoonacularStaplesEnabled) {
                                    HStack(spacing: 14) {
                                        Text("🧂")
                                            .font(.system(size: 24))
                                            .frame(width: 32)
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("Enable Core Staples")
                                                .font(.system(.body, design: .rounded, weight: .semibold))
                                                .foregroundStyle(Color("TextPrimary"))
                                            Text("Water · Salt · Pepper · Oil · Flour · Sugar")
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundStyle(Color("TextSecondary"))
                                        }
                                    }
                                }
                                .tint(Color("AccentSage"))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("CardBackground"))
                            )
                        }
                        .padding(.horizontal, 16)

                        // ── Tier 2: Common Household Staples ─────────────
                        VStack(alignment: .leading, spacing: 0) {
                            sectionHeader(
                                title: "Common Staples",
                                subtitle: "Things most families keep on hand — toggle what applies to you"
                            )

                            VStack(spacing: 0) {
                                stapleRow(
                                    emoji: "🧈",
                                    name: "Butter",
                                    detail: "Unsalted butter, salted butter",
                                    isOn: $staplesManager.butterEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🧄",
                                    name: "Garlic",
                                    detail: "Fresh garlic cloves",
                                    isOn: $staplesManager.garlicEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🫒",
                                    name: "Olive Oil",
                                    detail: "Extra virgin, light olive oil",
                                    isOn: $staplesManager.oliveOilEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🟫",
                                    name: "Brown Sugar",
                                    detail: "Light and dark brown sugar",
                                    isOn: $staplesManager.brownSugarEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🥄",
                                    name: "Baking Soda",
                                    detail: "Bicarbonate of soda",
                                    isOn: $staplesManager.bakingSodaEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🥄",
                                    name: "Baking Powder",
                                    detail: "Double-acting baking powder",
                                    isOn: $staplesManager.bakingPowderEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🌽",
                                    name: "Cornstarch",
                                    detail: "Corn starch, thickening agent",
                                    isOn: $staplesManager.cornstarchEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🍶",
                                    name: "Vanilla Extract",
                                    detail: "Pure vanilla extract",
                                    isOn: $staplesManager.vanillaExtractEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🍗",
                                    name: "Chicken Broth",
                                    detail: "Chicken broth or stock",
                                    isOn: $staplesManager.chickenBrothEnabled
                                )
                                divider()
                                stapleRow(
                                    emoji: "🥦",
                                    name: "Vegetable Broth",
                                    detail: "Vegetable broth or stock",
                                    isOn: $staplesManager.vegetableBrothEnabled
                                )
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("CardBackground"))
                            )
                        }
                        .padding(.horizontal, 16)

                        // ── Repeat Onboarding ─────────────────────────────
                        VStack(alignment: .leading, spacing: 0) {
                            sectionHeader(title: "Walkthrough", subtitle: nil)

                            Button {
                                HapticFeedback.light()
                                hasSeenOnboarding = false
                            } label: {
                                HStack {
                                    HStack(spacing: 14) {
                                        Text("🔁")
                                            .font(.system(size: 22))
                                            .frame(width: 32)
                                        Text("Repeat Onboarding")
                                            .font(.system(.body, design: .rounded, weight: .medium))
                                            .foregroundStyle(Color("TextPrimary"))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(Color("TextSecondary").opacity(0.4))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("CardBackground"))
                            )
                        }
                        .padding(.horizontal, 16)

                        // ── App Info ──────────────────────────────────────
                        VStack(alignment: .leading, spacing: 0) {
                            sectionHeader(title: "App Info", subtitle: nil)

                            VStack(spacing: 0) {
                                infoRow(label: "Version", value: "1.0.0")
                                Divider().padding(.leading, 16)
                                infoRow(label: "Recipe Data", value: "Spoonacular API")
                                Divider().padding(.leading, 16)
                                infoRow(label: "Barcode Data", value: "Open Food Facts")
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("CardBackground"))
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Subviews

    private func sectionHeader(title: String, subtitle: String?) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(Color("TextSecondary"))
                .textCase(.uppercase)
            if let subtitle {
                Text(subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary").opacity(0.7))
            }
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 8)
    }

    private func stapleRow(
        emoji: String,
        name: String,
        detail: String,
        isOn: Binding<Bool>
    ) -> some View {
        Toggle(isOn: isOn) {
            HStack(spacing: 14) {
                Text(emoji)
                    .font(.system(size: 24))
                    .frame(width: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundStyle(Color("TextPrimary"))
                    Text(detail)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color("TextSecondary"))
                }
            }
        }
        .tint(Color("AccentSage"))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color("TextPrimary"))
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color("TextSecondary"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func divider() -> some View {
        Divider().padding(.leading, 62)
    }
}
