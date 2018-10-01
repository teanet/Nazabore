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
    setup_cocoapods()
    protobuf()

def create_parser():
    parser = argparse.ArgumentParser(description="Generating v4iOS module..")
    parser.add_argument("--name", "-n",
        help="Module name",
        default="")
    return parser

def protobuf():
    generate_proto = os.path.join(script_dir, "generate_proto.py")

    parameters = [generate_proto]

    try:
        subprocess.check_call(parameters)
    except os.error as e:
        logging.error("Preinstalled data error")
        raise

def setup_cocoapods():
    logging.info("Cocoapods setup")
    # Disable sending stats
    os.environ["COCOAPODS_DISABLE_STATS"] = "1"
    logging.info("pod install --no-repo-update")
    try:
        subprocess.check_call(["pod", "install"])
    except subprocess.CalledProcessError:
        subprocess.check_call(["pod", "install", "--repo-update"])
    except OSError as e:
        if e.errno == os.errno.ENOENT:
            logging.error("CocoaPods is not installed. Please, install CocoaPods with 'sudo gem install cocoapods' or visit 'https://cocoapods.org/'")
        raise


if __name__ == "__main__":
    main()
