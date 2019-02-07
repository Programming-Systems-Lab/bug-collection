'''This script loads the program information
    clones the specified program
    into the specified directory
    uses the correct version
    builds it as required'''

import sh
import core.vuls_utils


def checkout(program_name, version, location_path):
    '''actually clone and checkout the program from git'''
    # Eventually bug index will need to be read by regular expression
    # i.e. take all the numbers at the beginning of the string
    if version != 'HEAD':
        bug_index = version[0]
        prog_type = version[1]
        core.vuls_utils.error_checking(program_name, bug_index, prog_type)

    tag = None


    print('checking out {} {} into {}'.format(program_name, version, location_path))
    # Make directory if doesn't exist
    sh.mkdir('-p', location_path)
    git = sh.git.bake(_cwd=location_path)
    try:
        git.clone(core.vuls_utils.URLS[program_name.upper()])
        print('SUCCESS cloned {} {} into {}'.format(program_name, version, location_path))
    except sh.ErrorReturnCode:
        print("{} already exists in location {}".format(program_name.lower(),
                                                        location_path))

    # if you need to checkout a certain version
    git = sh.git.bake(_cwd=location_path + "/" + program_name.lower())
    bug_entry = core.vuls_utils.PROG_INFO[program_name.upper()][bug_index]
    if version == 'HEAD':
        print('If newly cloned then checked out head...not fully implemented')
        exit(1)
    if prog_type == 'b':
        tag = bug_entry['buggy_release']
    else:
        tag = bug_entry['patched_release']
    # checkout the parent commit -- assuming only one parent commit
    git.checkout(tag)
    print('SUCCESS checked out {} {} into {}\nRelease name: {}'
          .format(program_name, version,
                  location_path, tag))
