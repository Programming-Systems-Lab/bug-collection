git clone https://github.com/antirez/redis.git redis_fix_1
cd redis_fix_1 && git checkout e2c1f80b && make -j8 && cd ..
echo "redis_fix_1/src/redis-server > /dev/null &" > fix_server.sh
echo "server=\$!" >> fix_server.sh
echo "wait \$server" >> fix_server.sh
echo "res=\$?" >> fix_server.sh
echo "echo \$res > result" >> fix_server.sh
chmod 744 fix_server.sh
./fix_server.sh &
mkfifo fix_pipe
telnet localhost 6379 < fix_pipe > /dev/null 2>&1 &
sleep 3600 > fix_pipe &
echo "MONITOR" >> fix_pipe
echo "hi redis" >> fix_pipe
sleep 10
if [ ! -f result ]; 
then
    kill -9 $(ps ax | grep -v "grep" | grep "redis-server" | awk '{print $1}');
    touch result;
fi
NUMBER=$(tail -1 result)
if [ $NUMBER -eq 139 ];
then
  echo "redis-server has segmentation fault";
else
  echo "redis-server is running normally";
fi
kill -9 $(ps ax | grep -v "grep" | grep "sleep 3600" | awk '{print $1}')
rm fix_pipe
rm fix_server.sh
rm -rf redis_fix_1
rm result
