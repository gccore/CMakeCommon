function(Core_Details_Git_Clone binary repo tag depth output)
  set(command)
  if(NOT ${tag} STREQUAL " ")
    set(command ${binary} clone ${repo} -b ${tag} ${output} --depth=${depth})
  else()
    set(command ${binary} clone ${repo} ${output} --depth=${depth})
  endif()

  execute_process(
    COMMAND
      ${command}
    COMMAND_ERROR_IS_FATAL
      ANY
  )
endfunction()

function(Core_Details_Git_Pull binary output)
  execute_process(
    COMMAND
      ${binary} pull
    WORKING_DIRECTORY
      ${output}
    COMMAND_ERROR_IS_FATAL
      ANY
  )
endfunction()

function(Core_Details_Git_Reset binary output reset_level)
  execute_process(
    COMMAND
      ${binary} reset --${reset_level}
    WORKING_DIRECTORY
      ${output}
    COMMAND_ERROR_IS_FATAL
      ANY
  )
endfunction()
