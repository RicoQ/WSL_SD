Add-Type -AssemblyName System.Windows.Forms

# Function to get the full path of a file in the Scripts folder
function GetScriptPath($fileName) {
    $scriptFolder = Join-Path -Path $PSScriptRoot -ChildPath "Scripts"
    return Join-Path -Path $scriptFolder -ChildPath $fileName
}

# Function to run the WSL installation script
function RunWSLInstallation($distributionName, $username, $password) {
    Write-Host "Running WSL installation script for distribution: $distributionName"
    $scriptPath = GetScriptPath "PowerShell\Install_WSL.ps1"  # Get the full path to the WSL installation script
    if (Test-Path $scriptPath) {
        Write-Host "WSL installation script found at: $scriptPath"
        $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" `"$distributionName`" `"$username`" `"$password`""
        $process = Start-Process powershell -Verb RunAs -ArgumentList $arguments -PassThru
        $process.WaitForExit()
        if ($process.ExitCode -eq 0) {
            $button2.Enabled = $true  # Enable the "Copy Config Files" button
        }
    }
    else {
        Write-Host "WSL installation script not found at: $scriptPath"
    }
}

# Function to copy the configuration files
function CopyConfigFiles($distributionName, $username, $userpassword) {
    
    Write-Host "Copying configuration files..."
    $scriptPath = GetScriptPath "PowerShell\Copy_Config_files.ps1"  # Get the full path to the configuration files script
    if (Test-Path $scriptPath) {
        Write-Host "Copy Config Files script found at: $scriptPath"
        Write-Host "Distribution name is : $distributionName"
        $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" `"$distributionName`" `"$username`" `"$password`""
        $process = Start-Process powershell -Verb RunAs -ArgumentList $arguments -PassThru
        $process.WaitForExit()
        if ($process.ExitCode -eq 0) {
            $button3.Enabled = $true  # Enable the "Install SD" button
        }
    }
    else {
        Write-Host "Copy Config Files script not found at: $scriptPath"
    }
}

# Function to install SD
function InstallSD($distributionName, $username, $userpassword) {
    
    Write-Host "Running Install SD for distribution: $distributionName"

    # Run the installation script for SD
    $scriptPath = GetScriptPath "PowerShell\Install_SD.ps1"  # Get the full path to the SD installation script
    if (Test-Path $scriptPath) {
        Write-Host "SD installation script found at: $scriptPath"
        $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" `"$distributionName`" `"$username`" `"$password`""
        $process = Start-Process powershell -Verb RunAs -ArgumentList $arguments -PassThru
        $process.WaitForExit()
    }
    else {
        Write-Host "SD installation script not found at: $scriptPath"
    }
}

function ShowDistributionList {
    $distributionList = @"
NAME:
                                 
Ubuntu                               
Debian                                 
kali-linux                             
Ubuntu-18.04                           
Ubuntu-20.04                           
Ubuntu-22.04                           
OracleLinux_7_9                        
OracleLinux_8_7                        
OracleLinux_9_1                        
SUSE-Linux-Enterprise-Server-15-SP4    
openSUSE-Leap-15.4                    
openSUSE-Tumbleweed
"@

    # Create a new form
    $wslOutputForm = New-Object System.Windows.Forms.Form
    $wslOutputForm.Text = "WSL Distribution List"
    $wslOutputForm.Width = 280
    $wslOutputForm.Height = 310
    $wslOutputForm.StartPosition = "CenterScreen"

    # Create a textbox to display the distribution list
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location = New-Object System.Drawing.Point(20, 20)
    $textbox.Size = New-Object System.Drawing.Size(220, 200)
    $textbox.Multiline = $true
    $textbox.ReadOnly = $true
    $textbox.ScrollBars = "Vertical"
    $textbox.Text = $distributionList

    # Create an OK button to close the form
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $okButton.Location = New-Object System.Drawing.Point(90, 230)
    $okButton.Size = New-Object System.Drawing.Size(80, 30)
    $okButton.Add_Click({
        $wslOutputForm.Close()
    })

    # Add the textbox and OK button to the form
    $wslOutputForm.Controls.Add($textbox)
    $wslOutputForm.Controls.Add($okButton)

    # Show the form as a non-modal dialog
    $wslOutputForm.ShowDialog()
}

