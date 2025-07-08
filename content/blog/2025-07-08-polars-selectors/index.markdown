---
title: Polars Selectors
author: 'Bas Machielsen'
date: '2025-07-08'
excerpt: 'A small blogpost about selection of variables in polars.'
slug: []
categories: []
tags: []
---

Excellent. Let's dive into these more advanced and idiomatic Polars techniques. These patterns are crucial for writing concise, expressive, and efficient Polars code, moving beyond basic transformations into more nuanced data manipulation.

We will use a new example dataset for these concepts to better illustrate their specific use cases. Let's imagine a dataset from a university's course enrollment system.

```python
import polars as pl
import polars.selectors as cs # We'll need this for advanced column selection

# Create our example DataFrame
df_courses = pl.DataFrame({
    "student_id": [101, 102, 101, 103, 102, 104, 101],
    "full_name": ["Alice Smith", "Bob Johnson", "Alice Smith", "Charlie Brown", "Bob Johnson", "Diana Prince", "Alice Smith"],
    "course_name": ["Intro to CS", "Linear Algebra", "Data Structures", "Calc I", "Linear Algebra", "World History", "Algorithms"],
    "grade_numeric": [95.5, 88.0, 91.2, 76.0, 89.5, None, 98.1],
    "grade_letter": ["A", "B", "A", "C", "B", "A", "A"],
    "credits": [4, 4, 4, 3, 4, 3, 4]
})
```

---

### Advanced Indexing: Selecting Data by Position

While filtering data based on its content (`.filter()`) is the most common way to select rows, there are times when you need to select data based on its integer position or index. Polars provides powerful and efficient ways to do this, far beyond simple head/tail operations.

#### Method 1: Chaining `nth`, `drop`, and `slice`

This method shows the power of chaining operations together to achieve a precise subset. Let's break down the user's first snippet: `(df.select(...).drop(...)).slice(...)`.

1.  **`pl.nth(indices)`**: This expression is used within a `select` or `filter` context to pick rows by their specific, zero-based index. You can provide a single index or a list of indices. It's the equivalent of "give me the 0th row, the 1st row, and the rows from index 3 to 5."

2.  **`.drop(column_name)`**: This is a straightforward method to remove one or more columns from the DataFrame after they have been used in a calculation or selection.

3.  **`.slice(offset, length)`**: This method selects a contiguous block (a "slice") of rows from a DataFrame, starting at the `offset` index and taking `length` rows.

Let's apply this logic to our `df_courses` dataset. Imagine we want to select the first two rows and rows 4 through 5, create a lowercase version of the `course_name`, drop the original `course_name`, and then from that result, take only the rows starting from the 4th position.

```python
# The logic from the user's snippet, applied to our data
# Let's rename 'Cursus' to 'course_name' for our example
complex_selection = (
    df_courses
    .select(
        pl.nth([0, 1] + list(range(3, 5))), # Select rows 0, 1, 3, 4
        test=pl.col("course_name").str.to_lowercase() # Create a new column 'test'
    )
    .drop("course_name") # Drop the original column
).slice(2, 2) # From the result, take 2 rows starting at index 2
```
This chain is executed sequentially. First Polars selects rows `[0, 1, 3, 4]`, creating a new 4-row DataFrame. Then, `.slice(2, 2)` is applied to this *new* DataFrame, selecting the final two rows (which were originally rows 3 and 4 of `df_courses`).

#### Method 2: Using `polars.selectors`

Polars has a dedicated module, `polars.selectors` (conventionally imported as `cs`), for creating expressive column selections. This is often cleaner than manual list building.

The user's snippet `cs.by_index(...)` is a powerful column selector. It allows you to select columns based on their integer position.

```python
# Select the first two columns (student_id, full_name) and the last three columns
# using their indices.
# Note: list(range(3,6)) corresponds to columns at index 3, 4, and 5.
selected_cols_by_index = df_courses.select(
    cs.by_index([0, 1] + list(range(3, 6)))
)
```
Using selectors like `cs.by_index()`, `cs.by_name()`, `cs.by_dtype()`, or `cs.matches()` is the modern, idiomatic way to build lists of columns for operations within `select` or `with_columns`.

### Dynamic Column Transformations and Renaming

As your data pipelines grow, you often need to apply transformations not just to column values, but to the column names themselves.

#### Dynamic Renaming with a Lambda Function

The `.rename()` method can accept a dictionary for explicit renames, but its real power lies in accepting a function (like a lambda). This function is applied to every column name, allowing you to perform programmatic renames across the entire DataFrame.

Let's say we want to standardize our column names to be all lowercase and have no underscores.

```python
# The user's snippet applied to our df_courses
df_renamed = df_courses.rename(
    lambda column_name: column_name.lower().replace("_", "")
)
# This will transform 'student_id' -> 'studentid', 'full_name' -> 'fullname', etc.
```
This is incredibly useful for cleaning up data from sources with inconsistent naming conventions.

#### The Universal Selector: `pl.all()`

