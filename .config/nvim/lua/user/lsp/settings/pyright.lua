return {
  cmd = { "pyright-langserver", "--stdio" },
    filetype = { "python" },
    single_file_support = true,
    settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            typeCheckingMode = "basic",
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            inlayHints = {
              variableTypes = true,
              functionReturnTypes = true,
            },
          },
        },
    },
}
