# DraggableButtonView-Swift
Draggable Button View - Inspired by the scroll button on the Reddit iOS app

## Demo
---
<img src=buttonDemo.gif width=155 height=276 />

## Usage
---
### Programmatic
~~~swift
let size = 50.0
let x = 100.0
let y = 100.0

let buttonFrame = CGRect(x: x, y: y, width: size, height: size)

let dragView = DraggableButtonView(frame: buttonFrame)
        
dragView.delegate = self   // Where self implements DraggableButtonViewDelegate
dragView.dataSource = self // Where self implements DraggableButtonViewDataSource
        
view.addSubview(dragView)
~~~

### Interface Builder
~~~swift
TODO: Implement IBDesignable
~~~
