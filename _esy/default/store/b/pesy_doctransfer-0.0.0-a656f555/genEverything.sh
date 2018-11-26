
#!/bin/bash

set -e
set -u

BOLD=`tput bold`  || BOLD=''   # Select bold mode
BLACK=`tput setaf 0` || BLACK=''
RED=`tput setaf 1` || RED=''
GREEN=`tput setaf 2` || GREEN=''
YELLOW=`tput setaf 3` || YELLOW=''
RESET=`tput sgr0` || RESET=''

MODE="update"
[[ $SHELL =~ "noprofile" ]] && MODE="build"


LAST_EXE_NAME=""
NOTIFIED_USER="false"
BUILD_STALE_PROBLEM="false"

DEFAULT_MAIN_MODULE_NAME="Index"

function notifyUser() {
  if [ "${NOTIFIED_USER}" == "false" ]; then
    echo ""
    if [ "${MODE}" == "build" ]; then
      printf "  %sAlmost there!%s %sWe just need to prepare a couple of files:%s\\n\\n" "${YELLOW}${BOLD}" "${RESET}" "${BOLD}" "${RESET}"
    else
      printf "  %sPreparing for build:%s\\n\\n" "${YELLOW}${BOLD}" "${RESET}"
    fi
    NOTIFIED_USER="true"
  else
    # do nothing
    true
  fi
}


function printDirectory() {
  DIR=$1
  NAME=$2
  NAMESPACE=$3
  REQUIRE=$4
  IS_LAST=$5
  printf "│\\n"
  PREFIX=""
  if [[ "$IS_LAST" == "last" ]]; then
    printf "└─%s/\\n" "$DIR"
    PREFIX="    "
  else
    printf "├─%s/\\n" "$DIR"
    PREFIX="│   "
  fi
  printf "%s%s\\n" "$PREFIX" "$NAME"
  printf "%s%s\\n" "$PREFIX" "$NAMESPACE"
  if [ -z "$REQUIRE" ]; then
    true
  else
    if [ "$REQUIRE" != " " ]; then
      printf   "%s%s\\n" "$PREFIX" "$REQUIRE"
    fi
  fi
}
PACKAGE_NAME="pesy-doctransfer"
PACKAGE_NAME_UPPER_CAMEL="PesyDoctransfer"
NAMESPACE="PesyDoctransfer"
PUBLIC_LIB_NAME="pesy-doctransfer.lib"
test_INCLUDESUBDIRS=""
#Default Requires
test_REQUIRE=""
#Default Flags
test_FLAGS=""
test_IGNOREDSUBDIRS=""
test_OCAMLC_FLAGS=""
test_OCAMLOPT_FLAGS=""
test_C_NAMES=""
test_JSOO_FLAGS=""
test_JSOO_FILES=""
#Default Namespace
library_NAMESPACE="PesyDoctransfer"
library_INCLUDESUBDIRS=""
#Default Requires
library_REQUIRE=""
#Default Flags
library_FLAGS=""
library_IGNOREDSUBDIRS=""
library_OCAMLC_FLAGS=""
library_OCAMLOPT_FLAGS=""
library_C_NAMES=""
library_JSOO_FLAGS=""
library_JSOO_FILES=""
executable_INCLUDESUBDIRS=""
#Default Requires
executable_REQUIRE=""
#Default Flags
executable_FLAGS=""
executable_IGNOREDSUBDIRS=""
executable_OCAMLC_FLAGS=""
executable_OCAMLOPT_FLAGS=""
executable_C_NAMES=""
executable_JSOO_FLAGS=""
executable_JSOO_FILES=""
library_NAMESPACE=""PesyDoctransfer""
test_MAIN_MODULE=""TestPesyDoctransfer""
executable_MAIN_MODULE=""Doctransfer""
test_REQUIRE=" pesy-doctransfer.lib "
executable_REQUIRE=" pesy-doctransfer.lib "
[ "${MODE}" != "build" ] && 
printDirectory "test" "name:    TestPesyDoctransfer.exe" "main:    ${test_MAIN_MODULE:-$DEFAULT_MAIN_MODULE_NAME}" "require:$test_REQUIRE" not-last
[ "${MODE}" != "build" ] && 
printDirectory "library" "library name: pesy-doctransfer.lib" "namespace:    $library_NAMESPACE" "require:     $library_REQUIRE" not-last
[ "${MODE}" != "build" ] && 
printDirectory "executable" "name:    Doctransfer.exe" "main:    ${executable_MAIN_MODULE:-$DEFAULT_MAIN_MODULE_NAME}" "require:$executable_REQUIRE" last
BIN_DIR="${cur__root}/test"
BIN_DUNE_FILE="${BIN_DIR}/dune"
# FOR BINARY IN DIRECTORY test
test_MAIN_MODULE="${test_MAIN_MODULE:-$DEFAULT_MAIN_MODULE_NAME}"

