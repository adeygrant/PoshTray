<#
    .Synopsis
    Systray app written in Powershell.
    .Description
    System Information app written in Powershell.
    Collects information using Get-CimInstance.
    WPF for the main GUI & Win Forms for a notify icon.
    .Notes
    to do:
    Try to fix the extra whitespace on the foreach loop.
    Add an about section?
    Add a loading bar?
#>

# Import assemblies
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
        Title="PoshTray | System Information"
        Height="$height" Width="$width"
        ResizeMode="NoResize"
        ShowInTaskbar="False"
        WindowStartupLocation="Manual"
        Left="$x" Top="$y"
        >
    <Grid Name="theGrid" Visibility="Visible">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" MinHeight="300" MaxHeight="300"/>
            <RowDefinition Height="Auto"  />
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions></Grid.ColumnDefinitions>
        <Menu Grid.Row="0" Grid.Column="0" >
            <MenuItem Header="_File" ><MenuItem Name="btnExit" Header="_Exit"></MenuItem></MenuItem>
        </Menu>
        <TabControl Name="tabControl" Grid.Row="1" Grid.Column="0" Margin="5 5 5 5" Visibility="Visible">
            <TabItem Name="Overview" Header="Overview">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tbOverview"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Computer" Header="Computer">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tbComputer"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Disks" Header="Disks">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tbDisks"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="OS" Header="OS">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tbOS"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Hardware" Header="Hardware">
                <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                    <TextBlock Name="tbHardware"></TextBlock>
                </StackPanel>
            </TabItem>
            <TabItem Name="Display" Header="Display">
                <ScrollViewer VerticalScrollBarVisibility="Auto" Height="232">
                    <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                        <TextBlock Name="tbDisplay"></TextBlock>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>
            <TabItem Name="Network" Header="Network">
                <ScrollViewer VerticalScrollBarVisibility="Auto" Height="232">
                    <StackPanel Orientation="Vertical" Margin="5 5 5 5">
                        <TextBlock Name="tbNetwork"></TextBlock>
                    </StackPanel>
                </ScrollViewer>
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

# Notify Icon
$notifyIcon             = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Text        = $Window.Title
$notifyIcon.Icon        = $icon
$notifyIcon.Visible     = $true

# Window Icon.
$Window.Icon = $bitmap

# Context menu
$contextMenu            = New-Object System.Windows.Forms.ContextMenu
$NotifyIcon.ContextMenu = $contextMenu

# Menu Item
$exitButton             = New-Object System.Windows.Forms.MenuItem
$exitButton.Text        = "Exit"
$notifyIcon.ContextMenu.MenuItems.AddRange($exitButton)

