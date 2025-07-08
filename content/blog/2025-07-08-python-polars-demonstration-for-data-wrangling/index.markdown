---
title: Python Polars Demonstration for Data Wrangling
author: 'Bas Machielsen'
excerpt: A short demonstration of the polars package in Python for data wrangling.
date: '2025-07-08'
slug: []
categories: []
tags: []
---

## Introduction

I’ve never really liked pandas. I always thought it was tedious to work with and it bothered me there were never really quick ways to do something simple. Thinks like renaming, filtering and selecting columns were always more tedious than they should’ve been too. Since a while now, I’ve been using the Python library `polars` instead. `polars` has an API which is much more similar to the R `tidyverse` system, it’s super suitable for piped sequences of code, and it has a submodule called `polars.selectors`, which allows you to select columns and rows easily. In what follows, I’ll give a short demonstration of the `polars` package using some commonly-used (and some less commonly-used) operations using an example dataset.

## Why `polars` is different?

There’s basically four things that make `polars` different, and better fro

- Parallelism by Default: Modern CPUs have multiple cores, yet many traditional data tools are single-threaded. Polars is built to parallelize your queries automatically wherever possible. Operations like aggregations, joins, and even simple column transformations are spread across all available CPU cores, dramatically reducing execution time.

- Apache Arrow Memory Model: Unlike pandas, which has its own memory layout, Polars is built directly on the Apache Arrow specification. Arrow is a language-agnostic, columnar memory format optimized for analytical query performance. This column-based structure is highly efficient for the types of scans and aggregations common in data analysis and enables zero-copy data transfer between systems that also speak Arrow (like database clients, Spark, or other processing engines).

- The Expression API: This is perhaps the most significant departure from pandas. Instead of executing operations one by one, Polars encourages you to build up a series of “expressions” that describe the transformations you want to perform. These expressions are essentially a recipe or a plan. This approach allows Polars’ query optimizer to analyze the entire plan, reorder operations for maximum efficiency, and then execute it in a highly parallelized manner.

- Lazy Execution: Closely tied to the Expression API is the concept of lazy execution. Instead of immediately computing a result, you can build a query plan against a dataset (even one that hasn’t been loaded into memory yet). Polars only executes the plan when you explicitly ask for the result. This enables incredible memory efficiency—you can filter a 50GB file down to the 100MB you actually need before loading the data into RAM.

## Set-Up

Getting started with Polars is straightforward. You can install it using pip. It’s recommended to also install pyarrow, which Polars uses for certain operations, and connectorx for high-performance database connections.

    pip install polars pyarrow connectorx

Once installed, you can import it into your Python script or notebook. The conventional alias for Polars is `pl`, much like `pd` for pandas or `np` for NumPy.

``` python
import polars as pl
```

## Example: NYC Taxi Trips

For the exploration, we will use a subset of the NYC Taxi Trip dataset. This dataset is a great example because it contains a mix of numerical, categorical, and datetime data, and its real-world versions are often too large to fit comfortably in memory, making it a perfect candidate for Polars’ lazy processing capabilities.

We will use a single Parquet file from one of the monthly releases, which is a highly efficient columnar storage format that Polars reads exceptionally well.

``` python
# The URL for our example dataset (Yellow Taxi Trip Records for January 2022)
DATA_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2022-01.parquet"
```

## The Building Blocks of Polars

There are two fundamental objects in Polars: the Series (a single column of data) and the DataFrame (a two-dimensional table of one or more Series). If you’re coming from pandas, this structure will feel familiar. However, how you interact with them is different.

- Creating a DataFrame

You can create a Polars DataFrame in several ways: from a dictionary, a list of lists, a NumPy array, a pandas DataFrame, or, most commonly, by reading from a file.

Let’s start by reading our Parquet file directly into a DataFrame. This is an example of eager execution, where Polars reads the file and loads its contents into memory immediately.

``` python
# Eagerly read the Parquet file from the URL into a DataFrame
df = pl.read_parquet(DATA_URL)
```

- Inspecting the DataFrame

Once loaded, you can inspect the DataFrame using familiar methods.

``` python
# Display the shape of the DataFrame (rows, columns)
df.shape
```

    ## (2463931, 19)

