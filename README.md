# JSON

Swift wrapper around Foundation.JSON (previously NSJSON).

### ⏬ Serialization

```swift
let json = try JSON([
    "null": nil,
    "bool": false,
    "string": "ferret 🚀",
    "int": 42,
    "double": 3.14159265358979,
    "object": JSON([
        "nested": "text"
    ]),
    "array": JSON([nil, true, 1337, "😄"])
])

let serialized = try json.makeBytes().string
```

### ⏫ Parsing

```swift
let serialized = "{\"hello\":\"world\"}"
let json = try JSON(bytes: string.bytes)
```

### ⛓ Node

JSON is `NodeConvertible` which means it can be easily converted to any other model that supports [Node](https://github.com/qutheory/node)

## 🌏 Environment

| Node  |     Xcode    |               Swift                    |
|:-----:|:------------:|:--------------------------------------:|
|0.1.x  |8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-20-qutheory|

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.qutheory.io) for instructions on how to install Swift 3. 

## 💧 Community

We pride ourselves on providing a diverse and welcoming community. Join your fellow Vapor developers in [our slack](slack.qutheory.io) and take part in the conversation.

## 🔧 Compatibility

Node has been tested on OS X 10.11, Ubuntu 14.04, and Ubuntu 15.10.
