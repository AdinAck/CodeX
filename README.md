# CodeX

Expression defined code views for animation.

![](https://github.com/user-attachments/assets/289cb759-ceec-4137-969a-6ca075896e8d)

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
