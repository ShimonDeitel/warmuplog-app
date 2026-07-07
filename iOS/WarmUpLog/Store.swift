import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [LogEntry] = []
    @Published var isProUnlocked: Bool = false

    static let freeLimit = 30

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)
        fileURL = appSupport.appendingPathComponent("warmuplog_entries.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || entries.count < Store.freeLimit
    }

    func add(_ entry: LogEntry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: LogEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: LogEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([LogEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
            LogEntry(primaryText: "Dynamic Stretch", secondaryText: "Legs and hips loose", numericValue: 8.0, tag: "Legs", isDone: true),
            LogEntry(primaryText: "Band Pull-Aparts", secondaryText: "Shoulders before push day", numericValue: 5.0, tag: "Shoulders", isDone: true),
            LogEntry(primaryText: "Ankle Mobility", secondaryText: "Before running", numericValue: 6.0, tag: "Ankles", isDone: false)
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL)
        }
    }
}
