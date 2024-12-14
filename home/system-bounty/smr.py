import os
import time
import sys
import argparse
import subprocess
import yaml
from yaml.loader import SafeLoader
import random

from string import ascii_letters, digits

char = lambda i: ' '.join(
        random.sample(ascii_letters + digits, k=i)).upper()

def shuffle(line, nlen):
    
    for x in range(0, random.randint(1, 10)):
        print('\t{}'.format(char(nlen)), end='\r')
        time.sleep(0.1)
    print('\t' + line)

def print_banner(name='Nameless', version='00.00.00', author='unknown'):

    nlen = len(name) + 4            # name legnth + four chars
    name = ' '.join(name.upper())   # space between letters

    # ? ? N A M E ? ?
    name = '{} \033[1;92m{} \033[0m{}'.format(char(2), name, char(2))

    lines = [char(nlen), name, char(nlen)]
    print('\n')
    [shuffle(line, nlen) for line in lines]
    print("\n\t{}".format(author))
    print("\t{}\n".format(version))

if __name__ == "__main__":
    print_banner("Scan Management Recon", "Version: V1.0", "Author: Al4xs")




parser = argparse.ArgumentParser()
parser.add_argument("-config", help="Yaml file.", dest="config_file", required=True)
parser.add_argument("-target", help="Target id.", dest="target_id", required=True)
parser.add_argument("-schedule", help="Schedule time in hours", dest="schedule_time", required=False)
#parser.add_argument("-sh", help="", dest="Custom SH", required=True)
args = parser.parse_args()


def banner():
    print("""    
                   
System Management Recon
                   
Author: @Al4xs
    """)


def nuclei(config_file: str) -> list:
    DEFAULT_NUCLEI_PATH = os.getenv("HOME") + "/nuclei-templates"
    with open(config_file) as wk:
        data = yaml.load(wk, Loader=SafeLoader)

    nuclei_yaml = data["nuclei_scan"]
    concurrency = nuclei_yaml["concurrency"]
    rate_limit = nuclei_yaml["rate_limit"]
    timeout = nuclei_yaml["timeout"]
    retries = nuclei_yaml["retries"]

    nuclei_default_command = "nuclei -es info,unknown -c {} -rl {} -timeout {} -retries {} -l __in__".format(
        concurrency, rate_limit, timeout, retries
    )
    nuclei_commands_list = []

    if nuclei_yaml["custom_templates"]:
        custom_templates_command = nuclei_default_command + " -o nuclei_custom.txt"
        for template in nuclei_yaml["custom_templates"]:
            custom_templates_command += " -t {}".format(template)
        nuclei_commands_list.append(custom_templates_command)

    if nuclei_yaml["severity"]:
        severity_command = nuclei_default_command + " -t {} -o nuclei_severity.txt -severity {}".format(DEFAULT_NUCLEI_PATH, ",".join(nuclei_yaml["severity"]))
        nuclei_commands_list.append(severity_command)

    if nuclei_yaml["cve_ids"]:
        cve_command = nuclei_default_command + " -o nuclei_cve.txt -id {}".format(",".join(nuclei_yaml["cve_ids"]))
        nuclei_commands_list.append(cve_command)

    if nuclei_yaml["tags"]:
        tags_command = nuclei_default_command + " -o nuclei_tags.txt -tags {}".format(",".join(nuclei_yaml["tags"]))
        nuclei_commands_list.append(tags_command)

    return nuclei_commands_list


def workflows(config_file: str) -> list:
    print("[INFO] - Loading Workflows..")
    with open(config_file) as wk:
        data = yaml.load(wk, Loader=SafeLoader)

    workflows_list = []
    workflows = data["workflows"]
    for command in workflows:
        command_name = command["name"]
        command_shell = command["command"]
        workflows_list.append(command_shell)

    return workflows_list


def scanner(config_file: str, target_id: str):
    workflowss = workflows(config_file)
    nuclei_commands = nuclei(config_file)

    TARGET_ID = target_id
    PPATH = os.getcwd()
    SCAN_ID = TARGET_ID + "-" + str(int(time.time()))
    SCAN_PATH = PPATH + "/scans/" + SCAN_ID
    RAW_PATH = PPATH + "/data/" + TARGET_ID + "/"
    TARGET_FILE = RAW_PATH + "subdomains-alive"
    TARGET_NEW_FILE = RAW_PATH + "subdomains-alive.new"
    THREADS = 15
    NOTIFY = "telegram"

    os.popen(f"echo 'Scan_ID {SCAN_ID}' >> log.txt ; echo 'scan_path {SCAN_PATH}' >> log.txt")
    try:
        os.makedirs(SCAN_PATH)
        os.makedirs(RAW_PATH)
    except:
        pass

    os.chdir(SCAN_PATH)

    print(f"[INFO] - Scan ID {SCAN_ID}")
    print(f"[INFO] - Scan Path {SCAN_PATH}")

    print("[INFO] - Preparing Scope..")
    cp = os.system(f'cp "{PPATH}/scope/{TARGET_ID}" "{SCAN_PATH}/scope"')

    print("[INFO] - Starting Subdomain Recon..")
    subdomain_recon = subprocess.Popen("cat scope | xargs -I{} bash -c 'scon {}'", shell=True)
    subdomain_recon.wait()

    print("[INFO - ASM] - Notifying new Subdomains..")
    new_subs = subprocess.Popen('cat "{}/subdomains-alive" | anew "{}/subdomains-alive" > "{}/subdomains-alive.new" ; notify -id sub -bulk -i "{}/subdomains-alive.new" -mf "New Subdomains found! {{{{data}}}}"'.format(SCAN_PATH, RAW_PATH, RAW_PATH, RAW_PATH, PPATH), shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
    new_subs.wait()

    if nuclei_commands:
        for command in nuclei_commands:
#            command = command + '| notify'.format(PPATH)
            command = command.replace("\n", "")
            command = command.replace("__in__", TARGET_FILE)
            if command.__contains__("__new__"):
                command = command.replace("__new__", TARGET_NEW_FILE)
            os.system(command)

    if workflowss:
        for oneliner in workflowss:
            oneliner = oneliner.replace("__in__", TARGET_FILE)
            if oneliner.__contains__("__new__"):
                oneliner = oneliner.replace("__new__", TARGET_NEW_FILE)
            os.system(oneliner)


def schedule(schedule_time: int, config_file: str, target_id: str):
    while True:
        path = os.getcwd()
        time.sleep(int(schedule_time) * 3600)
        scanner(config_file, target_id)
        os.chdir(path)


def main():
    print(banner())
    if args.schedule_time:
        print("[INFO] Scheduling... Scan every {} hours".format(args.schedule_time))
        schedule(args.schedule_time, args.config_file, args.target_id)
    else:
        scanner(args.config_file, args.target_id)


if __name__ == "__main__":
    main()
