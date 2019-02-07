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
wget-debug:
		
      

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
	rm -r ./curl-buggy-1-obj
clean-curl-patched-1:
	rm -r ./curl-patched-1-obj


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
clearr:
	rm curl-7.63.0.tar.xz.asc

test-curl-patched-2-before:clearr
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
	rm -r ./curl-buggy-2-obj
clean-curl-patched-2:
	rm -r ./curl-patched-2-obj

# Curl Bug #3 from the following pull request
# PR & Patch https://github.com/curl/curl/pull/3219/commits
# This bug corrects behavior parsing ipv6 URL's
# Includes reference to a test case
# Type 1 bug but changes the functions return value going forward

# Curl would mistakely parse some url
# This bug appears to be hard to reproduce in real using because it is reproduced 
# under lib test. I could think of some ways to do that, such as modifying the buggy
# version's test case, which means add some new test cases, or finding a real url which
# could generate the bug
CURL_BUG_3 = 46e164069d1a5230e4e64cbd2ff46c46cce056bb 
CURL_PATCH_3 = 7ffef9d207d7b940f1752f29151fcf8bf1930c56
CURL_BUGGY_INPUT_3 = http://[fd00:a41::50]/
curl-buggy-3: clone-curl
	cd ./curl; \
	git  checkout $(CURL_BUG_3); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-3-obj; \
	make -j8; \
	make install;

curl-patched-3: clone-curl
	cd ./curl; \
	git checkout $(CURL_PATCH_3); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-patched-3-obj; \
	make -j8; \
	make install;
test-curl-buggy-3:
	./curl-buggy-3-obj/bin/curl $(CURL_BUGGY_INPUT_3)

test-curl-patched-3:
	./curl-patched-3-obj/bin/curl $(CURL_BUGGY_INPUT_3)

record-curl-buggy-3:
# TODO NEEDS TO BE IMPLEMENTED
muplay-curl-buggy-3:
# TODO NEEDS TO BE IMPLEMENTED

clean-curl-buggy-3:
	rm -r ./curl-buggy-3-obj
clean-curl-patched-3:
	rm -r ./curl-patched-3-obj


# Curl Bug #4 -- Security Vulnerability
# Patch applied here: https://github.com/curl/curl/commit/d530e92f59ae9bb2d47066c3c460b25d2ffeb211
# Needs a test case since one is not included -- another good example of type 1 in the design section

# leave this first.
CURL_BUG_4 = e97679a360dda4ea6188b09a145f73a2a84acedd
CURL_PATCH_4 = d530e92f59ae9bb2d47066c3c460b25d2ffeb211

CURL_BUGGY_INPUT_4 = www.gdsfjewnfpqnojodfsdfoggsgjoiaemfqoinfyibdsuabuicnsianuidfhihqowufhqownfqowufnqowfnqowfnqwoufnqouwnfoqwnfoqwnfqqnwfnqowfnqwuofnoqwnfoquwnfoqwnfqowfnfdsaclcdsadcasdfsadfegwwqweqwfqwsce.com 

curl-buggy-4: clone-curl
	cd ./curl; \
	git checkout $(CURL_BUG_4); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-4-obj; \
	make -j8; \
	make install;

curl-patched-4: clone-curl
	cd ./curl; \
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
	rm -r ./curl-buggy-4-obj;
clean-curl-patched-4:
	rm -r ./curl-patched-4-obj;
# Registered with CVE-2018-16842

# Curl Bug #5 -- Security Vulnerability
# Not noted where the patch is applied but test case is given and should exist somewhere in the git history
#CVE-2017-1000101
# info available at: https://curl.haxx.se/docs/CVE-2017-1000101.html
CURL_BUG_5 = 0966b324d911423c81351fb12e9219f71cd63be8  
CURL_PATCH_5 = 5ca96cb84410270e233c92bf1b2583cba40c3fad 

CURL_BUGGY_INPUT_5 = http://ur%20[0-60000000000000000000 

curl-buggy-5: clone-curl
	cd ./curl; \
	git checkout $(CURL_BUG_5); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-5-obj; \
	make -j8; \
	make install;

curl-patched-5: clone-curl
	cd ./curl; \
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
	rm -r ./curl-buggy-5-obj;