``` python
# Display the column names
df.columns
```

    ## ['VendorID', 'tpep_pickup_datetime', 'tpep_dropoff_datetime', 'passenger_count', 'trip_distance', 'RatecodeID', 'store_and_fwd_flag', 'PULocationID', 'DOLocationID', 'payment_type', 'fare_amount', 'extra', 'mta_tax', 'tip_amount', 'tolls_amount', 'improvement_surcharge', 'total_amount', 'congestion_surcharge', 'airport_fee']

``` python
# Display the data types of each column
df.dtypes
```

    ## [Int64, Datetime(time_unit='ns', time_zone=None), Datetime(time_unit='ns', time_zone=None), Float64, Float64, Float64, String, Int64, Int64, Int64, Float64, Float64, Float64, Float64, Float64, Float64, Float64, Float64, Float64]

``` python
# Show the first 5 rows of the DataFrame
df[:, :5].head()
```

<div><style>
.dataframe > thead > tr,
.dataframe > tbody > tr {
  text-align: right;
  white-space: pre-wrap;
}
</style>
<small>shape: (5, 5)</small><table border="1" class="dataframe"><thead><tr><th>VendorID</th><th>tpep_pickup_datetime</th><th>tpep_dropoff_datetime</th><th>passenger_count</th><th>trip_distance</th></tr><tr><td>i64</td><td>datetime[ns]</td><td>datetime[ns]</td><td>f64</td><td>f64</td></tr></thead><tbody><tr><td>1</td><td>2022-01-01 00:35:40</td><td>2022-01-01 00:53:29</td><td>2.0</td><td>3.8</td></tr><tr><td>1</td><td>2022-01-01 00:33:43</td><td>2022-01-01 00:42:07</td><td>1.0</td><td>2.1</td></tr><tr><td>2</td><td>2022-01-01 00:53:21</td><td>2022-01-01 01:02:19</td><td>1.0</td><td>0.97</td></tr><tr><td>2</td><td>2022-01-01 00:25:21</td><td>2022-01-01 00:35:23</td><td>1.0</td><td>1.09</td></tr><tr><td>2</td><td>2022-01-01 00:36:48</td><td>2022-01-01 01:14:20</td><td>1.0</td><td>4.3</td></tr></tbody></table></div>

``` python
# Get descriptive statistics for the numerical columns
df[:, :5].describe()
```

<div><style>
.dataframe > thead > tr,
.dataframe > tbody > tr {
  text-align: right;
  white-space: pre-wrap;
}
</style>
<small>shape: (9, 6)</small><table border="1" class="dataframe"><thead><tr><th>statistic</th><th>VendorID</th><th>tpep_pickup_datetime</th><th>tpep_dropoff_datetime</th><th>passenger_count</th><th>trip_distance</th></tr><tr><td>str</td><td>f64</td><td>str</td><td>str</td><td>f64</td><td>f64</td></tr></thead><tbody><tr><td>&quot;count&quot;</td><td>2.463931e6</td><td>&quot;2463931&quot;</td><td>&quot;2463931&quot;</td><td>2.392428e6</td><td>2.463931e6</td></tr><tr><td>&quot;null_count&quot;</td><td>0.0</td><td>&quot;0&quot;</td><td>&quot;0&quot;</td><td>71503.0</td><td>0.0</td></tr><tr><td>&quot;mean&quot;</td><td>1.707819</td><td>&quot;2022-01-17 01:19:51.689726&quot;</td><td>&quot;2022-01-17 01:34:04.421901&quot;</td><td>1.389453</td><td>5.372751</td></tr><tr><td>&quot;std&quot;</td><td>0.502137</td><td>null</td><td>null</td><td>0.982969</td><td>547.871404</td></tr><tr><td>&quot;min&quot;</td><td>1.0</td><td>&quot;2008-12-31 22:23:09&quot;</td><td>&quot;2008-12-31 23:06:56&quot;</td><td>0.0</td><td>0.0</td></tr><tr><td>&quot;25%&quot;</td><td>1.0</td><td>&quot;2022-01-09 15:37:41&quot;</td><td>&quot;2022-01-09 15:50:51&quot;</td><td>1.0</td><td>1.04</td></tr><tr><td>&quot;50%&quot;</td><td>2.0</td><td>&quot;2022-01-17 12:11:45&quot;</td><td>&quot;2022-01-17 12:23:49&quot;</td><td>1.0</td><td>1.74</td></tr><tr><td>&quot;75%&quot;</td><td>2.0</td><td>&quot;2022-01-24 13:49:38&quot;</td><td>&quot;2022-01-24 14:02:51&quot;</td><td>1.0</td><td>3.13</td></tr><tr><td>&quot;max&quot;</td><td>6.0</td><td>&quot;2022-05-18 20:41:57&quot;</td><td>&quot;2022-05-18 20:47:45&quot;</td><td>9.0</td><td>306159.28</td></tr></tbody></table></div>

