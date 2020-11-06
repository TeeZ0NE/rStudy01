sub init()
  m.top.functionname = "load"
end sub

function load() as void
  fileSystem = CreateObject("roFilesystem")
  ' ? "Dirs: ";fileSystem.getDirectoryListing("pkg:/")
  filePath = m.top.filepath
  if filePath <> "" and fileSystem.Exists("pkg:/" + filePath)
    config = ReadAsciiFile("pkg:/" + filePath)
    ' ? "[loadConfigTask] Config: ";config
    jsonData = ParseJson(config)
    if jsonData <> invalid
      m.top.filedata = jsonData
    else
      m.top.error = "JSON data is invalid"
    end if
  else m.top.error = "Config file not specified or not found"
  end if
end function