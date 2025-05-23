local dap_go = require("dap-go")

dap_go.setup {
  -- Path to the delve command (default is "dlv")
  delve = {
    path = "dlv",
    initialize_timeout_sec = 20,
    port = "${port}",
  },
  -- Additional dap configurations
  dap_configurations = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug Package",
      request = "launch",
      program = "${fileDirname}"
    },
    {
      type = "go",
      name = "Debug Test",
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug Test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    },
  },
}
