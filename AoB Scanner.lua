
function createGUI()
  -- Create a basic form
  local form = createForm()
  form.Caption = "AoB Scanner"
  form.Width = 450  -- Increased the form width
  form.Height = 350
  form.Position = 'poScreenCenter'

  -- Label for AoB input
  local label = createLabel(form)
  label.Caption = "Enter AoB Pattern:"
  label.Top = 10
  label.Left = 10

  -- Edit box for AoB input
  local editBox = createEdit(form)
  editBox.Top = 30
  editBox.Left = 10
  editBox.Width = 300

  -- Button to scan for AoB
  local scanButton = createButton(form)
  scanButton.Caption = "Scan AoB"
  scanButton.Top = 60
  scanButton.Left = 10

  -- Button to save results to a file
  local saveButton = createButton(form)
  saveButton.Caption = "Save Results"
  saveButton.Top = 60
  saveButton.Left = 120
  saveButton.Width = 100  -- Adjusted button width
  saveButton.Enabled = false

  -- Button to clear results
  local clearButton = createButton(form)
  clearButton.Caption = "Clear Results"
  clearButton.Top = 60
  clearButton.Left = 230
  clearButton.Width = 100  -- Adjusted button width
  clearButton.Enabled = false

  -- Create a list to display scan results
  local resultList = createListBox(form)
  resultList.Top = 100
  resultList.Left = 10
  resultList.Width = 410  -- Adjusted list width to match the form
  resultList.Height = 180

  -- Right-click menu for copying address
  local popupMenu = createPopupMenu(resultList)
  local copyItem = createMenuItem(popupMenu)
  copyItem.Caption = "Copy Address"
  popupMenu.Items.add(copyItem)
  resultList.PopupMenu = popupMenu

  -- Function to handle AoB scan
  scanButton.OnClick = function()
    local aobPattern = editBox.Text
    if aobPattern == "" then
      showMessage("Please enter a valid AoB pattern.")
      return
    end

    -- Clear previous results
    resultList.clear()

    -- Perform the AoB scan
    local scanResults = AOBScan(aobPattern)

    -- Handle scan results
    if scanResults == nil then
      showMessage("No results found.")
    else
      local resultCount = scanResults.Count
      showMessage("Found " .. resultCount .. " result(s).")

      -- Add results to the list
      for i = 0, resultCount - 1 do
        resultList.Items.add(scanResults[i])
      end

      -- Enable save and clear buttons
      saveButton.Enabled = true
      clearButton.Enabled = true

      scanResults.destroy()  -- Clean up!
    end
  end

  -- Function to open Memory Viewer on double-click
  resultList.OnDblClick = function()
    local selectedAddress = resultList.Items[resultList.ItemIndex]
    if selectedAddress ~= nil then
      getMemoryViewForm().DisassemblerView.SelectedAddress = tonumber(selectedAddress, 16)
      getMemoryViewForm().show()
    end
  end

  -- Function to copy the selected address to the clipboard
  copyItem.OnClick = function()
    local selectedAddress = resultList.Items[resultList.ItemIndex]
    if selectedAddress ~= nil then
      writeToClipboard(selectedAddress)
      showMessage("Address " .. selectedAddress .. " copied to clipboard.")
    else
      showMessage("No address selected.")
    end
  end

  -- Function to save results to a file
  saveButton.OnClick = function()
    if resultList.Items.Count == 0 then
      showMessage("No results to save.")
      return
    end

    -- Save results to a file
    local filename = "AoBScanResults.txt"
    local file = io.open(filename, "w")
    if file then
      for i = 0, resultList.Items.Count - 1 do
        file:write(resultList.Items[i] .. "\n")
      end
      file:close()
      showMessage("Results saved to " .. filename)
    else
      showMessage("Failed to save results.")
    end
  end

  -- Function to clear the results
  clearButton.OnClick = function()
    resultList.clear()
    saveButton.Enabled = false
    clearButton.Enabled = false
  end
end

-- Call the GUI creation function
createGUI()
