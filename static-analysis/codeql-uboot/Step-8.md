## Step 8: Changing the selected output

In the previous step, you found invocations of the macros we are interested in. Modify your query to find the top-level **expressions** these macro invocations expand to.

**Note**: An expression is a source code element that can have a value at runtime. Invoking a macro can bring various source code elements into scope, including expressions.

### :keyboard: Activity: Find the expressions that correspond to macro invocations

As before, if you don't know how a piece of source code is represented in the library, you can use the auto-completion and contextual help to discover the classes and predicates you need.

1. Edit the file `8_macro_expressions.ql` with the previous query
2. Use the [`getExpr()` predicate](https://codeql.github.com/codeql-standard-libraries/cpp/semmle/code/cpp/Macro.qll/predicate.Macro$MacroInvocation$getExpr.0.html) in the `select` section, to return the wanted expressions.


