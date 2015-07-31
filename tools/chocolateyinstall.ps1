#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one
# REMOVE ANYTHING BELOW THAT IS NOT NEEDED

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'openssl' # arbitrary name for the package, used in messages
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://slproweb.com/download/Win32OpenSSL-1_0_2d.exe' # download url
$url64 = 'https://slproweb.com/download/Win64OpenSSL-1_0_2d.exe'

$installDir = Join-Path $Env:ProgramFiles 'OpenSSL'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64

  silentArgs    = '/silent', '/verysilent', '/sp-', '/suppressmsgboxes',
                  "/DIR=`"$installDir`"";
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

if (!$Env:OPENSSL_CONF)
{
  $configPath = Join-Path $installDir 'bin\openssl.cfg'

  if (Test-Path $configPath)
  {
    [Environment]::SetEnvironmentVariable('OPENSSL_CONF', $configPath, 'User')
	Write-Host "configured OPENSSL_CONF variable as $configPath"
  }
}