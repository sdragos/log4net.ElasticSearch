properties {
    $base_dir       = (Get-Item (Resolve-Path .)).Parent.FullName
    $bin_dir        = "$base_dir\bin"
    $sln_path       = "$base_dir\src\log4net.ElasticSearch.sln"
    $config         = "Release"
    
	$nuget_csproj_path = "$base_dir\src\log4net.ElasticSearch\log4net.ElasticSearch.csproj"

    $dirs           = @($bin_dir)
    $artefacts      = @("$base_dir\LICENSE", "$base_dir\readme.txt")
    $nuget_path     = "$base_dir\tools\nuget\NuGet.exe"
}

task default        -depends Clean, Compile, Test
task Package        -depends default, CreateNugetPackage

task Clean {
    $dirs | % { Recreate-Directory $_ }
}

task Compile {
    exec {
        dotnet msbuild $sln_path /p:Configuration=$config /t:Rebuild /v:Quiet /nologo
    }
}

task Test {
    exec {
		cd $base_dir\src\
		& dotnet test
    }
}

task CreateNugetPackage {
    exec {
        & dotnet pack $nuget_csproj_path
    }
}

task ? -Description "Helper to display task info" {
    Write-Documentation
}


function Recreate-Directory($directory) {
    if (Test-Path $directory) {
        Write-Host -NoNewline  "`tDeleting $directory"
        Remove-Item $directory -Recurse -Force | out-null
        Write-Host "...Done"
    }

    Write-Host -NoNewline  "`tCreating $directory"
    New-Item $directory -Type Directory | out-null
    Write-Host "...Done"
}

