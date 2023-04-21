local status, galaxyline = pcall(require, "galaxyline")
if not status then
    print("Galaxyline is not installed")
    return
end

require('galaxyline.themes.eviline')
