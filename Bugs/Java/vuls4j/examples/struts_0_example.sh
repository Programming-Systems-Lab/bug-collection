# This checks out builds runs and exploits the given vulnerability with
# struts bug 0
# This same procedure works for bug 1
cd ../core
python main.py checkout struts 0b /tmp/struts_1_buggy
python main.py info struts 0
python main.py build struts 0 /tmp/struts_1_buggy # Note this will throw an error and that's ok for the purposes of demonstrating the bug
python main.py run struts 0b /tmp/struts_1_buggy/struts & # run this is in background so it can be exploited
sleep 60 # need to give server time to start
python main.py exploit struts 0b