These inspection methods are helpful for getting a quick overview of your data’s structure and content, just as you would in pandas.

## Expressions and Contexts

The true power of Polars is unlocked through its Expression API. An expression in Polars is an object that represents a calculation or transformation to be performed on one or more columns. It is not the result of the calculation itself.

Expressions are always used within a specific context. The three most important contexts are:

- `select()`: Used for selecting or creating columns.
- `filter()`: Used for selecting rows based on a condition.
- `with_columns()`: Used for adding or transforming columns.

Let’s start with a simple expression. pl.col(“column_name”) is an expression that selects a column.

- Selecting Data with `select`

The select method is used to choose which columns you want to keep or to create new ones.

``` python
# Select a single column
selection_one_col = df.select(
    pl.col("passenger_count")
)

# Select multiple columns by name
selection_multiple_cols = df.select([
    pl.col("tpep_pickup_datetime"),
    pl.col("tpep_dropoff_datetime"),
    pl.col("trip_distance")
])

# Expressions can be combined to create new columns within a select
# Here, we create a new column 'tip_percentage'
selection_with_new_col = df.select([
    pl.col("total_amount"),
    pl.col("tip_amount"),
    (pl.col("tip_amount") / pl.col("total_amount") * 100).alias("tip_percentage")
])
```

Notice the `.alias("new_name")` method. This is essential for giving your new, computed columns a name. Without it, Polars would assign a default, often unhelpful, name.

- Filtering Data with `filter`

The filter method is used to select rows that meet one or more conditions. The conditions are, you guessed it, expressions.

``` python
# Filter for trips with more than 2 passengers
filter_high_passenger_count = df.filter(
    pl.col("passenger_count") > 2
)

# Filter for trips that were paid by credit card (VendorID 1) and cost more than $50
# The '&' operator is used for 'AND' conditions
filter_high_value_card_trips = df.filter(
    (pl.col("VendorID") == 1) & (pl.col("total_amount") > 50)
)

# Filter for short trips (less than 1 mile) OR very long trips (more than 50 miles)
# The '|' operator is used for 'OR' conditions
filter_short_or_long_trips = df.filter(
    (pl.col("trip_distance") < 1) | (pl.col("trip_distance") > 50)
)
```

The ability to chain logical conditions inside a single filter call is both clean and efficient. Polars can optimize the execution of these compound predicates.

- Adding and Modifying Columns with `with_columns`

While select can create new columns, it also discards the old ones. More often, you’ll want to add new columns to your existing DataFrame. For this, with_columns is the perfect tool.

``` python
# Let's add the 'tip_percentage' column to our original DataFrame
# and also calculate trip duration in minutes
df_with_new_cols = df.with_columns([
    (pl.col("tip_amount") / pl.col("total_amount") * 100).alias("tip_percentage"),
    (
        (pl.col("tpep_dropoff_datetime") - pl.col("tpep_pickup_datetime")).dt.total_seconds() / 60
    ).alias("trip_duration_minutes")
])
```

In this example, we see two more powerful features:
- Pipeing or Chaining expressions: We chain arithmetic operations to calculate the percentage.
- Specialized namespaces: We use the .dt namespace for datetime-specific operations, like calculating the duration in seconds. Polars also has .str for string manipulations, .list for list operations, and more, providing a consistent and discoverable API.

- Lazy vs. Eager Evaluation: Optimizing for Performance and Memory

So far, we’ve been working in eager mode. Every command we issued was executed immediately. This is fine for datasets that fit comfortably in RAM, but for larger-than-memory datasets, it’s a non-starter.

This is where lazy execution comes in. Instead of `read_parquet`, we use `scan_parquet`.

``` python
# Create a LazyFrame by scanning the file
# This does NOT load any data into memory. It only inspects the file's metadata.
lazy_df = pl.scan_parquet(DATA_URL)
```

The lazy_df object is not a DataFrame; it’s a LazyFrame. It holds a representation of the query plan we intend to run. No data has been read, and no computation has been performed.

