# Minimal static file server for local testing (no install required).
# Usage:  powershell -ExecutionPolicy Bypass -File serve.ps1
# Then open http://localhost:8080/sales-dashboard.html  and press Ctrl+C to stop.

$port = 8080
$root = $PSScriptRoot
$prefix = "http://localhost:$port/"

$mime = @{
  ".html"="text/html; charset=utf-8"; ".htm"="text/html; charset=utf-8";
  ".js"="application/javascript"; ".css"="text/css"; ".json"="application/json";
  ".png"="image/png"; ".jpg"="image/jpeg"; ".jpeg"="image/jpeg"; ".gif"="image/gif";
  ".svg"="image/svg+xml"; ".ico"="image/x-icon"; ".woff2"="font/woff2"
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
try { $listener.Start() } catch {
  Write-Host "Cannot start on $prefix - port may be in use." -ForegroundColor Red; exit 1
}
Write-Host "Serving $root" -ForegroundColor Green
Write-Host "Open  $($prefix)sales-dashboard.html" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop.`n"

while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
    if ([string]::IsNullOrWhiteSpace($rel)) { $rel = "sales-dashboard.html" }
    $path = Join-Path $root $rel
    if ((Test-Path $path -PathType Leaf) -and ($path.StartsWith($root))) {
      $ext = [IO.Path]::GetExtension($path).ToLower()
      $ctx.Response.ContentType = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { "application/octet-stream" }
      $bytes = [IO.File]::ReadAllBytes($path)
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $ctx.Response.StatusCode = 404
      $msg = [Text.Encoding]::UTF8.GetBytes("404 Not Found: $rel")
      $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
    }
    $ctx.Response.OutputStream.Close()
  } catch {}
}
