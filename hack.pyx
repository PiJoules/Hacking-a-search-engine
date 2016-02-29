from __future__ import print_function

import re
import string

from itertools import combinations

cdef DEL_CHARS = "".join(c for c in map(chr, range(256))
                         if not c.isalnum())

cdef set all_substrings(char* string, unsigned int length=1):
    """Get all substrings of a string."""
    # Initialization
    cdef set substrs = set()
    cdef unsigned int slen = len(string)

    # Logic
    for i in xrange(slen + 1 - length):
        substr = string[i:i + length]
        if substr not in substrs:
            substrs.add(substr)

    # Return
    return substrs


cdef char* simplify(s):
    """Remove all non alphanumeric chars."""
    return s.translate(None, DEL_CHARS).lower()


cdef set common_substrings(tuple str_list, unsigned int length=1):
    """Get list of common substrings in each string in str_list."""
    # Initialization
    cdef set substrs = all_substrings(simplify(str_list[0]), length=length)
    cdef char* string

    # Logic
    for i in xrange(1, len(str_list)):
        string = simplify(str_list[i])
        substrs = substrs & all_substrings(string, length=length)

    # Return
    return substrs


cpdef set fewest_queries(list results, unsigned int length=1):
    """Return queries that result in getting all results."""
    # Initialization
    cdef set queries = set()
    cdef set common = set()
    cdef set found = set()  # Results already found
    cdef set combo_set = set()

    # Logic
    for i in xrange(len(results), 0, -1):
        for combination in combinations(results, i):
            common = common_substrings(combination, length=length)
            # Check if any substrs found
            if common:
                # Check if the combination contains results we have not
                # yet found.
                combo_set = set(combination)
                if combo_set - found:
                    found.update(combo_set)
                    queries.add(common.pop())  # Only need 1 common substr
                    if len(found) == len(results):
                        return queries

    # Return (None found)
    return set()


from collections import defaultdict
cdef substrs(set lines, int length):
    """Generate dict of each substring combination to the line it came from."""
    # Initialization
    cdef substrs = defaultdict(set)

    # Logic
    for line in lines:
        for i in xrange(len(line) + 1 - length):
            substrs[line[i:i + length]].add(line)

    # Return
    return substrs


cpdef list queries(list lines, int length=1):
    """Get the queries that result in getting all results."""
    # Initialization
    cdef list queries = []
    cdef char* word
    cdef set unique_lines = set([filter(str.isalnum, x).lower() for x in lines])
    cdef common = substrs(unique_lines, length)
    cdef list prefixes = sorted([[-len(sentences), substr, sentences]
                                  for substr, sentences in common.iteritems()])

    # Logic
    for i in xrange(len(prefixes)):
        if not(unique_lines & prefixes[i][2]):
            continue
        word = prefixes[i][1]
        to_remove = set([j for j in unique_lines if word in j])
        unique_lines.difference_update(to_remove)
        for p in prefixes:
            p[2].difference_update(to_remove)
            p[0] = -len(p[2])
        prefixes[i + 1:] = sorted(prefixes[i + 1:])
        queries.append(word)

    # Return
    return queries


####################
# SCRIPT STARTS HERE
####################

#cdef results = ["Jack and Jill went up the hill to fetch a pail of water.",
#                "All work and no play makes Jack and Jill a dull couple.",
#                "The Manchester United Junior Athletic Club (MUJAC) karate team was super good at kicking.",
#                "The MUJAC playmaker actually kinda sucked at karate."]
#print(queries(results, length=5))