Now, we can chain all our transformations just as before.

``` python
# Build a query plan on our LazyFrame
# 1. Filter for trips with a positive trip distance and fare amount.
# 2. Create new columns for trip duration and average speed.
query_plan = lazy_df.filter(
    (pl.col("trip_distance") > 0) & (pl.col("fare_amount") > 0)
).with_columns([
    (
        (pl.col("tpep_dropoff_datetime") - pl.col("tpep_pickup_datetime")).dt.total_seconds() / 60
    ).alias("trip_duration_minutes"),
    (
        pl.col("trip_distance") / ((pl.col("tpep_dropoff_datetime") - pl.col("tpep_pickup_datetime")).dt.total_seconds() / 3600)
    ).alias("average_mph")
])
```

At this point, query_plan is still just a LazyFrame. We’ve described what we want to do, but nothing has happened yet. Polars has taken this chain of operations and fed it to its query optimizer. The optimizer might, for instance, realize it can apply the filter while reading the data from disk, so it never even has to load the filtered-out rows into memory. This is called predicate pushdown and is a key source of Polars’ efficiency.

To execute the plan and get our final result, we call the `.collect()` method.

``` python
# Execute the plan and collect the results into a DataFrame
final_df = query_plan.collect()
```

Now, and only now, does Polars execute the full, optimized plan across all available CPU cores, reading only the necessary data and producing the final DataFrame.

- Group By and Aggregations

Data analysis isn’t complete without the ability to group data and compute aggregate statistics. The pattern in Polars is `.group_by().agg()`, which will feel familiar to users of pandas or SQL.

Let’s use our lazy query as a base and perform an aggregation. We want to find the average tip percentage and the maximum trip duration for each payment_type.

``` python
# Build a full analysis pipeline: scan, filter, create features, and aggregate
# Note: We use the lazy_df from before
final_agg_plan = lazy_df.filter(
    pl.col("passenger_count") > 0
).with_columns([
    (pl.col("tip_amount") / pl.col("total_amount") * 100).alias("tip_percentage"),
    (
        (pl.col("tpep_dropoff_datetime") - pl.col("tpep_pickup_datetime")).dt.total_seconds() / 60
    ).alias("trip_duration_minutes")
]).group_by("payment_type").agg([
    pl.mean("tip_percentage").alias("avg_tip_percentage"),
    pl.max("trip_duration_minutes").alias("max_trip_duration"),
    pl.len().alias("num_trips") # pl.count() counts the number of rows in each group
])

# Now, execute the entire plan
results = final_agg_plan.collect()
```

This single, chained command represents a complete analytical query. It defines:

- Scanning the data source lazily.
- Filtering rows based on a condition.
- Creating new feature columns.
- Grouping the results by a categorical column.
- Aggregating multiple values for each group.
- Polars’ query optimizer analyzes this entire chain as a single unit, finding the most efficient path to the final result before executing it in parallel.

This holistic optimization is what sets Polars apart from the step-by-step, eager execution model of libraries like pandas.

Of course. Here are the additional sections expanding on specific Polars features, formatted in Markdown and continuing the tutorial style.

## Don’t Use Row-Wise Operations

Coming from libraries like pandas, a common pattern is to iterate over rows or use a function like `pandas.DataFrame.apply(axis=1)` to perform complex calculations that involve multiple columns. Polars *does* have an `.apply()` method on its DataFrames, but using it is almost always an anti-pattern that should be avoided.

**Why is row-wise execution an anti-pattern in Polars?**

1.  **It Destroys Parallelism:** Polars achieves its speed by operating on entire columns at once, allowing it to use SIMD (Single Instruction, Multiple Data) CPU instructions and parallelize the work across all available cores. A row-wise function is inherently sequential; it processes one row at a time in a Python loop, completely nullifying Polars’ parallel execution engine.
2.  **It Incurs a Huge Performance Penalty:** For each row, data has to be converted from Polars’ efficient Rust-native memory representation into Python objects, the Python function is called, and the result is converted back. This back-and-forth conversion is extremely slow compared to a native, vectorized operation.
3.  **It Prevents Query Optimization:** When you use a custom row-wise Python function, you are essentially creating a “black box” for the Polars query optimizer. The optimizer cannot see inside the function, so it cannot reorder operations, perform predicate pushdown, or apply any of its other powerful tricks.

