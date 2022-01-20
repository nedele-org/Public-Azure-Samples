# Replace the following URL with a public GitHub repo URL
$gitrepo="https://github.com/nedele-org/Azure-Samples.git"
$gittoken="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"
$webappname="mywebapp$(Get-Random)"
$location="West Europe"
$resourceGroup="myResourceGroup"

# Create a resource group.
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create an App Service plan in Free tier.
New-AzAppServicePlan -Name $webappname -Location $location -ResourceGroupName $resourceGroup -Tier Free

# Create a web app.
New-AzWebApp -Name $webappname -Location $location -AppServicePlan $webappname -ResourceGroupName $resourceGroup

# SET GitHub
$PropertiesObject = @{
    token = $gittoken;
}
Set-AzResource -PropertyObject $PropertiesObject `
-ResourceId /providers/Microsoft.Web/sourcecontrols/GitHub -ApiVersion 2015-08-01 -Force

# Configure GitHub deployment from your GitHub repo and deploy once.
$PropertiesObject = @{
    repoUrl = "$gitrepo";
    branch = "master";
}
Set-AzResource -Properties $PropertiesObject -ResourceGroupName $resourceGroup -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $webappname/web -ApiVersion 2015-08-01 -Force