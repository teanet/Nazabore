#!/usr/bin/env python
import os
import logging
import argparse
import subprocess
import hashlib

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(message)s")

script_dir = os.path.dirname(os.path.realpath(__file__))
root_dir = os.path.join(script_dir, "../")
build_dir = os.path.join(root_dir, "Build")


plist_path = os.path.join(root_dir, "Cashback/Info.plist")
versionNumber = subprocess.check_output(["/usr/libexec/PlistBuddy", "-c", "Print CFBundleShortVersionString", plist_path])
buildNumber = int(subprocess.check_output(["/usr/libexec/PlistBuddy", "-c", "Print CFBundleVersion", plist_path]))
archive_name = "archive_{}_{}".format(versionNumber, buildNumber + 1)
archive_path = os.path.join(build_dir, archive_name)
archive_full_path = archive_path + ".xcarchive"

team_id = "695938Y5Q8"
app_id = "1416612668"
bundle_id = "ru.doublegis.cashback"
scheme = "Cashback"
ipa_name = "Cashback.ipa"
provisioning_uuid = "80b67dac-e7ef-46f2-96bd-0b3adf576a10"
workspace = os.path.join(root_dir, "Cashback.xcworkspace")

def main():
    parser = create_parser()
    args = parser.parse_args()

    logging.debug("Passed arguments: {}".format(args))
    incement_build()
    create_archive()
    # upload_dsym()
    create_ipa()
    upload_ipa(args)

def incement_build():
    new_build_number = buildNumber + 1
    logging.info("Increment build to: {}".format(new_build_number))
    logging.info("Archive new path: {}".format(archive_full_path))
    
    subprocess.check_call(["/usr/libexec/PlistBuddy", "-c", "Set CFBundleVersion {}".format(new_build_number), plist_path])


def create_parser():
    parser = argparse.ArgumentParser(description="Generating v4iOS module..")
    parser.add_argument("--name", "-n", help="Module name", default="")
    parser.add_argument("--login", "-l", help="Login", required=True)
    parser.add_argument("--password", "-p", help="Password", required=True)
    return parser

def create_archive():
    xcodebuild = [
        "xcodebuild", 
        "archive", 
        "-workspace", workspace, 
        "-archivePath", archive_path,
        "-scheme", scheme,
    ]

    p1 = subprocess.Popen(xcodebuild, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    p2 = subprocess.check_call(["xcpretty", "-cs"], stdin=p1.stdout)
    p1.wait()


def upload_dsym():
    subprocess.check_call([
        os.path.join(root_dir, "Pods/Fabric/upload-symbols"),
        "-gsp", os.path.join(root_dir, "Cashback/Supporting Files/GoogleService-Info.plist"),
        "-p", "ios",
        os.path.join(archive_full_path, "dSYMs")
    ])

def upload_ipa(args):
    ipa_path = os.path.join(build_dir, ipa_name)
    logging.info("Upload ipa: {}".format(ipa_path))
    subprocess.check_call([
        "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool", 
        "--upload-app",
        "-f", ipa_path,
        "-t", "ios",
        "-u", args.login,
        "-p", args.password,
        "--output-format", "normal"
        ])

def create_ipa():
    plsit = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>provisioningProfiles</key>
        <dict>
            <key>{}</key>
            <string>{}</string>
        </dict>
        <key>signingCertificate</key>
            <string>iOS Distribution</string>
        <key>signingStyle</key>
            <string>manual</string>
        <key>method</key>
            <string>app-store</string>
        <key>teamID</key>
            <string>{}</string>
    </dict>
    </plist>
    """.format(bundle_id, provisioning_uuid, team_id)
    plist_path = os.path.join(root_dir, "Build/ipa.plist")
    with open(plist_path, "w") as text_file:
        text_file.write(plsit)

    subprocess.check_call([
        "xcodebuild", 
        "-exportArchive", 
        "-archivePath", archive_full_path, 
        "-exportOptionsPlist", plist_path,
        "-exportPath", os.path.join(root_dir, "Build/"),
        ])

if __name__ == "__main__":
    main()
