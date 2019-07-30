<#
    .Synopsis
    Pulls images from Docker Hub.

    .Description
    The Invoke-PullDockerImages cmdlet pulls images from Docker Hub.

    .Parameter Images
    The image names.

    .Example
        Invoke-PullDockerImages image1:v1,image1:v2
#>
function Invoke-PullDockerImages
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]] $Images
    )

    foreach ($Image in $Images)
    {
        docker pull $Image
    }
}
Export-ModuleMember Invoke-PullDockerImages

<#
    .Synopsis
    Lists local Docker images.

    .Description
    The Get-DockerImages cmdlet lists local images.

    .Parameter AsJson
    When specified formats the output as JSON.

    .Example
        Get-DockerImages
#>
function Get-DockerImages
{
    [CmdletBinding()]
    param(
        [switch] $AsJson = $false
    )

    if ($AsJson -eq $false)
    {
        docker images
    }
    else 
    {
        $ImageInfos = docker images --format='{{json .}}'
        $ImageInfos | ConvertFrom-Json | ConvertTo-Json
        Write-Output $Json
    }
    
}
Export-ModuleMember Get-DockerImages

<#
    .Synopsis
    Lists all Docker containers.

    .Description
    The Get-DockerContainers cmdlet lists all containers.

    .Parameter AsJson
    When specified formats the output as JSON.

    .Example
        Get-DockerContainers
#>
function Get-DockerContainers
{
    [CmdletBinding()]
    param(
        [switch] $AsJson = $false
    )

    if ($AsJson -eq $false)
    {
        docker ps -a -s
    }
    else 
    {
        $ContainerInfos = docker ps -a --format='{{json .}}'
        $ContainerInfos | ConvertFrom-Json | ConvertTo-Json
        Write-Output $Json
    }
    
}
Export-ModuleMember Get-DockerContainers

<#
    .Synopsis
    Removes all or some Docker containers.

    .Description
    The Remove-DockerContainers cmdlet removes all or some Docker containers. 

    .Parameter ContainersToRemove
    The containers to remove. If not specified all containers will be removed.

    .Example
        Remove-DockerContainers container1,container2,container3 
#>
function Remove-DockerContainers
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string[]] $ContainersToRemove = @()
    )

    if (($null -eq $ContainersToRemove) -or ($ContainersToRemove.Length -eq 0))
    {
        $Containers = docker ps -a -q

        foreach ($Container in $Containers)
        {
            docker rm $Container -f
        }
    }
    else 
    {
        foreach ($Container in $ContainersToRemove)
        {
            docker rm $Container -f
        }
    }
}
Export-ModuleMember Remove-DockerContainers

<#
    .Synopsis
    Removes all or some Docker images.

    .Description
    The Remove-DockerImages cmdlet removes all or some Docker images. 

    .Parameter ImagesToRemove
    The images to remove. If not specified all images will be removed.

    .Example
        Remove-DockerImages image1,image2,image3 
#>
function Remove-DockerImages
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string[]] $ImagesToRemove = @()
    )

    if (($null -eq $ImagesToRemove) -or ($ImagesToRemove.Length -eq 0))
    {
        $Images = docker images -q

        foreach ($Image in $Images)
        {
            docker rmi $Image -f
        }
    }
    else 
    {
        foreach ($Image in $ImagesToRemove)
        {
            docker rmi $Image -f
        }
    }
}
Export-ModuleMember Remove-DockerImages