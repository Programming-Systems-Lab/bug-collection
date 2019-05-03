# This is a makefile that is used for building the test suite
# And running the evaluation as well

# TODO: add comments, find bugs for SQLite
curl-debug:
	git clone https://github.com/curl/curl.git; \
	cd curl; \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl_obj; \
	#make; \
	#make install; 
# TODO: Need to make test to make sure this installed correctly
openssl-debug:
	git clone https://github.com/openssl/openssl.git; \
	cd openssl; \
	./config --enable-debug --prefix=$$(pwd)/../openssl_obj shared zlib; \
	#make; \
	#make install;
      
#Start of evaluation/testing

TRACE_DIRECTORY=$$(pwd)/traces
record-curl:
	mkdir -p $(TRACE_DIRECTORY)
	_RR_TRACE_DIR=$(TRACE_DIRECTORY) rr record ./curl_obj/bin/curl www.example.com

replay-curl:
	rr replay $(TRACE_DIRECTORY)/curl-0


# Evaluation Samples


# CURL

# Works with the following patch
# The patch deals with fixing parsing of url and semicolons, and adds a test case
# Buggy Version: https://github.com/curl/curl/commit/4258dc02d86e7e4de9f795a1af3a0bc6732d4ab5
# Patched Version: https://github.com/curl/curl/commit/d8607da1a68f2482302ccdbb7cf457210b9ccfc9
# Associated Issue: https://github.com/curl/curl/pull/3365

#builds the buggy version of curl
CURL_URL =  https://github.com/curl/curl.git

# Bug 1

CURL_BUG_1 = 4258dc02d86e7e4de9f795a1af3a0bc6732d4ab5

CURL_PATCH_1 = d8607da1a68f2482302ccdbb7cf457210b9ccfc9

# TODO find an input that triggers this bug
CURL_BUGGY_INPUT_1 = [0:0:0:0:0:0:0:1]: #simply pings local host

curl-buggy-1:
	if [ ! -d "./curl" ]; \
		then git clone $(CURL_URL); \
	fi
	cd ./curl; \
	git checkout $(CURL_BUG_1); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-1-obj; \
	make -j8; \
	make install;

curl-patched-1:
	if [ ! -d "./curl" ]; then \
		git clone $(CURL_URL); \
	fi
	cd ./curl; \
	git checkout $(CURL_PATCH_1); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-patched-1-obj; \
	make -j8; \
	make install;

test-curl-buggy-1:
	./curl-buggy-1-obj/bin/curl $(CURL_BUGGY_INPUT_1)
# TODO Add check for bad url here

test-curl-patched-1:
	./curl-patched-1-obj/bin/curl $(CURL_BUGGY_INPUT_1)
# add check for successful request here


record-curl-buggy-1:
	echo "Needs to be implemented"

muplay-curl-bugg-1:
	echo "Needs to be implemented"

clean-curl-buggy-1:
	rm -rf ./curl; \
		rm -rf ./curl-buggy-1-obj
clean-curl-patched-1:
	rm -rf ./curl-patched-1-obj


# Curl Bug #2 Works with the following pull request and patch
# PR & Patch https://github.com/curl/curl/pull/3381
# This bug corrects behavior where curl -J will append to the output file instead of creating a new file -- Weak example of type 5 in the design section

CURL_BUG_2 = f097669248a877dece74fdb525e82bfe1b69df90
CURL_PATCH_2 = 4849267197682e69cfa056c2bd7a44acd123a917
CURL_BUGGY_INPUT_2 = -JO --location https://github.com/curl/curl/releases/download/curl-7_63_0/curl-7.63.0.tar.xz.asc
SIZE = curl-7.63.0.tar.xz.asc

clone-curl:
	if [ ! -d "./curl" ]; \
		then git clone $(CURL_URL); \
	fi

curl-buggy-2: clone-curl
	cd ./curl; \
	git checkout $(CURL_BUG_2); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-2-obj; \
	make -j8; \
	make install;

curl-patched-2: clone-curl
	cd ./curl; \
	git checkout $(CURL_PATCH_2); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-patched-2-obj; \
	make -j8; \
	make install;

test-curl-buggy-2-before:
	./curl-buggy-2-obj/bin/curl $(CURL_BUGGY_INPUT_2)

check-size-before: test-curl-buggy-2-before
	FILE_SIZE=$(shell ./check_size.sh)

test-curl-buggy-2-after: check-size-before
	./curl-buggy-2-obj/bin/curl $(CURL_BUGGY_INPUT_2)

test-curl-buggy-2: test-curl-buggy-2-after
	FILE_SIZE=$(shell ./check_size.sh)

# TODO ADD SOME CHECK HERE THAT APPENDED OUTPUT TO FILE
# added.
clear:
	rm curl-7.63.0.tar.xz.asc

test-curl-patched-2-before:clear
	./curl-patched-2-obj/bin/curl $(CURL_BUGGY_INPUT_2)

check-size2-before: test-curl-patched-2-before
	FILE_SIZE=$(shell ./check_size.sh)

test-curl-patched-2-after:
	./curl-patched-2-obj/bin/curl $(CURL_BUGGY_INPUT_2)

test-curl-patched-2: check-size2-before 
	COMMAND=$(shell ./check_command.sh)
# TODO ADD SOME CHECK HERE THAT ERROR WAS THROWN
# added.

record-curl-buggy-2:
	echo TODO NEEDS TO BE IMPLEMENTED

muplay-curl-buggy-2:
	echo TODO NEEDS TO BE IMPLEMENTED

clean-curl-buggy-2:
	rm -rf ./curl; \
		rm -rf ./curl-buggy-2-obj
clean-curl-patched-2:
	rm -rf ./curl-patched-2-obj

