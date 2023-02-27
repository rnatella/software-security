## Step 3: Your first query

You will now run a simple CodeQL query, to understand its basic concepts and get familiar with your IDE.

### :keyboard: Activity: Run a CodeQL query

1. Edit the file `3_function_definitions.ql` with the following contents:
    ```ql
    import cpp

    from Function f
    where f.getName() = "strlen"
    select f, "a function named strlen"
    ```
    Don't copy / paste this code, but instead type it slowly. You will see the CodeQL auto-complete suggestions in your IDE as you type.
    
    - After typing `from` and the first letters of `Function`, the IDE will propose a list of available _classes_ from the CodeQL library for C/C++. This is a good way to discover what classes are available to represent standard patterns in the source code.
    - After typing `where f.` the IDE will propose a list of available _predicates_ that you can call on the variable `f`. 
    - Type the first letters of `getName()` to narrow down the list.
    - Move your cursor to a predicate name in the list to see its documentation. This is a good way to discover what predicates are available and what they mean.

1. Run this query: Right-click on the query editor, then click **CodeQL: Run Query**.
1. Inspect the results appearing in the results panel. Click on the result hyperlinks to navigate to the corresponding locations in the U-Boot code. Do you understand what this query does? You probably guessed it! This query finds all functions with the name `strlen`.
