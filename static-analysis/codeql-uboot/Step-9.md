## Step 9: Write your own class

In this step we will learn how to write our own CodeQL classes. This will help us make the logic of our query more readable, easier to reuse, and easier to refine.

We'd like to find the same results as in the previous step, i.e. the top level expressions that correspond to the `ntohl`, `ntohs` and `ntohll` macro invocations. It would be useful if we could refer to all such expressions directly, just like we can use `MacroInvocation` from the standard library to refer to all macro invocations.

We will define a **class** to describe exactly this set of expressions, and use it in the last step of this course.

The `Expr` class is the set of _all_ expressions, and we are interested in a more specific set of expressions, so the class we write will be a **subclass** of `Expr`.

### The `exists` quantifier

So far, we have declared variables in the `from` section of a query clause. Sometimes we need temporary variables in other parts of the query, and don't want to expose them in the query clause. The `exists` keyword helps us do this. It is a **quantifier**: it introduces temporary variables and checks if they satisfy a particular condition.

To understand how `exists` works, [visit the documentation](https://codeql.github.com/docs/ql-language-reference/formulas/#explicit-quantifiers).

Then look at this example from the “[Find the thief](https://codeql.github.com/docs/writing-codeql-queries/find-the-thief/)” CodeQL tutorial:

```ql
from Person t
where exists(string c | t.getHairColor() = c)
select t
```

This query selects all persons with a hair color that is a `string`. So we'll get all persons that are not bald, since we are able to find a `c` that defines their hair color. We don't really need `c` in the query except to know that it exists.

### :keyboard: Activity: Write your own `NetworkByteSwap` class

1. We recommend that you first [read the documentation on CodeQL classes](https://codeql.github.com/docs/ql-language-reference/types/#classes).
1. Edit the file `9_class_network_byteswap.ql` with the template below:

    ```ql
    import cpp

    class NetworkByteSwap extends Expr {
      NetworkByteSwap () {
        // TODO: replace <class> and <var>
        exists(<class> <var> |
          // TODO: <condition>
        )
      }
    }

    from NetworkByteSwap n
    select n, "Network byte swap"
    ```

1. This class `extends Expr`, which means it is a subclass of `Expr`, and it begins by taking all values from `Expr`. Now you need to restrict it to only the expressions we are interested in, which satisfy the condition of step 8.
   - You can do this by editing the [characteristic predicate](https://codeql.github.com/docs/ql-language-reference/types/#characteristic-predicates) `NetworkByteSwap() { ... }`. The template includes the `exists` quantifier, which will help.
   - Declare a temporary variable in the `exists` that refers to a macro invocation.
   - Constrain this macro invocation in the condition section of the `exists`. Use the same logic from the `where` section of your query in step 8.
   - How is the macro invocation related to the expression? Use the same logic from the `select` section of your query in step 8. You can refer to the macro invocation using the name of the variable you created, and you can refer to the expression using the `this` variable.