# Curl Bug #4 -- Security Vulnerability
# Patch applied here: https://github.com/curl/curl/commit/d530e92f59ae9bb2d47066c3c460b25d2ffeb211
# Needs a test case since one is not included -- another good example of type 1 in the design section

# leave this first.
CURL_BUG_4 = e97679a360dda4ea6188b09a145f73a2a84acedd
CURL_PATCH_4 = d530e92f59ae9bb2d47066c3c460b25d2ffeb211

CURL_BUGGY_INPUT_4 = www.gdsfjewnfpqnojodfsdfoggsgjoiaemfqoinfyibdsuabuicnsianuidfhihqowufhqownfqowufnqowfnqowfnqwoufnqouwnfoqwnfoqwnfqqnwfnqowfnqwuofnoqwnfoquwnfoqwnfqowfnfdsaclcdsadcasdfsadfegwwqweqwfqwsce.com 

curl-buggy-4: clone-curl
	mv ./curl ./curl-old; \
		cd ./curl-old; \
		git checkout $(CURL_BUG_4); \
		./buildconf; \
		./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-4-obj; \
		make -j8; \
		make install;

curl-patched-4: clone-curl
	mv ./curl ./curl-new; \
		cd ./curl-new; \
		git checkout $(CURL_PATCH_4); \
		./buildconf; \
		./configure --enable-debug --prefix=$$(pwd)/../curl-patched-4-obj; \
		make -j8; \
		make install;

test-curl-buggy-4:
	./curl-buggy-4-obj/bin/curl $(CURL_BUGGY_INPUT_4) 2> a 

test-curl-patched-4:
	./curl-patched-4-obj/bin/curl $(CURL_BUGGY_INPUT_4) 2> b

clean-curl-buggy-4:
	rm -rf ./curl-old; \
		rm -rf ./curl-buggy-4-obj;

clean-curl-patched-4:
	rm -rf ./curl-new; \
		rm -rf ./curl-patched-4-obj;
# Registered with CVE-2018-16842

# Curl Bug #5 -- Security Vulnerability
# Not noted where the patch is applied but test case is given and should exist somewhere in the git history
#CVE-2017-1000101
# info available at: https://curl.haxx.se/docs/CVE-2017-1000101.html
CURL_BUG_5 = 0966b324d911423c81351fb12e9219f71cd63be8  
CURL_PATCH_5 = 5ca96cb84410270e233c92bf1b2583cba40c3fad 

CURL_BUGGY_INPUT_5 = http://ur%20[0-60000000000000000000 

curl-buggy-5: clone-curl
	mv ./curl ./curl-old; \
		cd ./curl-old; \
		git checkout $(CURL_BUG_5); \
		./buildconf; \
		./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-5-obj; \
		make -j8; \
		make install;

curl-patched-5: clone-curl
	mv ./curl ./curl-new; \
		cd ./curl-new; \
		git checkout $(CURL_PATCH_5); \
		./buildconf; \
		./configure --enable-debug --prefix=$$(pwd)/../curl-patched-5-obj; \
		make -j8; \
		make install;

test-curl-buggy-5:
	./curl-buggy-5-obj/bin/curl $(CURL_BUGGY_INPUT_5) 

test-curl-patched-5:
	./curl-patched-5-obj/bin/curl $(CURL_BUGGY_INPUT_5) 

clean-curl-buggy-5:
	rm -rf ./curl-old; \
		rm -rf ./curl-buggy-5-obj;

clean-curl-patched-5:
	rm -rf ./curl-new; \
		rm -rf ./curl-patched-5-obj;

# Curl Bug #6 -- security vulnerability
# This hasn't been officially incorporated yet but seems like a good small fix
# https://github.com/curl/curl/pull/3433
# Related to CVE-2018-20483, when using --xattr flag, the file system could save 
# the information about user name and password
# Dependency: attr
CURL_BUG_6 = afeb8d99022255279ee63125f2fa0f69810ce9c3 
CURL_PATCH_6 = 98e6629154044e4ab1ee7cff8351c7ebcb131e88

CURL_BUGGY_INPUT_6 = http://testcurlbug:testcurl123@github.com -o file --xattr; \
		     getfattr file;\
		     getfattr -n user.xdg.origin.url file
#TODO
curl-buggy-6: clone-curl
	mv ./curl ./curl-old; \
		cd ./curl-old; \
		git checkout $(CURL_BUG_6); \
		./buildconf; \
		./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-6-obj; \
		make -j8; \
		make install;

curl-patched-6: clone-curl
	mv ./curl ./curl-new; \
		cd ./curl-new; \
		git checkout $(CURL_PATCH_6); \
		./buildconf; \
		./configure --enable-debug --prefix=$$(pwd)/../curl-patched-6-obj; \
		make -j8; \
		make install;

test-curl-buggy-6:
	./curl-buggy-6-obj/bin/curl $(CURL_BUGGY_INPUT_6)

test-curl-patched-6:
	rm file; \
	./curl-patched-6-obj/bin/curl $(CURL_BUGGY_INPUT_6) 

clean-curl-buggy-6:
	rm -rf ./curl-old; \
		rm -rf ./curl-buggy-6-obj;

clean-curl-patched-6:
	rm -rf ./curl-new; \
		rm -rf ./curl-patched-6-obj;


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


# Curl Bug #8
# https://github.com/curl/curl/commit/e50a2002bd450a4800a165d2874ed79c95b33a07
# FILE: fix CURLOPT_NOBODY and CURLOPT_HEADER output

CURL_BUG_8 = b55e85d 
CURL_PATCH_8 = e50a200

