Describe "Converting Object To Base64 String" {
	It "Convert Object To Base 64 String" {
		$obj = New-Object -TypeName System.Management.Automation.PSObject -ArgumentList @{
			Name = "Bob";
			Job = "Burger Flipper"
		}
		ConvertTo-CompressedString -object $obj | Should Be "H4sIAAAAAAAEAI2Sy3KjMBBFPygb8UrBYhZYGCxGYMwb7SJw8RIeUsbY5uuDksk4sR3XLFjQfVv33K72llr9snPKuIvPuchG2oDaCeQTbvSDE6Byawl7unM01FWgWOnP+KxNmVgxmpgT7oQ+k+wxF7WugEpDRTDmliaR1J5erHhPoXp2DB3gSQeokV1Y66XH/epFQBJiE2P2gujJ2PwpEZx7pr9Gps1Iy1ovQMfPGd5DxinymKvkks9ooLhZolREjAeSKAC3plBY2pClfk9F+RCZrpd1Pcskn6bhcYyNH99Z5Du72j7W/H1ro2Jhc2GFWhRe+NTQdCOvBL/f5+GdnMEl56dH+Kj/vo/NUySxqbDiAbfuSK0TzzRnVCbcVlUuViBL7D255v/41NhQwm3qApKAQyjaryRxAef+ysl1WPDX1zV/6V7rOLNJmxsfXg/RUtZQO7DtnCPszIEzRdMDLSMVXcUMNQqkIpoZnNv8ULvnp/qJfKPl9ei8WHuBjUna1l7bj1nz/wxFau9Iikq/O/X5asHy+7MqBvHhZn/AN77fz3Hk+/6n4/+X+5j1823wXM2HLp/kX2+Twf2ciAMAAA=="
	}
	It "Convert Base64 string back to object"{
		$obj = New-Object -TypeName System.Management.Automation.PSObject -ArgumentList @{
			Name = "Bob";
			Job = "Burger Flipper"
		}
		$testString = "H4sIAAAAAAAEAI2Sy3KjMBBFPygb8UrBYhZYGCxGYMwb7SJw8RIeUsbY5uuDksk4sR3XLFjQfVv33K72llr9snPKuIvPuchG2oDaCeQTbvSDE6Byawl7unM01FWgWOnP+KxNmVgxmpgT7oQ+k+wxF7WugEpDRTDmliaR1J5erHhPoXp2DB3gSQeokV1Y66XH/epFQBJiE2P2gujJ2PwpEZx7pr9Gps1Iy1ovQMfPGd5DxinymKvkks9ooLhZolREjAeSKAC3plBY2pClfk9F+RCZrpd1Pcskn6bhcYyNH99Z5Du72j7W/H1ro2Jhc2GFWhRe+NTQdCOvBL/f5+GdnMEl56dH+Kj/vo/NUySxqbDiAbfuSK0TzzRnVCbcVlUuViBL7D255v/41NhQwm3qApKAQyjaryRxAef+ysl1WPDX1zV/6V7rOLNJmxsfXg/RUtZQO7DtnCPszIEzRdMDLSMVXcUMNQqkIpoZnNv8ULvnp/qJfKPl9ei8WHuBjUna1l7bj1nz/wxFau9Iikq/O/X5asHy+7MqBvHhZn/AN77fz3Hk+/6n4/+X+5j1823wXM2HLp/kX2+Twf2ciAMAAA=="
		$obj2 = ConvertFrom-CompressedString -inputString $testString
		(Compare-object -ReferenceObject $obj -DifferenceObject $obj2 -IncludeEqual).sideindicator | Should Be "=="
	}
}
