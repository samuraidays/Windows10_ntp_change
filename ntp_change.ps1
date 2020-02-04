function RegSet( $RegPath, $RegKey, $RegKeyType, $RegKeyValue ){
    # レジストリありなし確認
    $Elements = $RegPath -split "\\"
    $RegPath = ""
    $FirstLoop = $True
    foreach ($Element in $Elements ){
        if($FirstLoop){
            $FirstLoop = $False
        }
        else{
            $RegPath += "\"
        }
        $RegPath += $Element
        if( -not (test-path $RegPath) ){
            echo "Add Registry : $RegPath"
            md $RegPath
        }
    }

    # Keyありなし確認
    $Result = Get-ItemProperty $RegPath -name $RegKey -ErrorAction SilentlyContinue
    # キーがあった時
    if( $Result -ne $null ){
        Set-ItemProperty $RegPath -name $RegKey -Value $RegKeyValue
    }
    # キーがなかった時
    else{
        # キーを追加する
        New-ItemProperty $RegPath -name $RegKey -PropertyType $RegKeyType -Value $RegKeyValue
    }
    Get-ItemProperty $RegPath -name $RegKey
}

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers"
$RegKey = "1"
$RegKeyType = "String"
$RegKeyValue = "ntp.nict.jp"
RegSet $RegPath $RegKey $RegKeyType $RegKeyValue