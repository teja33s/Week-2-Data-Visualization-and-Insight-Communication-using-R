# Data Visualization and Insight Communication using R

**Week 2 Task | Data Analysis Internship, Yuva Intern**
**Author:** Pulivarthi Sai Teja

## Overview
This project uses R and ggplot2 to turn two public datasets into clear, easy-to-read visualizations, each with a plain-language interpretation.

- **mtcars**: fuel economy and design details of 32 cars
- **AirPassengers**: monthly international airline passengers, 1949 to 1960

Both datasets are built into R, so no downloads are needed.

## Visualizations
| # | Chart | Question answered |
|---|-------|-------------------|
| 1 | Bar chart | How does average mpg change with cylinders? |
| 2 | Histogram | How is fuel economy distributed? |
| 3 | Scatter plot | How does weight relate to mpg? |
| 4 | Box plot | Do manual cars use less fuel than automatics? |
| 5 | Line chart | How did airline passenger numbers grow? |
| 6 | Seasonal line chart | Which months are busiest? |
| 7 | Heatmap | How are car measurements correlated? |

## Key findings
- 4-cylinder cars average 26.7 mpg versus 15.1 mpg for 8-cylinder cars.
- Each extra 1000 lbs of weight lowers mpg by about 5.3 (correlation -0.87).
- Manual cars have a median of 22.8 mpg versus 17.3 for automatics, partly because they are lighter.
- Airline passengers grew about 3.8 times from 1949 to 1960, peaking every July and August.

## Repository structure
```
analysis.R      # full R script that builds all seven charts
images/         # exported chart images
report/         # final Word report with narrative and interpretation
```

## How to run
1. Install R and RStudio.
2. Install packages: `install.packages(c("ggplot2", "dplyr"))` (ggplot2 3.4 or later).
3. Open `analysis.R` and run it from top to bottom. Charts are saved as 300-dpi PNG files.

## Tools
R, ggplot2, dplyr
