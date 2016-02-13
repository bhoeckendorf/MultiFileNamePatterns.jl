# MultiFilePatterns

A primitive but flexible way to handle file paths of multi-file data sets in Julia.


## Usage

This module handles file paths containing named fields followed by numeric indices, such as `/path/to/data1/data1_time0099_channel0.csv`. It exports the two functions `get` and `set` to interact with field indices.


### Getting field indices
```
using MultiFilePatterns

# file system path to one file of a multi-file data set
filepath = "/path/to/data1/data1_time0099_channel0.csv"

# get index of 'time' field
> index = get(filepath, "time")
99

# get indices of 'time' and 'channel' fields
> indices = get(filepath, "time", "channel")
2-element Array{Int64,2}
 99
  0
```


### Setting field indices
```
# representative file system path of data set
template = "/path/to/data1/data1_time0099_channel0.csv"

# get file path of time point 776
> filepath = set(template, "time", 776)
"/path/to/data1/data1_time0776_channel0.csv"

# get file path with given field indices
> filepath = set(template, "time", 1, "channel", 2, "data", 0)
"/path/to/data0/data0_time0001_channel2.csv"

# padding is implicit
> filepath = set(template, "data", 23, "time", 1)
"/path/to/data23/data23_time0001_channel0.csv"
```
