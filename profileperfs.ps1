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
            Write-Host $isGood
            return $isGood
        }

        Write-Host $eventData
    }
    
} 

SetupFolders

# Loop 20 times and call the function
for ($i = 1; $i -le $c; $i++) 
{
    RunXperfAndApp
}

ParsePerfs

