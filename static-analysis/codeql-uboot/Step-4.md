## Step 4: Anatomy of a query

Now let's analyze what you have written. A CodeQL query has the following basic structure:

```ql
import /* ... path to some CodeQL libraries ... */

from /* ... variable declarations ... */
where /* ... logical formulas that say something about the variables ... */
select /* ... expressions to output ... */
```

The `from`/`where`/`select` part is the **query clause**: it describes what we are trying to find in the source code.

Let's look closer at the query we wrote in the previous step.
<details>
<summary>Show the query</summary>

  ```ql
  import cpp

  from Function f
  where f.getName() = "strlen"
  select f, "a function named strlen"
  ```

</details>

### Imports

At the top of the query is `import cpp`. This is an **import statement**. It brings into scope the standard CodeQL library that models C/C++ code, allowing us to use its features in our query. We'll use this library in every query, and in later steps we'll also use some more specialized libraries.

### Classes

In the `from` section, there is a declaration `Function f`. Here we declare a variable named `f` which has the type `Function`. `Function` is a **class** declared in the standard library (you can jump to the definition using <kbd>F12</kbd>). A class represents a collection of values, in this case the collection of all C/C++ functions in the source code.

### Predicates

Now look at the expression `f.getName()` in the `where` section. Here we call the predicate `getName` on the variable `f` of type `Function`. Predicates are the building blocks of a query: they express logical properties that we want to hold. Some predicates return results (like `getName`), and some predicates do not (they just assert that a property must be true).

So far your query finds all functions with the name `strlen`. It does this by asserting that the result of `f.getName()` is equal to the string `"strlen"`.

### :keyboard: Activity: Find all functions named `memcpy`

1. Edit the file `4_memcpy_definitions.ql`
1. Copy the query you wrote in step 3 into this file, and modify the `where` clause so that the query finds all definitions of functions named `memcpy` instead.
1. Run your query on the U-Boot codebase to verify the results.

