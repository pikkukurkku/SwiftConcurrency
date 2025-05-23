import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nataliaogorek/Desktop/Concurrency_SwiftUI/Concurrency_SwiftUI/AsyncLet.swift", line: 1)
//
//  AsyncLet.swift
//  Concurrency_SwiftUI
//
//  Created by Natalia Ogorek on 14.05.25.
//

import SwiftUI

struct AsyncLet: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/300")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: __designTimeInteger("#54640_0", fallback: 150))
                    }
                }
            }
            .navigationTitle(__designTimeString("#54640_1", fallback: "Async Let 🥳"))
            .onAppear {
                Task  {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchTitle1 = fetchTitle()
                        
                        let (image, title) = await (try fetchImage1, fetchTitle1)
                        
//                        async let fetchImage2 = fetchImage()
//                        async let fetchImage3 = fetchImage()
//                        async let fetchImage4 = fetchImage()
//                        
//                        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
//                        self.images.append(contentsOf: [image1, image2, image3, image4])
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//                        
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//                        
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//                        
//                        let image4 = try await fetchImage()
//                        self.images.append(image4)
                        
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
       return __designTimeString("#54640_2", fallback: "NEW TITLE")
    }
    
    func fetchImage() async throws -> UIImage {
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

#Preview {
    AsyncLet()
}
