#!/bin/sh

# Get the current date and time in the format day_month_year-hour:minute:second
current_date=$(date "+%d_%m_%Y-%H:%M:%S")

# Create the old directory if it doesn't exist
mkdir -p old

# Move the contest directory to old/contest_day_month_year-hour:minute:second
mv contest "old/contest_$current_date"

# Create a new empty contest directory
mkdir contest