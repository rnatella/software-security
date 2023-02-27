## Step 7: Relating two variables, continued

In step 5, you wrote a query that finds the **definitions** of macros named  `ntohs`, `ntohl` and `ntohll` in the codebase. Now, we want to find all the **invocations** of these macros in the codebase.

This will be similar to what you did in step 6, where you created variables for functions and function calls, and restricted them to look for a particular function and its calls.

**Note**: A macro invocation is a place in the source code that calls a particular macro. This is comparable to how a function call is a place in the source code that calls a particular function.

### :keyboard: Activity: Find all the invocations of `ntoh*` macros

This query will look like the previous one, but with macros instead of functions.

1. Edit the file `7_macro_invocations.ql`
1. Use the auto-completion to find the class that represents macro invocations, and declare a variable that belongs to this class.
1. Use auto-completion again on your macro invocation variable, to find the predicate that tells us the target macro being invoked.
1. Combine this with your logic from step 5 to make sure the target is one of the `ntoh*` macros.
1. As in the previous step, you can make your query more compact by omitting superfluous variable declarations.