The “Polars way” is to always think in terms of columnar operations. If you find yourself wanting to do something for *each row*, take a step back and ask: “How can I express this as an operation on entire columns?”

Let’s look at a concrete example. Imagine we have sensor readings and for each row (timestamp), we want to find the maximum reading across all sensors.

``` python
# A sample DataFrame of sensor readings
df_sensors = pl.DataFrame({
    "sensor_a": [1.0, 2.0, 5.0, 4.0, None],
    "sensor_b": [3.0, None, 6.0, 1.0, 3.0],
    "sensor_c": [2.0, 3.0, 7.0, 2.0, 4.0],
})

# The anti-pattern: using a row-wise apply (AVOID THIS)
# This will be very slow on large datasets
max_reading_slow = df_sensors.with_columns(
    pl.max_horizontal(
        "sensor_a", "sensor_b", "sensor_c"
    ).alias("max_reading")
)

# The Polars way: using a vectorized, horizontal expression
# This is blazingly fast and leverages the query engine
max_reading_fast = df_sensors.with_columns(
    pl.max_horizontal(
        pl.col("sensor_a"), pl.col("sensor_b"), pl.col("sensor_c")
    ).alias("max_reading")
)
```

The expression `pl.max_horizontal()` is designed specifically for this use case. It is a vectorized, parallelized function that operates horizontally across the specified columns. It is orders of magnitude faster than a Python-based `apply` function and integrates perfectly into the Polars query optimizer. Always look for a native Polars expression before resorting to a row-wise operation.

- Applying the Same Function to Multiple Columns

A common data cleaning or feature engineering task is to apply the same transformation to many columns at once. For instance, you might want to fill null values in all numerical columns, or cast all columns ending with `_id` to a string type. Polars makes this incredibly easy and efficient through its powerful column selectors within expressions.

The `pl.col()` expression, which we’ve used to select single columns, is much more versatile. It can also accept:

- A list of column names.
- A regex pattern to match column names.
- A Polars data type to select all columns of that type.

Let’s see this in action with our NYC Taxi dataset.

``` python
# Assume 'df' is our loaded taxi DataFrame
import re
#df = pl.read_parquet(DATA_URL)

# Example 1: Applying a function to a list of columns
# Let's fill nulls in specific amount columns with 0
df_filled_amounts = df.with_columns(
    pl.col(["fare_amount", "tip_amount", "tolls_amount", "total_amount"]).fill_null(0)
)

# Example 2: Applying a function to columns selected by data type
# Let's get the standard deviation of all floating point columns.
# Note that this is an aggregation, so we use select() instead of with_columns().
float_std_devs = df.select(
    pl.col(pl.Float64).std().name.suffix("_std_dev")
)
# The .suffix() method is a convenient way to add a suffix to the names of all
# newly created columns, resulting in 'trip_distance_std_dev', 'fare_amount_std_dev', etc.

# Example 3: Applying a function to columns selected by a regex pattern
# Let's cast all columns containing "ID" in their name to strings (pl.Utf8)
df_casted_ids = df.with_columns(
    [pl.col(col).cast(pl.Utf8) for col in df.columns if r"ID" in col]
)
```

This selector syntax is a cornerstone of efficient Polars code. It allows you to write sweeping, generic transformations that are both readable and highly performant, avoiding the need for manual loops over column names. By combining data type and regex selectors, you can build powerful and reusable data cleaning pipelines.

In a similar way, we can iterate through column names and data types:

``` python
for column_name, dtype in df.schema.items():
  print(f"Column '{column_name}' has dtype: {dtype}")
```

    ## Column 'VendorID' has dtype: Int64
    ## Column 'tpep_pickup_datetime' has dtype: Datetime(time_unit='ns', time_zone=None)
    ## Column 'tpep_dropoff_datetime' has dtype: Datetime(time_unit='ns', time_zone=None)
    ## Column 'passenger_count' has dtype: Float64
    ## Column 'trip_distance' has dtype: Float64
    ## Column 'RatecodeID' has dtype: Float64
    ## Column 'store_and_fwd_flag' has dtype: String
    ## Column 'PULocationID' has dtype: Int64
    ## Column 'DOLocationID' has dtype: Int64
    ## Column 'payment_type' has dtype: Int64
    ## Column 'fare_amount' has dtype: Float64
    ## Column 'extra' has dtype: Float64
    ## Column 'mta_tax' has dtype: Float64
    ## Column 'tip_amount' has dtype: Float64
    ## Column 'tolls_amount' has dtype: Float64
    ## Column 'improvement_surcharge' has dtype: Float64
    ## Column 'total_amount' has dtype: Float64
    ## Column 'congestion_surcharge' has dtype: Float64
    ## Column 'airport_fee' has dtype: Float64

