# Find libicu's libraries

# For the given usage:
# find_package(ICU REQUIRED COMPONENTS uc i18n data)
#
# This will set the following variables:
# ICU_I18N_INCLUDE_DIR
# ICU_UC_INCLUDE_DIR
# ICU_DATA_INCLUDE_DIR
# ICU_I18N_LIBRARY
# ICU_UC_LIBRARY
# ICU_DATA_LIBRARY
#
# Additionally, this module supports specifying ICU_ROOT,
# following the convention laid out by a more popular and rigorous FindICU.cmake 
# Two different variations are supported:
# (1) Setting an explicit value in CMake, e.g. cmake -DICU_ROOT=/path/to/icu_root
# (2) Setting an environmental variable called ICU_ROOT.
# The explicit setting takes precedent over the environmental variable.
# Both take precedent over the standard system locations.
# This is useful when you need to replace your version of ICU (e.g. different version, supply a static library version)

include(FindPackageHandleStandardArgs)

find_package(PkgConfig)

set(ICU_REQUIRED)
foreach(MODULE ${ICU_FIND_COMPONENTS})
  string(TOUPPER "${MODULE}" MODULE)
  string(TOLOWER "${MODULE}" module)
  list(APPEND ICU_REQUIRED 
    ICU_${MODULE}_INCLUDE_DIR ICU_${MODULE}_LIBRARIES)

  # We are not using pkg-config because some systems do not ship with one for ICU (e.g. Ubuntu 12.04, Windows?)
  # and not all systems even provide libICU so there may not be a pkg-config that is availble depending how it was built/installed.
  # Cross-compiling is another potential pitfall.
  # CMake's built in find_ mechanisms are generally more than sufficient and tend to handle the above issues better.
  # Also the original pkg-config code could not handle the libicudata case.

  find_path(ICU_${MODULE}_INCLUDE_DIR unicode/utypes.h
    HINTS ${ICU_ROOT} $ENV{ICU_ROOT}
    PATH_SUFFIXES include)
  set(ICU_${MODULE}_INCLUDE_DIR ${ICU_${MODULE}_INCLUDE_DIR})

  find_library(ICU_${MODULE}_LIBRARY NAMES icu${module}
    HINTS ${ICU_ROOT} $ENV{ICU_ROOT}
    PATH_SUFFIXES lib)
  set(ICU_${MODULE}_LIBRARIES ${ICU_${MODULE}_LIBRARY})
endforeach()

if(NOT "${SWIFT_ANDROID_ICU_UC_INCLUDE}" STREQUAL "")
  set(ICU_UC_INCLUDE_DIR "${SWIFT_ANDROID_ICU_UC_INCLUDE}")
endif()
if(NOT "${SWIFT_ANDROID_ICU_I18N_INCLUDE}" STREQUAL "")
  set(ICU_I18N_INCLUDE_DIR "${SWIFT_ANDROID_ICU_I18N_INCLUDE}")
endif()
if(NOT "${SWIFT_ANDROID_ICU_DATA_INCLUDE}" STREQUAL "")
  set(ICU_DATA_INCLUDE_DIR "${SWIFT_ANDROID_ICU_DATA_INCLUDE}")
endif()

find_package_handle_standard_args(ICU DEFAULT_MSG ${ICU_REQUIRED})
mark_as_advanced(${ICU_REQUIRED})
