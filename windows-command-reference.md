# Windows Command Reference

My cheat sheet for the commands I used or looked up during this lab, with what it does in plain English. Anything that changes users, groups, policies, or permissions needs PowerShell opened as an administrator.

## Things I learned the hard way

- **Capitalization doesn't matter.** `Get-LocalUser` and `get-localuser` do the same thing. Passwords are the one exception.
- **Commands are Verb-Noun.** `Get-` looks something up, `New-` creates, `Set-` changes, `Add-` adds to something, and `Remove-` deletes. Once that clicked, guessing command names got a lot easier.
- **Don't hit Enter in the middle of a command.** It splits one command into two broken ones. I did this more than once.
- **Windows PowerShell 5.1 doesn't understand `&&`.** Use `;` if you want two commands on one line.
- **No output usually means it worked.** Errors show up in red and tell you the line and character where PowerShell got confused.
- **Anything starting with `$` is a variable,** like `$pw` or `$row`.
- **`|` (the pipe)** hands the output of one command to the next one.

## Finding help

| Command | What it does |
| --- | --- |
| `Get-Command *user*` | Lists every command with "user" in its name |
| `Get-Help New-LocalUser -Examples` | Shows working examples for a command |

## Users

| Command | What it does |
| --- | --- |
| `lusrmgr.msc` | Opens Local Users and Groups (the GUI) |
| `Get-LocalUser` | Lists all local accounts and whether they're enabled |
| `Get-LocalUser \| Format-Table Name, FullName, Description, Enabled` | Same list, with the columns I choose |
| `$pw = Read-Host -AsSecureString` | Asks for a password, hides it while typing, stores it encrypted |
| `New-LocalUser -Name "msmith" -FullName "Mary Smith" -Password $pw` | Creates an account (no groups yet) |
| `Disable-LocalUser -Name "msmith"` | Turns an account off without deleting it (offboarding) |
| `net user jappleseed` | Shows everything about one account: locked or not, last logon, groups |
| `net user jappleseed /logonpasswordchg:yes` | Forces a password change at next sign-in |

## Groups

| Command | What it does |
| --- | --- |
| `New-LocalGroup -Name "Projects" -Description "Projects team"` | Creates a group |
| `Add-LocalGroupMember -Group "Projects" -Member "jappleseed"` | Adds a user to a group |
| `Get-LocalGroupMember -Group "Administrators"` | Lists who is in a group |
| `Remove-LocalGroupMember -Group "Administrators" -Member "testadmin"` | Removes someone from a group, such as a temporary admin |

Accounts made in the GUI join the Users group on their own. Accounts made with `New-LocalUser` do not, so add them.

## Lockout policy

| Command | What it does |
| --- | --- |
| `net accounts` | Shows password and lockout policy |
| `net accounts /lockoutthreshold:5` | Locks an account after 5 wrong passwords |

To unlock: `lusrmgr.msc` > Users > the user > Properties > clear **Account is locked out**.

## Security log

Event Viewer (`eventvwr.msc`) > Windows Logs > Security.

| Event ID | Meaning |
| --- | --- |
| 4624 | Successful logon |
| 4625 | Failed logon |
| 4740 | Account locked out |

## Files and permissions

| Command | What it does |
| --- | --- |
| `New-Item -Path "C:\Shares\Projects" -ItemType Directory` | Creates a folder |
| `icacls "C:\Shares\Projects"` | Shows who has what access to a folder |
| `icacls "<folder>" /grant "Projects:(OI)(CI)M"` | Gives a group Modify on the folder and everything inside |
| `icacls "<folder>" /inheritance:r` | Removes the permissions copied from the parent folder |

Reading icacls output:

| Code | Meaning |
| --- | --- |
| `F` | Full control |
| `M` | Modify: create, edit, delete |
| `RX` | Read and execute: open only |
| `(OI)(CI)` | Applies to files and subfolders inside |
| `(I)` | Inherited from the parent folder |

Always grant first, then remove inheritance. The other order leaves the folder with no permissions in between.

## Scripts

| Command | What it does |
| --- | --- |
| `notepad C:\Lab\newhires.ps1` | Creates or opens a script file |
| `Import-Csv C:\Lab\newhires.csv` | Reads a CSV as a table of records |
| `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` | Allows scripts in this PowerShell window only |
| `C:\Lab\newhires.ps1` | Runs a script by its full path |
| `.\newhires.ps1` | Runs a script in the current folder (the `.\` is required) |

## Network

| Command | What it does |
| --- | --- |
| `ipconfig` | Shows the computer's IP address, subnet mask and gateway |
| `ipconfig /all` | Adds DNS servers, MAC address and DHCP details |
