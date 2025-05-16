import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nataliaogorek/Desktop/Concurrency_SwiftUI/Concurrency_SwiftUI/TaskGroup.swift", line: 1)
//
//  TaskGroup.swift
//  Concurrency_SwiftUI
//
//  Created by Natalia Ogorek on 14.05.25.
//

import SwiftUI


class TaskGroupDataManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetch1 = fetchImage(urlString: __designTimeString("#9287_0", fallback: "https://picsum.photos/300") )
        async let fetch2 = fetchImage(urlString: __designTimeString("#9287_1", fallback: "https://picsum.photos/300") )
        async let fetch3 = fetchImage(urlString: __designTimeString("#9287_2", fallback: "https://picsum.photos/300") )
        async let fetch4 = fetchImage(urlString: __designTimeString("#9287_3", fallback: "https://picsum.photos/300") )
        
        let (image1, image2, image3, image4) = await (try fetch1, try fetch2, try fetch3, try fetch4)
        
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        
        let urlStrings = [
            __designTimeString("#9287_4", fallback: "https://picsum.photos/300"),
            __designTimeString("#9287_5", fallback: "https://picsum.photos/300"),
            __designTimeString("#9287_6", fallback: "https://picsum.photos/300"),
            __designTimeString("#9287_7", fallback: "https://picsum.photos/300"),
            __designTimeString("#9287_8", fallback: "https://picsum.photos/300")
        ]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            
            for urlString in urlStrings {
                group.addTask() {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroup: View {
    
    @StateObject private var viewModel = TaskGroupViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: __designTimeInteger("#9287_9", fallback: 150))
                    }
                }
            }
            .navigationTitle(__designTimeString("#9287_10", fallback: "Async Let 🥳"))
            .task {
                await viewModel.getImages()
            }
        }
    }
}

#Preview {
    TaskGroup()
}
