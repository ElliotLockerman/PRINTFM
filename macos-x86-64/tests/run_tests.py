#! /usr/bin/env python3

import sys, os
from pathlib import Path
import subprocess as sp

test_a_gold =  """PRINTFM 0
PRINTFM 1: 12
PRINTFM 2: 12, 0xffffffff, 12
PRINTFM 3: 12, 0xffffffff, 12
PRINTFM 4: 12, 0xffffffff, 12, w
PRINTFM 5: 12, 0xffffffff, 12, w, foo
"""


tests = [("./test_a", test_a_gold)] # (test name, passing output)


def run():
    script_dir = Path(__file__).resolve().parent

    os.chdir(script_dir)

    sp.check_call("make")

    num_failures = 0
    num_passes = 0
    for test_name, passing in tests:
        proc = sp.run(test_name, stderr=sp.STDOUT, stdout=sp.PIPE, text=True)

        if proc.returncode == 0 and proc.stdout == passing:
            print(f"{test_name} passed")
            num_passes += 1
        else:
            print(f"{test_name} failed, exit code {proc.returncode}", file=sys.stderr)
            print("Output:", file=sys.stderr)
            print(proc.stdout, file=sys.stderr)

            num_failures += 1

    # test_b is supposed to end in a compilation failure.
    proc = sp.run(["cc", "test_b.s"], stderr=sp.STDOUT, stdout=sp.PIPE, text=True)
    if proc.returncode == 0:
        print(f"test_b failed (compilation succeeded, was supposed to fail)")
        num_failures += 1
    else:
        if "error: too many positional arguments" in proc.stdout:
            print(f"./test_b passed")
            num_passes += 1
        else:
            print(f"./test_b failed", file=sys.stderr)
            print("Output:", file=sys.stderr)
            print(proc.stdout, file=sys.stderr)

            num_failures += 1

    if num_passes == 0 and num_failures == 0:
        print("No tests ran?")
    elif num_failures == 0:
        print(f"All passed")
    else:
        print(f"{num_failures} failed")

if __name__ == "__main__":
    run()

