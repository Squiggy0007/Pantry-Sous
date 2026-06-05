import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var showingSettings: Bool = false
    @State private var showingWhatsNew: Bool = false
    @Query private var shoppingItems: [ShoppingItem]
    @AppStorage("hasSeenOnboardingV2") private var hasSeenOnboarding = false
    @AppStorage("lastSeenWhatsNewBuild") private var lastSeenWhatsNewBuild = ""

    var unpurchasedCount: Int {
        shoppingItems.filter { !$0.isPurchased }.count
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            InventoryView(showingSettings: $showingSettings)
                .tabItem {
                    Label("Ingredients", systemImage: "cabinet")
                }
                .tag(0)

            RecipesView(showingSettings: $showingSettings)
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
                .tag(1)

            MenuView(showingSettings: $showingSettings)
                .tabItem {
                    Label("Menu", systemImage: "calendar.badge.plus")
                }
                .tag(2)

            FavoritesView(showingSettings: $showingSettings)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(3)

            ShoppingListView(showingSettings: $showingSettings)
                .tabItem {
                    Label("Shopping", systemImage: "cart.fill")
                }
                .badge(unpurchasedCount)
                .tag(4)
        }
        .tint(Color("AccentSage"))
        .onChange(of: selectedTab) { _, _ in
            HapticFeedback.light()
        }
        .onAppear {
            updateWhatsNewVisibility()
        }
        .onChange(of: hasSeenOnboarding) { _, _ in
            updateWhatsNewVisibility()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: Binding(
            get: { !hasSeenOnboarding },
            set: { if !$0 { hasSeenOnboarding = true } }
        )) {
            OnboardingSheet {
                hasSeenOnboarding = true
                updateWhatsNewVisibility()
            }
        }
        .sheet(isPresented: $showingWhatsNew, onDismiss: markWhatsNewSeen) {
            WhatsNewSheet(
                versionText: AppBuildInfo.displayVersion,
                onDismiss: {
                    markWhatsNewSeen()
                    showingWhatsNew = false
                }
            )
        }
    }

    private func updateWhatsNewVisibility() {
        guard hasSeenOnboarding else { return }
        guard lastSeenWhatsNewBuild != AppBuildInfo.versionBuildKey else { return }
        showingWhatsNew = true
    }

    private func markWhatsNewSeen() {
        lastSeenWhatsNewBuild = AppBuildInfo.versionBuildKey
    }
}

private enum AppBuildInfo {
    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    static var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }

    static var versionBuildKey: String {
        "\(version)(\(build))"
    }

    static var displayVersion: String {
        "Version \(version) Beta \(build)"
    }
}

private struct WhatsNewSheet: View {
    let versionText: String
    let onDismiss: () -> Void

    private let updates: [(icon: String, title: String, detail: String)] = [
        (
            icon: "text.viewfinder",
            title: "Recipe Card Import",
            detail: "Scan cookbook pages or recipe cards, review the detected ingredients and steps, then import them into custom recipes."
        ),
        (
            icon: "fork.knife.circle.fill",
            title: "Smarter Matching",
            detail: "Ingredient matching now uses Spoonacular canonical ingredients first, with local matching as a backup."
        ),
        (
            icon: "arrow.triangle.2.circlepath",
            title: "Refresh Ingredients",
            detail: "Settings can now re-sort ingredients, fill matching data, and merge matching entries."
        ),
        (
            icon: "dial.medium.fill",
            title: "Wheel Quantity Entry",
            detail: "Manual ingredient quantities now use picker wheels instead of typed numbers."
        ),
        (
            icon: "shippingbox.circle.fill",
            title: "Cleaner Package Counts",
            detail: "Scanned packages now show as item or items with the size listed after it, like 1 item · 6 oz."
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(versionText)
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                .foregroundStyle(Color("AccentSage"))
                            Text("What's New")
                                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                .foregroundStyle(Color("TextPrimary"))
                        }
                        .padding(.top, 12)

                        VStack(spacing: 12) {
                            ForEach(updates, id: \.title) { update in
                                WhatsNewRow(update: update)
                            }
                        }

                        Button {
                            HapticFeedback.medium()
                            onDismiss()
                        } label: {
                            Text("Got It")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color("AccentSage"))
                                )
                        }
                        .padding(.top, 4)
                    }
                    .padding(24)
                }
            }
            .interactiveDismissDisabled()
        }
    }
}

private struct WhatsNewRow: View {
    let update: (icon: String, title: String, detail: String)

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color("AccentSage").opacity(0.14))
                    .frame(width: 42, height: 42)
                Image(systemName: update.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color("AccentSage"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(update.title)
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                Text(update.detail)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
        )
    }
}

// MARK: - Onboarding Sheet

struct OnboardingSheet: View {
    let onDismiss: () -> Void
    @State private var currentPage = 0

    private let pages: [(icon: String, title: String, subtitle: String, color: String, tip: String?)] = [
        (
            icon: "cabinet.fill",
            title: "Add Your Ingredients",
            subtitle: "Track everything in your kitchen — proteins, produce, pantry items, and more. Pantry Sous always knows what you have on hand.",
            color: "AccentSage",
            tip: "Long press any ingredient card to quickly log how much you used."
        ),
        (
            icon: "fork.knife",
            title: "Discover Recipes",
            subtitle: "See recipes you can make right now with what's already in your kitchen. No missing ingredients, no surprises.",
            color: "AccentSage",
            tip: nil
        ),
        (
            icon: "calendar.badge.plus",
            title: "Plan the Week",
            subtitle: "Add meals to your weekly menu and build a smart shopping list for anything you're missing. Dinner sorted.",
            color: "AccentSage",
            tip: nil
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Page content
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page, tip: page.tip)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4), value: currentPage)

            // Page dots
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { i in
                    Capsule()
                        .fill(i == currentPage ? Color("AccentSage") : Color("TextSecondary").opacity(0.25))
                        .frame(width: i == currentPage ? 20 : 8, height: 8)
                        .animation(.spring(response: 0.3), value: currentPage)
                }
            }
            .padding(.bottom, 32)

            // Action button
            Button {
                HapticFeedback.medium()
                if currentPage < pages.count - 1 {
                    withAnimation(.spring(response: 0.4)) {
                        currentPage += 1
                    }
                } else {
                    onDismiss()
                }
            } label: {
                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("AccentSage"))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .background(Color("BackgroundPrimary").ignoresSafeArea())
        .interactiveDismissDisabled()
    }
}

struct OnboardingPageView: View {
    let page: (icon: String, title: String, subtitle: String, color: String, tip: String?)
    var tip: String? = nil

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // Icon circle
            ZStack {
                Circle()
                    .fill(Color(page.color).opacity(0.12))
                    .frame(width: 120, height: 120)
                Image(systemName: page.icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(Color(page.color))
            }

            // Text
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Color("TextPrimary"))
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 8)
            }

            // Optional tip chip
            if let tip = tip {
                HStack(spacing: 8) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color("AccentSage"))
                    Text(tip)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color("TextSecondary"))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("BackgroundSecondary"))
                )
                .padding(.horizontal, 24)
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}
