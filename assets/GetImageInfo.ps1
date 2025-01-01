Function Get-ImageInfo {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    [Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null

    if (-not (Test-Path $FilePath)) {
        Write-Host "El archivo '$FilePath' no existe."
        return
    }

    $fileItem = Get-Item $FilePath
    Write-Host "Ruta: $($fileItem.FullName)"
    Write-Host "Tamaño (bytes): $($fileItem.Length)"
    Write-Host "Fecha de Modificación: $($fileItem.LastWriteTime)"

    $img = [System.Drawing.Image]::FromFile($FilePath)
    Write-Host "Ancho (px): $($img.Width)"
    Write-Host "Alto (px): $($img.Height)"
    Write-Host "Resolución Horizontal (DPI): $($img.HorizontalResolution)"
    Write-Host "Resolución Vertical (DPI): $($img.VerticalResolution)"
    $img.Dispose()
}

# Llamada de ejemplo:
Get-ImageInfo -FilePath "D:\06MASW-A1\en_mi_ciudad\assets\icon.png"
