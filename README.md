# Google Data Analytics Professional Capstone Project: Cyclistic
This is my first unguided data project and is designed as a culmination of Google's Data Analytics Professional Certificate on Coursera, and to help me start to build a portfolio and showcase what I have learned.
In addition to documenting the case study itself I will be including information about my workflow, what issues I encountered and what I learned.

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
- [x] Are particular start stations more popular with one group over the other?
- [ ]	Are there particular geographic areas which are more popular with one group over the other?
- [ ]	Do annual members use a different type of bike to casual members?
- [ ]	Do they use bikes at different times of day
      
## Preparation
The data has been stored in an online repository and made available for download as csv files. For the purposes of this case study, I will assume that it is a complete record of every trip and therefore bias is not an issue. The data is current. Since it is first-party data collected by the company itself further validation is not required. 

The data is organized into a set of 12 csv files, with one file for each month of 2023, which were stored in an online repository. I downloaded the files to the google_capstone_project folder >> source_data subfolder.

To prepare the data for analysis I decided to start by opening one of the files in Excel and using this to familiarize myself with the data. While doing this I noticed that there are blocks of missing values for the station names (and id's). The fact that these entries with NULLs are grouped together in blocks could be a problem if I want to do a monthly comparison and some months do not have enough remaining observations once the NULL rows are deleted.

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
I then save the files to be transferred to Google Bigquery for further processing which would be too slow and cumbersome in Excel. While doing this I found that there were 2 problems:

Firstly I got an invalid time string error for my calculated ride_length column when attempting to upload files. I clicked job details to get more information, and navigated to the appropriate row in the spreadsheet, finding that some of the values where negative, which when formatted as time generated an error. I deleted the affected rows.

During this process I also became aware that when recording the macro above I used flash fill. Rather than inserting the flash fill command into the macro it inserted the specific number of rows from the first sheet, meaning that I have many NULLs.

>This was a valuable learning experience showing me that I should wrap my excel formulas in an IFERROR() and that I must learn more about how to use macros effectively

### Processing in Bigquery Using SQL

First I joined the 12 tables into one. Within this query I also changed the day_of_week column to display "MON", "TUE" etc. rather than numerical values and created a new 'month' column.

[View my first SQL query here.](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/join.sql)

Using ride_id as the unique identifier I found duplicate rows:

!["screenshot of query showing duplicates"](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/Screenshot%202024-01-17%20101154.png)

My second SQL query removed the duplicates, and at this time I also rounded the coordinate values since I had noticed that the number of decimal places varied.

[Take a look at my second SQL query here.](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/deduplicate.sql)

When checking for NULLs I found a large number in the start and end station names and coordinates. Many stations, however, had either the name or the coordinates but not both. I have decided that observations with no station name but which do have coordinates may still be useful if I need to map journeys, and entries with no coordinates but which do have a station name may be useful to see if some statins are more popular with one group over the other, but entries with neither are not useful so for now I deleted only the rows where both the map coordinates or the name (for either start or end station) were missing.

[View my final SQL query here.](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/remove_nulls.sql)

## Analysis

In order to answer my question about whether there was a difference between start stations for the two groups I asked more specifically: How many stations are in the top 100 start stations for both groups?

76 stations were in the top 100 for both groups. 

My station analysis SQL code
