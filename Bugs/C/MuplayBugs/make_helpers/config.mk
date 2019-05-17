# Sets up the variables that need to be used for downloading, building and installing to recreate the bugs

TMP_DIR ?= /tmp
BUGS_DIR ?= ${TMP_DIR}/bugs
CLONE_DIR ?= ${BUGS_DIR}/clone
INSTALL_DIR ?= ${BUGS_DIR}/obj
RR ?= /home/ant/rr_muplay/obj/bin/rr
_RR_TRACE_DIR ?= /home/ant/rr_muplay/traces
PATCH_FILE_DIR ?= ${BUGS_DIR}/patch_files

.PHONY = make-dirs
make-dirs:
	if [ ! -d "${BUGS_DIR}" ]; \
		then mkdir -p ${BUGS_DIR} ; \
	fi \
   
	if [ ! -d "${CLONE_DIR}" ]; \
        then mkdir -p ${CLONE_DIR} ; \
	fi \
    
	if [ ! -d "${INSTALL_DIR}" ]; \
        then mkdir -p ${INSTALL_DIR} ; \
	fi \
	
	if [ ! -d "${_RR_TRACE_DIR}" ]; \
        then mkdir -p ${_RR_TRACE_DIR} ; \
	fi \
	
	if [ ! -d "${PATCH_FILE_DIR}" ]; \
        then mkdir -p ${PATCH_FILE_DIR} ; \
	fi
