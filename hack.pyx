from __future__ import print_function

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
    cdef set remove
    cdef set unique_lines = set([filter(str.isalnum, x).lower() for x in lines])
    cdef common = substrs(unique_lines, length)

    # Sort by longest sentence to shortest sentence.
    # Sort this way since lambda functions aren't yest supported
    # in cython.
    cdef list prefixes = sorted([[-len(sentences), substr, sentences]
                                 for substr, sentences in common.iteritems()])

    # Logic
    for i in xrange(len(prefixes)):
        # Skip ones that we have seen before
        if not(unique_lines & prefixes[i][2]):
            continue

        # Get the substring
        word = prefixes[i][1]

        # Do not use filter here because closures are not yet supported
        remove = set([j for j in unique_lines if word in j])

        # Remove the sentences visited
        unique_lines.difference_update(remove)
        for p in prefixes:
            p[2].difference_update(remove)
            p[0] = -len(p[2])

        # Sort by sentence length again
        prefixes[i + 1:] = sorted(prefixes[i + 1:])

        # Add the new word
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

