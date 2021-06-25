$commandDir = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $commandDir -Parent
$baseDir = Split-Path $scriptDir -Parent

$javacmd = $env:JAVACMD
if ($null -eq $javacmd) {
    $javacmd = "java"
    if ($null -ne $env:JAVA_HOME) {
        $javacmd = "$env:JAVA_HOME\bin\java"
    }
}

$libDir = $env:SVNKIT_LIB
if ($null -eq $libDir) {
    $libDir = "$baseDir\lib"
}

$classpath = "$libDir\*"
$jvmargs=@(
    "-Djava.util.logging.config.file=$baseDir\conf\logging.properties",
    "-Dsun.io.useCanonCaches=false")

$allargs = $jvmargs + @('-classpath', $classpath, 'org.tmatesoft.svn.cli.SVN') + $Args

Start-Process -FilePath $javacmd -ArgumentList $allargs -Wait -NoNewWindow
