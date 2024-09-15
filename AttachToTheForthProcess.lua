

-- here is an example when Your application have MultiProcess  so the example i used is Krunker game so From Top to Below The Forth Process Will be Attached


-- Target process partial name
local targetProcessPartialName = "Krunker"

-- Get the list of all processes
local processList = getProcesslist()

-- Table to store matching processes
local krunkerProcesses = {}

-- Filter processes with a partial name match
for pid, pname in pairs(processList) do
  if pname:lower():find(targetProcessPartialName:lower()) then
    table.insert(krunkerProcesses, {pid = pid, pname = pname})
  end
end

-- Reverse the order of the processes to count from bottom to top
for i = 1, math.floor(#krunkerProcesses / 2) do
  krunkerProcesses[i], krunkerProcesses[#krunkerProcesses - i + 1] = krunkerProcesses[#krunkerProcesses - i + 1], krunkerProcesses[i]
end

-- Display the filtered processes
print("Number of matching processes: " .. #krunkerProcesses)
for i, proc in ipairs(krunkerProcesses) do
  print(i .. ": " .. proc.pname .. " (PID: " .. proc.pid .. ")")
end

-- Ensure there are at least 4 processes
if #krunkerProcesses >= 4 then
  -- Select the 4th Krunker process from the bottom
  local targetProcess = krunkerProcesses[4]

  -- Attach to the 4th process
  openProcess(targetProcess.pid)
  print("Attached to process: " .. targetProcess.pname .. " (PID: " .. targetProcess.pid .. ")")
else
  print("Less than 4 'Krunker' processes found.")
end
