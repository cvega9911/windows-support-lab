# Create local user accounts in bulk from a CSV file
$csv = Import-Csv -Path "C:\lab\newhires.csv"
$pw = Read-Host -AsSecureString -Prompt "temporary password"

foreach ($row in $csv) {
    if (Get-LocalUser -Name $row.username -erroraction silentlycontinue) {
        Write-Host "Skip: $($row.username) already exists" -ForegroundColor Yellow
        continue
    }
    New-Localuser -Name $row.username -fullname $row.fullname -description $row.department -password $pw | Out-Null
    Add-LocalGroupmember -Group "Users" -Member $row.username
    Add-LocalGroupmember -Group $row.department -Member $row.username
    net user $row.username /logonpasswordchg:yes | Out-Null
    Write-Host "Created: $($row.username) in $($row.department)" -foregroundcolor green
}
