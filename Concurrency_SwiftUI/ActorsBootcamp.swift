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
// Dispatch queues, locks or queues nside the class

// 3. Actors can solve the problem!


class MyDataManager {
    
    static let instance = MyDataManager()
    private init() {}
    
    var data: [String] = []
    private let lock = DispatchQueue(label: "com.MyAppName.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    private init() {}
    
    var data: [String] = []
    
    nonisolated
    let myRandomText = "something"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated
    func getSavedData() -> String {
        return "NEW DATA"
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear(perform:  {
            
            let randomText = manager.myRandomText
            let newString = manager.getSavedData()
        })
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
                //            DispatchQueue.global(qos: .background).async {
                //                manager.getRandomData { title in
                //                    if let data = title {
                //                        DispatchQueue.main.async {
                //                            self.text = data
                //                        }
                //                    }
                //                }
                //            }
            }
        }
    }
}

struct BrowseView: View {
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: {
                        self.text = data
                    })
                }
                //                DispatchQueue.global(qos: .default).async {
                //                    manager.getRandomData { title in
                //                        if let data = title {
                //                            DispatchQueue.main.async {
                //                                self.text = data
                //                            }
                //                        }
                //                    }
                //                }
            }
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
