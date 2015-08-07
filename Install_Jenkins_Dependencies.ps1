Set-ExecutionPolicy Unrestricted

iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

$path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
$path = $path + ';C:\Windows\Microsoft.NET\Framework64\v4.0.30319\'
$path = $path + ';C:\Program Files (x86)\NUnit 2.6.3\bin'
$path = $path + ';C:\Program Files (x86)\Jenkins\jre\bin'
$path = $path + ';;C:\Program Files\Java\jdk1.7.0_76\bin'
[Environment]::SetEnvironmentVariable("PATH", $path, "Machine")

$env:PATH=$path

[Environment]::SetEnvironmentVariable("HOME", "C:", "Machine")
[Environment]::SetEnvironmentVariable("GIT_HOME", "C:\Program Files (x86)\Git\bin", "Machine")


choco install jenkins -version 1.596.0.0

choco install git -version 1.9.5

choco install curl  -version 7.28.1

choco install nunit  -version 2.6.3.20140715

choco install microsoft-build-tools -version 12.0.21005.20140416

choco install nodejs -version 0.10.35

choco install dotnet3.5 

choco install NuGet.CommandLine 2.8.3

choco install jdk7

choco install jmeter

cd "C:\Program Files (x86)\Jenkins\war\WEB-INF"

java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/scm-api/0.2/scm-api.hpi
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/git/2.3.4/git.hpi
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/git-client/1.15.0/git-client.hpi
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/msbuild/1.24/msbuild.hpi
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/nunit/0.16/nunit.hpi
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/powershell/1.2/powershell.hpi
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/zapper/1.0.7/zapper.hpi


$path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
$path = $path + ';C:\Program Files (x86)\Git\cmd'
[Environment]::SetEnvironmentVariable("PATH", $path, "Machine")
$env:PATH=$path

java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart

sleep 20