Often you want to apply an operation to *every* column. `pl.all()` is a selector that means exactly that: "all columns". It's a powerful shorthand that prevents you from having to type out every column name.

```python
# Append a suffix to all column names
df_suffixed = df_courses.select(
    pl.all().suffix("_original")
)

# You can also exclude columns from the 'all' selection
df_all_but_id = df_courses.select(
    pl.all().exclude("student_id")
)

# Check if any value in any column is null
null_check = df_courses.select(
    pl.all().is_null().any()
)
```
`pl.all()` is your go-to tool for DataFrame-wide transformations. It pairs beautifully with other selectors like `.exclude()` and methods like `.prefix()` or `.suffix()` to create expressive and maintainable code.

### Combining DataFrames: The `concat` Operation

Stitching DataFrames together is a fundamental task. Polars' `pl.concat()` function is a versatile tool for this, and the `how` parameter dictates its behavior.

Let's create two simple DataFrames to demonstrate.

```python
df1 = pl.DataFrame({
    "a": [1, 2],
    "b": [3, 4]
})

df2 = pl.DataFrame({
    "a": [5, 6],
    "c": [7, 8]
})
```

*   **`how="vertical"` (default)**: This stacks DataFrames on top of each other. It will match columns by name and fill missing values with nulls. This is the most common type of concatenation.

*   **`how="horizontal"`**: This places DataFrames side-by-side, creating a wider DataFrame. This is only advisable if the DataFrames have the same height and no overlapping column names.

*   **`how="diagonal"`**: This is a more specialized method shown in the user's snippet. It concatenates the DataFrames along the diagonal, extending both rows and columns. It effectively places the second DataFrame below and to the right of the first one, filling the misaligned quadrants with nulls.

```python
# The user's snippet shows diagonal concatenation
# We will use df1 and df2 which have a similar structure to the user's df3 and df4
concatenated_diagonal = pl.concat([df1, df2], how="diagonal")
```
The resulting `concatenated_diagonal` DataFrame will have columns `a`, `b`, and `c`. The first two rows will have values for `a` and `b` (from `df1`) and null for `c`. The next two rows will have values for `a` and `c` (from `df2`) and null for `b`. This is useful in scenarios where you are merging data from different schemas that have some overlap but are fundamentally staggered.

### Custom Functions: A Guide to Performance and Pitfalls

What happens when a built-in Polars expression doesn't exist for your specific, complex logic? Polars provides ways to apply custom Python functions, but it's crucial to understand the performance hierarchy.

**The Golden Rule: Native expressions are always fastest. Use custom Python functions only when absolutely necessary.**

Let's establish a clear hierarchy from most-performant to least-performant.

#### 1. (Slowest) Row-wise `pl.apply`

This applies a Python function to each row. As discussed previously, this is an **anti-pattern** and should be avoided. It serializes the process and involves costly data conversion between Rust and Python for every single row.

```python
# The user's snippet: calculating sum of two columns row by row
# THIS IS VERY SLOW AND NOT RECOMMENDED
df_slow_apply = df_courses.select(
    pl.apply(["grade_numeric", "credits"], lambda row_values: row_values[0] + row_values[1])
)

# The correct, native, and blazingly fast way to do this:
df_fast_native = df_courses.select(
    (pl.col("grade_numeric") + pl.col("credits"))
)
```

#### 2. (Better) Element-wise `.map()`

The `.map()` (or its alias `.apply` on an expression) method applies a Python function to each *element* within a column. This is still slower than a native expression because of the Python function call overhead for each value, but it is significantly better than a row-wise apply.

```python
# The user's snippet: multiply every value in every column by 2
# This will fail on non-numeric columns, so let's select numeric ones first
df_mapped = df_courses.select(
    cs.numeric().map(lambda value: value * 2 if value is not None else None)
)
```
This is best used for complex transformations on single values for which no native Polars function exists.

#### 3. (Fastest Custom Method) `.struct().map()`

This is the idiomatic Polars solution for performing custom row-wise logic that involves multiple columns. It strikes a balance between flexibility and performance.

1.  **`pl.struct([...])`**: You first bundle the columns you need for your calculation into a temporary `Struct`.
2.  **`.map(lambda s: ...)`**: You then apply your Python function to this `Struct` object.

The magic here is that Polars can pass the entire `Struct` to Python much more efficiently than individual row elements. The lambda function receives a dictionary-like object, which is easy and readable to work with.

```python
# The user's snippet: divide col1 by col2. Let's use our data.
# Goal: Calculate a custom 'weighted_grade' = grade_numeric * (credits / 4)
df_struct_map = df_courses.with_columns(
    pl.struct(["grade_numeric", "credits"])
      .map(
          lambda s: s["grade_numeric"] * (s["credits"] / 4)
      )
      .alias("weighted_grade")
)
```
This approach is vastly superior to `.apply()` because it minimizes the overhead between Rust and Python and allows the query optimizer to better reason about the operation. When you absolutely need custom logic across columns, `struct().map()` is the tool to reach for.
