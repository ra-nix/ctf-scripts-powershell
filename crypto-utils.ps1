function Decode-HexToAscii {
    param(
        [string]$HexValue
    )

    try {
        if ($HexValue | Select-String -Pattern "^0x.+") {
            $HexValue = $HexValue -replace "0x",""
            $decodedValue = ($HexValue -split "(..)" -ne '' | ForEach-Object {[char][byte]"0x$_"}) -join ''
            Write-Host "[+] $($HexValue) ---> $($decodedValue)"
        } else {
            $decodedValue = ($HexValue -split "(..)" -ne '' | ForEach-Object {[char][byte]"0x$_"}) -join ''
            Write-Host "[+] $($HexValue) ---> $($decodedValue)"
        }
    }
    catch {
        Write-Error "[!] Error: $($_.Exception.Message)"
    }
  
}

function Decode-Base64ToAscii {
    param(
        [string]$Base64String
    )

    try {
        $decodedText = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Base64String))
        Write-Host "[+] $($Base64String) ---> $($decodedText)"
    }
    catch {
        Write-Error "[!] Error: $($_.Exception.Message)"
    }
}

function Decode-BinaryToAscii {
    param(
        [string]$BinaryString
    )

    try {
        $ascii = ($BinaryString -split " " | ForEach-Object {[char][System.Convert]::ToInt32($_, 2)}) -join ''
        Write-Host "[+] $($BinaryString) ---> $($ascii)"
    }
    catch {
        Write-Error "[!] Error: $($_.Exception.Message)"
    }
}

function Decode-RotCipher {
    param(
        [string]$CipherText,
        [int32]$NumberOfRotations = 13
    )

    try {
        #m = (c - n) % 26
        $Upper = 65
        $Lower = 97

        $intValues = $CipherText.ToCharArray() | ForEach-Object {
            if ($_ -cmatch '[^\w\s]') {
                [int][char]$_
            } else {
                $_
            }
        }

        $shiftValues = $intValues | ForEach-Object {
            if ($_ -cmatch '[A-Z]') {
                [char]((($_ - $Upper + $NumberOfRotations) % 26) + $Upper) 
            } elseif ($_ -cmatch '[a-z]') {
                [char]((($_ - $Lower + $NumberOfRotations) % 26) + $Lower) 
            } else {
                $_
            }
        }
        
        $decoded = -join $shiftValues
        Write-Host "[+] $($intValues) ---> $($shiftValues)"
    }
    catch {
        Write-Error "[!] Error: $($_.Exception.Message)"
    }
}

function Decode-AtbashCipher {
    param(
        [string]$CipherText
    )

    #m = (c - u) + l
    try {
        $CipherText.ToLower()
        $cInt = $CipherText.ToCharArray() | ForEach-Object {
            if ($_ -cmatch '[^\w\s]') {
                [System.Convert]::ToInt32($_)
            } else {
                $_
            }
        }

        $mInt = $cInt | ForEach-Object {(122 - $_ ) + 97}
        $message = -join ($mInt | ForEach-Object {[System.Convert]::ToChar($_)})

        Write-Host "[+] $($CipherText) ---> $($message)"
     
    }
    catch {
        Write-Error "[!] Error: $($_.Exception.Message)"
    }
}
