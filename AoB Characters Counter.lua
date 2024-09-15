-- Create the main form
local form = createForm()
form.Caption = 'Text Analyzer'
form.Width = 600
form.Height = 400
form.BorderStyle = bsSizeable
form.Position = poScreenCenter
form.Font.Size = 12
form.Font.Name = 'Ink Free'  -- Updated font
form.Color = clBlack  -- Set the entire form's background to black

-- Create a label for instructions
local instructionLabel = createLabel(form)
instructionLabel.Caption = 'Your AoB:'
instructionLabel.Left = 10
instructionLabel.Top = 10
instructionLabel.Width = form.Width - 20
instructionLabel.Font.Size = 14
instructionLabel.Font.Style = {fsBold}
instructionLabel.Font.Color = clWhite  -- Set text color to white
instructionLabel.AnchorSideLeft.Control = form
instructionLabel.AnchorSideLeft.Side = asrLeft
instructionLabel.AnchorSideRight.Control = form
instructionLabel.AnchorSideRight.Side = asrRight
instructionLabel.AnchorSideTop.Control = form
instructionLabel.AnchorSideTop.Side = asrTop

-- Create the input box
local inputBox = createEdit(form)
inputBox.Left = 10
inputBox.Top = 30
inputBox.Width = form.Width - 20
inputBox.Height = 100
inputBox.MultiLine = true
inputBox.ScrollBars = ssVertical
inputBox.Font.Size = 14
inputBox.Font.Name = 'Ink Free'
inputBox.Color = clAqua  -- Set background color to Aqua
inputBox.Font.Color = clBlack  -- Set text color to black for better contrast
inputBox.AnchorSideLeft.Control = form
inputBox.AnchorSideLeft.Side = asrLeft
inputBox.AnchorSideRight.Control = form
inputBox.AnchorSideRight.Side = asrRight
inputBox.AnchorSideTop.Control = instructionLabel
inputBox.AnchorSideTop.Side = asrBottom

-- Create a panel for the results to enhance visual grouping
local resultsPanel = createPanel(form)
resultsPanel.Left = 10
resultsPanel.Top = 140
resultsPanel.Width = form.Width - 20
resultsPanel.Height = 150
resultsPanel.AnchorSideLeft.Control = form
resultsPanel.AnchorSideLeft.Side = asrLeft
resultsPanel.AnchorSideRight.Control = form
resultsPanel.AnchorSideRight.Side = asrRight
resultsPanel.AnchorSideTop.Control = inputBox
resultsPanel.AnchorSideTop.Side = asrBottom
resultsPanel.BevelInner = bvNone
resultsPanel.BevelOuter = bvRaised
resultsPanel.Color = clBlack  -- Background color for the results panel

-- Create labels for displaying results with improved font and style
local charLabel = createLabel(resultsPanel)
charLabel.Caption = 'Number of characters: 0'
charLabel.Left = 10
charLabel.Top = 10
charLabel.Width = resultsPanel.Width - 20
charLabel.Font.Size = 12
charLabel.Font.Name = 'Ink Free'
charLabel.Font.Color = clWhite  -- Set text color to white

local letterLabel = createLabel(resultsPanel)
letterLabel.Caption = 'Number of letters: 0'
letterLabel.Left = 10
letterLabel.Top = 30
letterLabel.Width = resultsPanel.Width - 20
letterLabel.Font.Size = 12
letterLabel.Font.Name = 'Ink Free'
letterLabel.Font.Color = clWhite

local byteLabel = createLabel(resultsPanel)
byteLabel.Caption = 'Number of bytes: 0'
byteLabel.Left = 10
byteLabel.Top = 50
byteLabel.Width = resultsPanel.Width - 20
byteLabel.Font.Size = 12
byteLabel.Font.Name = 'Ink Free'
byteLabel.Font.Color = clWhite

local wordLabel = createLabel(resultsPanel)
wordLabel.Caption = 'Number of words: 0'
wordLabel.Left = 10
wordLabel.Top = 70
wordLabel.Width = resultsPanel.Width - 20
wordLabel.Font.Size = 12
wordLabel.Font.Name = 'Ink Free'
wordLabel.Font.Color = clWhite

-- Update results in real time
inputBox.OnChange = function()
  local text = inputBox.Text

  -- Function to count characters, letters, bytes, and words
  local function countText(text)
    local charCount = #text
    local letterCount = 0
    local byteCount = #text
    local wordCount = 0

    -- Count letters
    for i = 1, #text do
      local c = text:sub(i, i)
      if c:match("%a") then
        letterCount = letterCount + 1
      end
    end

    -- Count words
    for _ in text:gmatch("%S+") do
      wordCount = wordCount + 1
    end

    return charCount, letterCount, byteCount, wordCount
  end

  -- Get counts
  local charCount, letterCount, byteCount, wordCount = countText(text)

  -- Update labels with results
  charLabel.Caption = string.format('Number of characters: %d', charCount)
  letterLabel.Caption = string.format('Number of letters: %d', letterCount)
  byteLabel.Caption = string.format('Number of bytes: %d', byteCount)
  wordLabel.Caption = string.format('Number of words: %d', wordCount)
end