Write-Host "Starting WSL Management..."

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "WSL Management"
$form.Size = New-Object System.Drawing.Size(315, 390)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Create labels
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(20, 45)
$label1.Size = New-Object System.Drawing.Size(100, 20)
$label1.Text = "Distribution Name:"

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(20, 115)
$label2.Size = New-Object System.Drawing.Size(100, 20)
$label2.Text = "Username:"
$label2.Visible = $false  # Initially hidden

$label3 = New-Object System.Windows.Forms.Label
$label3.Location = New-Object System.Drawing.Point(20, 155)
$label3.Size = New-Object System.Drawing.Size(100, 20)
$label3.Text = "User Password:"
$label3.Visible = $false  # Initially hidden

# Create textboxes
$textbox1 = New-Object System.Windows.Forms.TextBox
$textbox1.Location = New-Object System.Drawing.Point(120, 40)
$textbox1.Size = New-Object System.Drawing.Size(150, 20)

$textbox2 = New-Object System.Windows.Forms.TextBox
$textbox2.Location = New-Object System.Drawing.Point(120, 110)
$textbox2.Size = New-Object System.Drawing.Size(150, 20)
$textbox2.Visible = $false  # Initially hidden

$textbox3 = New-Object System.Windows.Forms.TextBox
$textbox3.Location = New-Object System.Drawing.Point(120, 150)
$textbox3.Size = New-Object System.Drawing.Size(150, 20)
$textbox3.PasswordChar = '*'
$textbox3.Visible = $false  # Initially hidden

# Create buttons
$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(50, 65)
$button1.Size = New-Object System.Drawing.Size(200, 30)
$button1.Text = "Install WSL"
$button1.Add_Click({
    $distributionName = $textbox1.Text
    if ($distributionName) {
        RunWSLInstallation $distributionName
        $label2.Visible = $true
        $textbox2.Visible = $true
        $label3.Visible = $true
        $textbox3.Visible = $true
    }
    else {
        Write-Host "Please enter the distribution name."
    }
})

$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(50, 190)
$button2.Size = New-Object System.Drawing.Size(200, 30)
$button2.Text = "Copy Config Files"
$button2.Enabled = $false  # Disable the button initially
$button2.Add_Click({
    $distributionName = $textbox1.Text
    $username = $textbox2.Text
    $userpassword = $textbox3.Text
    if ($username -and $userpassword) {
        CopyConfigFiles $distributionName $username $userpassword
        $button3.Enabled = $true

    }
    else {
        Write-Host "Please enter the username and user password."
    }
})

$button3 = New-Object System.Windows.Forms.Button
$button3.Location = New-Object System.Drawing.Point(50, 230)
$button3.Size = New-Object System.Drawing.Size(200, 30)
$button3.Text = "Install SD"
$button3.Enabled = $false  # Disable the button initially
$button3.Add_Click({
    $distributionName = $textbox1.Text
    $username = $textbox2.Text
    $userpassword = $textbox3.Text
    InstallSD $distributionName $username $userpassword
})

$button4 = New-Object System.Windows.Forms.Button
$button4.Location = New-Object System.Drawing.Point(50, 270)
$button4.Size = New-Object System.Drawing.Size(200, 30)
$button4.Text = "Exit"
$button4.Add_Click({
    $form.Close()
})

$button5 = New-Object System.Windows.Forms.Button
$button5.Text = "Show List"
$button5.Location = New-Object System.Drawing.Point(150, 05)
$button5.Size = New-Object System.Drawing.Size(90, 30)
$button5.Add_Click({
    ShowDistributionList
})


# Add controls to the form
$form.Controls.Add($label1)
$form.Controls.Add($label2)
$form.Controls.Add($label3)
$form.Controls.Add($textbox1)
$form.Controls.Add($textbox2)
$form.Controls.Add($textbox3)
$form.Controls.Add($button1)
$form.Controls.Add($button2)
$form.Controls.Add($button3)
$form.Controls.Add($button4)
$form.Controls.Add($button5)

# Show the form
$form.ShowDialog() | Out-Null

Write-Host "WSL Management completed."