function Get-Info {
    # Can we make this any quicker?
    $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
    $computerSystem  = Get-CimInstance -ClassName Win32_ComputerSystem
    $bios            = Get-CimInstance -ClassName Win32_BIOS
    $cpu             = Get-CimInstance -ClassName Win32_Processor
    $logocalDisk     = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID = 'C:'"
    $diskDrive       = Get-CimInstance -ClassName Win32_DiskDrive | Select-Object 'Model', 'SerialNumber'
    $monitors        = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorId
    $adapters        = Get-NetAdapter -Physical    

    # Overview tab
    $tbOverview.Inlines.Add( "Last boot: " + $operatingSystem.LastBootUpTime.DayOfWeek + " " + $operatingSystem.LastBootUpTime )
    $tbOverview.Inlines.Add( "`nBIOS Name: " + $bios.Name )
    $tbOverview.Inlines.Add( "`nSM BIOS Ver: " + $bios.SMBIOSBIOSVersion )
    $tbOverview.Inlines.Add( "`r")

    # Computer tab
    $tbComputer.Inlines.Add( "Name: " + $computerSystem.Name )
    $tbComputer.Inlines.Add( "`nManufacturer: " + $computerSystem.Manufacturer )
    $tbComputer.Inlines.Add( "`nDomain: " + $computerSystem.Domain )
    $tbComputer.Inlines.Add( "`nModel: " + $computerSystem.Model )
    $tbComputer.Inlines.Add( "`nMemory: " + $([math]::Round($computerSystem.TotalPhysicalMemory/1GB)) + " GB" )
    $tbComputer.Inlines.Add( "`r")

    # OS tab
    $tbOS.Inlines.Add( $operatingSystem.Caption )
    $tbOS.Inlines.Add( "`nRelease: " + (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId ) 
    $tbOS.Inlines.Add( "`nBuild number: " + $operatingSystem.BuildNumber ) 
    $tbOS.Inlines.Add( "`nArchitecture: " + $operatingSystem.OSArchitecture ) 
    $tbOS.Inlines.Add( "`nVersion: " + $operatingSystem.Version )
    $tbOS.Inlines.Add( "`r")

    # Hardware tab
    $tbHardware.Inlines.Add( "CPU: " + $cpu.Name )
    # $tabHardware_tbHardware.Inlines.Add( "`n " )
    # $tabHardware_tbHardware.Inlines.Add( "`n " )
    # $tabHardware_tbHardware.Inlines.Add( "`n " )

    # Disk tab
    $tbDisks.Inlines.Add( "Model: " + $diskDrive.Model)
    $tbDisks.Inlines.Add( "`nSN: " + $diskDrive.SerialNumber )
    $tbDisks.Inlines.Add( "`nDrive Type: " + $logocalDisk.DriveType )
    $tbDisks.Inlines.Add( "`nName: " + $logocalDisk.Name )
    $tbDisks.Inlines.Add( "`nDescription: " + $logocalDisk.Description )
    $tbDisks.Inlines.Add( "`nSize: " + [math]::Round($logocalDisk.Size / 1GB) + " GB")
    $tbDisks.Inlines.Add( "`nFree space: " + [math]::Round($logocalDisk.FreeSpace / 1GB) + " GB" )
    $tbDisks.Inlines.Add( "`nFile system: " + $logocalDisk.FileSystem)

    # Display tab - For some reason - This doesn't work well with Set-Clipboard. Assume it's the -join bit
    foreach ($monitor in $monitors){
        $tbDisplay.Inlines.Add( "Manufacturer: " + $(($monitor.ManufacturerName | ForEach-Object { [CHAR]$_ }) -join ''))
        $tbDisplay.Inlines.Add( "`nModel: " + $(($monitor.UserFriendlyName | ForEach-Object { [CHAR]$_ }) -join ''))
        $tbDisplay.Inlines.Add( "`nProduct code: " + $(($monitor.ProductCodeID | ForEach-Object { [CHAR]$_ }) -join ''))
        $tbDisplay.Inlines.Add( "`nSN: " + $(($monitor.SerialNumberID | ForEach-Object { [CHAR]$_ }) -join ''))
        $tbDisplay.Inlines.Add( "`nManufacture month: " + $monitor.YearOfManufacture )
        $tbDisplay.Inlines.Add( "`nManufacture week: " + $monitor.WeekOfManufacture)
        $tbDisplay.Inlines.Add( "`n`r")
    }

    # Network tab
    foreach ($adapter in $adapters){
        $tbNetwork.Inlines.Add( $adapter.InterfaceDescription )
        $tbNetwork.Inlines.Add( "`nName: " + $adapter.Name )
        $tbNetwork.Inlines.Add( "`nIPv4 Address: " + $($adapter | Get-NetIPAddress | Where-Object -FilterScript { $_.AddressFamily -eq 'IPv4' } | Select-Object -ExpandProperty 'IPAddress' ) )
        $tbNetwork.Inlines.Add( "`nMac addr: " + $adapter.MacAddress )
        $tbNetwork.Inlines.Add( "`nStatus: " + $adapter.Status )
        $tbNetwork.Inlines.Add( "`nMediaType: " + $adapter.MediaType )
        $tbNetwork.Inlines.Add( "`nConnection Status: " + $adapter.MediaConnectionState )
        $tbNetwork.Inlines.Add( "`nDriver version: " + $adapter.DriverVersion )
        $tbNetwork.Inlines.Add( "`n`r")
    }    

}

# Functions
function DrawWindow {
    $Window.Show()
    $Window.Activate()
}

function CloseWindow {
    $notifyIcon.Visible = $false
    $Window.Close()
    Stop-Process $pid
}

# Window events
$Window.Add_ContentRendered{
    Get-Info
}

$Window.Add_Deactivated{
    $Window.Hide()
}

$Window.Add_Closing{
    $_.Cancel = $true
    $Window.Hide()
}

$Window.Add_Closed{
    CloseWindow
}

#Notify Icon Event
$notifyIcon.Add_Click{
    DrawWindow
}

# Button Events
$btnExit.Add_Click{
    CloseWindow
}

$exitButton.Add_Click{
    CloseWindow
}

$btnCopyCurrent.Add_Click{
    $tabName = $tabControl.SelectedItem.Name
    $textblock = Get-Variable -Include "tb$tabName" -ValueOnly
    $textblock.Text | Set-Clipboard
}

$btnCopyAll.Add_Click{
    $textblocks = Get-Variable -Include "tb*" -ValueOnly
    foreach ($textblock in $textblocks){
        $textblock.Text | Set-Clipboard -Append
    }
}

# Garbage collector.
[System.GC]::Collect()

# Create an application context.
$AppContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($AppContext)