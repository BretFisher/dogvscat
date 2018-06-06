# Based on https://stackoverflow.com/questions/41383840/attach-ebs-volume-to-windows-ec2-with-powershell#41384463
$diskNumber = (Get-Disk | Where-Object { ($_.OperationalStatus -eq "Offline") -and ($_."PartitionStyle" -eq "RAW") }).Number
Initialize-Disk -Number $diskNumber -PartitionStyle "MBR"
$part = New-Partition -DiskNumber $diskNumber -UseMaximumSize -IsActive -AssignDriveLetter
Format-Volume -DriveLetter $part.DriveLetter -Confirm:$FALSE

# Remove the old version of Docker that is installed by default
Uninstall-Package Docker -ProviderName DockerMsftProvider

# Configure Docker to use new location
Set-Content -Encoding String "C:\ProgramData\Docker\config\daemon.json" "{ `"data-root`": `"d:\\`" }"
