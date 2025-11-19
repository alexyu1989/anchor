import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(
                String(
                    localized: "settings.title",
                    defaultValue: "Settings"
                )
            )
                .font(.title3)
            Text(
                String(
                    localized: "settings.description",
                    defaultValue: "Configuration options for your check-ins will appear here."
                )
            )
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
