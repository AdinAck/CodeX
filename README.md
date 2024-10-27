# CodeX

Expression defined code views for animation.

![](https://cdn.adinack.dev/CodeX/demo.mp4)

## Usage

```swift
struct ContentView: View {
    var body: some View {
        Code {
            Block([.braces]) {
                Line(.comma) {
                    Property("a")
                    TypeName("u32")
                }
                Line(.comma, comment: "a value of type T") {
                    Property("b")
                    TypeName("T")
                }
            } before: {
                Keyword("struct")
                Space()
                TypeName("Foo")
                Token("<")
                TypeName("T")
                Token(">")
                Space()
            }
        }
    }
}
```

This project is very useful when combined with [PresentationKit](https://github.com/adinack/presentationkit).
