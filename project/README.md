# EECE 5644 Project
All the files for my project for EECE 5644. Information about the directories and how to run this information is included below.

# How to run the project
Everything is written in Matlab, so if you dont have Matlab, get that set up.

Next, download everything, specifically the Excel file containing the data in the [data](data) directory and the Matlab script, [laon_project.m](loan_project.m).
Also, download everything in the functions folder. These are all the functions that are specified outside of the main script file (loan_project). (Note that as of 2019-12-01, there are no functions written.)

For the program to run as expected, this file strtucture *must* be preserved. I recommend downloading a zip of the whole thing and just running this one script, in the folder, as-is. See the comments within the Matlab file for more information.

# Directories
Information about each directory below.

## data
This is directory containing all the relevant data for the project. As of right now (2019-12-01), it's just the one Excel workbook. This folder will remain, however.

## functions
If you dont see a folder named "functions" then that likely means GitHub excluded it, which means that there was nothing in the folder, which means that I have not (yet) written any functions. See "How to run the project" for a little more info on that.

## Images
This contains all the images saved from the Matlab script. I usually automate the file saves, so if you don't want images to bloat-up your computer, comment out any line with the function "saveas."

## loan_project.m
This is the Big Kahuna. This will run everything, assuming that the *file structure is preserved!* See the file for more information about how the code works.