curl-buggy-8:
	git clone https://github.com/curl/curl.git curl-old; \
        cd ./curl-old; \
        git checkout $(CURL_BUG_8); \
        ./buildconf; \
	./configure; \
	make -j8; \

curl-patched-8:
	git clone https://github.com/curl/curl.git curl-new; \
        cd ./curl-new; \
        git checkout $(CURL_PATCH_8); \
        ./buildconf; \
	./configure; \
	make -j8; \

test-curl-buggy-8:
	mkdir test-result-curl; \
        cd ./curl-old; \
        ./src/curl --head file:///usr/share/dict/words > ../test-result-curl/buggy_result.txt; \
	vim ../test-result-curl/buggy_result.txt

test-curl-patched-8:
	cd ./curl-new; \
        ./src/curl --head file:///usr/share/dict/words > ../test-result-curl/fixed_version.txt; \
	vim ../test-result-curl/fixed_version.txt

clean-curl-8:
	rm -rf ./curl-old; \
        rm -rf ./curl-new; \
        rm -rf ./test-result-curl


# Curl Bug #9
# https://github.com/curl/curl/commit/2c5ec339ea67f43ac370ae77636a0f915cc5fbeb
# Curl_follow: accept non-supported schemes for "fake" redirects

CURL_BUG_9 = a4653a7
CURL_PATCH_9 = 2c5ec33

curl-buggy-9:
	git clone https://github.com/curl/curl.git curl-old; \
	cd ./curl-old; \
	git checkout $(CURL_BUG_9); \
	./buildconf; \
	./configure --without-ssl; \
	make -j8

curl-patched-9:
	git clone https://github.com/curl/curl.git curl-new; \
	cd ./curl-new; \
	git checkout $(CURL_PATCH_9); \
	./buildconf; \
	./configure --without-ssl; \
	make -j8

test-curl-buggy-9:
	mkdir test-result-curl; \
	cd ./curl-old; \
	./src/curl -v http://cmake.org > ../test-result-curl/buggy_result.txt 2>&1; \
	vim ../test-result-curl/buggy_result.txt

test-curl-patched-9:
	cd ./curl-new; \
	./src/curl -v http://cmake.org > ../test-result-curl/fixed_version.txt 2>&1; \
	vim ../test-result-curl/fixed_version.txt

clean-curl-9:
	rm -rf ./curl-old; \
	rm -rf ./curl-new; \
	rm -rf ./test-result-curl


# Curl Bug #10
# https://github.com/curl/curl/pull/3219
# URL: fix IPv6 numeral address parser

CURL_BUG_10 = 6987e37
CURL_PATCH_10 = b280948

curl-buggy-10:
	git clone https://github.com/curl/curl.git curl-old; \
        cd ./curl-old; \
        git checkout $(CURL_BUG_10); \
        ./buildconf; \
	./configure; \
	make -j8

curl-patched-10:
	git clone https://github.com/curl/curl.git curl-new; \
        cd ./curl-new; \
        git checkout $(CURL_PATCH_10); \
        ./buildconf; \
	./configure; \
	make -j8

test-curl-buggy-10:
	mkdir test-result-curl; \
        cd ./curl-old; \
        ./src/curl http://[2600::] > ../test-result-curl/buggy_result.txt 2>&1; \
        vim ../test-result-curl/buggy_result.txt

test-curl-patched-10:
	cd ./curl-new; \
        ./src/curl http://[2600::] > ../test-result-curl/fixed_version.txt 2>&1; \
        vim ../test-result-curl/fixed_version.txt

clean-curl-10:
	rm -rf ./curl-old; \
        rm -rf ./curl-new; \
        rm -rf ./test-result-curl


# Curl Bug #11
# https://github.com/curl/curl/issues/3251
# curl --local-port does not try last port in range

CURL_BUG_11 = 27cb384
CURL_PATCH_11 = fcf3f13

curl-buggy-11:
	git clone https://github.com/curl/curl.git curl-old; \
        cd ./curl-old; \
        git checkout $(CURL_BUG_11); \
        ./buildconf; \
	./configure; \
	make -j8

curl-patched-11:
	git clone https://github.com/curl/curl.git curl-new; \
        cd ./curl-new; \
        git checkout $(CURL_PATCH_11); \
        ./buildconf; \
	./configure; \
	make -j8

test-curl-buggy-11:
	mkdir test-result-curl; \
        cd ./curl-old; \
        ./src/curl --local-port 1023-1024 localhost > ../test-result-curl/buggy_version.txt 2>&1; \
        vim ../test-result-curl/buggy_result.txt

test-curl-patched-11:
	cd ./curl-new; \
        ./src/curl --local-port 1023-1024 localhost > ../test-result-curl/fixed_version.txt 2>&1; \
        vim ../test-result-curl/fixed_version.txt

clean-curl-11:
	rm -rf ./curl-old; \
        rm -rf ./curl-new; \
        rm -rf ./test-result-curl

# Curl Bug #12
# https://curl.haxx.se/docs/CVE-2016-8624.html
# curl doesn't parse the authority component of the URL correctly when the host name part ends 
# with a '#' character, and could instead be tricked into connecting to a different host. This may 
# have security implications if you for example use a URL parser that follows the RFC to check for 
# allowed domains before using curl to request them.
# Passing in http://example.com#@evil.com/x.txt would wrongly make curl send a request to evil.com
# while your browser would connect to example.com given the same URL.

CURL_BUG_12 = 164ee10b0
CURL_PATCH_12 = 3bb273db7

curl-buggy-12:
	git clone https://github.com/curl/curl.git curl-old; \
        cd ./curl-old; \
        git checkout $(CURL_BUG_12); \
        ./buildconf; \
	./configure; \
	make -j8

