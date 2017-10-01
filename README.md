# AlertDispatcher

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

- [Features](#features)
- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [License](#license)

## Features

- [x] Unified queue for all alerts
- [x] `Alert.tintColor`
- [x] `Alert` with custom actions
- [x] wait before & after alert
- [x] `enqueue()` & `present()`
- [x] `ignored()`
- [x] Alerts with `conditions`
- [ ] several alerts queues
- [ ] Action sheets

## Usage

Simple alert:
```swift
Alert.alert(title: "Super popup", message: "Description")
  .addCompletion { /* alert disappers */ }
  .present()
```

Dialog with custom action:

```swift
Alert.dialog(
  title: "Are you sure you want delete it?",
  cancelTitle: "No"
  actionTitle: "Delete",
  isDestructive: true,
  actionClosure: { /* remove smth */ }).enqueue()
```

### Dispatching
Every alert has `isDispatchable` property which can describe alert behaviour in case if other alert is already presented on screen.
Dispatchable alert will be putten in queue and will presented on screen after all alerts before it.
Not dispatchable alerts will just ignored if queue already has some alerts.
You can configure alert dispatching with `dispatchable(Bool)` method and then call `dispatch()`.
Or you can explicitly call `enqueue()` presentng alert **now or later**, or `present` for just presentng **now or never**.

- you can set `waitOnAppear(TimeInterval)` and `waitOnDisapper(TimeInterval)` delay in seconds.
- `ignored()` method just ignore this alert at all.
- with `addCondition(_ condition: @escaping () -> Bool)` you can specify custom condition for alert. Will be asked before presenting.

### Completions
- You can add as many completion handlers as you want by `addCompletion` method. Your completion will be called by FIFO rule.
- `onCompletion` method just rewrites all completion handlers with new one.

## Requirements

- Swift 4+
- xCode 9+
- iOS 8.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate NumberPad into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "OlegKetrar/AlertDispatcher"
```
Run `carthage update` to build the framework and drag the built `AlertDispatcher.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but `AlertDispatcher` does support its use on supported platforms.

Once you have your Swift package set up, adding TaskKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
  .Package(url: "https://github.com/OlegKetrar/AlertDispatcher")
]
```

## License

`AlertDispatcher` is released under the MIT license. See `LICENSE` for details.
