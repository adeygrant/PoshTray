<# 
    .Notes
    Simple systray app template.
#>

#Import assemblies
Add-Type -AssemblyName  WindowsBase,
                        System.Windows.Forms,
                        PresentationFramework,
                        System.Drawing,
                        WindowsFormsIntegration
# Enable visual styles
[Windows.Forms.Application]::EnableVisualStyles()

# Set variables for XAML
$height = 400
$width  = 355
$x = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - $width
$y = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height - $height

[xml]$xaml = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Name="Window"
        Title="PC Info"
        Height="$height" Width="$width"
        ResizeMode="NoResize"
        ShowInTaskbar="False"
        WindowStartupLocation="Manual"
        Left="$x" Top="$y"
        >
    <Grid Name="theGrid" Visibility="Visible">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" MinHeight="300"/>
            <RowDefinition Height="Auto"  />
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions></Grid.ColumnDefinitions>
        <Menu Grid.Row="0" Grid.Column="0" >
            <MenuItem Header="_File" ><MenuItem Name="btnExit" Header="_Exit"></MenuItem></MenuItem>
            <MenuItem Header="_Overlay" >
                <MenuItem Header="Show on desktop" IsCheckable="True" IsChecked="True" Margin="0,0,-30,0" ></MenuItem>
            </MenuItem>
            <MenuItem Header="_Help"><MenuItem Name="btnAbout" Header="About"></MenuItem>
            </MenuItem>
        </Menu>
        <Label  Name="lblAbout"
                Visibility="Collapsed"
                HorizontalContentAlignment="Center"
                Grid.Row="1"
                Grid.Column="0"
                Margin="0 115 0 0">
                github.com/adeygrant
        </Label>
        <Label  Name="lblAbout2"
                Visibility="Collapsed"
                HorizontalContentAlignment="Center"
                Grid.Row="1"
                Grid.Column="0"
                Margin="0 130 0 0">
                Adrian Grant
        </Label>
        <Button Name="btnAboutClose" 
                Visibility="Collapsed"
                HorizontalContentAlignment="Center"
                Width="85" 
                Height="25"
                Content="Close"
                Grid.Row="2"
                Grid.Column="0"
        />
        <TabControl Name="tabControl" Grid.Row="1" Grid.Column="0" Margin="5 5 5 5" Visibility="Visible">
            <TabItem Name="Overview" Header="Overview">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tabOverview_tbOverview"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Computer" Header="Computer">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tabComputer_tbComputer"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Disks" Header="Disks">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tabDisks_tbDisks"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="OS" Header="OS">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tabOS_tbOS"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Hardware" Header="Hardware">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tabHardware_tbHardware"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Display" Header="Display">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tabDisplay_tbDisplay"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Network" Header="Network">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tabNetwork_tbNetwork"></TextBlock>
                </StackPanel>
            </TabItem>
        </TabControl>
        <Button Name="btnCopyCurrent"
                Margin="5,5,100,5"
                Width="85"
                Height="25"
                Content="Copy Current"
                Grid.Column="0"
                Grid.Row="2"
        />
        <Button Name="btnCopyAll"
                Margin="100,5,5,5"
                Width="85"
                Height="25"
                Content="Copy All"
                Grid.Column="0"
                Grid.Row="2"
        />
    </Grid>
</Window>
"@