test_MAIN_MODULE_NAME="${test_MAIN_MODULE%%.*}"
# https://stackoverflow.com/a/965072
if [ "$test_MAIN_MODULE_NAME"=="$test_MAIN_MODULE" ]; then
  # If they did not specify an extension, we'll assume it is .re
  test_MAIN_MODULE_FILENAME="${test_MAIN_MODULE}.re"
else
  test_MAIN_MODULE_FILENAME="${test_MAIN_MODULE}"
fi

if [ -f  "${BIN_DIR}/${test_MAIN_MODULE_FILENAME}" ]; then
  true
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  echo ""
  if [ "${MODE}" == "build" ]; then
    printf "    □  Generate %s main module\\n" "${test_MAIN_MODULE_FILENAME}"
  else
    printf "    %s☒%s  Generate %s main module\\n" "${BOLD}${GREEN}" "${RESET}" "${test_MAIN_MODULE_FILENAME}"
    mkdir -p "${BIN_DIR}"
    printf "print_endline(\"Hello!\");" > "${BIN_DIR}/${test_MAIN_MODULE_FILENAME}"
  fi
fi

if [ -d "${BIN_DIR}" ]; then
  LAST_EXE_NAME="TestPesyDoctransfer.exe"
  BIN_DUNE_EXISTING_CONTENTS=""
  if [ -f "${BIN_DUNE_FILE}" ]; then
    BIN_DUNE_EXISTING_CONTENTS=$(<"${BIN_DUNE_FILE}")
  else
    BIN_DUNE_EXISTING_CONTENTS=""
  fi
  BIN_DUNE_CONTENTS=""
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "; !!!! This dune file is generated from the package.json file by pesy. If you modify it by hand")
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "; !!!! your changes will be undone! Instead, edit the package.json and then rerun 'esy pesy' at the project root.")
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s %s" "${BIN_DUNE_CONTENTS}" "; !!!! If you want to stop using pesy and manage this file by hand, change pacakge.json's 'esy.build' command to: refmterr dune build -p " "${cur__name}")
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "(executable")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  ; The entrypoint module")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (name ${test_MAIN_MODULE_NAME})  ;  From package.json main field")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  ; The name of the executable (runnable via esy x TestPesyDoctransfer.exe) ")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (public_name TestPesyDoctransfer.exe)  ;  From package.json name field")

  if [ -z "${test_JSOO_FLAGS}" ] && [ -z "${test_JSOO_FILES}" ]; then
    # No jsoo flags whatsoever
    true
  else
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (js_of_ocaml ")
    if [ ! -z "${test_JSOO_FLAGS}" ]; then
      BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "    (flags (${test_JSOO_FLAGS}))  ; From package.json jsooFlags field")
    fi
    if [ ! -z "${test_JSOO_FILES}" ]; then
      BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "    (javascript_files ${test_JSOO_FILES})  ; From package.json jsooFiles field")
    fi
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "   )")
  fi
  if [ ! -z "${test_REQUIRE}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (libraries ${test_REQUIRE}) ;  From package.json require field (array of strings)")
  fi
  if [ ! -z "${test_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (flags (${test_FLAGS})) ;  From package.json flags field")
  fi
  if [ ! -z "${test_OCAMLC_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (ocamlc_flags (${test_OCAMLC_FLAGS}))  ; From package.json ocamlcFlags field")
  fi
  if [ ! -z "${test_OCAMLOPT_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (ocamlopt_flags (${test_OCAMLOPT_FLAGS}))  ; From package.json ocamloptFlags field")
  fi
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" ")")
  if [ ! -z "${test_IGNOREDSUBDIRS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" "(ignored_subdirs (${test_IGNOREDSUBDIRS})) ;  From package.json ignoredSubdirs field")
  fi
  if [ ! -z "${test_INCLUDESUBDIRS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" "(include_subdirs ${test_INCLUDESUBDIRS}) ;  From package.json includeSubdirs field")
  fi

  if [ "${BIN_DUNE_EXISTING_CONTENTS}" == "${BIN_DUNE_CONTENTS}" ]; then
    true
  else
    notifyUser
    BUILD_STALE_PROBLEM="true"
    if [ "${MODE}" == "build" ]; then
      printf "    □  Update test/dune build config\\n"
    else
      printf "    %s☒%s  Update test/dune build config\\n" "${BOLD}${GREEN}" "${RESET}"
      printf "%s" "${BIN_DUNE_CONTENTS}" > "${BIN_DUNE_FILE}"
      mkdir -p "${BIN_DIR}"
    fi
  fi
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  if [ "${MODE}" == "build" ]; then
    printf "    □  Generate missing the test directory described in package.json buildDirs\\n"
  else
    printf "    %s☒%s  Generate missing the test directory described in package.json buildDirs\\n" "${BOLD}${GREEN}" "${RESET}"
    mkdir -p "${BIN_DIR}"
  fi
