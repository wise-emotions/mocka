# Wise Emotions - Mocka Guidelines

## Code Guidelines

We use [swift-format](https://github.com/apple/swift-format) to enforce the following rules. This is automatically run on the GitHub Actions.
Inside this repository, there is a `swiftformat.json` configuration files that set all the swift-format rules.

### Spacing

- There is NO space between the declaration of a class/struct/enum and the first line of code
- There is NO space after the declaration of a function
- There is NO space after the declaration of an `if`, `guard` etc.. condition
- There is 1 line space between each variable
- There is 1 line space after a `guard`/`if`/`reduce` etc.. body
- There is 1 line space before and after a `// MARK: - `

### Order

The order of the code is important, and usually we stick to a single style described below, however some situations may require a tweak of the order (for instance a view with different sections) and the order can be modified accordingly.

#### General Order

The normal order goes as follows:

- Constants
- Stored Properties / Variables
- Computed Properties
- Body (for a SwiftUI `View`)
- Functions

Each block should first contain the public ones, then internal then private.

If function A calls function B, function A should preceed function B.

```swift
func functionA() {
  functionB()
}

func functionB() {}
```

#### Helpers

Helpers (tho not recommended to exist) should be the last thing in a file.

### Documentation

Documentation is a very important part of any application regardless of its size and complexity.  
Properly documented code allows other developers to jump in the codebase easily and be productive sooner.  
Even if you are the only one working on a project, documenting the code helps you know precisely what to expect and does therefore makes it easier to refactor, modify and introduce new features faster and safer.

Documenting code should be done properly, or not done at all. A good documentation includes:

- A description of what a function does, what it is expected to return when applicable, and what it expects as parameters
It is preferable to provide an example for more complex functions
- A function with high complexity or special implementation should have an explanation of these choices in the documentation
- What type of data a variable is storing, what values can it store (if finite values are expected), and if it changes on special cases, what those cases are
- A function with special assumptions (example: Integer input parameter is positive) should be included in the documentation
- A description of the parameters/variables. Documenting variables start with properly choosing their names (more on that later)
But even when it might seem self-explanatory, it is better to explain what a variable does or what it reflects. Use `Cmd + Option + /` to have a good start
- A function with default values should document them
- Every sentence of the documentations must start with an uppercase letter, and finish with a dot (`.`)
- Use `///` and not `/** */`
- Use metadata keywords when they lead to a better understanding of the documentation. Read more and find these keywords at [Apple Documentation](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/)

**Example**

```swift
/// Creates the `Operation` with an execution block.
/// - Parameters:
///   - name: Operation name, useful for Queue Restoration. It must be unique. Default is `nil`.
///   - executionBlock: Execution block. Default is `nil`.
public init(name: String? = nil, executionBlock: ((_ operation: ConcurrentOperation) -> Void)? = nil) {
    super.init()

    self.name = name
    self.executionBlock = executionBlock
}
```

### Naming Conventions

Naming a variable, class, struct or function is an important aspect of writing code. Take your time when naming elements.

Clarity at the point of use is your most important goal. Entities such as methods and properties are declared only once but used repeatedly.  
Design APIs to make those uses clear and concise. When evaluating a design, reading a declaration is seldom sufficient; always examine a use case to make sure it looks clear in context.

Clarity is more important than brevity. Although Swift code can be compact, it is a non-goal to enable the smallest possible code with the fewest characters.  
Brevity in Swift code, where it occurs, is a side-effect of the strong type system and features that naturally reduce boilerplate.

#### General Rules

Include all the words needed to avoid ambiguity for anyone reading code where the name is used.

**Preferred**
```swift
extension List {
  public mutating func remove(at position: Index) -> Element
}
employees.remove(at: x)
```

**Not Preferred**
```swift
employees.remove(x) // unclear: are we removing x?
```

Remove all the words that are redundant.

**Preferred**
```swift
public mutating func remove(_ member: Element) -> Element

employees.remove(element)
```

**Not Preferred**
```swift
public mutating func removeElement(_ member: Element) -> Element

employees.removeElement(element)

```

#### Variables

- `Boolean` properties referring to a state, should be prefixed with `is`. Example: `isVisible`, `isTurnedOn`
- `Boolean` variables referring to a state, should be prefixed with `is` and the name of element they refer to. Example: `isButtonVisible`, `isSettingsSwitchOn`
- `Boolean` variables referring to a permission, should start with `should` or `can`. Example: `canResetPassword`, `shouldAskForPassword`
- `UI Elements` should clearly describe the element it refers to, not its color or position for instance. Example: `deleteButton` is a good name. `bottomRedButton` is not
- `Tuple` elements should always be labeled. Example: `let temperature: (min: Double, max: Double)`

`Array`s should be declared as follow:

**Preferred**
```swift
let dummyArray: [Int] = []
```

**Not Preferred**
```swift
let dummyArray2 = Array<Int>()
let dummyArray3 = [Int]()
```

Do not explicitly set the variable type when it can be easily inferred.

**Preferred**
```swift
let isTrue = true
```

**Not Preferred**
```swift
let isTrue: Bool = true
```

- Do not name the parameter of a function the same as a class property unless it is for the initializer.

- leverage `typealias`; It is easy to declare an `email` as `String`, but is "sadsgdsag" an email? What if in the future we want to validate that email? By leveraging `typealias`, we can give a better explanation of what to expect from a field.

**Preferred**

```swift
typealias People = [Person]

struct Event {
  let name: String
  let participants: People
}
```

#### Functions

Naming a function should clearly describe what it does. Its parameters should serve as documentation. Below is a two example, one you should do, one you should not do.

**Preferred**
```swift
/// Return an `Array` containing the elements of `self`
/// that satisfy `predicate`.
func filter(_ predicate: (Element) -> Bool) -> [Generator.Element]

/// Replace the given `subRange` of elements with `newElements`.
mutating func replaceRange(_ subRange: Range, with newElements: [E])
```

**Not Preferred**
```swift
/// Return an `Array` containing the elements of `self`
/// that satisfy `includedInResult`.
func filter(_ includedInResult: (Element) -> Bool) -> [Generator.Element]

/// Replace the range of elements indicated by `r` with
/// the contents of `with`.
mutating func replaceRange(_ r: Range, with: [E])
```

Take advantage of defaulted parameters when it simplifies common uses. They improve readability by hiding irrelevant information. **IMPORTANT**: It is better **NOT** to add defaulted parameters to an already existing function. This can lead to bugs.

- Try to keep defaulted parameters at the end of the function signature.

- Mention the default value of defaulted parameters if any.

### Leverage Swifts Builtin Functions

It is important and more efficient and cleaner to leverage `Swift`'s built in functions such as `map`, `reduce`, `allSatisfy`, `compactMap`, `sort`, `contains` etc... here is how to use the [most common ones](https://useyourloaf.com/blog/swift-guide-to-map-filter-reduce/).

### Reusability

- When working with models, regardless of how backend data is delivered, always aim to have small reusable models. If a transaction model has user parameters such as `userName`, `userID`, etc... Extract those information into a separated `User` model/struct which can later be reused.
- Leverage protocols and generics. [Protocols](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html) and [Generics](https://docs.swift.org/swift-book/LanguageGuide/Generics.html) are powerful Swift options that allows to write better reusable code. Make sure to be familiar with them.

### Enum/Struct vs Class

As a best practice always leverage `enum` for encapsulation/namespacing, and `struct` over `class`.
Unless you have to use class for obvious reasons, like subclassing a `UIView`, prefer `struct`. Being a value type, it helps you avoid bugs knowing that the value being modified is to that single variable.

### Encapsulate Logic

Generally known as `Managers`, choose to create objects responsible for handling specific parts of business logic. For instance, an app dealing with GitHubAPI, can have a `GitHubAPIManager` which contains all the code related to that business logic.

A manager should have a configuration provider, that is a protocol backed object that contains all the necessary pieces for the proper functioning of that manager. The manager itself should contain ideally only one stored variable, that is the configuration, and computed variables. Other stored variables can exist if they exist to access a sub value faster, and are populated from the configuration variable itself.

By having a configuration provider it makes testing a lot easier. You only change the configurationProvider values, pass the new values to the Manager, and test it.

**Example**

```swift
protocol GitHubAPIManagerProvider {
  /// The base URL for Github API calls
  var baseUrl: String { get }
  /// The URL session used to launch the data tasks.
  var session: URLSession { get }
}

struct GitHubAPIManagerConfigurationProvider: GitHubAPIManagerProvider {
  var baseUrl = "https://api.github.com/"
  var session: URLSession = URLSession.shared
}

struct GitHubAPIManager {
  let configuration: GitHubAPIManagerProvider

  init(config: GitHubAPIManagerProvider) {
    self.configuration = config
  }

  // Logic goes here.
}
```

### No Abbreviation

Avoid using abbreviations when writing code. Always prefer clarity over fast. Prefer clarity over abbreviation.

## Visual Guidelines

- Code should be indented by 2 white spaces, not 4. This helps with visualizing the code. It is really useful with multiple nested functions and closures. Please activate the following Xcode settings under `Text Editing` tab > `While Editing` > `Automatically trim trailing whitespace` and the sub-option `Including whitespace-only lines`.

- Code should wrap at 150 characters. This assures a proper vision on 13" inch `MacBook`s.

- Always leave a space before opening a brace `{`.

**Preferred**
```swift
func remove(element at: Int) {

}
```

**Not Preferred**
```swift
func remove(element at: Int){

}
```

The opening brace should on the same line as the function signature / class name / struct name etc.

**Preferred**
```swift
func remove(element at: Int) {

}
```

**Not Preferred**
```swift
func remove(element at: Int)
{

}
```

The `:` in a Dictionary should immediately follow the key, and have a whitespace before the value.

**Preferred**
```swift
[key: value]
```

**Not Preferred**
```swift
[key : value]
[key :value]
[key:value]
```

- When declaring a variable with an explicit type, a white space should be kept after the semicolon. Example: `var button: UIButton?`

- When writing a boolean condition, do not compare a boolean variable to a boolean value.

**Preferred**
```swift
let isTrue = true

if isTrue {
  // Do something.
}

guard !isTrue else {
  // Do something.
}
```

**Not Preferred**
```swift
let isTrue = true

if isTrue == true {
  // Do something.
}

guard isTrue == false else {
  // Do something.
}
```

Moreover, rather than using `!isTrue` it it better to create a variable called `isNotTrue` for better clarity.

In a conditional statement only use parenthesis when grouping elements logically together.

**Preferred**
```swift
if x == 3 {
  // Do something.
}

if (x == 3 || y == 5) && z == 2 {
  // Do something.
}
```

**Not Preferred**
```swift
if (x == 3) {
  // Do something.
}

if (x == 3 || y == 5) {
  // Do something.
}
```

## Miscellaneous

### MARK

Here is a list of preferable `// MARK: -` names to give to sections:

- `Init`
- `Constants` for `static let` constants
- `Stored Properties`
- `Computed Properties`
- `Body` (for SwiftUI `View`)
- `Functions`
- `Helpers`

### File Headers

File headers should contain only the app name or the SDK name.

Below is a recommended format:

```swift
//
//  Mocka
//
```

### Self

We opted to not explicitly call self, unless necessary.

### Missing Implementation

In case of a missing implementation, do **NOT** add a `// TODO` but rather a `#warning(_ message: String)` that way it is more bold and explicit that something is missing.

### Code Warning

Before pushing code, compile it, and make sure there are no code warnings. Except for third-party libraries and missing implementation warnings. It is important to always maintain a 0 warning code base.

### Commented Code

The only accepted commented code inside the code base are documentation, or explanation on why a certain decision was made or equivalent.

Garbage code, old code, and equivalents should **NEVER** be included in the codebase. If a code is commented, it might as well be deleted. If we will need that code in the future, we will use the Git History feature.

### Write Abstraction

If you think you are re-writing the same code over and over again, with a lot of boiler plate, evaluate if it makes sense to dedicate some time to writing a component / extension to centralize it and cut future coding time.

## Git

GitFlow is a proven working method for collaborating on big projects. If you are not familiar with it, please read [this document](https://nvie.com/posts/a-successful-git-branching-model/).

- The **main** branch should mirror the currently released version.

- The **develop**  branch is the main working branch to which all code should finally be merged. You do not directly work on this branch. You do not modify code on this branch.

- Each task should be on a separate branch. Branches should be named in the following manner:
  - Feature: `feature/name-of-feature`
  - Fix: `bugfix/name-of-bugfix`
  - When a release should be created: `release/<number-of-the-release>`

- When a task is finished, a Pull Request should be opened, reviewed by 2 developers following these guidelines, and then merged into the **develop** branch.

- Do not keep dead branches around. When a branch is merged, it should be automatically deleted by GitHub, but if it doesn't, please delete it.

## How To Contribute

NOTHING IS A LAW. SHARE, DISCUSS, and RESEARCH best practices. Propose it to team members and update this file accordingly.
