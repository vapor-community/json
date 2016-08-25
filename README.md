# JSON

JSON wrapper around [Node](https://github.com/vapor/node) using [vdka](https://github.com/vdka)'s JSON parsing and serializing.

![Swift](http://img.shields.io/badge/swift-v3.0--dev.08.18-brightgreen.svg)
[![Build Status](https://travis-ci.org/vapor/json.svg?branch=master)](https://travis-ci.org/vapor/json)
[![CircleCI](https://circleci.com/gh/vapor/json.svg?style=shield)](https://circleci.com/gh/vapor/json)
[![Code Coverage](https://codecov.io/gh/vapor/json/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor/json)
[![Codebeat](https://codebeat.co/badges/a793ad97-47e3-40d9-82cf-2aafc516ef4e)](https://codebeat.co/projects/github-com-vapor-json)
[![Slack Status](http://vapor.team/badge.svg)](http://vapor.team)

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

### vdka/JSON

Fast and Flexible Native Swift JSON

Parsing / Serializing from [vdka/JSON](https://github.com/vdka/JSON)

By [Ethan Jackwitz](https://github.com/vdka)

### ⛓ Node

JSON is `NodeConvertible` which means it can be easily converted to any other model that supports [Node](https://github.com/vapor/node).

## 🌏 Environment

|JSON|Xcode|Swift|
|:-:|:-:|:-:|
|0.5.x|8.0 Beta **6**|DEVELOPMENT-SNAPSHOT-2016-08-18-a|
|0.4.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-25-a|
|0.3.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-25-a|
|0.2.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-25-a|
|0.1.x|8.0 Beta **3**|DEVELOPMENT-SNAPSHOT-2016-07-20-qutheory|

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to install Swift 3.

## 💧 Community

We pride ourselves on providing a diverse and welcoming community. Join your fellow Vapor developers in [our slack](slack.qutheory.io) and take part in the conversation.

## 🔧 Compatibility

JSON has been tested on OS X 10.11, Ubuntu 14.04, and Ubuntu 15.10.

## 👥 Author

Created by [Tanner Nelson](https://github.com/tannernelson).
