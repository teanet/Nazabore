#!/usr/bin/env python
import os
import logging
import argparse
import subprocess

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(message)s")

script_dir = os.path.dirname(os.path.realpath(__file__))
root_dir = os.path.join(script_dir, "../")


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
	subprocess.check_call(["rm", "-rf", "Nazabore/ProtoModels"])
	subprocess.check_call(["protoc", "--swift_out=./Nazabore", "./ProtoModels/protocol.proto"])

if __name__ == "__main__":
    main()
