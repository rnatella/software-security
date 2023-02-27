## Step 5: Using different classes and their predicates

We want to identify integer values that are supplied from network data. A good way to spot those is to look for use of network ordering conversion macros such as `ntohl`, `ntohll`, and `ntohs`.

In the `from` section of the query, you declare some variables, and state the  types of those variables. The type tells us what the possible values are for the variable.

In the previous query you were querying for values in the class `Function` to find functions in the source code. We have to query a different type to find macros in the source code instead. Can you guess its name?

*NOTE: These Network ordering conversion utilities can be macros or functions depending on the platform. In this course, we are looking at a Linux database, where they are macros.*

### :keyboard: Activity: Find all `ntoh*` macros

1. Edit the file `5_macro_definitions.ql`
1. Write a query that finds the definitions of the macros named `ntohs`, `ntohl` or `ntohll`. Use the auto-completion in the Visual Studio Code extension to guide you:
    - Wait a moment after typing `from` to get a list of available classes in the CodeQL standard library for C/C++. Which class in this list represents macros? Create a variable with this class as its type.
    - In the `where` section, type `<your_variable_name>` followed by a dot `.`, and wait a moment to get the list of predicates available for a value in the variable's type. Hover over each predicate to see the inline documentation.
    - Which predicate will give us the name of a macro?
    - Use the `or` keyword to combine multiple conditions where you want at least one condition to be met. Here we are interested in three possible macro names.
1. To write a more compact query that searches for all three macros at once, instead of using three cases combined by `or` you have 2 choices:
    - Use a regular expression. Check out the predicate `string::regexpMatch` in the [built-in predicates for string](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#built-ins-for-string). CodeQL uses the [`java.util.Pattern` regexp conventions](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html).
    - Use a [_set literal expression_](https://codeql.github.com/docs/ql-language-reference/expressions/#set-literal-expressions) to equate `<your_variable_name>` to a list of choices `<your_variable_name> in ["bar", "baz", "quux"]`