- Understanding Structs: Grouping Fields for Clarity

As your data analysis becomes more complex, you may find yourself with a wide DataFrame containing many related columns. For instance, you might have `pickup_latitude`, `pickup_longitude`, `pickup_time`, and then `dropoff_latitude`, `dropoff_longitude`, and `dropoff_time`. Keeping these as six separate top-level columns can become unwieldy.

Polars offers a powerful solution for this: the `Struct` data type. A `Struct` is a nested data type that groups multiple fields (columns) into a single, logical parent column. Think of it like a dictionary or an object that lives inside a cell of your DataFrame.

**Creating and Using Structs**

You can create a `Struct` using the `pl.struct()` expression, typically within a `with_columns` context.

``` python
# Assume 'df' is our loaded taxi DataFrame

# Let's group pickup and dropoff information into structs
df_with_structs = df.with_columns([
    pl.struct(
        [pl.col("tpep_pickup_datetime"), pl.col("PULocationID")]
    ).alias("pickup_info"),
    pl.struct(
        [pl.col("tpep_dropoff_datetime"), pl.col("DOLocationID")]
    ).alias("dropoff_info")
])

# The resulting DataFrame will now have 'pickup_info' and 'dropoff_info' columns.
# These columns contain struct values, not simple numbers or strings.
```

The primary benefit is organization, but the real power comes from operating on these structs. Polars provides a special `.struct` namespace for expressions to interact with `Struct` columns.

``` python
# Let's work with our new df_with_structs DataFrame

# Example 1: Accessing a field within a struct
# We can extract just the pickup location ID from the struct
df_extracted_field = df_with_structs.select(
    pl.col("pickup_info").struct.field("PULocationID").alias("pickup_id_from_struct")
)

# Example 2: Renaming fields within a struct
# This is useful for creating cleaner, more understandable nested data
df_renamed_struct = df_with_structs.with_columns(
    pl.col("pickup_info")
    .struct.rename_fields(["timestamp", "location_id"])
    .alias("pickup_info_renamed")
)

# Example 3: Unnesting a struct
# The opposite of creating a struct is 'unnesting' it, which flattens
# the fields back into top-level columns. This is very useful after
# you've performed your grouped operations.
df_unnested = (df_with_structs
 .drop(["tpep_pickup_datetime", "PULocationID"])
 .unnest("pickup_info")
 )
# This would add 'tpep_pickup_datetime' and 'PULocationID' back as top-level
# columns (if they weren't already there).
```

`Structs` are a powerful tool for managing complexity. They allow you to group related data, operate on those groups as a unit, and maintain a cleaner, more organized top-level DataFrame structure.

- Strings and Regex

String manipulation is a fundamental part of data cleaning and feature engineering. Polars has a rich set of string operations available through the `.str` expression namespace. This includes simple checks, powerful regex-based extraction, and replacement functions.

**Selecting and Filtering with String Patterns**

We’ve already seen how to select columns using a regex pattern in `pl.col()`. The same logic applies when you need to filter rows based on the content of a string column. The `.str.contains()` method is your primary tool for this, and it fully supports regular expressions.

Let’s create a sample DataFrame to illustrate these concepts.

``` python
df_logs = pl.DataFrame({
    "timestamp": ["2023-10-26 10:00:00", "2023-10-26 10:05:00", "2023-10-26 10:10:00"],
    "log_message": ["INFO: User user_123 logged in.", "WARNING: Disk space low on host_abc.", "INFO: Process pid_456 completed successfully."],
    "service_name": ["authentication-service", "monitoring-service", "data-pipeline-service"]
})
```

**Filtering Rows Based on String Matches**

``` python
# Filter for rows where the log message contains "INFO"
info_logs = df_logs.filter(
    pl.col("log_message").str.contains("INFO")
)

# Filter for rows from either the 'authentication' or 'data-pipeline' service
# We use a regex pattern with the OR operator '|'
auth_or_pipeline_logs = df_logs.filter(
    pl.col("service_name").str.contains("authentication|data-pipeline")
)

# You can also use other helpful methods like .starts_with() and .ends_with()
monitoring_logs = df_logs.filter(
    pl.col("service_name").str.starts_with("monitoring")
)
```

