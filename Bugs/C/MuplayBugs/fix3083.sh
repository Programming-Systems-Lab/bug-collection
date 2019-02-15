git clone https://github.com/curl/curl.git curl-old
git clone https://github.com/curl/curl.git curl-new
cd curl-old
git checkout b55e85d
./buildconf
./configure
make -j8
mkdir ../test-result-curl
./src/curl --head file:///usr/share/dict/words > ../test-result-curl/buggy_result.txt
cd ..
cd curl-new/
git checkout e50a200
./buildconf
./configure
make -j8
./src/curl --head file:///usr/share/dict/words > ../test-result-curl/fixed_version.txt
