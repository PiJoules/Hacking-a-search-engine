from __future__ import print_function

cdef set all_substrings(char* string, unsigned int min_len=1):
    """Get all substrings of a string."""
    # Initialization
    cdef set substrs = set()
    cdef unsigned int slen = len(string)

    # Logic
    for size in xrange(1, slen + 1):
        for i in xrange(slen + 1 - size):
            substr = string[i:i + size]
            if len(substr) >= min_len and substr not in substrs:
                substrs.add(substr)

    # Return
    return substrs


cdef set common_substrings(list str_list, unsigned int min_len=1):
    """Get list of common substrings in each string in str_list."""
    # Assertions
    assert str_list

    # Initialization
    cdef set substrs = all_substrings(str_list[0], min_len=min_len)

    # Logic
    for i in xrange(1, len(str_list)):
        substrs = substrs & all_substrings(str_list[i], min_len=min_len)

    # Return
    return substrs


####################
# SCRIPT STARTS HERE
####################
print(all_substrings("something", min_len=5))
print(common_substrings(["something", "else"], min_len=5))

