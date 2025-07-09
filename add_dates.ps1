# 获取所有md文件路径
$files = Get-ChildItem -Path "src\linux" -Filter "*.md" -Recurse

# 计算开始日期（3年前的今天）
$startDate = (Get-Date).AddYears(-3)

# 文件计数
$fileCount = $files.Count
$currentIndex = 0

# 为每个文件添加日期
foreach ($file in $files) {
    try {
        # 计算当前文件的日期（从3年前开始，每天递增）
        $fileDate = $startDate.AddDays($currentIndex)
        $formattedDate = $fileDate.ToString("yyyy-MM-dd")
        
        # 读取文件内容
        $content = Get-Content -Path $file.FullName -Encoding UTF8 | Out-String
        
        # 检查文件是否已有date字段
        if ($content -match "date:") {
            Write-Host "File $($file.Name) already has date field, skipping"
            $currentIndex++
            continue
        }
        
        # 在frontmatter中添加date字段
        if ($content -match "---\s*\r?\n((.|\r|\n)*?)\r?\n---") {
            $frontmatter = $Matches[1]
            
            # 确保date字段添加在单独一行
            if ($frontmatter.TrimEnd().EndsWith("`n")) {
                $newFrontmatter = $frontmatter + "date: $formattedDate`r`n"
            } else {
                $newFrontmatter = $frontmatter + "`r`ndate: $formattedDate`r`n"
            }
            
            $newContent = $content -replace [regex]::Escape($frontmatter), $newFrontmatter
            
            # 写回文件
            [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
            
            Write-Host "Added date: $formattedDate to $($file.Name)"
        } else {
            # 为没有frontmatter的文件创建frontmatter
            $fileContent = Get-Content -Path $file.FullName -Encoding UTF8 | Out-String
            $newContent = "---`r`ntitle: $($file.BaseName)`r`ncategory:`r`n  - Linux`r`ntag:`r`n  - $($file.BaseName)`r`ndate: $formattedDate`r`n---`r`n`r`n" + $fileContent
            
            # 写回文件
            [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
            
            Write-Host "Created frontmatter with date: $formattedDate for $($file.Name)"
        }
    } catch {
        Write-Host "Error processing file $($file.Name): $_"
    }
    
    $currentIndex++
}

Write-Host "Done! Processed $fileCount files" 