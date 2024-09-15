function createTaskManagerGUI()
  -- Create the main form
  local form = createForm()
  form.Caption = "Task Manager"
  form.Width = 600
  form.Height = 400
  form.Position = 'poScreenCenter'
  form.BorderStyle = 'bsSizeable'  -- Make the form resizable

  -- Label for processes
  local label = createLabel(form)
  label.Caption = "Running Processes:"
  label.Top = 10
  label.Left = 10
  label.AutoSize = true

  -- Create the list box to display processes
  local processList = createListBox(form)
  processList.Top = label.Top + label.Height + 10
  processList.Left = 10
  processList.Width = form.ClientWidth - 20
  processList.Height = form.ClientHeight - 100

  -- Button to refresh the process list
  local refreshButton = createButton(form)
  refreshButton.Caption = "Refresh List"
  refreshButton.Top = form.ClientHeight - 60
  refreshButton.Left = 10
  refreshButton.Width = 100

  -- Button to terminate the selected process
  local terminateButton = createButton(form)
  terminateButton.Caption = "Terminate"
  terminateButton.Top = form.ClientHeight - 60
  terminateButton.Left = refreshButton.Left + refreshButton.Width + 10
  terminateButton.Width = 100
  terminateButton.Enabled = false

  -- Search box to search processes by name
  local searchBox = createEdit(form)
  searchBox.Top = form.ClientHeight - 60
  searchBox.Left = terminateButton.Left + terminateButton.Width + 10
  searchBox.Width = form.ClientWidth - searchBox.Left - 20
  searchBox.PlaceHolderText = "Search by name"

  -- Function to resize components
  local function resizeComponents()
    label.Width = form.ClientWidth - 20
    processList.Width = form.ClientWidth - 20
    processList.Height = form.ClientHeight - refreshButton.Height - 80
    refreshButton.Left = 10
    refreshButton.Top = form.ClientHeight - 60
    terminateButton.Left = refreshButton.Left + refreshButton.Width + 10
    terminateButton.Top = refreshButton.Top
    searchBox.Left = terminateButton.Left + terminateButton.Width + 10
    searchBox.Top = refreshButton.Top
    searchBox.Width = form.ClientWidth - searchBox.Left - 10
  end

  -- Resize event handler
  form.OnResize = resizeComponents

  -- Refresh the list of processes
  function refreshProcessList()
    processList.clear()

    -- Get the list of processes
    local processTable = getProcesslist()

    -- Populate the list with process names and IDs
    for pid, pname in pairs(processTable) do
      processList.Items.add(string.format("%s (PID: %d)", pname, pid))
    end

    -- Disable the terminate button until a process is selected
    terminateButton.Enabled = false
  end

  -- Function to terminate the selected process using taskkill command
  function terminateSelectedProcess()
    local selectedItem = processList.Items[processList.ItemIndex]
    if selectedItem then
      -- Extract PID from the selected item
      local pid = tonumber(selectedItem:match("%(PID: (%d+)%)"))

      if pid then
        -- Build the command
        local command = 'taskkill /F /PID ' .. pid

        -- Execute the command
        os.execute(command)

        -- Refresh the process list regardless of success/failure
        refreshProcessList()
      end
    end
  end

  -- Function to filter the process list based on search input
  function searchProcesses()
    local searchQuery = searchBox.Text:lower()
    processList.clear()

    -- Get the list of processes
    local processTable = getProcesslist()

    -- Filter processes based on the search query
    for pid, pname in pairs(processTable) do
      if pname:lower():find(searchQuery) then
        processList.Items.add(string.format("%s (PID: %d)", pname, pid))
      end
    end

    -- Disable the terminate button if nothing is selected
    terminateButton.Enabled = false
  end

  -- Event handler when a process is selected
  processList.OnClick = function()
    if processList.ItemIndex ~= -1 then
      terminateButton.Enabled = true
    else
      terminateButton.Enabled = false
    end
  end

  -- Set up button actions
  refreshButton.OnClick = refreshProcessList
  terminateButton.OnClick = terminateSelectedProcess
  searchBox.OnChange = searchProcesses

  -- Initially populate the process list
  refreshProcessList()
end

-- Create the task manager GUI
createTaskManagerGUI()
