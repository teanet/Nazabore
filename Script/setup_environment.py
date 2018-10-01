#!/usr/bin/env python
import os
import logging
import argparse
import subprocess
import errno

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(message)s")

script_dir = os.path.dirname(os.path.realpath(__file__))
root_dir = os.path.join(script_dir, "../")
build_dir = os.path.join(script_dir, "../Build")

def main():
    parser = create_parser()
    args = parser.parse_args()

    logging.debug("Passed arguments: {}".format(args))
    create_protos()

def create_parser():
    parser = argparse.ArgumentParser(description="Generating v4iOS module..")
    parser.add_argument("--name", "-n",
        help="Module name",
        default="")
    return parser

def create_protos():
    subprocess.check_call(["brew", "upgrade", "protobuf"])
    try:
        os.makedirs(build_dir)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise
    os.chdir(build_dir)
    subprocess.check_call(["git", "clone", "https://github.com/apple/swift-protobuf.git"])
    os.chdir(os.path.join(build_dir, "swift-protobuf"))
    subprocess.check_call(["git", "tag", "-l"])
    subprocess.check_call(["git", "checkout", "tags/0.9.903"])
    subprocess.check_call(["swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"])
    subprocess.check_call(["cp", ".build/release/protoc-gen-swift", "/usr/local/bin"])


if __name__ == "__main__":
    main()
