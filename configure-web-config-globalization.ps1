$cayusePath = ".\cayuse.net"
$webConfigPath = "$cayusePath\ITW.WebApp\web.config"
$xml = New-Object System.Xml.XmlDocument;
$xml.Load($webConfigPath);

# [System.Xml.XmlNode]$cultureNode = $xml.SelectSingleNode("configuration/appSettings");
# Write-Output $cultureNode.ChildNodes | ?($_.Attributes);

$cultureCode = (Select-Xml -Xml $xml -XPath "/configuration/appSettings/add[@key='CultureCode']/@value").Node.Value

$globalCulture = $xml.SelectSingleNode("/configuration/system.web/globalization/@culture")
$globalUICulture = $xml.SelectSingleNode("/configuration/system.web/globalization/@uiCulture")

# checking for null
if (!$globalCulture -Or !$globalUICulture) {
    Write-Host "Globalization xml node in web.config not found!"
    exit
} elseif (!$cultureCode) {
    Write-Host "CultureCode Pipeline Variable not found!"
    exit
} else {
        Write-Host "Current Globalization Code:" $globalCulture.Value
    Write-Host "Changing attributes to:" $cultureCode
    $globalCulture.Value = $cultureCode
    $globalUICulture.Value = $cultureCode
    $xml.Save($webConfigPath)
}