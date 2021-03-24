/* Copyright WHITE STAR LINE 1911. Internal use only. */

#include <stdlib.h>
#include <stdio.h>

/* 3 is plenty. How far do we expect this thing to travel, anyway? */
#define DIGITS_LENGTH (3)

/* This allocates memory for the returned string. The caller is responsible for
 * freeing it.
 */
char * full_steam_ahead(unsigned distance)
{
    static const char LOG_TEXT[] = "miles, still unsinkable!\n";
    static const TOTAL_LENGTH    = sizeof(LOG_TEXT) + DIGITS_LENGTH + 1;

    const unsigned tugboat_distance = 0; /* TODO: who do we ask about this? */
    const unsigned total_distance = distance + tugboat_distance;

    char *status = malloc(TOTAL_LENGTH * sizeof(char) * 1);
    sprintf(status, "%*u %s", DIGITS_LENGTH, total_distance, LOG_TEXT);
    return status;
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
        char *captains_log = full_steam_ahead(nautical_miles);
        printf("%s", captains_log);
        free(captains_log);
    }

    return 0;
}
