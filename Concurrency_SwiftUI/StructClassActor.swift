//
//  StructClassActor.swift
//  Concurrency_SwiftUI
//
//  Created by Natalia Ogorek on 15.05.25.
//


/*
 
 VALUE TYPES:
 - Struct, Enum, String, Intc etc.
 - Stored in the Stack
 - Faster
 - Thread safe
 - When you assign or pass a value type a new copy of data is created
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Stored in the Heap
 - Slower, but synchronized
 - NOT Thread safe
 - When you assign or pass a reference type a new reference to the original instance will be creted (pointer)
 
 STACK:
 - Stores Value Types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each thread has it's own stack
 
 HEAP:
 - Stores reference types
 - Shared accross threads
 
 STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the stack
 
 CLASS:
 - Based on REFERENCES (INSTANCES)
 - Cannot be mutated
 - Stored in the Heap
 - Can inherit from other classes
 
 ACTOR:
 - Same as Class, but thread safe
 
 
 When to use what?
 
 Structs: use for Data Models, we want them to be super fast and thread safe, also for Views
 Classes: use for View Models (conforms to ObservableObject)
 Actors: Shared 'Manager' and 'Data Store'
 
 
 
 */
 

import SwiftUI


actor StructClassActorDataManager {
    
    func getDataFromDatabase() {
        
    }
}


class StructClassActorViewModel: ObservableObject {
    @Published var title: String = ""
    
    init() {
        print("Viewmodel INIT")
    }
}


struct StructClassActor: View {
    
    @StateObject private var viewModel = StructClassActorViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
//                runTest()
            }
    }
}


struct StructClassActorHomeView: View {
    
    @State private var isActive: Bool = false
    var body: some View {
        StructClassActor(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
    
}

/*
#Preview {
    StructClassActor()
}
 */

extension StructClassActor {
    
    private func runTest() {
        print("Test started")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print("""
     - - - - - - - - - - - - - - - -
""")
    }
    
    private func structTest1() {
        print("Struct test 1")
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("pass the VALUES of objectA to objectB")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    
    private func classTest1() {
        print("Class test 1")
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("pass the REFERECE of objectA to objectB")
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print("Actor test 1")
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA: ", objectA.title)
            
            print("pass the REFERECE of objectA to objectB")
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            await objectB.updateTitle(newTitle: "Second title!")
            print("ObjectB title changed.")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
}

struct MyStruct {
    var title: String
}

// immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    var title: String
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActor {
    
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
     
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
    }
}


class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}


actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActor {
    
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class 1: ", class1.title)
        class1.title = "Title2"
        print("Class 1: ", class1.title)
        
        
        let class2 = MyClass(title: "Title1")
        print("Class 2: ", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class 2: ", class2.title)
    }
}