curl-patched-12:
	git clone https://github.com/curl/curl.git curl-new; \
        cd ./curl-new; \
        git checkout $(CURL_PATCH_12); \
        ./buildconf; \
	./configure; \
	make -j8

test-curl-buggy-12:
	cd ./curl-old; \
	./src/curl -v http://example.com#@127.0.0.1/x.txt

test-curl-patched-12:
	cd ./curl-new; \
        ./src/curl -v http://example.com#@127.0.0.1/x.txt

clean-curl-12:
	rm -rf ./curl-old; \
        rm -rf ./curl-new; \
        rm -rf ./test-result-curl

# libpng Bug #1
# https://bugzilla.redhat.com/show_bug.cgi?id=1599943
# Bug 1599943 (CVE-2018-13785) - CVE-2018-13785 libpng: 
# Integer overflow and resultant divide-by-zero in
# pngrutil.c:png_check_chunk_length() allows for denial
# of service

LIBPNG_BUG_1 = cde1e1fe79974a37d7ef255a44dae3bfd1b34a0f
LIBPNG_PATCH_1 = 8a05766cb74af05c04c53e6c9d60c13fc4d59bf2

libpng-buggy-1:
	git clone https://github.com/glennrp/libpng.git libpng-buggy; \
        cd ./libpng-buggy; \
        git checkout $(LIBPNG_BUG_1); \
        sed -i 's/return ((int)(crc != png_ptr->crc));/return (0);/g' pngrutil.c; \
	autoreconf -f -i; \
	./configure --disable-shared; \
	make clean all check

libpng-patched-1:
	git clone https://github.com/glennrp/libpng.git libpng-fixed; \
        cd ./libpng-fixed; \
        git checkout $(LIBPNG_PATCH_1); \
        sed -i 's/return ((int)(crc != png_ptr->crc));/return (0);/g' pngrutil.c; \
	autoreconf -f -i; \
	./configure --disable-shared; \
	make clean all check

test-libpng-buggy-1:
	wget https://sourceforge.net/p/libpng/bugs/278/attachment/crash1.png; \
	./libpng-buggy/pngimage crash1.png > result_buggy.txt 2>&1

test-libpng-patched-1:
	./libpng-fixed/pngimage crash1.png > result_fixed.txt 2>&1

clean-libpng-1:
	rm -rf ./libpng-buggy; \
        rm -rf ./libpng-fixed; \
        rm ./result_buggy.txt; \
	rm ./result_fixed.txt



# libpng Bug #2
# https://sourceforge.net/p/libpng/bugs/270/
# libpng-1.6.32 rejects valid PNG images with "IDAT: chunk data is too large"

LIBPNG_BUG_2 = 47aa798
LIBPNG_PATCH_2 = eb2f42a

libpng-buggy-2:
	git clone https://github.com/glennrp/libpng.git libpng-buggy; \
        cd ./libpng-buggy; \
        git checkout $(LIBPNG_BUG_2); \
	autoreconf -f -i; \
	./configure; \
	make

libpng-patched-2:
	git clone https://github.com/glennrp/libpng.git libpng-fixed; \
        cd ./libpng-fixed; \
        git checkout $(LIBPNG_PATCH_2); \
	autoreconf -f -i; \
	./configure; \
	make

test-libpng-buggy-2:
	wget https://raw.githubusercontent.com/Programming-Systems-Lab/bug-collection/reproduce-curl-bug-script/Bugs/C/MuplayBugs/idat_too_large.png?token=Aovwu1XD_3CUlb7duUiobzO-yo8btoRTks5cvlMHwA%3D%3D -O idat_too_large.png; \
	./libpng-buggy/pngimage idat_too_large.png > result_buggy.txt 2>&1;

test-libpng-patched-2:
	./libpng-fixed/pngimage idat_too_large.png > result_fixed.txt 2>&1;

clean-libpng-2:
	rm -rf ./libpng-buggy; \
        rm -rf ./libpng-fixed; \
        rm ./result_buggy.txt; \
	rm ./result_fixed.txt



#OpenSSL Bug #1 -- Potential Use after free vulnerability
# Pull request here: https://github.com/openssl/openssl/pull/7359
# NEEDS TEST CASE
OPENSSL_BUG_1 = 23d221b771348e3e3ee316cd1190a4a344d145fc
OPENSSL_PATCH_1 = da84249be6492ccfc5ecad32ac367fd06e9bdbef 

OPENSSL_BUGGY_INPUT_1 =
#TODO
openssl-buggy-1: clone-openssl
	cd ./openssl; \
        git checkout $(OPENSSL_BUG_1); \
        ./config --enable-debug --prefix=$$(pwd)/../openssl-buggy-1-obj; \
        make -j8; \
        make install;

openssl-patched-1: clone-openssl
	cd ./openssl; \
        git checkout $(OPENSSL_PATCH_1); \
        ./config --enable-debug --prefix=$$(pwd)/../openssl-patched-1-obj; \
        make -j8; \
        make install;

test-openssl-buggy-1:
	./openssl-buggy-1-obj/bin/openssl $(OPENSSL_BUGGY_INPUT_1)

test-openssl-patched-1:
	./openssl-patched-1-obj/bin/openssl $(OPENSSL_BUGGY_INPUT_1) 
clean-openssl-buggy-1:
	rm -r ./openssl-buggy-1-obj;
clean-openssl-patched-1:
	rm -r ./openssl-patched-1-obj;

#### Coreutils Bug collections
clone-coreutils:
	git clone git://git.sv.gnu.org/coreutils

