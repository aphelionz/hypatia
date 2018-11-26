
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
src_INCLUDESUBDIRS=""
#Default Requires
src_REQUIRE=""
#Default Flags
src_FLAGS=""
src_IGNOREDSUBDIRS=""
src_OCAMLC_FLAGS=""
src_OCAMLOPT_FLAGS=""
src_C_NAMES=""
src_JSOO_FLAGS=""
src_JSOO_FILES=""
src_MAIN_MODULE=""Main""
src_REQUIRE=" yojson core jsonm "
[ "${MODE}" != "build" ] && 
printDirectory "src" "name:    Doctransfer.exe" "main:    ${src_MAIN_MODULE:-$DEFAULT_MAIN_MODULE_NAME}" "require:$src_REQUIRE" last
BIN_DIR="${cur__root}/src"
BIN_DUNE_FILE="${BIN_DIR}/dune"
# FOR BINARY IN DIRECTORY src
src_MAIN_MODULE="${src_MAIN_MODULE:-$DEFAULT_MAIN_MODULE_NAME}"

src_MAIN_MODULE_NAME="${src_MAIN_MODULE%%.*}"
# https://stackoverflow.com/a/965072
if [ "$src_MAIN_MODULE_NAME"=="$src_MAIN_MODULE" ]; then
  # If they did not specify an extension, we'll assume it is .re
  src_MAIN_MODULE_FILENAME="${src_MAIN_MODULE}.re"
else
  src_MAIN_MODULE_FILENAME="${src_MAIN_MODULE}"
fi

if [ -f  "${BIN_DIR}/${src_MAIN_MODULE_FILENAME}" ]; then
  true
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  echo ""
  if [ "${MODE}" == "build" ]; then
    printf "    □  Generate %s main module\\n" "${src_MAIN_MODULE_FILENAME}"
  else
    printf "    %s☒%s  Generate %s main module\\n" "${BOLD}${GREEN}" "${RESET}" "${src_MAIN_MODULE_FILENAME}"
    mkdir -p "${BIN_DIR}"
    printf "print_endline(\"Hello!\");" > "${BIN_DIR}/${src_MAIN_MODULE_FILENAME}"
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
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (name ${src_MAIN_MODULE_NAME})  ;  From package.json main field")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  ; The name of the executable (runnable via esy x Doctransfer.exe) ")
  BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (public_name Doctransfer.exe)  ;  From package.json name field")

  if [ -z "${src_JSOO_FLAGS}" ] && [ -z "${src_JSOO_FILES}" ]; then
    # No jsoo flags whatsoever
    true
  else
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s" "${BIN_DUNE_CONTENTS}" "  (js_of_ocaml ")
    if [ ! -z "${src_JSOO_FLAGS}" ]; then
      BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "    (flags (${src_JSOO_FLAGS}))  ; From package.json jsooFlags field")
    fi
    if [ ! -z "${src_JSOO_FILES}" ]; then
      BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "    (javascript_files ${src_JSOO_FILES})  ; From package.json jsooFiles field")
    fi
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s" "${BIN_DUNE_CONTENTS}" "   )")
  fi
  if [ ! -z "${src_REQUIRE}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (libraries ${src_REQUIRE}) ;  From package.json require field (array of strings)")
  fi
  if [ ! -z "${src_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (flags (${src_FLAGS})) ;  From package.json flags field")
  fi
  if [ ! -z "${src_OCAMLC_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (ocamlc_flags (${src_OCAMLC_FLAGS}))  ; From package.json ocamlcFlags field")
  fi
  if [ ! -z "${src_OCAMLOPT_FLAGS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n %s\\n" "${BIN_DUNE_CONTENTS}" "  (ocamlopt_flags (${src_OCAMLOPT_FLAGS}))  ; From package.json ocamloptFlags field")
  fi
  BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" ")")
  if [ ! -z "${src_IGNOREDSUBDIRS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" "(ignored_subdirs (${src_IGNOREDSUBDIRS})) ;  From package.json ignoredSubdirs field")
  fi
  if [ ! -z "${src_INCLUDESUBDIRS}" ]; then
    BIN_DUNE_CONTENTS=$(printf "%s\\n%s\\n" "${BIN_DUNE_CONTENTS}" "(include_subdirs ${src_INCLUDESUBDIRS}) ;  From package.json includeSubdirs field")
  fi

  if [ "${BIN_DUNE_EXISTING_CONTENTS}" == "${BIN_DUNE_CONTENTS}" ]; then
    true
  else
    notifyUser
    BUILD_STALE_PROBLEM="true"
    if [ "${MODE}" == "build" ]; then
      printf "    □  Update src/dune build config\\n"
    else
      printf "    %s☒%s  Update src/dune build config\\n" "${BOLD}${GREEN}" "${RESET}"
      printf "%s" "${BIN_DUNE_CONTENTS}" > "${BIN_DUNE_FILE}"
      mkdir -p "${BIN_DIR}"
    fi
  fi
else
  BUILD_STALE_PROBLEM="true"
  notifyUser
  if [ "${MODE}" == "build" ]; then
    printf "    □  Generate missing the src directory described in package.json buildDirs\\n"
  else
    printf "    %s☒%s  Generate missing the src directory described in package.json buildDirs\\n" "${BOLD}${GREEN}" "${RESET}"
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

