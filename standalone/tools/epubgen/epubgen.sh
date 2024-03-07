#!/bin/bash

# display_usage function displays the usage information for the script
display_usage() {
    echo "Usage: $0 MONTH YEAR LANG"
    echo "Create a monthly Divinum Officium in EPUB format."
    echo -e "\n\nMandatory arguments:"
    echo -e "  MONTH\t\tThe month in two-digit format"
    echo -e "  YEAR\t\tThe year in four-digit format"
    echo -e "  LANG\t\tThe second language (English, Italiano, Magyar)"
}

# Check if the correct number of arguments are provided
if [ $# -ne 3 ]; then
    echo -e "Too few arguments, you must specify three arguments: MONTH, YEAR and LANG.\n"
    display_usage
    exit 1
fi

# Validate the month format
mformat='^[0-9][0-9]$'
if ! [[ $1 =~ $mformat ]]; then
    echo -e "Invalid month format, the month must be in two-digit format.\n"
    display_usage
    exit 1
fi

MONTH=$1

# Validate the year format
yformat='^[0-9][0-9][0-9][0-9]$'
if ! [[ $2 =~ $yformat ]]; then
    echo -e "Invalid year format, the year must be in four-digit format.\n"
    display_usage
    exit 1
fi

YEAR=$2

# Validate and set the language
case $3 in
    English)
	BLANG=$3
	;;
    Italiano)
	BLANG=$3
	;;
    Magyar)
	BLANG=$3
	;;
    "")
	echo -e "Language not specified. You must specify a language.\n"
	display_usage
	exit 1
	;;
    *)
	echo -e "Invalid language specified.\n"
	display_usage
	exit 1
	;;
esac

# Set the current directory and create a temporary working directory
CDUR=$(pwd)
WDIR=$(mktemp -d)

# Calculate the number of days in the specified month
DAYN=$(cal $MONTH $YEAR|egrep -v [a-z]|wc -w)

echo -e "\e[1m:: Starting to generate hours\e[0m"
cd ../../../web/cgi-bin/horas

# Generate HTML files for each day and hour
for DAY in $(seq -w $DAYN); do
    echo -ne "Day $DAY/$DAYN\r"
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=prayMatutinum&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-1-Matutinum.html 2> /dev/null;
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=prayLaudes&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-2-Laudes.html 2> /dev/null;
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=prayPrima&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-3-Prima.html 2> /dev/null;
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=prayTertia&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-4-Tertia.html 2> /dev/null;
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=praySexta&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-5-Sexta.html 2> /dev/null;
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=prayNona&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-6-Nona.html 2> /dev/null;
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=prayVespera&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-7-Vespera.html 2> /dev/null;
    ./Eofficium.pl "date1=$MONTH-$DAY-$YEAR&command=prayCompletorium&version=Rubrics%201960&testmode=regular&lang2=$BLANG&votive=" > $WDIR/$MONTH-$DAY-$YEAR-8-Completorium.html 2> /dev/null;
done
echo ""
echo -e "\e[1m:: Finished the generation of hours\e[0m"

# Create the index.html file
echo -e "\e[1m:: Starting to create index.html\e[0m"
cd $WDIR

# Redirect stdout to index.html
exec 6>&1
exec > index.html

# Print the HTML structure and content
printf "<html>\n<head><title>Index Horarum</title></head>\n<body style=\"font-family:'Gentium Book Basic'; font-size:87%%; line-height:150%%;\">\n<h1 align=\"center\">
