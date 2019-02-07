'''This script runs the main functionality of the sec_vuls4J'''
import sys

import core.info as info
import core.vuls_utils
import core.checkout
import core.build as build
import core.run as run
import core.exploit as exploit
def usage():
    '''Print the usage message'''
    print('Usage:\n'+
          '1) python vuls4j checkout [progname] [version] [directory to store the program in]\n' +
          '2) python vuls4j build [progname] [version] [location]\n' +
          '3) python vuls4j exploit [progname] [version]\n' +
          '4) python vuls4j info [progname] [version]\n' +
          '5) python vuls4j run [progname] [version] [directory that holds the program]')

def main(args):
    '''parse arguments and load info'''
    # Minimum error checking
    if len(args) < 4:
        print("Not enough args")
        usage()
        exit(1)
    elif args[1] == 'checkout' and len(args) != 5:
        print("Error: impoper number of args for checkout")
        usage()
        exit(1)
    elif args[1] == 'build' and len(args) != 5:
        print("Error: improper number of args for build")
        usage()
        exit(1)
    elif args[1] == 'exploit' and len(args) != 4:
        print("Error: improper number of args for exploit")
        usage()
        exit(1)
    elif args[1] == 'run' and len(args) != 5:
        print("Error: improper number of args for run")
        usage()
        exit(1)
    elif args[1] == 'info' and len(args) != 4:
        print("Error: improper number of args for info")
        usage()
        exit(1)
    elif (args[1] != 'checkout' and args[1] != 'info'
          and args[1] != 'exploit' and args[1] != 'build'
          and args[1] != 'run'):
        print("Unrecognized command {}".format(args[1]))
        usage()
        exit(1)
    # TODO: add checkout-build command to checkout and then build automatically

    core.vuls_utils.load_program_info()

    if args[1] == 'checkout':
        core.checkout.checkout(args[2], args[3], args[4])
    elif args[1] == 'exploit':
        exploit.exploit(args[2], args[3])
    elif args[1] == 'info':
        info.print_info(args[2], args[3])
    elif args[1] == 'build':
        build.build(args[2], args[3], args[4])
    elif args[1] == 'run':
        run.run(args[2], args[3], args[4])


if __name__ == '__main__':

    main(sys.argv)


'''
Some notes on how preliminary version will work
NOTE this is based a lot on defects4j by rjust from UMASS

CHECKOUT does the following
1) specify a program name
2) specify a program bug index/version
call with:
python vuls4j checkout [progname] [version] [directory to store the program in]
python vuls4j checkout struts 1b /tmp/stuts_1_buggy

EXPLOIT will work as follows
1) runs the predetermined exploit to recreate the bug as required
call with:
python vuls4j exploit [progname] [version]
python vuls4j exploit struts 1b

INFO will work as follows
1) prints information about the specified program and version
   i.e. stuff like associated cve commit, patch commit
call with:
    python vuls4j info [progname] [version]

BUILD
1) given a directory and project version will build the project as normal
   once it has already been downloaded
call with:
    python vuls4j build [progname] [version] [location]

RUN
1) Runs the server side program with the bug to be exploited
call with:
    python vuls4j run [progname] [version] [location]
'''
