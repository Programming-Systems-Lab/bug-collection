git clone https://github.com/curl/curl.git curl-old
git clone https://github.com/curl/curl.git curl-new
cd curl-old
git checkout a4653a7
./buildconf
./configure --without-ssl
make -j8
mkdir ../test-result-curl
./src/curl -v http://cmake.org > ../test-result-curl/buggy_result.txt 2>&1
cd ..
cd curl-new/
git checkout 2c5ec33
./buildconf
./configure --without-ssl
make -j8
./src/curl -v http://cmake.org > ../test-result-curl/fixed_version.txt 2>&1