fi

# Perform validation:

LIB_DIR="${cur__root}/library"
LIB_DUNE_FILE="${LIB_DIR}/dune"

# TODO: Error if there are multiple libraries all using the default namespace.
if [ -d "${LIB_DIR}" ]; then
  true
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  if [ "${MODE}" == "build" ]; then
    printf "    □  Your project is missing the library directory described in package.json buildDirs\\n"
  else
    printf "    %s☒%s  Your project is missing the library directory described in package.json buildDirs\\n" "${BOLD}${GREEN}" "${RESET}"
    mkdir -p "${LIB_DIR}"
  fi
fi

LIB_DUNE_CONTENTS=""
LIB_DUNE_EXISTING_CONTENTS=""
if [ -f "${LIB_DUNE_FILE}" ]; then
  LIB_DUNE_EXISTING_CONTENTS=$(<"${LIB_DUNE_FILE}")
fi
LIB_DUNE_CONTENTS=$(printf "%s\\n%s" "${LIB_DUNE_CONTENTS}" "; !!!! This dune file is generated from the package.json file by pesy. If you modify it by hand")
LIB_DUNE_CONTENTS=$(printf "%s\\n%s" "${LIB_DUNE_CONTENTS}" "; !!!! your changes will be undone! Instead, edit the package.json and then rerun 'esy pesy' at the project root.")
LIB_DUNE_CONTENTS=$(printf "%s\\n%s %s" "${LIB_DUNE_CONTENTS}" "; !!!! If you want to stop using pesy and manage this file by hand, change pacakge.json's 'esy.build' command to: refmterr dune build -p " "${cur__name}")
LIB_DUNE_CONTENTS=$(printf "%s\\n%s" "${LIB_DUNE_CONTENTS}" "(library")
LIB_DUNE_CONTENTS=$(printf "%s\\n %s" "${LIB_DUNE_CONTENTS}" "  ; The namespace that other packages/libraries will access this library through")
LIB_DUNE_CONTENTS=$(printf "%s\\n %s" "${LIB_DUNE_CONTENTS}" "  (name ${library_NAMESPACE})")
LIB_DUNE_CONTENTS=$(printf "%s\\n %s" "${LIB_DUNE_CONTENTS}" "  ; Other libraries list this name in their package.json 'requires' field to use this library.")
LIB_DUNE_CONTENTS=$(printf "%s\\n %s" "${LIB_DUNE_CONTENTS}" "  (public_name pesy-doctransfer.lib)")
if [ ! -z "${library_REQUIRE}" ]; then
  LIB_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${LIB_DUNE_CONTENTS}" "  (libraries ${library_REQUIRE})")
