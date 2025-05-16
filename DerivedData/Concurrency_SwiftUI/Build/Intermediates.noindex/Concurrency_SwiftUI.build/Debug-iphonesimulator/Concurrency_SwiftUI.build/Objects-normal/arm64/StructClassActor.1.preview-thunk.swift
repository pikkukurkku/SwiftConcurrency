import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/nataliaogorek/Desktop/Concurrency_SwiftUI/Concurrency_SwiftUI/StructClassActor.swift", line: 1)
//
//  StructClassActor.swift
//  Concurrency_SwiftUI
//
//  Created by Natalia Ogorek on 15.05.25.
//

import SwiftUI

struct StructClassActor: View {
    var body: some View {
        Text(__designTimeString("#31817_0", fallback: "Hello, World!"))
            .onAppear {
                runTest()
            }
    }
}

#Preview {
    StructClassActor()
}

extension StructClassActor {
    
    private func runTest() {
        print(__designTimeString("#31817_1", fallback: "Test started"))
    }
    
}
