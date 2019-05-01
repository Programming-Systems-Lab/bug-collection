echo "redis_bug_1/src/redis-server > /dev/null &" > bug_server.sh
echo "server=\$!" >> bug_server.sh
echo "wait \$server" >> bug_server.sh
echo "res=\$?" >> bug_server.sh
echo "echo \$res > result" >> bug_server.sh
chmod 744 bug_server.sh
./bug_server.sh &
mkfifo bug_pipe
telnet localhost 6379 < bug_pipe > /dev/null 2>&1 &
sleep 3600 > bug_pipe &
echo "MONITOR" >> bug_pipe
echo "hi redis" >> bug_pipe
sleep 10
NUMBER=$(tail -1 result)
echo $NUMBER
if [ $NUMBER -eq 139 ];
then
  echo "redis-server has segmentation fault";
else
  echo "redis-server is running normally";
fi
kill -9 $(ps ax | grep -v "grep" | grep "sleep 3600" | awk '{print $1}')