# WC bugs
# WC bug1: the visible output of this printf is "how are you".  In either case, wc does 
# not recognize the second space as white space, resulting in an incorrect word 
# count
WC_BUG_1 = 2ab2f7a422652a9ec887e08ca8935b44e9629505
WC_PATCH_1 = a5202bd58531923ea9f93cc35ddeec5e3a8e0189

wc-buggy-1: clone-coreutils
	mv coreutils coreutils-wc-bug1; \
				cd ./coreutils-wc-bug1; \
				git checkout $(WC_BUG_1); \
				./bootstrap; \
				./configure --disable-gcc-warnings --quiet; \
				make -j8;

wc-patch-1: clone-coreutils
	mv coreutils coreutils-wc-patch1; \
				cd ./coreutils-wc-patch1; \
				git checkout $(WC_PATCH_1); \
				./bootstrap; \
				./configure --disable-gcc-warnings --quiet; \
				make -j8;

test-wc-buggy-1:
	printf 'how are\xC2\xA0you\n' | LC_ALL=en_US.utf8 coreutils-wc-bug1/src/wc -w

test-wc-patch-1:
	printf 'how are\xC2\xA0you\n' | LC_ALL=en_US.utf8 coreutils-wc-patch1/src/wc -w
	
clean-wc-buggy-1:
	rm -rf ./coreutils-wc-bug1

clean-wc-patch-1:
	rm -rf ./coreutils-wc-patch1

# WC bugs
# WC bug2: wc reports wrong byte counts when using '--from-files0=-'

WC_BUG_2 = f071b04afaeefbf6c37a00986fec02b8df5e9560 
WC_PATCH_2 = 9944e4763bb178852727812e8b188540772384e2

wc-buggy-2: clone-coreutils
	mv coreutils coreutils-wc-bug2; \
				cd ./coreutils-wc-bug2; \
				git checkout $(WC_BUG_2); \
				./bootstrap; \
				./configure --disable-gcc-warnings --quiet; \
				make -j8;

wc-patch-2: clone-coreutils
	mv coreutils coreutils-wc-patch2; \
				cd ./coreutils-wc-patch2; \
				git checkout $(WC_PATCH_2); \
				./bootstrap; \
				./configure --disable-gcc-warnings --quiet; \
				make -j8;

test-wc-buggy-2:
	cd coreutils-wc-bug2; \
		touch wc.small; \
		seq 10000 > wc.big; \
		printf '%s\0' wc.big wc.small | src/wc -c --files0-from=-
		
test-wc-patch-2:
	cd coreutils-wc-patch2; \
		touch wc.small; \
		seq 10000 > wc.big; \
		printf '%s\0' wc.big wc.small | src/wc -c --files0-from=-
	
clean-wc-buggy-2:
	rm -rf ./coreutils-wc-bug2

clean-wc-patch-2:
	rm -rf ./coreutils-wc-patch2

# YES bugs
# YES bug1: For select programs which accept only --help and --version options
# (in addition to non-option arguments), process these options before
# any other options.

# Before:

#  $ dd bs=1 --help
#  dd: unrecognized option '--help'
#  Try 'dd --help' for more information.

#  $ yes me --help
#  me --help
#  me --help
#  ...

# After:
# Any occurrence of '--help' in the arguments (prior to '--') will
# show the help screen.
YES_BUG_1 = 36b99b611309d8ef9634376d87149724850074a8
YES_PATCH_1 = 44af84263ed9398418f8366d08a1c20f3aed367e

