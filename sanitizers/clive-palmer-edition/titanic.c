/* Copyright WHITE STAR LINE 1911. Internal use only. */
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

static const char *LOG_TEXT = "miles, still unsinkable!\n";

unsigned count_digits(unsigned number)
{
    return   (number == 0)
           ? 1
           : (unsigned) floor(log10(number)) + 1;
}

unsigned log_buffer_length(unsigned distance)
{
    return strlen(LOG_TEXT) + count_digits(distance) + 2;
}

full_steam_ahead(unsigned distance, char * captains_log)
{
    sprintf(captains_log, "%u %s", distance, LOG_TEXT);
}

int main(int argc, char *argv[])
{
    /* ints only please, let's avoid float errors */
    int to_the_atlantic;
    int nautical_miles;

    if (argc < 2)
    {
        return 1;
    }

    to_the_atlantic = atoi(argv[1]);

    if (to_the_atlantic < 1)
    {
        return 2;
    }

    for (nautical_miles = 1; nautical_miles <= to_the_atlantic; nautical_miles++)
    {
        const unsigned current_length = log_buffer_length(nautical_miles);

        char *captains_log = malloc(current_length);

        full_steam_ahead(nautical_miles, captains_log);

        printf("%s", captains_log);

        free(captains_log);
    }

    return 0;
}
