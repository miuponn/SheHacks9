import SwiftUI

struct BetItem: Identifiable {
    let id = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let displayImage: Image?
}
