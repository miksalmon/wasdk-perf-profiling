param 
(
    [int]$c = 20
)

function SetupFolders
{
        # Create logs folder if it doesn't exist
        if ((Test-Path -Path ".\Logs"))
        {
            # Delete all files in the logs folder
            Remove-Item -Path ".\Logs\" -Force -Recurse
        }
        New-Item -ItemType Directory -Path ".\Logs"
        New-Item -ItemType Directory -Path ".\Logs\etl"
        New-Item -ItemType Directory -Path ".\Logs\dump"
        New-Item -ItemType Directory -Path ".\Logs\summary"
}

# Define a function to run xperf and launch the app
function RunXperfAndApp 
{
    # Get the current loop index as a string
    $index = $i.ToString()
    # Start xperf with the given command and append the index to the testsession and testsession name
    xperf -start "testsession$index" -f ".\Logs\etl\testsession$index.etl" -on 2e0582f3-d1b6-516a-9de3-9fd79ef952f8
    # Launch the app with the given name
    Start-Process shell:AppsFolder\22a1fef7-227f-418a-a664-97b10161a21e_1b3t2bcbty5kr!App
    # Wait for 1 seconds
    Start-Sleep -Seconds 1
    # Kill process
    $process = Get-Process WinAppSdkActivationSampleApp
    Stop-Process -Id $process.Id
    # Stop xperf with the given command and append the index to the testsession
    xperf -stop "testsession$index"
    # Run tracerpt with the given command and append the index to the testsession name
    tracerpt ".\Logs\etl\testsession$index.etl" -o ".\Logs\dump\testsessiondump$index.xml" -summary ".\Logs\summary\testsessionsummary$index.txt"
} 

function ParsePerfs 
{
    $perfs = [hashtable]::new()

    for ($i = 1; $i -le $c; $i++) 
    {
        $index = $i.ToString()
        [xml]$xml = Get-Content ".\Logs\dump\testsessiondump$index.xml"
        
        $eventData = $xml.Events.Event.EventData | Where-Object {
            $isGood = $false
            $_.Data | ForEach-Object {
                $isGood = $isGood -or $_.Name -eq "timeElapsed"
            }
            return $isGood
        }

        $eventData | ForEach-Object {
            $timeElapsedData = $_.Data | Where-Object { $_.Name -eq "timeElapsed" }
            $eventNameData = $_.Data | Where-Object { $_.Name -eq "eventName" }

            if ($perfs.ContainsKey($eventNameData.InnerText))
            {
                $perfs[$eventNameData.InnerText] += [double]$timeElapsedData.InnerText
            }
            else
            {
                $perfs[$eventNameData.InnerText] = [System.Collections.ArrayList]::new()
                $perfs[$eventNameData.InnerText] += [double]$timeElapsedData.InnerText
            }
        }
    }

    Write-Host ($perfs | Format-Table | Out-String)

    # Iterate through the values of the dictionary
    foreach ($pair in $perfs.GetEnumerator()) {
        $median = Get-Median -InputArray $pair.Value
        $average = ($pair.Value | Measure-Object -Average).Average
        Write-Host ("{0} Median = {1}ms" -f $pair.Key, $median)
        Write-Host ("{0} Average = {1}ms" -f $pair.Key, $average)
    }
} 

# Define a function named Get-Median
function Get-Median {
    # Define a parameter for the input array
    param (
        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$InputArray
    )

    # Sort the array in ascending order
    $sorted = $InputArray | Sort-Object

    # Get the length of the array
    $length = $sorted.Length

    # Check if the length is odd or even
    if ($length % 2 -eq 0) {
        # Get the average of the two middle elements
        $index1 = $length / 2 - 1
        $index2 = $index1 + 1
        $median = ($sorted[$index1] + $sorted[$index2]) / 2
    }
    else {
        # Get the middle element
        $index = ($length - 1) / 2
        $median = $sorted[$index]
    }

    # Return the median value
    return $median
}

SetupFolders

# Loop 20 times and call the function
for ($i = 1; $i -le $c; $i++) 
{
    RunXperfAndApp
}

ParsePerfs

