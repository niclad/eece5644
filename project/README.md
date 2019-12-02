# EECE 5644 Project: School Type Based on Direct Loan Volume
All the files for my project for EECE 5644. Information about the directories and how to run this information is included below.

# How to run the project ▶
Everything is written in Matlab, so if you dont have Matlab, get that set up.

Next, download everything, specifically the Excel file containing the data in the [data](data) directory and the Matlab script, [laon_project.m](loan_project.m).
Also, download everything in the functions folder. These are all the functions that are specified outside of the main script file (loan_project). (Note that as of 2019-12-01, there are no functions written.)

For the program to run as expected, this file strtucture *must* be preserved. I recommend downloading a zip of the whole thing and just running this one script, in the folder, as-is. See the comments within the Matlab file for more information.

# Directories 📂
Information about each directory below.

## data 🎁
This is directory containing all the relevant data for the project. As of right now (2019-12-01), it's just the one Excel workbook. This folder will remain, however.

## functions 💻
If you dont see a folder named "functions" then that likely means GitHub excluded it, which means that there was nothing in the folder, which means that I have not (yet) written any functions. See "How to run the project" for a little more info on that. 😘

## images 📸
This contains all the images saved from the Matlab script. I usually automate the file saves, so if you don't want images to bloat-up your computer, comment out any line with the function "saveas."

## loan_project.m 🍔 (not actually a directory)
This is the Big Kahuna. This will run everything, assuming that the *file structure is preserved!* See the file for more information about how the code works.

# Project Proposal
This is included so that anyone seeing this repository may reference the proposal I submitted. I received no feedback on this proposal, so I can't speak to its quality. The final version of the project, deviates a bit from this proposal.

**Project title:** Federal Student Loans Based on Student Information

**Team members:** N/A - Only myself for now

**Programming language:** Matlab

**Question/thesis:** How does a school or its location affect the volume of a loan astudent will receive?

**Source of data:** US Department of Education, Direct Loan award year data for 2018-2019. Data available [here](https://studentaid.ed.gov/sa/about/data-center/student/title-iv​).

**Data description:** Data provides school, state, zip-code, and loan information (such as total dollar amount, number of students receiving aid, and type of loan).

**Outline of approach:** A decent approach might possibly be a classification tree. This would allow for the categorical splits that the data contains, showing how much in loans is given out at certain schools. Of course this classification would likely be boosted to allow for more precise results as a way to achieve better classificatio nresults (than without the additional functionality).