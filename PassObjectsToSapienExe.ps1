function ConvertFrom-CliXml
{
	param (
		[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
		[ValidateNotNullOrEmpty()]
		[String[]]$InputObject
	)
	begin
	{
		$OFS = "`n"
		[String]$xmlString = ""
	}
	process
	{
		$xmlString += $InputObject
	}
	end
	{
		$type = [PSObject].Assembly.GetType('System.Management.Automation.Deserializer')
		$ctor = $type.GetConstructor('instance,nonpublic', $null, @([xml.xmlreader]), $null)
		$sr = New-Object System.IO.StringReader $xmlString
		$xr = New-Object System.Xml.XmlTextReader $sr
		$deserializer = $ctor.Invoke($xr)
		$done = $type.GetMethod('Done', [System.Reflection.BindingFlags]'nonpublic,instance')
		while (!$type.InvokeMember("Done", "InvokeMethod,NonPublic,Instance", $null, $deserializer, @()))
		{
			try
			{
				$type.InvokeMember("Deserialize", "InvokeMethod,NonPublic,Instance", $null, $deserializer, @())
			}
			catch
			{
				Write-Warning "Could not deserialize ${string}: $_"
			}
		}
		$xr.Close()
		$sr.Dispose()
	}
}
function ConvertTo-CliXml
{
	param (
		[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
		[ValidateNotNullOrEmpty()]
		[PSObject[]]$InputObject
	)
	begin
	{
		$type = [PSObject].Assembly.GetType('System.Management.Automation.Serializer')
		$ctor = $type.GetConstructor('instance,nonpublic', $null, @([System.Xml.XmlWriter]), $null)
		$sw = New-Object System.IO.StringWriter
		$xw = New-Object System.Xml.XmlTextWriter $sw
		$serializer = $ctor.Invoke($xw)
	}
	process
	{
		try
		{
			[void]$type.InvokeMember("Serialize", "InvokeMethod,NonPublic,Instance", $null, $serializer, [object[]]@($InputObject))
		}
		catch
		{
			Write-Warning "Could not serialize $($InputObject.GetType()): $_"
		}
	}
	end
	{
		[void]$type.InvokeMember("Done", "InvokeMethod,NonPublic,Instance", $null, $serializer, @())
		$sw.ToString()
		$xw.Close()
		$sw.Dispose()
	}
}
function ConvertTo-Base64Stream
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
		[object]$object
	)
	
	$holdingJson = ConvertTo-CliXml -InputObject $object
	$preConversion_bytes = [System.Text.Encoding]::UTF8.GetBytes($holdingJson)
	$preconversion_64 = [System.Convert]::ToBase64String($preConversion_bytes)
	return $preconversion_64
}
function ConvertFrom-Base64ToObject
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Alias('string')]
		[string]$inputString
	)
	
	return ConvertFrom-CliXml ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($inputString)))
}