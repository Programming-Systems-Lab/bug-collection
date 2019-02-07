'''This runs the build scripts as directed for each program and version'''
import sh
def build(program_name, version, location):
    '''Does the build for the specific program and version found
        at the specfied location'''
    if program_name.lower() == 'struts':
        build_struts(location, version)
    elif program_name.lower() == 'tomcat80':
        build_tomcat80(location, version)

def build_struts(location, version):
    '''does the struts build for the specified version
        location is the parent directory of the code
        i.e. .../.../struts'''
    log_path = location+'/sec_vuls4j.log'
    print("building...struts {}".format(version))
    with open(log_path, 'w') as log:
        try:
            mvn = sh.mvn.bake(_cwd=location)
            mvn(_out=log)
            mvn.install()
        except sh.ErrorReturnCode:
            print('FAILED to BUILD see logs at {}'.format(log_path))
            print('NOTE at the moment this message doesnt mean anything')

def build_tomcat80(location, version):
    '''does the tomcat80 build for the specified version
        location is the parent directory of the code
        i.e. .../.../tomcat80'''
    log_path = location+'/sec_vuls4j.log'
    print("building...tomcat80 {}".format(version))
    with open(log_path, 'w') as log:
        try:
            ant = sh.ant.bake(_cwd=location)
            ant(_out=log)
            ant()
        except sh.ErrorReturnCode:
            print('FAILED to BUILD see logs at {}'.format(log_path))
