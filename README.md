# RSA-SoftToken
Short Powershell program to create the link/token code necessary for RSA software tokens on mobile phones. This program does not include the password option, but can be easily added if you read the documentation RSA provides at http://www.emc.com/security/rsa-securid/rsa-securid-software-authenticators/converter.htm

Also only accounts for one token downloaded at a time. Modify to your hearts desire.

This was created on Powershell 4.0, and I am assuming you have the latest .NET Framework updates for Powershell. You also need a Java install.

Create a folder on your computer with the following contents:
  - distribute_rsa.ps1
  - TokenConverter.jar
  - Software_Tokens.zip (Dowloaded from your admin console)

I would also advise creating 3 instruction sheets, 1 for each phone type installed.
