Since wlogout can't store command-line flags in a json file (like wleave's layout.json), I have to manually put the following command like flags:
`-b 6 -c 0 -r 0 -m 0`

Breakdown:

-b 6 - put everything (all 6 buttons) in one row  
-c 0 -r 0 - remove all gaps, column-wise and row-wise, between buttons  
-m 0 - removes wlogout's 230px default margin (Source: [deepwiki](<https://deepwiki.com/ArtsyMacaw/wlogout/3.1-application-structure-(main.c)>) and [the GitHub source code](https://github.com/ArtsyMacaw/wlogout/blob/350fe88b/main.c#L47-L47))
