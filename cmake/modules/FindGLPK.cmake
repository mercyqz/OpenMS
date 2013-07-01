# Taken from lemon library  
# https://lemon.cs.elte.hu/trac/lemon
# License: Boost Software License, Version 1.0

SET(GLPK_ROOT_DIR "" CACHE PATH "GLPK root directory")

SET(GLPK_REGKEY "[HKEY_LOCAL_MACHINE\\SOFTWARE\\GnuWin32\\Glpk;InstallPath]")
GET_FILENAME_COMPONENT(GLPK_ROOT_PATH ${GLPK_REGKEY} ABSOLUTE)

FIND_PATH(GLPK_INCLUDE_DIR
  glpk.h
  PATHS ${GLPK_REGKEY}/include
  HINTS ${GLPK_ROOT_DIR}/include
)
FIND_LIBRARY(GLPK_LIBRARY
  glpk
  PATHS ${GLPK_REGKEY}/lib
  HINTS ${GLPK_ROOT_DIR}/lib
)

IF(GLPK_INCLUDE_DIR AND GLPK_LIBRARY)
  FILE(READ ${GLPK_INCLUDE_DIR}/glpk.h GLPK_GLPK_H)

  STRING(REGEX MATCH "define[ ]+GLP_MAJOR_VERSION[ ]+[0-9]+" GLPK_MAJOR_VERSION_LINE "${GLPK_GLPK_H}")
  STRING(REGEX REPLACE "define[ ]+GLP_MAJOR_VERSION[ ]+([0-9]+)" "\\1" GLPK_VERSION_MAJOR "${GLPK_MAJOR_VERSION_LINE}")

  STRING(REGEX MATCH "define[ ]+GLP_MINOR_VERSION[ ]+[0-9]+" GLPK_MINOR_VERSION_LINE "${GLPK_GLPK_H}")
  STRING(REGEX REPLACE "define[ ]+GLP_MINOR_VERSION[ ]+([0-9]+)" "\\1" GLPK_VERSION_MINOR "${GLPK_MINOR_VERSION_LINE}")

  SET(GLPK_VERSION_STRING "${GLPK_VERSION_MAJOR}.${GLPK_VERSION_MINOR}")

  IF(GLPK_FIND_VERSION)
    IF(GLPK_FIND_VERSION_COUNT GREATER 2)
      MESSAGE(SEND_ERROR "unexpected version string")
    ENDIF(GLPK_FIND_VERSION_COUNT GREATER 2)

    MATH(EXPR GLPK_REQUESTED_VERSION "${GLPK_FIND_VERSION_MAJOR}*100 + ${GLPK_FIND_VERSION_MINOR}")
    MATH(EXPR GLPK_FOUND_VERSION "${GLPK_VERSION_MAJOR}*100 + ${GLPK_VERSION_MINOR}")

    IF(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
      SET(GLPK_PROPER_VERSION_FOUND FALSE)
    ELSE(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
      SET(GLPK_PROPER_VERSION_FOUND TRUE)
    ENDIF(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
  ELSE(GLPK_FIND_VERSION)
    SET(GLPK_PROPER_VERSION_FOUND TRUE)
  ENDIF(GLPK_FIND_VERSION)
ENDIF(GLPK_INCLUDE_DIR AND GLPK_LIBRARY)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GLPK DEFAULT_MSG GLPK_LIBRARY GLPK_INCLUDE_DIR GLPK_PROPER_VERSION_FOUND)

IF(GLPK_FOUND)
  SET(GLPK_INCLUDE_DIRS ${GLPK_INCLUDE_DIR})
  SET(GLPK_LIBRARIES ${GLPK_LIBRARY})
  SET(GLPK_BIN_DIR ${GLPK_ROOT_PATH}/bin)
ENDIF(GLPK_FOUND)

MARK_AS_ADVANCED(GLPK_LIBRARY GLPK_INCLUDE_DIR GLPK_BIN_DIR)