BruteForce
==========
by Matthew Wean

MattWean.com

A simple password-checker that gives:

- The time required to check all possible strings from a given character set and length
- The probability of a password being cracked in a given amount of time
- Each with several pre-set speeds of attack or a provided rate

Usage:
------
### Make a new BruteForce instance and specify the password and cracker used
`bf = BruteForce.new(
:password => "$uPer4wesOmePassw0rd",
:attack_type => :GPU
)`

### Find how long to try all combinations
`time = bf.crack_time
=> "about 734 quintillion years"`

### Find the chance of being cracked in 100 quintillion years
`fail = bf.chance_of_failure(100000000000000000000)
=> "13.62%"`

Options: (all but password are optional)
----------------------------------------
`:password` => any english letter, arabic numeral or the symbols ,.!@#$%^&*?_~-()

`:attack_type` => :Extreme (10 billion attempts/sec), :GPU (3 billion), :desktop (200 million), online (100)

`:speed` => any positive integer

`:user_gen` => true/false (sets whether or not to correct for predictability of user-generated passwords based on estimates by NIST)

`:combinations` => number of possible passwords