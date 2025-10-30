import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("设置页面")
                .font(.title3)
            Text("这里将配置打卡相关选项。")
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
