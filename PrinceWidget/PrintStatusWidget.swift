//
//  PrintStatusWidget.swift
//  Prince
//
//  Created by Scott Dodge on 9/28/20.
//

import WidgetKit
import SwiftUI

struct PrintStatusWidget: Widget {
    let kind: String = "PrintStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrintStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Print Status")
        .description("Displays the current progress of your 3D Print.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), job: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), job: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let task = URLSession.shared.dataTask(with: JobRequest) { data, response, error in
            guard let data = data else { return }
            let job = parseJobJSON(data: data)
            var currentDate = Date()
            let endDate = Calendar.current.date(byAdding: .second, value: (job?.progress?.printTimeLeft)!, to: currentDate)!
            let oneMinute: TimeInterval = 60
            var entries: [SimpleEntry] = []
            
            while currentDate < endDate {
                let entry = SimpleEntry(date: currentDate, job: job)
                currentDate += oneMinute
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        task.resume()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let job: Job?
}

struct PrintStatusWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack  {
            Text("\(entry.job?.progress?.completion ?? 0)%")
            Text(Calendar.current.date(byAdding: .second, value: (entry.job?.progress?.printTimeLeft)!, to: Date())!, style: .timer)
        }
    }
}

struct PlaceholderView : View {
    var entry: Provider.Entry

    var body: some View {
        PrintStatusWidgetEntryView(entry: entry)
            .redacted(reason: .placeholder)
    }
}

struct PrintStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrintStatusWidgetEntryView(entry: SimpleEntry(date: Date(), job: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            PrintStatusWidgetEntryView(entry: SimpleEntry(date: Date(), job: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            PlaceholderView(entry: SimpleEntry(date: Date(), job: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
