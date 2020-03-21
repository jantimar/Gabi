# Gabi

[![SPM Compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
![Platforms: macOS, iOS](https://img.shields.io/badge/platforms-macOS-brightgreen.svg?style=flat)

Helper library for reading XML

## Instalation

As a Swift Package

`Gabi` is distributed via SPM. You can use it as a framework in your macOS or iOS project. In your Package.swift add a new package dependency:
```
.package(
    url: "https://github.com/jantimar/Gabi",
    from: "0.1.0"
)
```

## Usage
Gabi parser support `Data` and `String` XML format.
For parse document just create instance of `Gabi` and call parse function
```
let xmlService = Gabi()
xmlService.parse(xml: xml) { result in
	...
}
```
After finish read whole XML document you can process your result `Result<XML, Error>`

Every `XML` containe `name` , `attributes`,  `nodes`, `value` `cData` `parentNode`

## Examples

### Subscript
To make things easier, `XML` implement subscript with name to get all child nodes with same name
```
let xml: XML ... 
let items = xml["items"]
```

### Sequence
`XML` implement `Sequence` so you can easily call `map`, `forEach`, `filter` and a lot of more helpful functions, all of this iteration will be called on `node`

For example from XML
```
<list>
  <name>Jan</name>
  <name>Zuzka</name>
</list>
```
```
xml["name"].map { $0.value } //  ["Jan", "Zuzka"]
```
You can get value of every from `name` child

### First with name
Many times you expect just one child, for this case you can use
```
xml.first(name: "name")
```
To get the first node with `name`

### Child of child
When your XML has more layers

```
<list>
  <user>
    <name>Jan</name>
  </user>
</list>
```
your code can look smiliar like this

```
let firstUserName = xml["user"]
	.first(name: "name")
	.value	// "Jan"
```

### Read node attribute
As you can notice, node attributes is  `[String: String]` dictionary
```
xml.attributes["description"]
```

For more examples look on tests in `GabiTests.swift` 

## License and Credits

**Gabi** is released under the MIT license. See [LICENSE](/LICENSE) for details.

Created by [Jan Timar](https://github.com/jantimar).
