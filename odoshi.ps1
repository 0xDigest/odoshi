$fakeprocesses = @()
$fake_binary_source = "./fake_binary.cs"
$fake_binary_location = "c:\temp\fake_binary.exe"

# if fake binary doesn't exist, create it by running csc.exe on fake_binary.cs
if (-not (Test-Path $fake_binary_location)) {
    write-host "[!] Fake binary not found, creating it"
    $csc = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
    & $csc /out:$fake_binary_location $fake_binary_source
}


# load the list of fake processes from process_list.txt and add them to the list
$processes = Get-Content -Path "process_list.txt"
foreach ($process in $processes) {
    $procExists = Get-Process -Name $process.split(".")[0] -ErrorAction SilentlyContinue
    if ($procExists -eq $null) {
        # process is already running
        write-host "[!] $process is already running"
        $fakeprocesses += $process
    }
    else {
        # if process doesn't end in exe, add it
        $new_process_name = $processes
        if ($process -notlike "*.exe") {
            $new_process_name = "$process.exe"
        }
        Copy-Item -Path $fake_binary_location -Destination "C:\Temp\$new_process_name" -Force
        Start-Process -FilePath "C:\Temp\$new_process_name" 
        write-host "[+] $process started"
    }
}
