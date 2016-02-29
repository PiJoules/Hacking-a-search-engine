#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys

from hack import queries


def main():
    lines = list(sys.stdin)
    print(queries(lines, length=5))

    return 0


if __name__ == "__main__":
    sys.exit(main())

