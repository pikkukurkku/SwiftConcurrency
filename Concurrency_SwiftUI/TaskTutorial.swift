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
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
           let (data, _ ) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
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
                NavigationLink("CLICK ME! 🤓") {
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
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
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
