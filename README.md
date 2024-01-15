# Google Data Analytics Professional Capstone Project: Cyclistic
This is my first unguided data project and is designed as a culmination of Google's Data Analytics Professional Certificate on Coursera, and to help me start to build a portfolio and showcase what I have learned.

## Background
For this project I am playing the role of a junior data analyst at a bike share company called Cyclistic. The company has determined that annual membership holders are more profitable than casual riders. They want to launch a marketing campaign targeting casual riders in order to persuade more of them to become annual members. As a part of this, my job is to analyse the differences between how casual riders and annual members use the bikes.
Due to data protection rules we cannot connect passes purchased with credit card details. This means we cannot determine where casual riders live or if they have purchased multiple single passes.

### Defining The Task

#### Team Business Task:
To develop a new marketing strategy that will convert casual riders into annual members
#### My individual task:
Identify relevant differences between casual riders and annual members in order to inform the development of the new marketing strategy.

### Questions to ask during analysis:

- [ ]	Is there a difference in the days of the week that the two groups use the service?
- [ ]	Is there a difference in trip length between the two groups?
- [ ] Are particular stations more popular with one group over the other?
- [ ]	Are there particular geographic areas which are more popular with one group over the other?
- [ ]	Do annual members use a different type of bike to casual members?
- [ ]	Do they use bikes at different times of day
      
## Preparation
The data has been stored in an online repository and made available for download as csv files. For the purposes of this case study, I will assume that it is a complete record of every trip and therefore bias is not an issue. The data is current. Since it is first-party data collected by the company itself further validation is not required. 

The data is organized into a set of 12 csv files, with one file for each month of 2023, which were stored in an online repository. I downloaded the files to the google_capstone_project folder >> source_data subfolder.

To prepare the data for analysis I decided to start by opening one of the files in Excel and using this to familiarize myself with the data. While doing this I noticed that there are blocks of missing values for the station names (and id's). The fact that these entries with NULLs are grouped together in blocks could be a problem if I want to do a monthly comparison and some months do not have enough remaining observations once the NULL rows are deleted. Inititally I thought that the NULL values for station name could be inferred, as longditude and latitude seem to be present in each observations. Unfortunately there are inconsistencies in the long and lat for each station, with the values covering a currently indeterminate range, which makes this impossible. Currently my best idea to replace the missing station names is to use K-Means clustering with the number of unique station names as the number of centres to determine a mean value for the long and lat of each station. If so I would then be able to use these coordinates to locate the station names which are missing, as well as being able to plot stations on a map for a deeper analysis, but that may be beyond the scope of this project.

## Processing

Within Excel I checked how many unique bike types there are (3) then created a new column for ride length and another for the day of week that each trip started. I also deleted start_station_id and end_station_id because the id's are in various different formats and a quick check showed that there are no spelling variations in station names so they can be used as unique identifiers for each station. Since the data is spread out across 12 separate workbooks I used a macro to edit them:

``` vba
Sub google_cyclistic()
'
' google_cyclistic Macro
'
' Keyboard Shortcut: Ctrl+Shift+G
'
    Columns("E:E").Select
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    ActiveCell.FormulaR1C1 = "ride_length"
    Range("E2").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=RC[-1]-RC[-2]"
    Range("E2").Select
    Selection.NumberFormat = "h:mm:ss"
    Selection.AutoFill Destination:=Range("E2:E190446")
    Range("E2:E190446").Select
    Columns("F:F").Select
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    Range("F1").Select
    ActiveCell.FormulaR1C1 = "day_of_week"
    Range("F2").Select
    ActiveCell.FormulaR1C1 = "=WEEKDAY(RC[-3],1)"
    Range("F2").Select
    Selection.NumberFormat = "General"
    Range("F2").Select
    Selection.AutoFill Destination:=Range("F2:F190446")
    Range("F2:F190446").Select
    Columns("H:H").Select
    Selection.Delete Shift:=xlToLeft
    Columns("I:I").Select
    Selection.Delete Shift:=xlToLeft
End Sub
```
I then save the files to be transferred to Google Bigquery for further processing which would be too slow and cumbersome in Excel.
