function New-ObjectPropertyName
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )][System.Object[]]$InputObject,
        [Parameter(
            Mandatory=$true
        )][String[]]$NewName,
        [Parameter(
            Mandatory=$true
        )][String[]]$MemberType
    )
    begin {
        $useSameNameMapForRest = $null
    } process {
        $tmpName = $NewName | Select-Object -Unique
        $properties = $InputObject | Get-Member -MemberType $MemberType
        if ($properties.count -gt $tmpName.count) {
            throw "The number of selected properties $($properties.count) " + `
                "is greater than the number of new names $($tmpName.count)."
        }
        if ($useSameNameMapForRest -eq $false -or $null -eq $useSameNameMapForRest) {
            $nameMap = @()
            foreach ($property in $properties) {
                Write-Host "Pick a new name for the property $($property.Name)" `
                    -ForegroundColor Yellow
                $nName = New-Menu -InputObject $tmpName
                $nameMap += @{
                    OldName = $property.Name
                    MemberType = $property.MemberType
                    NewName = $nName
                }
                if ($tmpName.count -gt 1) {
                    $tmpName = $tmpName | Where-Object { $_ -ne $nName }
                }
            }
        }

        $newObject = $InputObject | Select-Object -Property * `
            -ExcludeProperty $nameMap.OldName

        foreach ($name in $nameMap) {
            $newObject | Add-Member -MemberType $name.MemberType `
                -Name $name.NewName -Value $InputObject.($name.OldName)
        }

        if ($null -eq $useSameNameMapForRest) {
            Write-Host "Use the same new name for following input objects if any?" `
                -ForegroundColor Green
            $answer = New-Menu -InputObject 'YES', 'NO'
            if ($answer -eq 'YES') {
                $useSameNameMapForRest = $true
                $nameMap = $nameMap
            } else {
                $useSameNameMapForRest = $false
            }
        }

        return $newObject
    }
}
