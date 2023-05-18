param 
(
    [int]$iterCount = 1
)

function SetupFolders
{
        # Create logs folder if it doesn't exist
        if ((Test-Path -Path ".\Logs"))
        {
            # Delete all files in the logs folder
            Remove-Item -Path ".\Logs\" -Force -Recurse | Out-Null
        }
        New-Item -ItemType Directory -Path ".\Logs" | Out-Null
        New-Item -ItemType Directory -Path ".\Logs\etl" | Out-Null
        New-Item -ItemType Directory -Path ".\Logs\dump" | Out-Null
        New-Item -ItemType Directory -Path ".\Logs\summary" | Out-Null
}

# Define a function to run xperf and launch the app
function RunXperfAndApp($appId, $appName, $iterCount)
{
    for ($i = 1; $i -le $iterCount; $i++) 
    {
        # Start xperf with the given command and append the index to the testsession and testsession name
        xperf -start "testsession${i}" -f ".\Logs\etl\${appName}_testsession${i}.etl" -on 2e0582f3-d1b6-516a-9de3-9fd79ef952f8 | Out-Null
        # Launch the app with the given name
        Start-Process shell:AppsFolder\$appId!App | Out-Null
        # Wait for 1 seconds
        Start-Sleep -Seconds 1 | Out-Null
        # Kill process
        # UWP: AppCSharpUWP
        # WASDK: AppCSharpWASDK
        # C++ WASDK: AppCppWASDK
        $process = Get-Process $appName
        Stop-Process -Id $process.Id | Out-Null
        # Stop xperf with the given command and append the index to the testsession
        xperf -stop "testsession${i}" | Out-Null
        # Run tracerpt with the given command and append the index to the testsession name
        tracerpt ".\Logs\etl\${appName}_testsession${i}.etl" -o ".\Logs\dump\${appName}_testsessiondump${i}.xml" -summary ".\Logs\summary\${appName}_testsessionsummary${i}.txt" | Out-Null
    }

} 

function ParsePerfs ($appName, $iterCount)
{
    $perfs = [hashtable]::new()

    for ($i = 1; $i -le $iterCount; $i++) 
    {
        [xml]$xml = Get-Content ".\Logs\dump\${appName}_testsessiondump${i}.xml"
        
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

    $medians = [hashtable]::new()
    $averages = [hashtable]::new()
    
    # Iterate through the values of the dictionary
    foreach ($pair in $perfs.GetEnumerator()) {
        $median = Get-Median -InputArray $pair.Value
        $average = ($pair.Value | Measure-Object -Average).Average
        $medians[$pair.Key] = $median
        $averages[$pair.Key] = $average
    }

    $sortedMedians = $medians.GetEnumerator() | Sort-Object -Property Value
    $sortedAverages = $averages.GetEnumerator() | Sort-Object -Property Value

    Write-Host "~~~ ${appName} ~~~"
    Write-Host "~~~ Medians ~~~"
    Write-Host ($sortedMedians | Format-Table | Out-String)
    Write-Host "~~~ Averages ~~~"
    Write-Host ($sortedAverages | Format-Table | Out-String)
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

$AppName_UWP = "AppCSharpUWP"
$AppId_UWP = "66e9f9be-e9dd-4ddf-a3aa-40c2808eefcb_0dbdf1n3n58kt"
$AppName_CppUWP = "AppCppUWP"
$AppId_CppUWP = "1e47014e-e6f4-44cf-9be4-f77d5b4d886a_0dbdf1n3n58kt"
$AppName_WASDK = "AppCSharpWASDK"
$AppId_WASDK = "22a1fef7-227f-418a-a664-97b10161a21e_1b3t2bcbty5kr"
$AppName_CppWASDK = "AppCppWASDK"
$AppId_CppWASDK = "c32740de-9273-4b90-92a7-20cbf6415978_0dbdf1n3n58kt"

SetupFolders

RunXperfAndApp $AppId_UWP $AppName_UWP $iterCount
ParsePerfs $AppName_UWP $iterCount
RunXperfAndApp $AppId_CppUWP $AppName_CppUWP $iterCount
ParsePerfs $AppName_CppUWP $iterCount
RunXperfAndApp $AppId_WASDK $AppName_WASDK $iterCount
ParsePerfs $AppName_WASDK $iterCount
RunXperfAndApp $AppId_CppWASDK $AppName_CppWASDK $iterCount
ParsePerfs $AppName_CppWASDK $iterCount
