git clone https://github.com/curl/curl.git curl-old
git clone https://github.com/curl/curl.git curl-new
mkdir test-result-curl
cd curl-old
git checkout 09d16af
./buildconf
./configure --with-ssl=/path/to/libressl 2> ../test-result-curl/buggy_result.txt
cd ..
cd curl-new/
git checkout d353af0
./buildconf
./configure --with-ssl=/path/to/libressl 2> ../test-result-curl/fixed_version.txt