fi
LIB_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${LIB_DUNE_CONTENTS}" "  (c_names ${library_C_NAMES})  ; From package.json cNames field")
if [ -z "${library_JSOO_FLAGS}" ] && [ -z "${library_JSOO_FILES}" ]; then
  # No jsoo flags whatsoever
  true
else
  LIB_DUNE_CONTENTS=$(printf "%s\\n %s" "${LIB_DUNE_CONTENTS}" "  (js_of_ocaml ")
  if [ ! -z "${library_JSOO_FLAGS}" ]; then
    LIB_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${LIB_DUNE_CONTENTS}" "    (flags (${library_JSOO_FLAGS}))  ; From package.json jsooFlags field")
  fi
  if [ ! -z "${library_JSOO_FILES}" ]; then
    LIB_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${LIB_DUNE_CONTENTS}" "    (javascript_files ${library_JSOO_FILES})  ; From package.json jsooFiles field")
  fi
  LIB_DUNE_CONTENTS=$(printf "%s\\n%s" "${LIB_DUNE_CONTENTS}" "   )")
fi
if [ ! -z "${library_FLAGS}" ]; then
  LIB_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${LIB_DUNE_CONTENTS}" "  (flags (${library_FLAGS}))  ; From package.json flags field")
fi
if [ ! -z "${library_OCAMLC_FLAGS}" ]; then
  LIB_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${LIB_DUNE_CONTENTS}" "  (ocamlc_flags (${library_OCAMLC_FLAGS}))  ; From package.json ocamlcFlags field")
fi
if [ ! -z "${library_OCAMLOPT_FLAGS}" ]; then
  LIB_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${LIB_DUNE_CONTENTS}" "  (ocamlopt_flags (${library_OCAMLOPT_FLAGS})) ; From package.json ocamloptFlags")
fi
LIB_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${LIB_DUNE_CONTENTS}" ")")

if [ ! -z "${library_IGNOREDSUBDIRS}" ]; then
  LIB_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${LIB_DUNE_CONTENTS}" "(ignored_subdirs (${library_IGNOREDSUBDIRS}))  ; From package.json ignoreSubdirs field")
fi
if [ ! -z "${library_INCLUDESUBDIRS}" ]; then
  LIB_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${LIB_DUNE_CONTENTS}" "(include_subdirs ${library_INCLUDESUBDIRS})  ; From package.json includeSubdirs field")
fi

if [ "${LIB_DUNE_EXISTING_CONTENTS}" == "${LIB_DUNE_CONTENTS}" ]; then
  true
else
  notifyUser
  BUILD_STALE_PROBLEM="true"
  if [ "${MODE}" == "build" ]; then
    printf "    □  Update library/dune build config\\n"
  else
    printf "    %s☒%s  Update library/dune build config\\n" "${BOLD}${GREEN}" "${RESET}"
    printf "%s" "$LIB_DUNE_CONTENTS" > "${LIB_DUNE_FILE}"
  fi
fi
BIN_DIR="${cur__root}/executable"
BIN_DUNE_FILE="${BIN_DIR}/dune"
# FOR BINARY IN DIRECTORY executable
executable_MAIN_MODULE="${executable_MAIN_MODULE:-$DEFAULT_MAIN_MODULE_NAME}"

