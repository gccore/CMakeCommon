function(Core_Details_FetchQMakeContents_ConfigureQMake input args output)
  find_program(qmake_binary qmake REQUIRED)

  set(command1)
  if(args)
    set(command1 ${qmake_binary} -project ${args} ${input})
  else()
    set(command1 ${qmake_binary} -project ${input})
  endif()

  execute_process(
    COMMAND
      ${command1}
    WORKING_DIRECTORY
      ${output}
    COMMAND_ERROR_IS_FATAL
      ANY
  )

  set(command2)
  if(args)
    set(command2 ${qmake_binary} -makefile ${args} ${input})
  else()
    set(command2 ${qmake_binary} -makefile ${input})
  endif()

  execute_process(
    COMMAND
      ${command2}
    WORKING_DIRECTORY
      ${output}
    COMMAND_ERROR_IS_FATAL
      ANY
  )
endfunction()

function(Core_Details_FetchQMakeContents_BuildQMake build_dir)
  find_program(make_binary make REQUIRED)

  execute_process(
    COMMAND
      ${make_binary} -C ${build_dir}
    WORKING_DIRECTORY
      ${build_dir}
    COMMAND_ERROR_IS_FATAL
      ANY
  )
endfunction()

function(Core_Details_FetchQMakeContents_InstallQMake build_dir)
  find_program(make_binary make REQUIRED)

  execute_process(
    COMMAND
      ${make_binary} install -C ${build_dir}
    WORKING_DIRECTORY
      ${build_dir}
    COMMAND_ERROR_IS_FATAL
      ANY
  )
endfunction()
