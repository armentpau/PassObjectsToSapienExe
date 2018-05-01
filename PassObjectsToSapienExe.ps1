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
	return [management.automation.psserializer]::Serialize($InputObject)
}
function ConvertTo-CompressedString
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
		[object]$object
	)
	
	$holdingXml = ConvertTo-CliXml -InputObject $object
	$preConversion_bytes = [System.Text.Encoding]::UTF8.GetBytes($holdingXml)
	$preconversion_64 = [System.Convert]::ToBase64String($preConversion_bytes)
	$memoryStream = New-Object System.IO.MemoryStream
	$compressionStream = New-Object System.IO.Compression.GZipStream($memoryStream, [System.io.compression.compressionmode]::Compress)
	$streamWriter = New-Object System.IO.streamwriter($compressionStream)
	$streamWriter.write($preconversion_64)
	$streamWriter.close()
	$compressedData = [System.convert]::ToBase64String($memoryStream.ToArray())
	return $compressedData
}
function ConvertFrom-CompressedString
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Alias('string', 'inputString')]
		[string]$CompressedInput
	)
	
	$data = [System.convert]::FromBase64String($CompressedInput)
	$memoryStream = New-Object System.Io.MemoryStream
	$memoryStream.write($data, 0, $data.length)
	$memoryStream.seek(0, 0) | Out-Null
	$streamReader = New-Object System.IO.StreamReader(New-Object System.IO.Compression.GZipStream($memoryStream, [System.IO.Compression.CompressionMode]::Decompress))
	$decompressedData = ConvertFrom-CliXml ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($($streamReader.readtoend()))))
	return $decompressedData
}