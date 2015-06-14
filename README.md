# MultiFileNamePatterns

A primitive but flexible way to handle file paths of multi-file data sets in Julia.


## Usage

This module currently exports two functions: `get` and `set`.

```
using MultiFileNamePatterns

# file system path to one file of a multi-file data set
template = "/path/to/data1/data1_time0099_channel0.csv"

# get data index
> index = get(template, "time")
99

# get multiple indices at once
> indices = get(template, "time", "channel")
2-element Array{Int64,2}
 99
  0

# get file path with given index
> filepath = set(template, "time", 776)
"/path/to/data1/data1_time0776_channel0.csv"

# get file path with given indices
> filepath = set(template, "time", 1, "channel", 2, "data", 0)
"/path/to/data0/data0_time0001_channel2.csv"

```
