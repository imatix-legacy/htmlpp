#
#   sflcvdp.pl  SFL date picture formatting package
#
#   Written:    97/05/22   Pieter Hintjens <ph@imatix.com>
#   Revised:    98/10/06   Enrique Bengoechea <ebb@eco.uc3m.es>
#
#   Implements the functionality of the SFL date picture formatting
#   package (sflcvdp.c).
#

package sflcvdp;
require 'sfldate.pl';

CONFIG: {
    @month_name_dk = ("januar", "februar", "marts", "april",
                      "maj", "juni", "juli", "august", "september",
                      "oktober", "november", "december");
    @day_name_dk   = ("s&oslash;ndag", "mandag", "tirsdag", "onsdag",
                      "torsdag", "fredag", "l&oslash;rdag");
    @month_name_en = ("January", "February", "March", "April",
                      "May", "June", "July", "August", "September",
                      "October", "November", "December");
    @day_name_en   = ("Sunday", "Monday", "Tuesday", "Wednesday",
                      "Thursday", "Friday", "Saturday");
    @month_name_es = ("Enero", "Febrero", "Marzo", "Abril",
                      "Mayo", "Junio", "Julio", "Agosto", "Septiembre",
                      "Octubre", "Noviembre", "Diciembre");
    @day_name_es   = ("Domingo", "Lunes", "Martes", "Mi&eacute;rcoles",
                      "Jueves", "Viernes", "S&aacute;bado");
    @month_name_fr = ("Dimanche", "Lundi", "Mardi", "Mercredi",
                      "Jeudi", "Vendredi", "Samedi");
    @day_name_fr   = ("Janvier", "F&eacute;vrier", "Mars", "Avril",
                      "Mai", "Juin", "Juillet", "Ao&uuml;t", "Septembre",
                      "Octobre", "Novembre", "D&eacute;cembre");
}

#   $result = &conv_date_pict ($date, $picture);
#
#   The picture is composed of any combination of these formats:
#
#       cc      century 2 digits, 01-99
#       y       day of year, 1-366
#       yy      year 2 digits, 00-99
#       yyyy    year 4 digits, 100-9999
#       m       month, 1-12
#       mm      month, 01-12
#       mmm     month, 3 letters
#       mmmm    month, full name
#       MMM     month, 3 letters, ucase
#       MMMM    month, full name, ucase
#       d       day, 1-31
#       dd      day, 01-31
#       ddd     day of week, Sun-Sat
#       dddd    day of week, Sunday-Saturday
#       DDD     day of week, SUN-SAT
#       DDDD    day of week, SUNDAY-SATURDAY
#       w       day of week, 1-7 (1=Sunday)
#       ww      week of year, 1-53
#       q       year quarter, 1-4
#       \x      literal character x
#       other   literal character
#
#   Returns the formatted result.  If you pass only a picture string, uses
#   today's date.  If you pass a second argument, it should be a date value
#   containing the date as 8 digits (yyyymmdd).  You can also pass a 6-digit
#   value (yymmdd) and this subroutine will assume a suitable century.  If
#   the supplied date value is zero, returns an empty string.
#   The 'm' and 'd' formats output a leading space when used at the start
#   of the picture.  This is to improve alignment of columns of dates.  The
#   'm' and 'd' formats also output a space when the previous character was
#   a digit; otherwise the date components stick together and are illegible.
#
#   Examples:
#   &conv_date_pict (19951202, "mm d, yy")     Dec 2, 95
#   &conv_date_pict (19951202, "d mmm, yy")    2 Dec, 95
#   &conv_date_pict (19951202, "yymd")         9512 2
#   &conv_date_pict (951202, "yyyymmdd")       19951202