**Extracting Data from Strings with Regex**

Often, you don’t just want to know if a pattern exists; you want to extract the matching data into a new column. The `.str.extract()` method is perfect for this. It takes a regex pattern with a capture group (defined by parentheses `()`) and extracts the content of that group.

``` python
# Extract the user ID, host name, and process ID from the log messages.
# We use a regex with a capture group `(\w+)` which means "one or more word characters".
# The second argument to extract, `1`, specifies we want the first capture group.
df_extracted = df_logs.with_columns(
    pl.col("log_message").str.extract(r"user_(\w+)", 1).alias("user_id"),
    pl.col("log_message").str.extract(r"host_(\w+)", 1).alias("host_name"),
    pl.col("log_message").str.extract(r"pid_(\d+)", 1).alias("process_id").cast(pl.Int64)
)
# Notice we can chain .cast() after .extract() to convert the extracted string "456"
# into a proper integer.
```

This ability to use the `.str` namespace within a `with_columns` or `filter` context, combined with the power of regex, allows you to perform complex text processing tasks as part of a single, optimized Polars query.

## Final, Complete Example: Chaining it All Together

Let’s write one final, comprehensive query to showcase the expressiveness and power of Polars. Our goal is to find the top 5 busiest routes (defined by pickup and dropoff location IDs) for trips paid by credit card, calculating their average fare, distance, and trip count.

``` python
# Define the full, chained lazy query
top_routes_plan = pl.scan_parquet(DATA_URL).filter(
    # Condition 1: Payment type is Credit Card (ID 1)
    pl.col("payment_type") == 1
).filter(
    # Condition 2: Both location IDs are valid (not null)
    pl.col("PULocationID").is_not_null() & pl.col("DOLocationID").is_not_null()
).group_by(["PULocationID", "DOLocationID"]).agg([
    pl.mean("fare_amount").alias("avg_fare"),
    pl.mean("trip_distance").alias("avg_distance"),
    pl.len().alias("trip_count")
]).sort(
    "trip_count", descending=True
).limit(5)

# Execute the plan and materialize the result
top_routes_df = top_routes_plan.collect()
```

This single, readable block of code represents a sophisticated query that would be significantly more verbose and less performant in other libraries. It demonstrates the culmination of Polars’ design: lazy scanning, predicate pushdown, multi-key grouping, parallel aggregation, sorting, and limiting—all optimized and executed as one cohesive unit.

## Conclusion: When and Why to Use Polars

Polars is not a replacement for pandas in every conceivable situation. The pandas ecosystem is mature, with deep integrations into visualization and machine learning libraries. For small datasets (tens or hundreds of megabytes), the performance difference may not be a deciding factor, and the familiar pandas API might be more convenient.

You can convert a polars DataFrame to a pandas Data.Frame in this way:

``` python
top_routes_df.to_pandas()
```

    ##    PULocationID  DOLocationID   avg_fare  avg_distance  trip_count
    ## 0           237           236   6.437305      1.096252       15293
    ## 1           236           237   7.061231      1.087370       13164
    ## 2           236           236   5.570402      0.719279       10636
    ## 3           237           237   5.629696      0.703183        8973
    ## 4           264           264  16.457482      2.631818        8184

In sum, you should strongly consider Polars when:

- Performance is critical: You are working with medium-to-large datasets (hundreds of MBs to hundreds of GBs) and your processing times are becoming a bottleneck.

- Memory is a constraint: You need to process datasets that are larger than your available RAM. The lazy API and efficient memory model are game-changers here.

- You value a modern, consistent API: The Expression API, while requiring a slight mental shift, is exceptionally powerful, consistent, and less prone to the subtle inconsistencies found in the pandas API.

- You are starting a new project: For new data-intensive projects, starting with Polars can prevent many of the performance and memory headaches that often arise later when using traditional tools.

Polars represents a significant step forward in the world of high-performance data manipulation in Python. By using parallelism, lazy execution, and a powerful expression-based API, it provides a scalable tool for data scientists and researchers. In my opinion, taking the time to learn its core concepts will pay enormous dividends in the speed, efficiency, and clarity of future data analysis work.
