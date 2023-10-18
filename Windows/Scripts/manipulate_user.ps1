#When this script is called, a parameter of -Type must be specificed
#C is for account creation
#Del is for account deletion
#Di is for account disablement
#  !!!!!!!!!! PARAMETERS ARE NOT CASE SENSITIVE !!!!!!!!!!!!
Param(
    [Parameter(Mandatory)]
    [ValidateSet("C","Del","Di")]
    $Type
)
function Add-Account {
    Write-Host "Enter Account Username: "
    $user = Read-Host 

    Write-Host "`nEnter Account Password: "
    $Password = Read-Host -AsSecureString

    Write-Host "`nEnter Account Full Name: "
    $full = Read-Host

    Write-Host "`nEnter Account Description: "
    $des = Read-Host

    $params = @{
        Name        = $user
        Password    = $Password
        FullName    = $full
        Description = $des
    }
    
    New-LocalUser @params   
}
function Remove-Account {
    Write-Host "User to Delete: "
    $Name = Read-Host
    
    Remove-LocalUser -Name $Name

}

function Disable-Account {
    Write-Host "User to Disable: "
    $Name = Read-Host

    Disable-LocalUser -Name $Name
}

# Functions are ran based off of -Type Input
if($Type -eq "C"){
    Add-Account
}

if($Type -eq "Del"){
    Remove-Account
}

if($Type -eq "Di"){
    Disable-Account
}