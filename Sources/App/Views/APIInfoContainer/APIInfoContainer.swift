//REMOVE ME

import SwiftUI

struct APIInfoContainer: View {
  
  let keyValueItems = [KeyValueItem(key: "aaa", value: "aaa"), KeyValueItem(key: "aaa", value: "aaa"), KeyValueItem(key: "aaa", value: "aaa")]
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("URL")
        
        ZStack {
          Color.black
          
          TextField("/api/v1/transactions/*/pippo", text: .constant("/api/v1/transactions/*/pippo"))
            .padding()
            .textFieldStyle(PlainTextFieldStyle())
        }
        .cornerRadius(8)
        
        Text("Query")
        
        ZStack {
          Color.black
          
          KeyValueTable(keyValueItems: keyValueItems)
        }
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(8)
        
        Text("Headers")

        ZStack {
          Color.black
          
          KeyValueTable(keyValueItems: keyValueItems)
        }
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(8)
        
        Text("Body")

        ZStack {
          Color.black
          
          TextEditor(text: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate"))
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(8)
      }
    }
  }
}

struct APIInfoContainer_Previews: PreviewProvider {
  static var previews: some View {
    APIInfoContainer()
  }
}

extension NSTextView {
  open override var frame: CGRect {
    didSet {
      backgroundColor = .clear
      drawsBackground = true
      
    }
  }
  
  open override func scrollWheel(with event: NSEvent) {
    // 1st nextResponder is NSClipView
    // 2nd nextResponder is NSScrollView
    // 3rd nextResponder is NSResponder SwiftUIPlatformViewHost
    self.nextResponder?.nextResponder?.nextResponder?.scrollWheel(with: event)
  }
}
