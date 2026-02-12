# R-projects
This repository contains all my projects implemented in R, showcasing data analysis, statistical modeling, and practical applications.
# SDG 11 India Dashboard

An interactive Shiny dashboard for monitoring India's progress towards **Sustainable Development Goal 11 (SDG 11): Sustainable Cities and Communities**.

## What It Does

This dashboard visualizes urban development data across Indian states and global countries through six analytical views:

**1. Urban Population in Slums**  
Compares slum population percentages across selected countries using interactive bar charts with color-coded severity gradients.

**2. National SDG 11 Performance**  
Displays India's overall normalized SDG 11 achievement score (0-100 scale) through a pie chart showing progress vs. remaining gap.

**3. State-wise Indicator Analysis**  
Allows users to select states and compare performance across any numerical indicator (housing, infrastructure, sanitation, etc.).

**4. Indicator Statistics Dashboard**  
Presents state-wise summary tables and density distributions for all SDG 11 indicators.

**5. State Performance Ranking**  
Ranks selected states based on their normalized composite SDG 11 scores.

**6. Housing Correlation Analysis**  
Plots the relationship between katcha housing percentages and PMAY housing completion rates, with correlation coefficient calculation.

## Data Sources

- Primary Excel dataset with two sheets containing global urban statistics and India-specific SDG 11 indicators
- Indicators normalized to 0-100 scale for cross-comparable state ranking

## Built With

- R / Shiny
- ggplot2, plotly (visualizations)
- dplyr, tidyr (data manipulation)
- DT (interactive tables)
- shinydashboard (UI framework)
