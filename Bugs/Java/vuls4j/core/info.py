'''Print the info of the desired program as required'''
import core.vuls_utils as cvu

def print_info(program_name, version):
    '''prints info about the thing'''

    version_num = version[0]
    cve = None
    buggy_release = None
    patched_release = None
    url = None
    if program_name == 'struts':
        try:
            cve = cvu.PROG_INFO[program_name.upper()][version_num]['CVE']
            buggy_release = cvu.PROG_INFO[program_name.upper()][version_num]['buggy_release']
            patched_release = cvu.PROG_INFO[program_name.upper()][version_num]['patched_release']
            url = cvu.URLS[program_name.upper()]
            run_subdir = cvu.PROG_INFO[program_name.upper()][version_num]['run_subdir']
            run_cmd = cvu.PROG_INFO[program_name.upper()][version_num]['run_cmd']
        except KeyError as err:
            print('INVALID VERSION NUM')
            print("Key error:  {}".format(err))
            exit(1)
    elif program_name == 'tomcat80':
        try:
            cve = cvu.PROG_INFO[program_name.upper()][version_num]['CVE']
            buggy_release = cvu.PROG_INFO[program_name.upper()][version_num]['buggy_release']
            patched_release = cvu.PROG_INFO[program_name.upper()][version_num]['patched_release']
            url = cvu.URLS[program_name.upper()]
            run_subdir = cvu.PROG_INFO[program_name.upper()][version_num]['run_subdir']
            run_cmd = cvu.PROG_INFO[program_name.upper()][version_num]['run_cmd']
        except KeyError as err:
            print('INVALID VERSION NUM')
            print("Key error:  {}".format(err))
            exit(1)
    else:
        print("Unexpected program name: {}".format(program_name))
        exit(1)


    print(("Program Name: {}\n" +
           "Git URL: {}\n" +
           "Program Version: {}\n" +
           "Associated CVE: {}\n" +
           "Buggy Release: {}\n" +
           "Patched Release: {}\n" +
           "Run subdirectory: {}\n" +
           "Run cmd: {}").format(program_name, url, version, cve,
                                 buggy_release,
                                 patched_release, run_subdir, run_cmd))
