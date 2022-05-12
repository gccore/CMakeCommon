function(Core_Utility_FetchQMakeContents)
  include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/Details/Implementations.cmake)

  set(options)
  set(one_value_arguments
    GIT_REPOSITORY
    GIT_TAG

    QMAKE_ARGUMENTS

    OUTPUT_PREFIX
    OUTPUT_BUILD_DIRECTORY
    OUTPUT_SOURCE_DIRECTORY
    OUTPUT_INSTALL_DIRECTORY

    QMAKE_CONFIG_DIRECTORY

    RUN_INSTALL_RULE
    RUN_BUILD_RULE

    APPLY_PATCH
  )
  set(multi_value_arguments)
  cmake_parse_arguments(FQC
    "${options}"
    "${one_value_arguments}"
    "${multi_value_arguments}"
    ${ARGN}
  )

  if(NOT FQC_GIT_REPOSITORY)
    message(FATAL_ERROR "Please specify a git repository usnig: GIT_REPOSITORY")
  endif()

  if(NOT FQC_OUTPUT_PREFIX)
    Core_Utility_GetRepoName(${FQC_GIT_REPOSITORY} FQC_OUTPUT_PREFIX)
  endif()

  if(NOT FQC_GIT_TAG)
    set(FQC_GIT_TAG " ")
  endif()

  set(default_prefix_path ${CMAKE_BINARY_DIR}/dependencies/${FQC_OUTPUT_PREFIX})

  if(NOT FQC_SOURCE_DIRECTORY)
    set(FQC_SOURCE_DIRECTORY ${default_prefix_path}/source)
  endif()

  if(NOT FQC_BUILD_DIRECTORY)
    set(FQC_BUILD_DIRECTORY ${default_prefix_path}/build)
  endif()

  if(NOT FQC_INSTALL_DIRECTORY)
    set(FQC_INSTALL_DIRECTORY ${default_prefix_path}/install)
  endif()

  if(NOT FQC_RUN_BUILD_RULE)
    set(FQC_RUN_BUILD_RULE true)
  endif()

  file(MAKE_DIRECTORY ${FQC_BUILD_DIRECTORY})
  file(MAKE_DIRECTORY ${FQC_INSTALL_DIRECTORY})

  Core_Utility_CloneRepository(
    GIT_REPOSITORY ${FQC_GIT_REPOSITORY}
    GIT_TAG ${FQC_GIT_TAG}
    OUTPUT_DIRECTORY ${FQC_SOURCE_DIRECTORY}
    RESET_ON_DIRTY_REPO on
    UPDATE_SUBMODULES on
    APPLY_PATCH ${FQC_APPLY_PATCH}
  )

  if(FQC_QMAKE_CONFIG_DIRECTORY)
    set(FQC_SOURCE_DIRECTORY ${FQC_SOURCE_DIRECTORY}/${FQC_QMAKE_CONFIG_DIRECTORY})
  endif()

  if(${FQC_RUN_BUILD_RULE})
    Core_Details_FetchQMakeContents_ConfigureQMake(
      ${FQC_SOURCE_DIRECTORY} "${FQC_QMAKE_ARGUMENTS}" ${FQC_BUILD_DIRECTORY})
    Core_Details_FetchQMakeContents_BuildQMake(${FQC_BUILD_DIRECTORY})
  endif()

  if(FQC_RUN_INSTALL_RULE)
    if(${FQC_RUN_INSTALL_RULE})
      Core_Details_FetchQMakeContents_InstallQMake(${FQC_BUILD_DIRECTORY})
    endif()
  endif()

endfunction()
