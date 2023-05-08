# AppleScriptBridge

A collection of helpers for dealing with AppleEvents in Swift. This package focuses on bridging `NSAppleEventDescriptor` with Swift types for easier automation of scriptable applications. 

## AppleEventDescriptorRepresentable

A core protocol of the library is `AppleEventDescriptorRepresentable`, which encapsulates converting between Swift types and AppleEvent descriptors. The is similar to `RawRepresentable`, allowing initialization from a descriptor and providing a descriptor. 

Default implementations are provided for many primitive types that are available from a descriptor:

- String
- Date
- Bool
- Double
- File URL
- Int

Conditional conformance is also added for types whose elements are descriptors: 

- Arrays
- Optionals
- RawRepresentable

## NSAppleEventDescriptor

There are several initializers on `NSAppleEventDescriptor` which reduce boilerplate, mostly dealing with constructing lists. 

`NSAppleEventDescriptor.init(listDescriptor:)` handles initializing a list descriptor and adding each item in the array.

`NSAppleEventDescriptor.missingValue()` is also added in addition to `.null()`.  


## NSAppleScript
 

### Throwing Methods

Both init and execute have options which will throw instead of requiring a dictionary be passed in:

```
let scriptURL = URL(fileURLWithPath: "/path/to/yourscript.applescript")
let script = try NSAppleScript(contentsOf: scriptURL)

let result = try script.execute()
```

### Calling Handlers

Calling handlers (methods) in an AppleScript is usually full of boilerplate requiring creating a whole host of other events and descriptors. This has been simplified to a single method:

```
let result = try script.execute(scriptHandler: "greet", args: [NSAppleEventDescriptor(string: "Emory")])
// <NSAppleEventDescriptor: 'utxt'("Hello Emory")>
```

### Using `AppleEventDescriptorRepresentable`

However, passing in `NSAppleEventDescriptor` is still inconvenient. With `AppleEventDescriptorRepresentable` we can get Swift types out directly:

```
let result: String = try script.execute()
// Hello, World!
```

We can also call handlers while passing in Swift types:

```
try script.execute(scriptHandler: "setRating", args: 5)
// Handler doesn't return a value 

let result: String = try script.execute(scriptHandler: "greet", args: "Emory")
// Hello Emory
```

There's also a special case where where a script returning `nil` is invalid and instead throws:

```
let result: String = try script.execute(scriptHandler: "getRating")
// 5
```
