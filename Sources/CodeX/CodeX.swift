import SwiftUI

@available(iOS 18.0, *)
struct Colors {
    static let background: Color = .init(red: 0x1e / 0xff, green: 0x1e / 0xff, blue: 0x1e / 0xff)
    static let keyword: Color = .init(red: 0xfb / 0xff, green: 0x48 / 0xff, blue: 0x33 / 0xff)
    static let typeName: Color = .init(red: 0xfa / 0xff, green: 0xbd / 0xff, blue: 0x2e / 0xff)
    static let attribute: Color = .init(red: 0x83 / 0xff, green: 0xa5 / 0xff, blue: 0x98 / 0xff)
    static let property: Color = .init(red: 0xeb / 0xff, green: 0xdb / 0xff, blue: 0xa2 / 0xff)
    static let function: Color = .init(red: 0xfb / 0xff, green: 0xcb / 0xff, blue: 0x00 / 0xff)
    static let op: Color = .init(red: 0x8e / 0xff, green: 0x8e / 0xff, blue: 0x8e / 0xff)
    static let variable: Color = .init(red: 0xd0 / 0xff, green: 0xd0 / 0xff, blue: 0xd0 / 0xff)
    static let variableSpecial: Color = .init(red: 0x83 / 0xff, green: 0xa5 / 0xff, blue: 0x98 / 0xff)
    static let comment: Color = .init(red: 0x80 / 0xff, green: 0x80 / 0xff, blue: 0x80 / 0xff)
}

@available(iOS 18.0, *)
public struct Code<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    public var body: some View {
        Vertical {
            content()
                .fontDesign(.monospaced)
        }
    }
}

@available(iOS 18.0, *)
struct Horizontal<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            content()
        }
    }
}

@available(iOS 18.0, *)
struct Vertical<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            content()
        }
    }
}

@available(iOS 18.0, *)
public struct Token: View {
    let token: String
    
    init(_ token: String) {
        self.token = token
    }
    
    public var body: some View {
        Text(token)
    }
}

@available(iOS 18.0, *)
public struct Space: View {
    public var body: some View {
        Text(" ")
    }
}

public enum CommentStyle {
    case inline, doc
}

@available(iOS 18.0, *)
public struct Comment: View {
    let text: String
    let style: CommentStyle
    
    init(_ text: String) {
        self.text = text
        self.style = .inline
    }
    
    init(_ text: String, style: CommentStyle) {
        self.text = text
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            switch style {
            case .inline:
                Text("//")
            case .doc:
                Text("///")
            }
            Space()
            Text(text)
        }
        .foregroundStyle(Colors.comment)
    }
}

public enum LineEnds {
    case semicolon, comma
}

@available(iOS 18.0, *)
public struct Line<Content: View>: View {
    let end: LineEnds?
    
    @ViewBuilder let content: () -> Content
    @ViewBuilder let comment: String?
    
    init(_ end: LineEnds? = nil, comment: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.end = end
        self.content = content
        self.comment = comment
    }
    
    public var body: some View {
        Horizontal {
            content()
            
            if let end {
                switch end {
                case .semicolon:
                    Token(";")
                case .comma:
                    Token(",")
                }
                
                if let comment {
                    Space()
                    Comment(comment)
                }
            }
        }
    }
}

@available(iOS 18.0, *)
public struct Keyword: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .foregroundStyle(Colors.keyword)
    }
}

@available(iOS 18.0, *)
public struct TypeName: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .foregroundStyle(Colors.typeName)
    }
}

@available(iOS 18.0, *)
public struct Property: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Horizontal {
            Text(text)
                .foregroundStyle(Colors.property)
            Token(":")
            Space()
        }
    }
}

@available(iOS 18.0, *)
public struct Function: View {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    public var body: some View {
        Text(name)
            .foregroundStyle(Colors.function)
    }
}

@available(iOS 18.0, *)
public struct Operator: View {
    let token: String
    
    init(_ token: String) {
        self.token = token
    }
    
    public var body: some View {
        Text(token)
            .foregroundStyle(Colors.op)
    }
}

public enum VariableStyle {
    case normal, special
}

@available(iOS 18.0, *)
public struct Variable: View {
    let name: String
    let style: VariableStyle
    
    init(_ name: String, style: VariableStyle = .normal) {
        self.name = name
        self.style = style
    }
    
    public var body: some View {
        Text(name)
            .foregroundStyle(style == .special ? Colors.variableSpecial : Colors.variable)
    }
}

@available(iOS 18.0, *)
public struct Parameter<Content: View>: View {
    let name: String
    @ViewBuilder let content: () -> Content
    
    init(_ name: String, @ViewBuilder content: @escaping () -> Content) {
        self.name = name
        self.content = content
    }
    
    public var body: some View {
        Variable(name)
        Token(":")
        Space()
        content()
    }
}