# https://www.motobit.com/util/base64-decoder-encoder.asp
# https://www.iconsdb.com/white-icons/settings-5-icon.html 32x32
# Create Icon.
$b64 = 
"AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////PP///6D////U////BgAAAAAAAAAA
AAAAAP///xT////e////lP///zAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////KP///8L/////////////
//////+M////AgAAAAD///8E////qP///////////////////7b///8YAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8c
////+v/////////////////////////U////pv///9r/////////////////////////5P///wYA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAD////e////////////////////////////////////////////////////
//////////+wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Gv////j/////////////////////////////////
/////////////////////////////+D///8GAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///yD///8YAAAAAP///xb///++////////////////////
/////////////////////////////////////////////////////5z///8KAAAAAP///yr///8Y
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////tv////j////i////9v//////
////////////////////////////////////////////////////////////////////////////
//T////g/////P///5gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///zD/////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////+P///xgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAA////jP///////////////////////////////////////////////////9z///98////Wv//
/3z////a////////////////////////////////////////////////////cAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAD///+q//////////////////////////////////////////////+q
////CAAAAAAAAAAAAAAAAP///wj///+s////////////////////////////////////////////
//+iAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///9k////////////////////////
////////////2P///wgAAAAAAAAAAAAAAAAAAAAAAAAAAP///wj////Y////////////////////
///////////4////Uv///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///+8
//////////////////////////////98AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///3b/
/////////////////////////////4wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAP///57//////////////////////////////14AAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAA////WP//////////////////////////////XAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAD///8I////2v//////////////////////////////eAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///92//////////////////////////////+YAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Jv///7b/////////////////////////
///////////W////BgAAAAAAAAAAAAAAAAAAAAAAAAAA////Bv///9b/////////////////////
//////////r///9m////BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///++////////////
//////////////////////////////////+o////CAAAAAAAAAAAAAAAAP///wb///+i////////
//////////////////////////////////////+aAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AP///3D////////////////////////////////////////////////////Y////dP///1L///90
////1P///////////////////////////////////////////////////1AAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAA////FP////T/////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////i////
BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////iP///6z///90////rP////z/////
/////////////////////////////////////////////////////////////////////////7b/
//+E////wP///2wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8CAAAAAAAA
AAAAAAAA////cP//////////////////////////////////////////////////////////////
//////////9yAAAAAAAAAAD///8A////Av///y7///+c////igAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAD///8E////7P//////////////////////////////////////
////////////////////////5P///wIAAAAA////LP///1D///8C////kv/////////8////IAAA
AAD///8oAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wD////o////////////////////
///////////////////////////////////////////YAAAAAP///yz////w//////////D/////
///////////////q////zv////r///9SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////RP//////
///////////////////2////jP///2T///+a/////P////////////////////z///8u////Dv//
//D//////////////////////////////////////////////6YAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAD///8G////bv///+T//////////////1IAAAAAAAAAAAAAAAD///9s///////////////Y
////Xv///wL///8O////7v//////////////8P///7j////k////////////////////NAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////BP///0r///+EAAAAAAAAAAAAAAAAAAAAAP//
/wb///+I////Pv///wIAAAAA////cP///+D//////////////+D///8aAAAAAP///wr////K////
//////////+k////JAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///+w////////////////////iAAAAAAA
AAAAAAAAAP///2b////////////////////cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///0r///++////
//////////+wAAAAAAAAAAAAAAAA////gv///////////////////9IAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAP///xD////8//////////////+E////MP///2r////2//////////////9e////EAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAA////Tv//////////////////////////////////////////
////9v///wQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///9i////////////////////////
////////////////////////////VgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///9m
////Nv///0b////4/////////+T///9W////gv///5T///8EAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///7D////s////egAAAAAAAAAAAAAAAAAAAAAAAAAA/z5/
//wcH//8AB///AAf//wAH//4AA//gAAA/4AAAP8AHAD/AD4Af8B/Af/A/4H/wP+D/8D/gf+AfwH/
AD4Af4AcAP+AAAD/kAAB//wAH5/8AB8f/AAYA/wIGAH+PjgD/77w4f//4PD///Dg///4Y///+AP/
//gD////E////z8="

# Process Icon.
$bitmap               = New-Object System.Windows.Media.Imaging.BitmapImage
$bitmap.BeginInit()
$bitmap.StreamSource  = [System.IO.MemoryStream][System.Convert]::FromBase64String($b64)
$bitmap.EndInit()
$bitmap.Freeze()
$image                = [System.Drawing.Bitmap][System.Drawing.Image]::FromStream($Bitmap.StreamSource)
$icon                 = [System.Drawing.Icon]::FromHandle($Image.GetHicon())

# Setting up...
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)
$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $Window.FindName($_.Name) }

# Set Icon.
$Window.Icon            = $icon

