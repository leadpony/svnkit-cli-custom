$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$baseDir = Split-Path $scriptDir -Parent

$cmd = $null
foreach ($arg in $args) {
    if (-not $arg.StartsWith('-')) {
        $cmd = $arg
        break
    }    
}

$usePager = @('blame', 'diff', 'log').Contains($cmd)

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

if ($usePager) {
    & $java $javaArgs | more
} else {
    & $java $javaArgs
}
