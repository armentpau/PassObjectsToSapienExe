Describe "Converting Object To Base64 String" {
	It "Convert Object To Base 64 String" {
		$obj = New-Object -TypeName System.Management.Automation.PSObject -ArgumentList @{
			Name = "Bob";
			Job = "Burger Flipper"
		}
		convertTo-Base64String -object $obj | Should Be "PE9ianMgVmVyc2lvbj0iMS4xLjAuMSIgeG1sbnM9Imh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vcG93ZXJzaGVsbC8yMDA0LzA0Ij48T2JqIFJlZklkPSIwIj48VE4gUmVmSWQ9IjAiPjxUPlN5c3RlbS5Db2xsZWN0aW9ucy5IYXNodGFibGU8L1Q+PFQ+U3lzdGVtLk9iamVjdDwvVD48L1ROPjxEQ1Q+PEVuPjxTIE49IktleSI+TmFtZTwvUz48UyBOPSJWYWx1ZSI+Qm9iPC9TPjwvRW4+PEVuPjxTIE49IktleSI+Sm9iPC9TPjxTIE49IlZhbHVlIj5CdXJnZXIgRmxpcHBlcjwvUz48L0VuPjwvRENUPjwvT2JqPjwvT2Jqcz4="
	}
	It "Convert Base64 string back to object"{
		$obj = New-Object -TypeName System.Management.Automation.PSObject -ArgumentList @{
			Name = "Bob";
			Job = "Burger Flipper"
		}
		$testString = "PE9ianMgVmVyc2lvbj0iMS4xLjAuMSIgeG1sbnM9Imh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vcG93ZXJzaGVsbC8yMDA0LzA0Ij48T2JqIFJlZklkPSIwIj48VE4gUmVmSWQ9IjAiPjxUPlN5c3RlbS5Db2xsZWN0aW9ucy5IYXNodGFibGU8L1Q+PFQ+U3lzdGVtLk9iamVjdDwvVD48L1ROPjxEQ1Q+PEVuPjxTIE49IktleSI+TmFtZTwvUz48UyBOPSJWYWx1ZSI+Qm9iPC9TPjwvRW4+PEVuPjxTIE49IktleSI+Sm9iPC9TPjxTIE49IlZhbHVlIj5CdXJnZXIgRmxpcHBlcjwvUz48L0VuPjwvRENUPjwvT2JqPjwvT2Jqcz4="
		$obj2 = ConvertFrom-Base64ToObject -inputString $testString
		(Compare-object -ReferenceObject $obj -DifferenceObject $obj2 -IncludeEqual).sideindicator | Should Be "=="
	}
}
