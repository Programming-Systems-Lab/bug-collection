'''This runs the specified server program'''
import os
import sh
import core.vuls_utils
import atexit

# This is a hack. Need to change this
tomcat_path = ''
def stop_tomcat():
    '''shuts off the tomcat server because it will run anyway'''
    print('Stopping Tomcat server')
    os.path.join('', tomcat_path)
    os.system('./catalina.sh stop')


def run(program_name, version, location_path):
    '''Run the given program name and version where the specified
        program's parent directory is located at the location path'''

    program_index = version[0]
    program_type = version[1]
    core.vuls_utils.error_checking(program_name, program_index, program_type)
    # Eventually this needs to be a regex to get the version num from the
    # prefix of the version code
    bug_index = program_index
    bug_entry = core.vuls_utils.PROG_INFO[program_name.upper()][bug_index]
    run_cmd = bug_entry['run_cmd']
    total_run_path = os.path.join(location_path, bug_entry['run_subdir'])
    try:
        sh.cd(total_run_path)
    except sh.ErrorReturnCode:
        print("No file found at: {}".format(total_run_path))
        print("Check parent directory: {}".format(location_path))
        exit(1)

    print("{} version {}".format(program_name, version))
    print("working directory: {}".format(total_run_path))
    print("Running: {}".format(run_cmd))
    # TODO add flag to run with recording
    os.system(run_cmd)
    choice = input('Press enter to shut down tomcat')

    if program_name.lower() == 'tomcat80':
        tomcat_path = total_run_path
        atexit.register(stop_tomcat)
