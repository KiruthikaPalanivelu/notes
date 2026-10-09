$f = "$env:USERPROFILE\otel\copilot-otel.jsonl"
Get-Content $f | ForEach-Object { $_ | ConvertFrom-Json } |
  Where-Object { $_.attributes.'gen_ai.operation.name' -and -not $_.hrTime } |   # spans only, no events
  Select-Object `
    @{n='op';     e={ $_.attributes.'gen_ai.operation.name' }},
    @{n='label';  e={ $_.attributes.'copilot_chat.debug_log_label' }},
    @{n='model';  e={ $_.attributes.'gen_ai.request.model' }},
    @{n='tool';   e={ $_.attributes.'gen_ai.tool.name' }},
    @{n='in';     e={ $_.attributes.'gen_ai.usage.input_tokens' }},
    @{n='cached'; e={ $_.attributes.'gen_ai.usage.cache_read.input_tokens' }},
    @{n='out';    e={ $_.attributes.'gen_ai.usage.output_tokens' }},
    @{n='ttft';   e={ $_.attributes.'copilot_chat.time_to_first_token' }},
    @{n='nanoAiu';e={ $_.attributes.'copilot_chat.copilot_usage_nano_aiu' }},
    @{n='ms';     e={ if ($_.duration -is [array]) { [math]::Round($_.duration[0]*1000 + $_.duration[1]/1e6) } }} |
  Format-Table -AutoSize
