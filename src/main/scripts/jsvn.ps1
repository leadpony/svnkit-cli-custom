$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$baseDir = Split-Path $scriptDir -Parent

$java = $env:JAVACMD
if ($null -eq $java) {
    $java = "java"
    if ($null -ne $env:JAVA_HOME) {
        $java = "$env:JAVA_HOME\bin\java"
    }
}

$libDir = $env:SVNKIT_LIB
if ($null -eq $libDir) {
    $libDir = "$baseDir\lib"
}

$classpath = "$libDir\*"

$javaArgs=@(
    "-Djava.util.logging.config.file=$baseDir\conf\logging.properties",
    "-Dsun.io.useCanonCaches=false",
    '-classpath',
    $classpath,
    'org.tmatesoft.svn.cli.SVN'
    ) + $args

$javaArgs = $javaArgs | ForEach-Object { """$_""" } 

Start-Process -Wait -NoNewWindow -FilePath $java -ArgumentList $javaArgs 
