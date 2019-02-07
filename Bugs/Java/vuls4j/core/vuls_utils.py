''' This file will function as a DB or a utils location at the moment
    will probably need to change at some point '''

PROG_INFO = {}
URLS = {'STRUTS' : 'https://github.com/apache/struts.git',
        'TOMCAT80' : 'https://github.com/apache/tomcat80.git'}

def load_program_info():
    '''loads all the vulnerability infos'''
    # This will probably have to be done cached somewhere at somepoint
    # or for a web program get put in a db

    with open('../resources/struts_commits.csv') as struts_in:
        PROG_INFO['STRUTS'] = {}
        for index, line in enumerate(struts_in):
            splt = line.strip().split(',')
            PROG_INFO['STRUTS'][str(index)] = {'CVE' : splt[0],
                                               'buggy_release' : splt[1],
                                               'patched_release' : splt[2],
                                               'run_subdir' : splt[3],
                                               'run_cmd' : splt[4]
                                              }
    with open('../resources/tomcat8_commits.csv') as tomcat_in:
        PROG_INFO['TOMCAT80'] = {}
        for index, line in enumerate(tomcat_in):
            splt = line.strip().split(',')
            PROG_INFO['TOMCAT80'][str(index)] = {'CVE' : splt[0],
                                               'buggy_release' : splt[1],
                                               'patched_release' : splt[2],
                                               'run_subdir' : splt[3],
                                               'run_cmd' : splt[4]}


'''
Form of PROG_INFO is as follows:
{program_name:
    {bug_index:
        { cve: "",
          buggy_release: "",
          patched_release:"",
          run_subdir: "",
          run_cmd: "" }
    }
}
'''
def error_checking(program_name, bug_index, prog_type):
    '''Do some common input checking.'''
    if prog_type != 'b' and prog_type != 'p':
        print('Error: Invalid Version Type')
        exit(1)
    if program_name.upper() not in PROG_INFO:
        print('Invalid program name {}'.format(program_name))
        exit(1)
    if bug_index not in PROG_INFO[program_name.upper()]:
        print('Invalid bug index {}'.format(bug_index))
        exit(1)
