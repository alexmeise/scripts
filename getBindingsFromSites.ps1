Import-Module WebAdministration

$sitios = get-website

Foreach ($sitio in $sitios){

get-website -name $sitio.name | select -ExpandProperty Bindings | Select -ExpandProperty Collection | select Protocol,bindingInformation
$sitio.name
}
