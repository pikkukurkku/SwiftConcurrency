import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nataliaogorek/Desktop/Concurrency_SwiftUI/Concurrency_SwiftUI/ActorsBootcamp.swift", line: 1)
//
//  ActorsBootcamp.swift
//  Concurrency_SwiftUI
//
//  Created by Natalia Ogorek on 16.05.25.
//

import SwiftUI

// 1. What is the problem that actors are solving?
// a data race problem, when two different threads are accessing the same object in memory

// 2. How was this problem solved prior to actors?
// 3. Actors can solve the problem!


class MyDataManager {
    
    static let instance = MyDataManager()
    private init() {
        
    }
    
    var data: [String] = []
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
}

struct HomeView: View {
    
    let manager = MyDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(__designTimeFloat("#1741_0", fallback: 0.8)).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            if let data = manager.getRandomData() {
                self.text = data
            }
        }
    }
}

struct BrowseView: View {
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(__designTimeFloat("#1741_1", fallback: 0.8)).ignoresSafeArea()
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(__designTimeString("#1741_2", fallback: "Home"), systemImage: __designTimeString("#1741_3", fallback: "house.fill"))
                }
            BrowseView()
                .tabItem {
                    Label(__designTimeString("#1741_4", fallback: "Browse"), systemImage: __designTimeString("#1741_5", fallback: "magnifyingglass"))
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