executable_MAIN_MODULE_NAME="${executable_MAIN_MODULE%%.*}"
# https://stackoverflow.com/a/965072
if [ "$executable_MAIN_MODULE_NAME"=="$executable_MAIN_MODULE" ]; then
  # If they did not specify an extension, we'll assume it is .re
  executable_MAIN_MODULE_FILENAME="${executable_MAIN_MODULE}.re"
else
  executable_MAIN_MODULE_FILENAME="${executable_MAIN_MODULE}"
fi

if [ -f  "${BIN_DIR}/${executable_MAIN_MODULE_FILENAME}" ]; then
  true
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  echo ""
  if [ "${MODE}" == "build" ]; then
    printf "    □  Generate %s main module\\n" "${executable_MAIN_MODULE_FILENAME}"
  else
    printf "    %s☒%s  Generate %s main module\\n" "${BOLD}${GREEN}" "${RESET}" "${executable_MAIN_MODULE_FILENAME}"
    mkdir -p "${BIN_DIR}"
    printf "print_endline(\"Hello!\");" > "${BIN_DIR}/${executable_MAIN_MODULE_FILENAME}"
  fi
fi

if [ -d "${BIN_DIR}" ]; then
  LAST_EXE_NAME="Doctransfer.exe"
  BIN_DUNE_EXISTING_CONTENTS=""
  if [ -f "${BIN_DUNE_FILE}" ]; then
    BIN_DUNE_EXISTING_CONTENTS=$(<"${BIN_DUNE_FILE}")
  else
    BIN_DUNE_EXISTING_CONTENTS=""
  fi
  BIN_DUNE_CONTENTS=""
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "; !!!! This dune file is generated from the package.json file by pesy. If you modify it by hand")
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "; !!!! your changes will be undone! Instead, edit the package.json and then rerun 'esy pesy' at the project root.")
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s %s" "${BIN_DUNE_CONTENTS}" "; !!!! If you want to stop using pesy and manage this file by hand, change pacakge.json's 'esy.build' command to: refmterr dune build -p " "${cur__name}")
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "(executable")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  ; The entrypoint module")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (name ${executable_MAIN_MODULE_NAME})  ;  From package.json main field")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  ; The name of the executable (runnable via esy x Doctransfer.exe) ")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (public_name Doctransfer.exe)  ;  From package.json name field")

  if [ -z "${executable_JSOO_FLAGS}" ] && [ -z "${executable_JSOO_FILES}" ]; then
    # No jsoo flags whatsoever
    true
  else
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (js_of_ocaml ")
    if [ ! -z "${executable_JSOO_FLAGS}" ]; then
      BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "    (flags (${executable_JSOO_FLAGS}))  ; From package.json jsooFlags field")
    fi
    if [ ! -z "${executable_JSOO_FILES}" ]; then
      BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "    (javascript_files ${executable_JSOO_FILES})  ; From package.json jsooFiles field")
    fi
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "   )")
  fi
  if [ ! -z "${executable_REQUIRE}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (libraries ${executable_REQUIRE}) ;  From package.json require field (array of strings)")
  fi
  if [ ! -z "${executable_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (flags (${executable_FLAGS})) ;  From package.json flags field")
  fi
  if [ ! -z "${executable_OCAMLC_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (ocamlc_flags (${executable_OCAMLC_FLAGS}))  ; From package.json ocamlcFlags field")
  fi
  if [ ! -z "${executable_OCAMLOPT_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (ocamlopt_flags (${executable_OCAMLOPT_FLAGS}))  ; From package.json ocamloptFlags field")
  fi
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" ")")
  if [ ! -z "${executable_IGNOREDSUBDIRS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" "(ignored_subdirs (${executable_IGNOREDSUBDIRS})) ;  From package.json ignoredSubdirs field")
  fi
  if [ ! -z "${executable_INCLUDESUBDIRS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" "(include_subdirs ${executable_INCLUDESUBDIRS}) ;  From package.json includeSubdirs field")
  fi

  if [ "${BIN_DUNE_EXISTING_CONTENTS}" == "${BIN_DUNE_CONTENTS}" ]; then
    true
  else
    notifyUser
    BUILD_STALE_PROBLEM="true"
    if [ "${MODE}" == "build" ]; then
      printf "    □  Update executable/dune build config\\n"
    else
      printf "    %s☒%s  Update executable/dune build config\\n" "${BOLD}${GREEN}" "${RESET}"
      printf "%s" "${BIN_DUNE_CONTENTS}" > "${BIN_DUNE_FILE}"
      mkdir -p "${BIN_DIR}"
    fi
  fi
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  if [ "${MODE}" == "build" ]; then
    printf "    □  Generate missing the executable directory described in package.json buildDirs\\n"
  else
    printf "    %s☒%s  Generate missing the executable directory described in package.json buildDirs\\n" "${BOLD}${GREEN}" "${RESET}"
    mkdir -p "${BIN_DIR}"
  fi