clean-curl-patched-5:
	rm -r ./curl-patched-5-obj;

# Curl Bug #6 -- security vulnerability
# This hasn't been officially incorporated yet but seems like a good small fix
# https://github.com/curl/curl/pull/3433
# Related to CVE-2018-20483, when using --xattr flag, the file system could save 
# the information about user name and password
CURL_BUG_6 = 251cabfb4a9968e92a488635a7ac5071b3f260bd 
CURL_PATCH_6 = 71886f5b4a4d2b90b55deab27e05733b7ba4fb87

CURL_BUGGY_INPUT_6 = http://testcurlbug:testcurl123@github.com -o file --xattr; \
		     getfattr file;\
		     getfattr -n user.xdg.origin.url file
#TODO
curl-buggy-6: clone-curl
	cd ./curl; \
	git checkout $(CURL_BUG_6); \
	./buildconf; \
	./configure --enable-debug --prefix=$$(pwd)/../curl-buggy-6-obj; \
	make -j8; \
	make install;

curl-patched-6: clone-curl
	cd ./curl; \
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
	rm -r ./curl-buggy-6-obj;
clean-curl-patched-6:
	rm -r ./curl-patched-6-obj;


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


# Wget Bug #1 -- Simple fix stops creating the log when using -O and -q in the background
# https://github.com/mirror/wget/commit/7ddcebd61e170fb03d361f82bf8f5550ee62a1ae
# NEEDS TEST CASE but seems relatively easy to  reproduce
WGET_BUG_1 = 2f451dbf4e83c751f6bbba7ed26d90bf275fcbf7
WGET_PATCH_1 = 7ddcebd61e170fb03d361f82bf8f5550ee62a1ae

WGET_BUGGY_INPUT_1 = -q -O - www.google.com 

wget-buggy-1: clone-wget
	cd ./wget; \
        git checkout $(WGET_BUG_1); \
        ./config --enable-debug --prefix=$$(pwd)/../wget-buggy-1-obj; \
        make -j8; \
        make install;

wget-patched-1: clone-wget
	cd ./wget; \
        git checkout $(WGET_PATCH_1); \
        ./config --enable-debug --prefix=$$(pwd)/../wget-patched-1-obj; \
        make -j8; \
        make install;

test-wget-buggy-1:
	./wget-buggy-1-obj/bin/wget $(WGET_BUGGY_INPUT_1)

test-wget-patched-1:
	./wget-patched-1-obj/bin/wget $(WGET_BUGGY_INPUT_1) 
clean-wget-buggy-1:
	rm -r ./wget-buggy-1-obj;
clean-wget-patched-1:
	rm -r ./wget-patched-1-obj;



# Wget Bug #2 -- Still awaiting analysis but seems like a good one
# https://nvd.nist.gov/vuln/detail/CVE-2018-20483
#this Wget bug seems has been covered in curl bug #6


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
SQLITE_BUG_1 = 64e780d3db07fb8c3e7861b086c34edba81ec89a 
SQLITE_PATCH_1 = 59fa2969625bd593a601562e8416a6047f6f5142

SQL_BUGGY_INPUT_1 = 

sqlite-buggy-1: clone-sqlite
	cd ./sqlite; \
	git checkout $(SQLITE_BUG_1); \
	../sqlscript.sh; \
	cd ../; \
	mkdir sqlite-buggy-1-obj && cd sqlite-buggy-1-obj; \
	../sqlite/configure --enable-debug; \
	make -j8;

sqlite-patched-1: clone-sqlite
	cd ./sqlite; \
	git checkout $(SQLITE_PATCH_1); \
	../sqlscript.sh; \
	cd ../; \
	mkdir sqlite-buggy-1-obj && cd sqlite-buggy-1-obj; \
	../sqlite/configure --enable-debug; \
	make -j8;

test-sqlite-buggy-1:
	./sqlite-buggy-1-obj/sqlite3 $(CURL_BUGGY_INPUT_6)

test-sqlite-patched-1:
	./sqlite-patched-1-obj/sqlite3 $(CURL_BUGGY_INPUT_6) 
clean-sqlite-buggy-1:
	rm -r ./sqlite-buggy-1-obj;
clean-sqlite-patched-1:
	rm -r ./sqlite-patched-1-obj;