# Notify Icon
$notifyIcon             = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Text        = $Window.Title
$notifyIcon.Icon        = $icon
$notifyIcon.Visible     = $true
# Contect menu
$ContextMenu            = New-Object System.Windows.Forms.ContextMenu
$NotifyIcon.ContextMenu = $ContextMenu
# Menu Item
$exitButton             = New-Object System.Windows.Forms.MenuItem
$exitButton.Text        = "Exit"
$notifyIcon.ContextMenu.MenuItems.AddRange($ExitButton)

# Functions
function DrawWindow {
    # This needs to be $Window.Show()?
    $Window.ShowDialog()
    # $Window.Show()
}

function CloseWindow {
    $notifyIcon.Visible = $false
    $Window.Close()
}

function GetInfo {
    # Retrive values. This needs adding as an onload when clicked or something.
    # Becuase we don't want it slowing down logon times.
    $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
    $computerSystem  = Get-CimInstance -ClassName Win32_ComputerSystem
    $bios            = Get-CimInstance -ClassName Win32_BIOS
    $logocalDisk     = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID = 'C:'"
    $diskDrive       = Get-CimInstance -ClassName Win32_DiskDrive | Select-Object 'Model', 'SerialNumber'
    $monitors        = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorId
    $adapters        = Get-NetAdapter -Physical

    # add some BIOS details on one of the tabs....

    # Overview tab
    $tabOverview_tbOverview.Inlines.Add( "Last boot: " + $operatingSystem.LastBootUpTime.DayOfWeek + " " + $operatingSystem.LastBootUpTime )
    $tabOverview_tbOverview.Inlines.Add( "`nBIOS Name: " + $bios.Name )
    $tabOverview_tbOverview.Inlines.Add( "`nSM BIOS Ver: " + $bios.SMBIOSBIOSVersion )

    # Computer tab
    $tabComputer_tbComputer.Inlines.Add( "Name: " + $computerSystem.Name )
    $tabComputer_tbComputer.Inlines.Add( "`nManufacturer: " + $computerSystem.Manufacturer )
    $tabComputer_tbComputer.Inlines.Add( "`nDomain: " + $computerSystem.Domain )
    $tabComputer_tbComputer.Inlines.Add( "`nModel: " + $computerSystem.Model )
    $tabComputer_tbComputer.Inlines.Add( "`nMemory: " + $([math]::Round($computerSystem.TotalPhysicalMemory/1GB)) + " GB" )

    # OS tab
    $tabOS_tbOS.Inlines.Add( $operatingSystem.Caption )
    $tabOS_tbOS.Inlines.Add( "`nRelease: " + (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId ) 
    $tabOS_tbOS.Inlines.Add( "`nBuild number: " + $operatingSystem.BuildNumber ) 
    $tabOS_tbOS.Inlines.Add( "`nArchitecture: " + $operatingSystem.OSArchitecture ) 
    $tabOS_tbOS.Inlines.Add( "`nVersion: " + $operatingSystem.Version ) 

    # Hardware tab
    # $tabHardware_tbHardware.Text = "Test: " + $
    # $tabHardware_tbHardware.Inlines.Add( "`n " )
    # $tabHardware_tbHardware.Inlines.Add( "`n " )
    # $tabHardware_tbHardware.Inlines.Add( "`n " )

    # Disk tab
    $tabDisks_tbDisks.Inlines.Add( "Model: " + $diskDrive.Model)
    $tabDisks_tbDisks.Inlines.Add( "`nSN: " + $diskDrive.SerialNumber )
    $tabDisks_tbDisks.Inlines.Add( "`nDrive Type: " + $logocalDisk.DriveType )
    $tabDisks_tbDisks.Inlines.Add( "`nName: " + $logocalDisk.Name )
    $tabDisks_tbDisks.Inlines.Add( "`nDescription: " + $logocalDisk.Description )
    $tabDisks_tbDisks.Inlines.Add( "`nSize: " + [math]::Round($logocalDisk.Size / 1GB) + " GB")
    $tabDisks_tbDisks.Inlines.Add( "`nFree space: " + [math]::Round($logocalDisk.FreeSpace / 1GB) + " GB" )
    $tabDisks_tbDisks.Inlines.Add( "`nFile system: " + $logocalDisk.FileSystem)

    # Display tab - For some reason - This doesn't work well with Set-Clipboard. Assume it's the -join bit
    foreach ($monitor in $monitors){
        $tabDisplay_tbDisplay.Inlines.Add( "Manufacturer: " + $(($monitor.ManufacturerName | ForEach-Object { [CHAR]$_ }) -join ''))
        $tabDisplay_tbDisplay.Inlines.Add( "`nModel: " + $(($monitor.UserFriendlyName | ForEach-Object { [CHAR]$_ }) -join ''))
        $tabDisplay_tbDisplay.Inlines.Add( "`nProduct code: " + $(($monitor.ProductCodeID | ForEach-Object { [CHAR]$_ }) -join ''))
        $tabDisplay_tbDisplay.Inlines.Add( "`nSN: " + $(($monitor.SerialNumberID | ForEach-Object { [CHAR]$_ }) -join ''))
        $tabDisplay_tbDisplay.Inlines.Add( "`nManufacture month: " + $monitor.YearOfManufacture )
        $tabDisplay_tbDisplay.Inlines.Add( "`nManufacture week: " + $monitor.WeekOfManufacture)
        $tabDisplay_tbDisplay.Inlines.Add( "`n`r" )
    }

    # Network tab
    foreach ($adapter in $adapters){
        $tabNetwork_tbNetwork.Inlines.Add( $adapter.InterfaceDescription )
        $tabNetwork_tbNetwork.Inlines.Add( "`nName: " + $adapter.Name )
        $tabNetwork_tbNetwork.Inlines.Add( "`nIPv4 Address: " + $($adapter | Get-NetIPAddress | Where-Object -FilterScript { $_.AddressFamily -eq 'IPv4' } | Select-Object -ExpandProperty 'IPAddress' ) )
        $tabNetwork_tbNetwork.Inlines.Add( "`nMac addr: " + $adapter.MacAddress )
        $tabNetwork_tbNetwork.Inlines.Add( "`nStatus: " + $adapter.Status )
        $tabNetwork_tbNetwork.Inlines.Add( "`nMediaType: " + $adapter.MediaType )
        $tabNetwork_tbNetwork.Inlines.Add( "`nConnection Status: " + $adapter.MediaConnectionState )
        $tabNetwork_tbNetwork.Inlines.Add( "`nDriver version: " + $adapter.DriverVersion )
        $tabNetwork_tbNetwork.Inlines.Add( "`n`r" )
    }

}

# Window events
$Window.Add_Activated{
    Write-Host 'Window is activated'
}

$Window.Add_Deactivated{
    Write-Host 'Window has been deactivated'
}

$Window.Add_Closing{
    Write-Host 'Window is closing...'
    $notifyIcon.Visible = $false
}

$Window.Add_Closed{
    Write-Host 'Window has been closed.'
}

#Notify Icon Event
$notifyIcon.Add_Click{
    DrawWindow
}

# Button Events
$btnExit.Add_Click{
    CloseWindow
}

$ExitButton.Add_Click{
    CloseWindow
}

$btnAbout.Add_Click{
    $tabControl.Visibility      = "Collapsed"
    $btnCopyCurrent.Visibility  = "Collapsed"
    $btnCopyAll.Visibility      = "Collapsed"
    $lblAbout.Visibility        = "Visible"
    $lblAbout2.Visibility       = "Visible"
    $btnAboutClose.Visibility   = "Visible"
}

$btnAboutClose.Add_Click{
    $tabControl.Visibility      = "Visible"
    $btnCopyCurrent.Visibility  = "Visible"
    $btnCopyAll.Visibility      = "Visible"
    $lblAbout.Visibility        = "Collapsed"
    $lblAbout2.Visibility       = "Collapsed"
    $btnAboutClose.Visibility   = "Collapsed"
}

$btnCopyCurrent.Add_Click{
    $currentTab = Get-Variable -Include "*tb$($tabControl.SelectedItem.Name)" -ValueOnly
    $currentTab.Text | Set-Clipboard
}

$btnCopyAll.Add_Click{
    Write-Host "btnCopyAll clicked"
}

GetInfo
DrawWindow