public enum BlockStyle {
    case parenthesis, braces, brackets
}

public enum BlockType {
    case inline, multiline
}

@available(iOS 18.0, *)
public struct Block<Content: View, Before: View, After: View>: View {
    let style: [BlockStyle]?
    let type: BlockType
    
    @ViewBuilder let content: () -> Content
    @ViewBuilder let before: () -> Before
    @ViewBuilder let after: () -> After
    
    init(_ style: [BlockStyle]? = nil, _ type: BlockType, @ViewBuilder content: @escaping () -> Content) where Before == EmptyView, After == EmptyView {
        self.style = style
        self.type = type
        self.content = content
        self.before = { EmptyView() }
        self.after = { EmptyView() }
    }
    
    init(_ style: [BlockStyle]? = nil, @ViewBuilder content: @escaping () -> Content, @ViewBuilder before: @escaping () -> Before = { EmptyView() }, @ViewBuilder after: @escaping () -> After = { EmptyView() }) {
        self.style = style
        self.type = .multiline
        self.content = content
        self.before = before
        self.after = after
    }
    
    var start: some View {
        Group {
            if let style {
                ForEach(style, id: \.self) { token in
                    switch token {
                    case .parenthesis:
                        Token("(")
                    case .braces:
                        Token("{")
                    case .brackets:
                        Token("[")
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    var stop: some View {
        Group {
            if let style {
                ForEach(style.reversed(), id: \.self) { token in
                    switch token {
                    case .parenthesis:
                        Token(")")
                    case .braces:
                        Token("}")
                    case .brackets:
                        Token("]")
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    @ViewBuilder var view: some View {
        Horizontal {
            before()
            start
        }
        switch type {
        case .inline:
            Horizontal {
                content()
            }
        case .multiline:
            Horizontal {
                Token("\t")
                Vertical {
                    content()
                }
            }
        }
        Horizontal {
            stop
            after()
        }
    }
    
    public var body: some View {
        switch type {
        case .inline:
            Horizontal {
                view
            }
        case .multiline:
            Vertical {
                view
            }
        }
    }
}

@available(iOS 18.0, *)
struct CodeView: View {
    var t: CGFloat
    var scale: CGFloat
    
    var ty_def: some View {
        Group {
            Keyword("struct")
            Space()
            TypeName("Foo")
            if t >= 1 {
                Group {
                    Token("<")
                    TypeName("T")
                    Token(">")
                }
                .transition(.scale.combined(with: .opacity))
            }
            Space()
        }
    }
    
    var body: some View {
        Code {
            Comment("A Foo", style: .doc)
                .blur(radius: t == 3 ? 10 * scale : 0)
            
            if t > 3 {
                Line {
                    ty_def
                }
                
                Block {
                    Line(.comma) {
                        TypeName("T")
                        Token(":")
                        Space()
                        TypeName("MyTrait")
                    }
                } before: {
                    Keyword("where")
                }
            }
            
            Block([.braces]) {
                Line(.comma) {
                    Property("a")
                    TypeName("u32")
                }
                .padding(t == 4 ? 8 * scale : 0)
                .background {
                    RoundedRectangle(cornerRadius: 16 * scale)
                        .fill(Color.white.opacity(t == 4 ? 0.1 : 0))
                }
                
                if t >= 1 {
                    Line(.comma, comment: t < 2 ? "a value": "a value of type T") {
                        Property("b")
                        TypeName("T")
                    }
                    .transition(.scale.combined(with: .opacity))
                    .shadow(color: .blue.opacity(t == 3 ? 1 : 0), radius: 40 * scale)
                }
            } before: {
                if t <= 3 {
                    ty_def
                        .blur(radius: t == 3 ? 10 * scale : 0)
                }
            }
            
            if t >= 3 {
                Group {
                    Space()
                    
                    Block([.braces, .brackets]) {
                        Line {
                            Variable("a")
                            Operator("+")
                            Variable("b")
                        }
                    } before: {
                        Keyword("fn")
                        Space()
                        Function("add")
                        Block([.parenthesis], .inline) {
                            Parameter("a") {
                                Operator("&")
                                Keyword("mut")
                                Space()
                                TypeName("u32")
                            }
                            Token(",")
                            Space()
                            Parameter("a") {
                                TypeName("u32")
                            }
                        }
                        Space()
                    } after: {
                        Token(",")
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .blur(radius: t == 3 ? 10 * scale : 0)
            }
        }
        .font(.system(size: 100 * scale))
        .rotation3DEffect(.degrees(t <= 1 ? 0 : t <= 2 ? 5 : -5), axis: (x: 0, y: 1, z: 0))
    }
}

@available(iOS 18.0, *)
#Preview {
    CodeView(t: 4, scale: 0.2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.background)
}
