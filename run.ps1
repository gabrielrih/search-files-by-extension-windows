# It searches files recursively by extension.
# By default, it searches for XML extension files.
# Richter, Gabriel <gabrielrih@gmail.com>
# 2021-06-16

Function Get-RandomAlphanumericString {
	
	[CmdletBinding()]
	Param (
        [int] $length = 8
	)

	Begin{
	}

	Process{
        Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count $length  | % {[char]$_}) )
	}	
}

# Here you put the root folder
$RootFolder = "C:\test\"

# It creates the output folder
$Output="Output"
New-Item -ItemType Directory -Force -Path ./$Output

# Search all sub folder into the RootFolder
Write-Output "(+) Searching for folders..."
$SubFolderList = (Get-ChildItem -path $RootFolder | ?{ $_.PSIsContainer })

if ( $SubFolderList -ne $null ) {

	# It runs in each sub folder
	foreach ( $SubFolder In $SubFolderList ) {
	
		# Get the fullname folder
		$SubFolderFullName = $SubFolder.FullName
		Write-Output "(+) Folder founded: $SubFolderFullName"
		
		# Find XML files into a folder (recursive)
		$ListFiles = (Get-ChildItem $SubFolderFullName *.xml -Recurse)

		# Copy all files to the output folder
		if ( $ListFiles -ne $null ) {

			Write-Output "(+) Copying files..."
			foreach ($File In $ListFiles)
			{

				# Print original file name
				$FileFullName = $File.FullName
				Write-Output $FileFullName

				# It generate a random string an move the file using the new name
				# I did this to avoid crashing having two files with the same name. 
				$NewRandomFileName = Get-RandomAlphanumericString -length 25
				$NewRandomFileName += ".xml"
				Copy-Item $FileFullName -Destination ./$Output/$NewRandomFileName

			}
		}
	}
}