sub 'conv_date_pict {
    #   Get subroutine arguments
    local ($date, $picture, $language) = @_;

    #   Zero or invalid dates are returned as empty string
    if ($date == 0 || !&'valid_date ($date)) {
        return ("");
    }
    if   ($language =~ /DK/i) {
        @month_name = @month_name_dk;
        @day_name   = @day_name_dk;
    }
    elsif ($language =~ /ES/i) {
        @month_name = @month_name_es;
        @day_name   = @day_name_es;
    }
    elsif ($language =~ /FR/i) {
        @month_name = @month_name_fr;
        @day_name   = @day_name_fr;
    }
    else {
        @month_name = @month_name_en;
        @day_name   = @day_name_en;
    }
    $date = &'default_century ($date);
    local ($century) = &'get_century ($date);
    local ($year)    = &'get_year    ($date);
    local ($month)   = &'get_month   ($date);
    local ($day)     = &'get_day     ($date);
    local ($formatted) = "";
    local ($lastch)    = "";            #   Last character we output

    while ($picture) {
        $element = substr ($picture, 0, 1);
        if ($element ne "\\") {
            $picture =~ /^($element+)/;
            $element = $1;              #   Get picture element; one or more
            $picture = $';              #     instances of same character
        }
        if ($element eq "cc") {         #   century 2 digits, 01-99
            $formatted .= sprintf ("%02d", $century);
        }
        elsif ($element eq "y") {       #   day of year, 1-366
            $formatted .= &'julian_date ($date);
        }
        elsif ($element eq "yy") {      #   year 2 digits, 00-99
            $formatted .= sprintf ("%02d", $year);
        }
        elsif ($element eq "yyyy") {    #   year 4 digits, 0100-9999
            $formatted .= sprintf ("%02d%02d", $century, $year);
        }
        elsif ($element eq "m") {       #   month, 1-12
            $formatted .= sprintf (($lastch =~ /[0-9]/? "%2d": "%d"), $month);
        }
        elsif ($element eq "mm") {      #   month, 01-12
            $formatted .= sprintf ("%02d", $month);
        }
        elsif ($element eq "mmm") {     #   month, 3 letters
            $formatted .= substr ($month_name [$month - 1], 0, 3);
        }
        elsif ($element eq "mmmm") {    #   month, full name
            $formatted .= $month_name [$month - 1];
        }
        elsif ($element eq "MMM") {     #   month, 3-letters, ucase
            local ($name) = substr ($month_name [$month - 1], 0, 3);
            $name =~ tr/a-z/A-Z/;
            $formatted .= $name;
        }
        elsif ($element eq "MMMM") {    #   month, full name, ucase
            local ($name) = $month_name [$month - 1];
            $name =~ tr/a-z/A-Z/;
            $formatted .= $name;
        }
        elsif ($element eq "d") {       #   day, 1-31
            $formatted .= sprintf ($lastch =~ /[0-9]/? "%2d": "%d", $day);
        }
        elsif ($element eq "dd") {      #   day, 01-31
            $formatted .= sprintf ("%02d", $day);
        }
        elsif ($element eq "ddd") {     #   day of week, Sun-Sat
            $formatted .= substr ($day_name [&'day_of_week ($date)], 0, 3);
        }
        elsif ($element eq "dddd") {    #   day of week, Sunday-Saturday
            $formatted .= $day_name [&'day_of_week ($date)];
        }
        elsif ($element eq "DDD") {     #   day of week, SUN-SAT
            $name = substr ($day_name [&'day_of_week ($date)], 0, 3);
            $name =~ tr/a-z/A-Z/;
            $formatted .= $name;
        }
        elsif ($element eq "DDDD") {    #   day of week, SUNDAY-SATURDAY
            $name = $day_name [&'day_of_week ($date)];
            $name =~ tr/a-z/A-Z/;
            $formatted .= $name;
        }
        elsif ($element eq "w") {       #   day of week, 1-7 (1=Sunday)
            $formatted .= &'day_of_week ($date) + 1;
       }
        elsif ($element eq "ww") {      #   week of year, 1-53
            $formatted .= &'week_of_year ($date);
        }
        elsif ($element eq "q") {       #   year quarter, 1-4
            $formatted .= &'year_quarter ($date);
        }
        elsif ($element eq "\\") {      #   literal character follows
            $formatted .= substr ($picture, 1, 1);
            $picture    = substr ($picture, 2);
        }
        else {
            $formatted .= $element;
        }
        $lastch = substr ($formatted, -1, 1);
    }
    return ($formatted);
}

1;

