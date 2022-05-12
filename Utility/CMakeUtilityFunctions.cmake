function(Core_Utility_GetRepoName url repo_name)
  string(REGEX MATCH "[^\/]+\.git$" repo_name_out ${url})
  set(${repo_name} ${repo_name_out} PARENT_SCOPE)
endfunction()
