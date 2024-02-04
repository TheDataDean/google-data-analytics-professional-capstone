# Google Data Analytics Professional Capstone Project: Cyclistic
This is my first unguided data project (as well as the first time I have used Github!) and is designed as a culmination of Google's Data Analytics Professional Certificate on Coursera, and to help me start to build a portfolio and showcase what I have learned.
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

- [x]	Is there a difference in the days of the week that the two groups use the service?
- [x] Are particular start stations more popular with one group over the other?
- [x]	Do annual members use a different type of bike to casual members?
- [x]	Do they use bikes at different times of day
      
## Preparation
The data has been stored in an online repository and made available for download as csv files. For the purposes of this case study, I will assume that it is a complete record of every trip and therefore bias is not an issue. The data is current. Since it is first-party data collected by the company itself further validation is not required. 

The data is organized into a set of 12 csv files, with one file for each month of 2023, which were stored in an online repository. I downloaded the files to the google_capstone_project folder >> source_data subfolder.

To prepare the data for analysis I decided to start by opening one of the files in Excel and using this to familiarize myself with the data. While doing this I noticed that there are blocks of missing values for the station names (and id's). The fact that these entries with NULLs are grouped together in blocks could be a problem if I want to do a monthly comparison and some months do not have enough remaining observations once the NULL rows are deleted.

## Processing

I started in Excel because at this point I was following Google's instructions for completing the project. Within Excel I checked how many unique bike types there are (3) then created a new column for ride length and another for the day of week that each trip started. I also deleted start_station_id and end_station_id because the id's are in various different formats and a quick check showed that there are no spelling variations in station names so they can be used as unique identifiers for each station. Since the data is spread out across 12 separate workbooks I used a macro to edit them:

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

Having rectified this error I moved realized that continuing to follow Google's instructions would not be feasible for me as the dataset was too large for Excel to handle on my machine without substantial wait times for each operation, so I decided to move to SQL since I am currenty more confident using SQL for analysis than either R or Tableau which are the other technologies covered in the Google course. Python might have worked better for me but I wated to stick with technologies covered in the course. In hindsight it would have been easier to use the same technology for as much of the project as possible rather than doing part in excel and part elsewhere, but I am glad I at least opened the files and got to know the data in excel as a first step.

### Processing in Bigquery Using SQL

Processing the data in SQL required me to learn a lot more about Google Cloud Platform. This is because many of the files were too large to upload directly to Bigquery so I needed to be host them on GCP first and then imported to Bigquery. This was a great learning experience for me as I had not used anything within GCP outside of Bigquery itself before this.

Once all the data was imported into my project within Bigquery I first joined the 12 tables into one. Within this query I also changed the day_of_week column to display "MON", "TUE" etc. rather than numerical values and created a new 'month' column. If I was to do this again I would have just created this column using SQL in the beginning.

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

![screenshot of SQL query](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/Screenshot%202024-01-17%20171122.png)

[My station analysis SQL code](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/station_analysis.sql)

#### Use of different bike types

Comparing the type of bike hired by each group I found that members did not use docked bikes at all, and that electric bikes were the most popular in both groups but by a larger margin for the casual riders.

[SQL code](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/bike_type.sql)


![bike type chart](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/Screenshot%202024-01-18%20200025.png)

## Further Analysis and Presentation

To analysis bike use on different days and at different times of days I decided that a visual analysis would be useful so I switched over to Tableau. I again had trouble moving the data between GCP and Tableau due to the size and the fact that it was downloaded from GCP in a file format which Tableau did not accept. These types of issues with compatibility and migration caused me more difficulties during this project than the data analysis itself.

>Moving forward I will focus my learning more on learning different platforms and on creating data pipelines and not just on learning the features of individual platforms in isolation. My aim will not only be to improve my ability to migrate data, but also to improve my ability to select the most appropriate technology in the first place.

At the beginning I was not very confident using Tableau and needed further study elsewhere to complete this. Having done so I realized that I would have done the processing and preparation within Tableau in the first place, which would have made life easier for me.

Within Tableau I analyzed the differences between casual riders and members according to day of week, month and time using static plots. I then created a dynamic map of start stations to see if there was any geographic patterns that might be relevant.

### To see the full analysis and presentation please [view the story I created on Tableau](https://public.tableau.com/app/profile/dean.walsh/viz/DeansGoogleCapstoneProject/CyclisticBikeUsebyUserType)

Otherwise see the first page below as a sample:

![Usage patterns by User type at different times](https://github.com/TheDataDean/google-data-analytics-professional-capstone/blob/main/Dashboard%201%20(1).png)


## Recommendations

- Use by casual members clearly peaks on weekends, while for members the peak is during the work week. It seems likely, therefore, that members are using the bikes for commuting whereas casual riders are using them for leisure. This is confirmed by the spike in trips started by members around 8:00am which is not present in the casual rider group which exhibits a much smoother increase throughout the morning. I therefore recommend that a marketing campaign aimed at casual users should aim to communicate the benefits of using the bikes for commuting to work.
- Electric bikes are the most popular with both groups, but especially casual riders. Since electric bikes have great benefits are faster and easier I would focus the advertising on highlighting how quickly and easily you can zip around gridlocked traffic on an electric bike to get to work without breaking a sweat.
- Use of Cyclistic by both casual riders and members peaks in the summer months around coastal areas (see my tableau story link), but there is a greater increase for casual riders than members. This further confirms the idea that casual riders are using the bikes more for leisure. It also presents an opportunity for marketing as promotional activities can be focussed on the coastal areas during the summer where there are is an increase in casual users, reducing costs compared to a broader campaign. These same stations are also heavily used by members throughout the year (see initial SQL analysis, suggesting that there is potential to convert casual riders to memmbers in these areas. I would recommend local advertising such as billboards during the summer around the coast.