fi
if [ -f  "${cur__root}/dune" ]; then
  true
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  if [ "${MODE}" == "build" ]; then
    printf "    □  Update ./dune to ignore node_modules\\n"
  else
    printf "    %s☒%s  Update ./dune to ignore node_modules\\n" "${BOLD}${GREEN}" "${RESET}"
    printf "(ignored_subdirs (node_modules _esy))" > "${cur__root}/dune"
  fi
fi

if [ -f  "${cur__root}/${PACKAGE_NAME}.opam" ]; then
  true
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  if [ "${MODE}" == "build" ]; then
    printf "    □  Add %s\\n" "${PACKAGE_NAME}.opam"
  else
    printf "    %s☒%s  Add %s\\n" "${BOLD}${GREEN}" "${RESET}" "${PACKAGE_NAME}.opam" 
    touch "${cur__root}/${PACKAGE_NAME}.opam"
  fi
fi

if [ -f  "${cur__root}/dune-project" ]; then
  true
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  if [ "${MODE}" == "build" ]; then
    printf "    □  Add a ./dune-project\\n"
  else
    printf "    %s☒%s  Add a ./dune-project\\n" "${BOLD}${GREEN}" "${RESET}"
    printf "(lang dune 1.2)\\n (name %s)" "${PACKAGE_NAME}" > "${cur__root}/dune-project"
  fi
fi


if [ "${MODE}" == "build" ]; then
  if [ "${BUILD_STALE_PROBLEM}" == "true" ]; then
    printf "\\n  %sTo perform those updates and build run:%s\n\n" "${BOLD}${YELLOW}" "${RESET}"
    printf "    esy pesy\\n\\n\\n\\n"
    exit 1
  else
    # If you list a refmterr as a dev dependency, we'll use it!
    BUILD_FAILED=""
    if hash refmterr 2>/dev/null; then
      refmterr dune build -p "${PACKAGE_NAME}" || BUILD_FAILED="true"
    else
      dune build -p "${PACKAGE_NAME}" || BUILD_FAILED="true"
    fi
    if [ -z "$BUILD_FAILED" ]; then
      printf "\\n%s  Build Succeeded!%s " "${BOLD}${GREEN}" "${RESET}"
      if [ -z "$LAST_EXE_NAME" ]; then
        printf "\\n\\n"
        true
      else
        # If we built an EXE
        printf "%sTo test a binary:%s\\n\\n" "${BOLD}" "${RESET}"
        printf "      esy x %s\\n\\n\\n" "${LAST_EXE_NAME}"
      fi
      true
    else
      exit 1
    fi
  fi
else
  # In update mode.
  if [ "${BUILD_STALE_PROBLEM}" == "true" ]; then
    printf "\\n  %sUpdated!%s %sNow run:%s\\n\\n" "${BOLD}${GREEN}" "${RESET}" "${BOLD}" "${RESET}"
    printf "    esy build\\n\\n\\n"
  else
    printf "\\n  %sAlready up to date!%s %sNow run:%s\\n\\n" "${BOLD}${GREEN}" "${RESET}" "${BOLD}" "${RESET}"
    printf "      esy build\\n\\n\\n"
  fi
fi

