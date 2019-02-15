git clone https://github.com/curl/curl.git curl-old
git clone https://github.com/curl/curl.git curl-new
mkdir test-result-curl
cd curl-old
git checkout 6987e37
./buildconf
./configure 
make -j8
./src/curl http://[2600::] > ../test-result-curl/buggy_result.txt 2>&1
cd ..
cd curl-new/
git checkout b280948
./buildconf
./configure 
make -j8
./src/curl http://[2600::] > ../test-result-curl/fixed_version.txt 2>&1
