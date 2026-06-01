# ==================================================
# SESSION 13: THE AUTOMATED ONBOARDING
# Operator: Desmond Hinds | Domain: titan.local
# ==================================================

Write-Host "[*] Beginning Engineering Onboarding..." -ForegroundColor Cyan

# Step 1: Create the Engineering Organizational Unit
try {
    New-ADOrganizationalUnit -Name "Engineering" -Path "DC=titan,DC=local" `
        -ProtectedFromAccidentalDeletion $false
    Write-Host "[+] OU 'Engineering' created at DC=titan,DC=local" -ForegroundColor Green
} catch {
    Write-Host "[!] Engineering OU may already exist: $_" -ForegroundColor Yellow
}

# Step 2: Set password for all new engineers
$Password = ConvertTo-SecureString "TitanCorp2026!" -AsPlainText -Force

# Step 3: For loop — create Eng_User1 through Eng_User5
for ($i = 1; $i -le 5; $i++) {
    $Username = "Eng_User$i"
    $FullName = "Engineer User $i"

    New-ADUser `
        -Name                 $FullName `
        -GivenName            "Engineer" `
        -Surname              "User$i" `
        -SamAccountName       $Username `
        -UserPrincipalName    "$Username@titan.local" `
        -Path                 "OU=Engineering,DC=titan,DC=local" `
        -AccountPassword      $Password `
        -ChangePasswordAtLogon $true `
        -Enabled              $true

    Write-Host "  [+] Created: $Username in OU=Engineering,DC=titan,DC=local" -ForegroundColor Green
}

# Step 4: Verify — show all Engineering OU users
Write-Host ""
Write-Host "[*] Verification:" -ForegroundColor Cyan
Get-ADUser -Filter 'Name -like "Eng*"' | Select-Object Name, DistinguishedName | Format-Table -AutoSize

Write-Host "[+] All engineers onboarded successfully." -ForegroundColor Green
