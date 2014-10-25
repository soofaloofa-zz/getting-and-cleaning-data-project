# UCI HAR Summarized Data

The output of this analysis script is a subset of the data from the UCI Human
Activity Recognition dataset available from
[UCI](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The data has been summarized to extract only the mean and standard deviation
measurements grouped by each subject participant and each activity being
performed.

The summarized data is a tidy data set where each variable is contained in a
single column, each column has a descriptive name and each row describes a
single observation of the data.

## Running the Script

The script is run by cloning this project and sourcing the `run_analysis.R` file
into your R session. A file 'output.txt' will be written to the working
directory with the summarized and tidy data.

```R
source('./run_analysis.R')
```
