import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nataliaogorek/Desktop/Concurrency_SwiftUI/Concurrency_SwiftUI/TaskTutorial.swift", line: 1)
//
//  TaskTutorial.swift
//  Concurrency_SwiftUI
//
//  Created by Natalia Ogorek on 14.05.25.
//

import SwiftUI

class TaskTutorialViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: __designTimeString("#38427_0", fallback: "https://picsum.photos/1000")) else { return }
           let (data, _ ) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print(__designTimeString("#38427_1", fallback: "IMAGE RETURNED SUCCESSFULLY"))
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: __designTimeString("#38427_2", fallback: "https://picsum.photos/1000")) else { return }
           let (data, _ ) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
            self.image2 = UIImage(data: data)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskTutorialHomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(__designTimeString("#38427_3", fallback: "CLICK ME! 🤓")) {
                    TaskTutorial()
                }
            }
        }
    }
}

struct TaskTutorial: View {
    
    @StateObject private var viewModel = TaskTutorialViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: __designTimeInteger("#38427_4", fallback: 40)) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: __designTimeInteger("#38427_5", fallback: 200), height: __designTimeInteger("#38427_6", fallback: 200))
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: __designTimeInteger("#38427_7", fallback: 200), height: __designTimeInteger("#38427_8", fallback: 200))
            }
        }
        .task  {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
////            Task {
////                await viewModel.fetchImage2()
////            }
////            Task(priority: .high) {
//////                try? await Task.sleep(nanoseconds: 2_000_000_000)
////                await Task.yield()
////                print("HIGH: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .userInitiated) {
////                print("USERINITIATED: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .medium) {
////                print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .utility) {
////                print("UTILITY: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .low) {
////                print("LOW: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .background) {
////                print("BACKGROUND: \(Thread.current) : \(Task.currentPriority)")
////            }
//            
////            Task(priority: .low) {
////                print("low: \(Thread.current) : \(Task.currentPriority)")
////                
////                Task.detached {
////                    print("low: \(Thread.current) : \(Task.currentPriority)")
////                }
////            }
//        }
    }
}

#Preview {
    TaskTutorial()
}
