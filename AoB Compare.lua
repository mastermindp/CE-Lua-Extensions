-- Create the form
local form = createForm(true)
form.Caption = 'AoB Compare Tool'
form.Width = 700  -- Increased width
form.Height = 500
form.Position = 'poScreenCenter'  -- Center the form
form.BorderStyle = 'bsSizeable'  -- Allow resizing

-- Create a groupbox for the input section
local groupBoxInput = createGroupBox(form)
groupBoxInput.Caption = "AoB Patterns"
groupBoxInput.Left = 10
groupBoxInput.Top = 10
groupBoxInput.Width = 680  -- Adjusted width to fit the form
groupBoxInput.Height = 120

-- Create labels for AoB inputs
local labelAob1 = createLabel(groupBoxInput)
labelAob1.Caption = "AoB 1"
labelAob1.Left = 10
labelAob1.Top = 20

local labelAob2 = createLabel(groupBoxInput)
labelAob2.Caption = "AoB 2"
labelAob2.Left = 10
labelAob2.Top = 60

-- Create edit boxes for AoB inputs
local aobInput1 = createEdit(groupBoxInput)
aobInput1.Left = 120
aobInput1.Top = 20
aobInput1.Width = 540  -- Increased width for larger form
aobInput1.Text = 'Enter first AoB'

local aobInput2 = createEdit(groupBoxInput)
aobInput2.Left = 120
aobInput2.Top = 60
aobInput2.Width = 540  -- Increased width for larger form
aobInput2.Text = 'Enter second AoB'

-- Create a button to trigger the compare
local compareButton = createButton(form)
compareButton.Left = 10
compareButton.Top = 140
compareButton.Width = 330
compareButton.Height = 30
compareButton.Caption = 'Compare AoBs'
compareButton.OnClick = function()
    local aobPattern1 = aobInput1.Text
    local aobPattern2 = aobInput2.Text
    compareAoBs(aobPattern1, aobPattern2)
end

-- Create a button to clear the inputs and results
local clearButton = createButton(form)
clearButton.Left = 350
clearButton.Top = 140
clearButton.Width = 330
clearButton.Height = 30
clearButton.Caption = 'Clear'
clearButton.OnClick = function()
    aobInput1.Text = ''
    aobInput2.Text = ''
    resultMemo.Lines.Clear()
end

-- Create a memo to display results
local resultMemo = createMemo(form)
resultMemo.Left = 10
resultMemo.Top = 180
resultMemo.Width = 680  -- Adjusted width to fit larger form
resultMemo.Height = 250
resultMemo.ReadOnly = true

-- Create a GitHub button
local githubButton = createButton(form)
githubButton.Left = 250
githubButton.Top = 440
githubButton.Width = 200
githubButton.Height = 30
githubButton.Caption = 'Visit GitHub'

-- Open GitHub link when clicked
githubButton.OnClick = function()
    os.execute('start "" "https://github.com/mastermindp"')
end

-- Function to split AoB patterns into byte arrays
function splitAoBPattern(aobPattern)
    local bytes = {}
    for byte in aobPattern:gmatch('%S+') do
        table.insert(bytes, byte)
    end
    return bytes
end

-- Function to compare two AoB patterns
function compareAoBs(aobPattern1, aobPattern2)
    resultMemo.Lines.Clear()

    -- Split AoB patterns into byte arrays
    local bytes1 = splitAoBPattern(aobPattern1)
    local bytes2 = splitAoBPattern(aobPattern2)

    -- Find the length of the shorter pattern
    local minLength = math.min(#bytes1, #bytes2)

    -- Prepare result table
    local resultBytes = {}

    -- Compare each byte, replace mismatches with '??'
    for i = 1, minLength do
        if bytes1[i] == bytes2[i] then
            table.insert(resultBytes, bytes1[i])
        else
            table.insert(resultBytes, '??')
        end
    end

    -- If one AoB pattern is longer, fill the rest with '??'
    if #bytes1 > minLength then
        for i = minLength + 1, #bytes1 do
            table.insert(resultBytes, '??')
        end
    elseif #bytes2 > minLength then
        for i = minLength + 1, #bytes2 do
            table.insert(resultBytes, '??')
        end
    end

    -- Display the result
    resultMemo.Lines.Add('Comparison result:')
    resultMemo.Lines.Add(table.concat(resultBytes, ' '))
end
