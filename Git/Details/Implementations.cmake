function(Core_Details_Git_Clone binary repo tag depth output update_submodule)
  set(command)
  if(${tag} STREQUAL " ")
    set(command ${binary} clone ${repo} ${output} --depth=${depth})
  else()
    set(command ${binary} clone ${repo} -b ${tag} ${output} --depth=${depth})
  endif()

  set(submodule_command)
  if(${update_submodule})
    set(submodule_command --recurse-submodules)
  endif()

  execute_process(
    COMMAND
      ${command} ${submodule_command}
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

function(Core_Details_Git_Update_Submodules binary output)
  execute_process(
    COMMAND
      ${binary} submodule update --init --recursive
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

function(Core_Details_Git_Apply binary output patch_file)
  execute_process(
    COMMAND
      ${binary} apply ${patch_file}
    WORKING_DIRECTORY
      ${output}
    COMMAND_ERROR_IS_FATAL
      ANY
  )
endfunction()