yes-buggy-1: clone-coreutils
	mv coreutils coreutils-yes-bug1; \
		cd ./coreutils-yes-bug1; \
		git checkout $(YES_BUG_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

yes-patch-1: clone-coreutils
	mv coreutils coreutils-yes-patch1; \
		cd ./coreutils-yes-patch1; \
		git checkout $(YES_PATCH_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

test-yes-buggy-1:
	cd ./coreutils-yes-bug1; \
		./src/yes me --help

test-yes-patch-1:
	cd ./coreutils-yes-patch1; \
		./src/yes me --help

clean-yes-buggy-1:
	rm -rf ./coreutils-yes-bug1

clean-yes-patch-1:
	rm -rf ./coreutils-yes-patch1

# Shred Bugs
# Shred bug1: Fixed: shred --remove will again repeatedly rename files with shortening names
#  to attempt to hide the original length of the file name
SHRED_BUG_1 = 4cb3f4faa435820dc99c36b30ce93c7d01501f65
SHRED_PATCH_1 = c34f8d5c787e6f7f7a0fdcd5f8c8bcf845081584

shred-buggy-1: clone-coreutils
	mv coreutils coreutils-shred-bug1; \
		cd ./coreutils-shred-bug1; \
		git checkout $(SHRED_BUG_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8

shred-patch-1: clone-coreutils
	mv coreutils coreutils-shred-patch1; \
		cd ./coreutils-shred-patch1; \
		git checkout $(SHRED_PATCH_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8

test-shred-buggy-1:
	cd ./coreutils-shred-bug1; \
		touch test; \
		./src/shred -vu test

test-shred-patch-1:
	cd ./coreutils-shred-patch1; \
		touch test; \
		./src/shred -vu test

clean-shred-buggy-1:
	rm -rf ./coreutils-shred-bug1

clean-shred-patch-1:
	rm -rf ./coreutils-shred-patch1

# LS Bugs
# ls bug1: ls -aA shows . and .. in an empty directory; Fix: 'ls -aA' is now equivalent to 'ls -A', since -A now overrides -a
LS_BUG_1 = 49b126bfc5ae78c8fd913699aa645c10187af1c5
LS_PATCH_1 = 8d6acfd853fe78f9b47fe3a317b55d904278f89f

ls-buggy-1: clone-coreutils
	mv coreutils coreutils-ls-bug1; \
		cd coreutils-ls-bug1; \
		git checkout $(LS_BUG_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

ls-patch-1: clone-coreutils
	mv coreutils coreutils-ls-patch1; \
		cd coreutils-ls-patch1; \
		git checkout $(LS_PATCH_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

test-ls-buggy-1:
	cd coreutils-ls-bug1; \
		mkdir temp && cd temp; \
		\../src/ls -aA;

test-ls-patch-1:
	cd coreutils-ls-patch1; \
		mkdir temp && cd temp; \
		\../src/ls -aA;

clean-ls-buggy-1:
	rm -rf ./coreutils-ls-bug1

clean-ls-patch-1:
	rm -rf ./coreutils-ls-patch1

# CP Bugs
#
# Fix: Don't fail immediately upon
# getting ELOOP when running stat() on the destination,
# rather proceeding if -f specified, allowing the link
# to be removed.  If the loop is not in the final component
# of the destination path, we still fail but at the
# subsequent unlink() stage
#
# --force doesn't work with dangling links, rather than
# all links that can't be traversed
# 'cp --force file symlink' now removes the symlink even if
#  it is self referential
CP_BUG_1 = 694d10b71e418ef4ea68847185b73544fe03eae2
CP_PATCH_1 = a391007511cebe4a1731d85b4808499293c67173
CP_PATCH_2 = c732388fa1a47376c28bc4a55eadd73944ab711d

cp-buggy-1: clone-coreutils
	mv coreutils coreutils-cp-buggy1; \
		cd coreutils-cp-buggy1; \
		git checkout $(CP_BUG_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

cp-patched-1: clone-coreutils
	mv coreutils coreutils-cp-patched1; \
		cd coreutils-cp-patched1; \
		git checkout $(CP_PATCH_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

cp-patched-2: clone-coreutils
	mv coreutils coreutils-cp-patched2; \
		cd coreutils-cp-patched2; \
		git checkout $(CP_PATCH_2); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

test-cp-buggy-1: 
	cd coreutils-cp-buggy1; \
		ln -s self self; \
		cat self; \
		touch a; \
		./src/cp a self; \
		./src/cp -f a self;

test-cp-patched-1:
	cd coreutils-cp-patched1; \
		ln -s self self; \
		cat self; \
		touch a; \
		./src/cp a self; \
		./src/cp -f a self;

test-cp-patched-2:
	cd coreutils-cp-patched2; \
		ln -s self self; \
		cat self; \
		touch a; \
		./src/cp a self; \
		./src/cp -f a self;

clean-cp-buggy-1:
	rm -rf ./coreutils-cp-buggy1

clean-cp-patched-1:
	rm -rf ./coreutils-cp-patched1

clean-cp-patched-2:
	rm -rf ./coreutils-cp-patched2
# MV Bugs:
# mv bug1:
#
# Fix:
# 'cp -n -u' and 'mv -n -u' now consistently ignore the -u option.
# Previously, this option combination suffered from race conditions
# that caused -u to sometimes override -n
MV_BUG_1 = 3f9b1b86b18777b996c81d40c64e1e3ede8ecbef
MV_PATCH_1 = 7e244891b0c41bbf9f5b5917d1a71c183a8367ac

mv-buggy-1: clone-coreutils
	mv coreutils coreutils-mv-bug1; \
		cd coreutils-mv-bug1; \
		git checkout $(MV_BUG_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

mv-patch-1: clone-coreutils
	mv coreutils coreutils-mv-patch1; \
		cd coreutils-mv-patch1; \
		git checkout $(MV_PATCH_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

# mv -n -u should not overwrite b, but due to race condition sometimes it does since a is newer than b
test-mv-buggy-1: 
	cd coreutils-mv-bug1; \
		touch b && echo 'hello' >> b; \
		touch a && echo 'world' >> a; \
		./src/mv -n -u a b;

# now mv -n -u completely ignores -u and will not overwrite b
test-mv-patch-1:
	cd coreutils-mv-patch1; \
		touch b && echo 'hello' >> b; \
		touch a && echo 'world' >> a; \
		./src/mv -n -u a b;

clean-mv-buggy-1:
	rm -rf coreutils-mv-bug1

clean-mv-patch-1:
	rm -rf coreutils-mv-patch1

# DF Bugs:
# df bug1: 
# mkfifo p
# df p
# hangs, unless you make "p" non-readable or some other process has the fifo open in write mode

# Fix: df no longer hangs when given a fifo argument
DF_BUG_1 = f89c20bdf7ccc033cbc22662e932fae7761754fc
DF_PATCH_1 = b04ce61958c1f1fc264950f8d3b6058f640ee491

df-buggy-1: clone-coreutils
	mv coreutils coreutils-df-bug1; \
		cd coreutils-df-bug1; \
		git checkout $(DF_BUG_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

df-patch-1: clone-coreutils
	mv coreutils coreutils-df-patch1; \
		cd coreutils-df-patch1; \
		git checkout $(DF_PATCH_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

test-df-buggy-1:
	cd coreutils-df-bug1; \
		mkfifo p; \
		./src/df p

test-df-patch-1:
	cd coreutils-df-patch; \
		mkfifo p; \
		./src/df p

clean-df-buggy-1:
	rm -rf coreutils-df-bug1

clean-df-patch-1:
	rm -rf coreutils-df-patch1

# B2Sum bugs
# Running b2sum with --check option, and simply
# providing a string "BLAKE2" with no trailing character raises segFault
BS_BUG_1 = f926f7ce0e0a224ef3a37a82e60fd3d7aaca906e
BS_PATCH_1 = cc19f63be3ad0f27c9ea7f223883b75917fda7fb

bs-buggy-1: clone-coreutils
	mv coreutils coreutils-bs-bug1; \
		cd coreutils-bs-bug1; \
		git checkout $(BS_BUG_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

bs-patch-1: clone-coreutils
	mv coreutils coreutils-bs-patch1; \
		cd coreutils-bs-patch1; \
		git checkout $(BS_PATCH_1); \
		./bootstrap; \
		./configure --disable-gcc-warnings --quiet; \
		make -j8;

test-bs-buggy-1:
	cd coreutils-bs-bug1; \
		./src/b2sum --check <<< BLAKE2

test-bs-patch-1:
	cd coreutils-bs-patch1; \
		./src/b2sum --check <<< BLAKE2

clean-bs-buggy-1:
	rm -rf coreutils-bs-bug1

clean-bs-patch-1:
	rm -rf coreutils-bs-patch1

# Wget Bug #1 -- Simple fix stops creating the log when using -O and -q in the background
# https://github.com/mirror/wget/commit/7ddcebd61e170fb03d361f82bf8f5550ee62a1ae
# NEEDS TEST CASE but seems relatively easy to  reproduce
clone-wget:
	git clone https://github.com/mirror/wget.git

WGET_BUG_1 = 2f451dbf4e83c751f6bbba7ed26d90bf275fcbf7
WGET_PATCH_1 = 7ddcebd61e170fb03d361f82bf8f5550ee62a1ae
WGET_BUGGY_INPUT_1 = -bq -O - www.google.com 

wget-buggy-1: clone-wget
	mv ./wget ./wget-buggy-1; \
		cd ./wget-buggy-1; \
    git checkout $(WGET_BUG_1); \
		./bootstrap; \
    ./configure --enable-debug --prefix=$$(pwd)/../wget-buggy-1-obj; \
    make -j8; \
    make install;

wget-patched-1: clone-wget
	mv ./wget ./wget-patched-1; \
		cd ./wget-patched-1; \
    git checkout $(WGET_PATCH_1); \
		./bootstrap; \
    ./configure --enable-debug --prefix=$$(pwd)/../wget-patched-1-obj; \
    make -j8; \
    make install;

test-wget-buggy-1:
	./wget-buggy-1-obj/bin/wget $(WGET_BUGGY_INPUT_1)

test-wget-patched-1:
	./wget-patched-1-obj/bin/wget $(WGET_BUGGY_INPUT_1) 

clean-wget-buggy-1:
	rm -rf ./wget-buggy-1; \
		rm -rf ./wget-buggy-1-obj;

clean-wget-patched-1:
	rm -rf ./wget-patched-1; \
		rm -rf ./wget-patched-1-obj;

# Wget Bug #2 CVE-2017-6508
WGET_BUG_2 = 63c2aea2557b84640272629c7dc0caccab66ab6d
WGET_PATCH_2 = 4d729e322fae359a1aefaafec1144764a54e8ad4
WGET_BUGGY_INPUT_2 = 'http://127.0.0.1%0d%0aCookie%3a hi%0a/'

wget-buggy-2: clone-wget
	mv ./wget ./wget-buggy-2; \
		cd ./wget-buggy-2; \
    git checkout $(WGET_BUG_2); \
		./bootstrap; \
    ./configure --enable-debug --prefix=$$(pwd)/../wget-buggy-2-obj; \
    make -j8; \
    make install;

wget-patched-2: clone-wget
	mv ./wget ./wget-patched-2; \
		cd ./wget-patched-2; \
    git checkout $(WGET_PATCH_2); \
		./bootstrap; \
    ./configure --enable-debug --prefix=$$(pwd)/../wget-patched-2-obj; \
    make -j8; \
    make install;

test-wget-buggy-2:
	./wget-buggy-2-obj/bin/wget $(WGET_BUGGY_INPUT_2)

test-wget-patched-2:
	./wget-patched-2-obj/bin/wget $(WGET_BUGGY_INPUT_2) 

clean-wget-buggy-2:
	rm -rf ./wget-buggy-2; \
		rm -rf ./wget-buggy-2-obj;

clean-wget-patched-2:
	rm -rf ./wget-patched-2; \
		rm -rf ./wget-patched-2-obj;

# Wget Bug #3 -- Still awaiting analysis but seems like a good one
# https://nvd.nist.gov/vuln/detail/CVE-2018-20483
# this Wget bug seems has been covered in curl bug #6


# MBEDTLS Bug #1 -- Could be good but hasn't been officially patched yet
# https://github.com/ARMmbed/mbedtls/issues/2300

# Exim Bug -- Security Vulnerability
# Exim seems to be a good program with some bugs but need to sort through bugzilla
# Needs test case but contains relatively explicit directions on how to trigger the bug
# https://www.exim.org/static/doc/security/CVE-2016-9963.txt

# Exim Bug #2 With Bug POC Here.
# https://www.andreafortuna.org/cybersecurity/cve-2017-16943-exim-remote-code-execution-vulnerability/
# Patched at this commit
# https://git.exim.org/exim.git/commitdiff/4e6ae6235c68de243b1c2419027472d7659aa2b4


# Nginx Bug parsing config file, if nginx.conf contains more than 300 lines of 20 blanks, test conf will fail
# No test case included but seems reasonably easy to repoduce
# https://trac.nginx.org/nginx/ticket/1557
NGINX_BUG_1 = nginx-1.14.0
NGINX_PATCH_1 = nginx-1.15.6

current_dir = $(shell pwd)

NGINX_BUGGY_INPUT_1 = nginx -c $(current_dir)/$(NGINX_BUG_1)/conf/nginx.conf -t

NGINX_PATCH_INPUT_1 = nginx -c $(current_dir)/$(NGINX_PATCH_1)/conf/nginx.conf -t

nginx-buggy-1: 
	wget http://nginx.org/download/$(NGINX_BUG_1).tar.gz; \
        tar -zxvf $(NGINX_BUG_1).tar.gz; \
	cd $(NGINX_BUG_1); \
        ./configure; \
        make -j8;

nginx-patched-1:
	wget http://nginx.org/download/$(NGINX_PATCH_1).tar.gz; \
        tar -zxvf $(NGINX_PATCH_1).tar.gz; \
	cd $(NGINX_PATCH_1); \
        ./configure; \
        make -j8;

test-nginx-buggy-1:
	cp nginx1.conf $(NGINX_BUG_1)/conf/nginx.conf; \
	
	./$(NGINX_BUG_1)/objs/$(NGINX_BUGGY_INPUT_1)

test-nginx-patched-1:
	cp nginx1.conf $(NGINX_PATCH_1)/conf/nginx.conf; \
	./$(NGINX_PATCH_1)/objs/$(NGINX_PATCH_INPUT_1) 
clean-nginx-buggy-1:
	rm -r ./$(NGINX_BUG_1);
clean-nginx-patched-1:
	rm -r ./$(NGINX_PATCH_1);
# Nginx Bug #2 deals with logging files
# From an old version of Nginx and may not be easy to make test case
# https://trac.nginx.org/nginx/ticket/531

# Nginx Bug #3 deals with a crashing bug when a certain config file is used
# There is a test case included in the ticket
# https://trac.nginx.org/nginx/ticket/1464
NGINX_BUG_3 = nginx-1.13.0

# Move to a recent version to make sure bug is gone
NGINX_PATCH_3 = nginx-1.15.6

current_dir = $(shell pwd)

NGINX_BUGGY_INPUT_3 = nginx -c $(current_dir)/nginx3.conf

nginx-buggy-3: 
	wget http://nginx.org/download/$(NGINX_BUG_3).tar.gz; \
        tar -zxvf $(NGINX_BUG_3).tar.gz; \
	cd $(NGINX_BUG_3); \
        ./configure; \
        make -j8;

nginx-patched-3:
	wget http://nginx.org/download/$(NGINX_PATCH_3).tar.gz; \
        tar -zxvf $(NGINX_PATCH_3).tar.gz; \
	cd $(NGINX_PATCH_3); \
        ./configure; \
        make -j8;

test-nginx-buggy-3:
	./$(NGINX_BUG_3)/objs/$(NGINX_BUGGY_INPUT_3); \
	curl -k https://example.com;

test-nginx-patched-3:
	./$(NGINX_PATCH_3)/objs/$(NGINX_BUGGY_INPUT_3); \
	curl -k https://example.com
clean-nginx-buggy-3:
	rm -r ./$(NGINX_BUG_3);
clean-nginx-patched-3:
	rm -r ./$(NGINX_PATCH_3);


# Nginx Bug #4 simple change in logging code to remove a trailing null character in a string
# https://trac.nginx.org/nginx/ticket/1494

# Nginx Error Handling Bug Shows wrong page includes test case
# https://trac.nginx.org/nginx/ticket/1634


# Sqlite

# Sqlite Bug #1 INSERT INTO ... SELECT * FROM
# https://github.com/mackyle/sqlite/commit/59fa2969625bd593a601562e8416a6047f6f5142
SQLITE_URL = https://github.com/mackyle/sqlite.git

clone-sqlite:
	if [ ! -d "./sqlite" ]; \
		then git clone $(SQLITE_URL); \
	fi

clone-sqlite1:
	if [ ! -d "./sqlite1" ]; \
		then git clone $(SQLITE_URL) sqlite1; \
	fi



SQLITE_BUG_1 = 0ae3371797d89deb80f729e56c5af6851518e6bd
SQLITE_PATCH_1 = b9338e8475463b29b7f05fb28c78c3f35a7ce814

sqlite-buggy-1: clone-sqlite
	cd ./sqlite; \
	git checkout $(SQLITE_BUG_1); \
	../sqlscript.sh; \
	cd ../; \
	mkdir sqlite-buggy-1-obj && cd sqlite-buggy-1-obj; \
	../sqlite/configure --enable-debug; \
	make -j8;

sqlite-patched-1: clone-sqlite1
	cd ./sqlite1; \
	git checkout $(SQLITE_PATCH_1); \
	../sqlscript.sh; \
	cd ../; \
	mkdir sqlite-patched-1-obj && cd sqlite-patched-1-obj; \
	../sqlite1/configure --enable-debug; \
	make -j8;

test-sqlite-buggy-1:
	./sqlite_bug_reproduce_1.sh

test-sqlite-patched-1:
	./sqlite_bug_patch_1.sh

clean-sqlite-buggy-1:
	rm -r ./sqlite-buggy-1-obj;
clean-sqlite-patched-1:
	rm -r ./sqlite-patched-1-obj;


# Redis Server Bug
redis-buggy-1:
	git clone https://github.com/antirez/redis.git redis_bug_1; \
		cd redis_bug_1;\
		git checkout 46a51cdc; \
		make -j8;

redis-patched-1:
	git clone https://github.com/antirez/redis.git redis_fix_1; \
		cd redis_fix_1;\
		git checkout e2c1f80b;\
		make -j8;

test-redis-buggy-1:
	./redis_bug.sh

test-redis-patched-1:
	./redis_fix.sh

clean-redis-buggy-1:
	rm bug_pipe; \
		rm bug_server.sh; \
		rm -rf redis_bug_1; \
		rm result;

clean-redis-patched-1:
	rm fix_pipe;\
		rm fix_server.sh;\
		rm -rf redis_fix_1;\
		rm result;
	
