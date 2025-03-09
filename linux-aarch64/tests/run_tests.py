#! /usr/bin/env python3

import sys, os
from pathlib import Path
import subprocess as sp

test_a_gold =  """PRINTFM 0
PRINTFM 1: 12
PRINTFM 2: 12, -423
PRINTFM 3: 12, -423, 0xffffffff
PRINTFM 4: 12, -423, 0xffffffff, 72
PRINTFM 5: 12, -423, 0xffffffff, 72, w
PRINTFM 6: 12, -423, 0xffffffff, 72, w, foo
PRINTFM 7: 12, -423, 0xffffffff, 72, w, foo, 18446744073709551193
"""


tests = [("./test_a", test_a_gold)] # (test name, passing output)


test_b_gold = """test_b.s: Assembler messages:
test_b.s:90: Error: too many positional arguments
test_b.s:21:  Info: macro invoked from here
"""

def run():
    script_dir = Path(__file__).resolve().parent

    os.chdir(script_dir)

    sp.check_call("make")

    num_failures = 0
    num_passes = 0
    for test_name, passing in tests:
        output = sp.check_output(test_name)
        try:
            output = output.decode()
        except UnicodeDecodeError:
            assert(output != passing)
            pass

        if output == passing:
            print(f"{test_name} passed")
            num_passes += 1
        else:
            print(f"{test_name} failed", file=sys.stderr)
            print("Output:")
            print(output)

            num_failures += 1

    # test_b is supposed to end in a compilation failure.
    proc = sp.run(["cc", "test_b.s"], stderr=sp.PIPE)
    if proc.returncode == 0:
        print(f"test_b failed (compilation succeeded)")
        num_failures += 1
    else:
        try:
            stderr = proc.stderr.decode()
        except UnicodeDecodeError:
            stderr = proc.stderr
            assert(stderr != passing)

        if stderr == test_b_gold:
            print(f"./test_b passed")
            num_passes += 1
        else:
            print(f"./test_b failed", file=sys.stderr)
            print("Output:")
            print(stderr)

            num_failures += 1

    if num_passes == 0 and num_failures == 0:
        print("No tests ran?")
    elif num_failures == 0:
        print(f"All passed")
    else:
        print(f"{num_failures} failed")

if __name__ == "__main__":
    run()

