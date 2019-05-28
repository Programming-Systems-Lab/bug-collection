# Curl Bug #7
# https://github.com/curl/curl/commit/d353af001420574210605ba132dfd31a0e3876a5
# configure: add basic test of --with-ssl prefix

CURL_BUG_7 = 09d16af 
CURL_PATCH_7 = d353af0

curl-buggy-7: 
	git clone https://github.com/curl/curl.git curl-old; \
	cd ./curl-old; \
	git checkout $(CURL_BUG_7); \
	./buildconf; 
	
curl-patched-7: 
	git clone https://github.com/curl/curl.git curl-new; \
	cd ./curl-new; \
	git checkout $(CURL_PATCH_7); \
	./buildconf; 

test-curl-buggy-7:
	mkdir test-result-curl; \
	cd ./curl-old; \
	./configure --with-ssl=/path/to/libressl 2> ../test-result-curl/buggy_result.txt; \
	vim ../test-result-curl/buggy_result.txt

test-curl-patched-7:
	cd ./curl-new; \
	./configure --with-ssl=/path/to/libressl 2> ../test-result-curl/fixed_version.txt; \
	vim ../test-result-curl/fixed_version.txt

clean-curl-7:
	rm -rf ./curl-old; \
	rm -rf ./curl-new; \
	rm -rf ./test-result-curl


