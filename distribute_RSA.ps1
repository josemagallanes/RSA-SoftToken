<#
Description: Drop the "Software_Tokens.zip" file downloaded from RSA in to a 
             folder along with TokenConverter.jar and this script. This script 
             will automatically unzip the file, and extract the token 
             in to a folder for archive. It will convert the token if needed 
             and produce an e-mail for the recipient.
Author:      Jose E. Magallanes
Date:        10/3/2014
Updated:     4/28/2015
             Changed to updated Java creation program.
#>

### Gets current directory location and zipfile path.
$current_dir = (Get-Location).path
$zip_file = $current_dir + "\Software_Tokens.zip" #Default name; Can be changed
$shell = New-Object -com shell.application
$zip = $shell.NameSpace($zip_file)

### Unzips file
ForEach ($item in $zip.items())
{
    $file_name = $item.name
    $underscore_index = $file_name.Indexof("_")
    $user_name = $file_name.substring(0,$underscore_index) #strips EOS
    $shell.Namespace($current_dir).copyhere($item)
    $file_path = $current_dir + "\" + $file_name
}

### Prompts the user to choose type of device token will be used on.
$answer = ""
$possible_answers = "1","2","3","4"
while ($possible_answers -notcontains $answer)
{
    CLS
    $title = "`n`n                            RSA SOFT TOKEN CONVERTER"
    $sub_title = "`n`n                         Please Select the Device Type"
    $choice_1 = "`n                               1. Android"
    $choice_2 = "`n                               2. I-Phone/IOS"
    $choice_3 = "`n                               3. Windows Phone"
    $choice_4 = "`n                               4. Windows Computer"
    $prompt = "`n`n                      Enter the number of your choice"
    Write-Host $title -ForeGroundColor Magenta
    Write-Host $sub_title -ForeGroundColor Cyan
    Write-Host $choice_1 -ForeGroundColor Cyan
    Write-Host $choice_2 -ForeGroundColor Cyan
    Write-Host $choice_3 -ForeGroundColor Cyan
    Write-Host $choice_4 -ForeGroundColor Cyan
    $answer = Read-Host $Prompt
}

# Converts the token according to user choice.
if ($answer -eq "1") {
    $link = (java -jar TokenConverter.jar $file_path -android)
    $instructions = "Android_Instructions.docx"} #Add your own user instructions here.
elseif ($answer -eq "2") {
    $link = (java -jar TokenConverter.jar $file_path -ios)
    $instructions = "IPhone_Instructions.docx"} # IOS #Add your own user instructions here.
else {
    $link = (java -jar TokenConverter.jar $file_path -winphone)
    $instructions = "Windows_Instructions.docx"} # Win devices # Instructions for windows phone.

### Generic email message.
$email_body = "Enclosed are the instructions for installing the RSA token " + `
"to your device. Please read the instructions before taking any action and " + `
"follow the directions carefully.`n`nPlease respond upon successful " + `
"installation of your RSA Token.`n`n" + $link

### Send email
$subject = "RSA Soft Token Request"
$user_email = $user_name + "@company.com" # Change if you don't use username@company as default email address.

$creds = Get-Credential

#Change this to send using whatever mail delivery system you use. This is for Office 365
Send-MailMessage -To $user_email -Subject $subject -Body $email_body `
                 -SmtpServer "smtp.office365.com" `
                 -Attachments $instructions, $file_path `
                 -Cc "yourself@company.com" -Credential $creds -Port "587" `
                 -UseSsl -From "yourself@company.com" -Dno OnFailure

### Store token in a folder.
New-Item $current_dir -Name $user_name -Type Directory -Force | Out-Null
Move-Item -path ($file_path) -Destination ($current_dir + "\" + $user_name) `
          -Force | Out-Null
New-Item -path ($current_dir + "\" + $user_name) -Name ($user_name + ".txt") `
         -Type File -Value $link -Force | Out-Null

$Confirm = "`n`n                                Token Extracted.`n`n"
Write-Host $Confirm -ForeGroundColor Blue
