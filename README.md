# MultiFileNamePatterns

A primitive but flexible way to deal with multi-file data sets in Julia.


## Usage

This Julia module currently exports a single function: set

```
using MultiFileNamePatterns

template = "/path/to/data1/data1_time0000_channel0.csv"

# set variable 'filepath' to "/path/to/data1/data1_time0076_channel0.csv"
filepath = set(template, "time", 76)

# set variable 'filepath' to "/path/to/data0/data0_time0076_channel2.csv"
filepath = set(template, "time", 76, "channel", 2, "data", 0)
```
