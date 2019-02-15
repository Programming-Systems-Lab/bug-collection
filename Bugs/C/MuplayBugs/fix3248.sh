# enable localhost first
git clone https://github.com/curl/curl.git curl-old
git clone https://github.com/curl/curl.git curl-new
mkdir test-result-curl
cd curl-old
git checkout 27cb384
./buildconf
./configure 
make -j8
./src/curl --local-port 1023-1024 localhost > ../test-result-curl/buggy_version.txt 2>&1
cd ..
cd curl-new/
git checkout fcf3f13
./buildconf
./configure 
make -j8
./src/curl --local-port 1023-1024 localhost > ../test-result-curl/buggy_version.txt 2>&1
