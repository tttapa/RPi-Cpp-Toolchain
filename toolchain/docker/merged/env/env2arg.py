#!/usr/bin/env python3

import sys
import re

with open(sys.argv[1], 'r') as f:
    ptrn = re.compile(r'^export (\w+)=', re.MULTILINE)
    res = map(lambda m: '--build-arg ' + m.group(1),
              re.finditer(ptrn, f.read()))
    print(' '.join(res))