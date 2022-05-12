function(Core_Utility_CloneRepository)
  include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/Details/Implementations.cmake)

  set(options
    RESET_ON_DIRTY_REPO
    UPDATE_SUBMODULES
  )
  set(one_value_arguments
    GIT_REPOSITORY
    GIT_TAG
    OUTPUT_DIRECTORY
    GIT_CLONE_DEPTH
    APPLY_PATCH
  )
  set(multi_value_arguments)
  cmake_parse_arguments(CP
    "${options}"
    "${one_value_arguments}"
    "${multi_value_arguments}"
    ${ARGN}
  )

  if(NOT CP_GIT_REPOSITORY)
    message(FATAL_ERROR "Please specify a git repository with: GIT_REPOSITORY")
  endif()

  if(NOT CP_OUTPUT_DIRECTORY)
    message(WARNING
      "The default path(${CMAKE_BINARY_DIR}/<YOUR_REPO_NAME>) "
      "will be used since no path was specified with: OUTPUT_DIRECTORY"
    )
    Core_Utility_GetRepoName(${CP_GIT_REPOSITORY} repository_name)
    set(CP_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${repository_name})
  endif()

  if(NOT CP_GIT_CLONE_DEPTH)
    set(CP_GIT_CLONE_DEPTH 1)
  endif()

  if(NOT CP_GIT_TAG)
    set(CP_GIT_TAG " ")
  endif()

  find_package(Git REQUIRED)
  if(NOT GIT_FOUND)
    message(FATAL_ERROR "Couldn't Find Git CLI")
  endif()

  if(NOT EXISTS ${CP_OUTPUT_DIRECTORY})
    Core_Details_Git_Clone(
      ${GIT_EXECUTABLE}
      ${CP_GIT_REPOSITORY}
      ${CP_GIT_TAG}
      ${CP_GIT_CLONE_DEPTH}
      ${CP_OUTPUT_DIRECTORY}
      ${CP_UPDATE_SUBMODULES}
    )
  else()
    if(${CP_RESET_ON_DIRTY_REPO})
      Core_Details_Git_Reset(
        ${GIT_EXECUTABLE}
        ${CP_OUTPUT_DIRECTORY}
        hard
      )
    endif()
    Core_Details_Git_Pull(
      ${GIT_EXECUTABLE}
      ${CP_OUTPUT_DIRECTORY}
    )
    if(${CP_UPDATE_SUBMODULES})
      Core_Details_Git_Update_Submodules(
        ${GIT_EXECUTABLE}
        ${CP_OUTPUT_DIRECTORY}
      )
    endif()
  endif()

  if(CP_APPLY_PATCH)
    Core_Details_Git_Apply(
      ${GIT_EXECUTABLE}
      ${CP_OUTPUT_DIRECTORY}
      ${CP_APPLY_PATCH}
    )
  endif()
endfunction()
